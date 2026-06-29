import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_constants.dart';
import 'package:drip_talk/core/config/env_config.dart';
import 'package:drip_talk/core/services/api/dio_client.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_session_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatGenerationRealtimeService {
  ChatGenerationRealtimeService(this._dioClient, this._authSessionRepository);

  static const String _chatUpdatedEvent = 'chat.image.updated';
  static const String _chatUserChannelPrefix = 'chat.user.';

  final DioClient _dioClient;
  final AuthSessionRepository _authSessionRepository;

  Future<ChatGenerationRealtimeSession> connect({
    required String batchId,
    String? channelName,
  }) async {
    final authToken = await _authSessionRepository.getAuthToken();
    if (authToken == null || authToken.isEmpty) {
      throw 'Chat realtime session requires an authenticated user.';
    }

    final userId = await _authSessionRepository.getAuthenticatedUserId();
    if (userId == null || userId.isEmpty) {
      throw 'Chat realtime session requires an authenticated user id.';
    }

    _dioClient.setAuthToken(authToken);

    final resolvedChannelName = _resolveChannelName(
      userId: userId,
      channelName: channelName,
    );
    final subscriptionChannelName = _subscriptionChannelName(
      resolvedChannelName,
    );
    final socketUri = EnvConfig.reverbWebSocketUri;
    if (socketUri.scheme.toLowerCase() != 'wss') {
      throw StateError('Realtime chat requires a secure websocket endpoint.');
    }

    final controller = StreamController<ChatImageGenerationUpdate>();
    final channel = WebSocketChannel.connect(socketUri);
    StreamSubscription<dynamic>? subscription;
    var isClosed = false;
    var isTerminalMessageReceived = false;

    Future<void> closeSession() async {
      if (isClosed) {
        return;
      }

      isClosed = true;
      await subscription?.cancel();
      await channel.sink.close();
      if (!controller.isClosed) {
        await controller.close();
      }
    }

    Future<void> emitFailure(Object error, [StackTrace? stackTrace]) async {
      if (isClosed || controller.isClosed) {
        return;
      }

      controller.addError(
        error is String
            ? error
            : _sanitizeErrorMessage(
                error.toString(),
                fallback:
                    'Chat image generation connection closed before results were received.',
              ),
        stackTrace,
      );
      await closeSession();
    }

    Future<void> handleMessage(dynamic rawMessage) async {
      if (isClosed) {
        return;
      }

      final envelope = _asMap(rawMessage);
      if (envelope == null || envelope.isEmpty) {
        return;
      }

      _logDebug(
        'ChatGenerationRealtimeService.raw=${_formatDebugData(envelope)}',
      );

      final eventName = _asString(envelope['event']);
      if (eventName == null) {
        return;
      }

      if (eventName == 'pusher:connection_established') {
        final payload = _asMap(envelope['data']);
        final socketId = _asString(payload?['socket_id']);
        if (socketId == null) {
          await emitFailure(
            'Chat realtime connection did not return a socket id.',
          );
          return;
        }

        final subscribePayload = await _buildSubscribePayload(
          channelName: subscriptionChannelName,
          socketId: socketId,
        );
        if (isClosed) {
          return;
        }

        channel.sink.add(
          jsonEncode(<String, dynamic>{
            'event': 'pusher:subscribe',
            'data': subscribePayload,
          }),
        );
        return;
      }

      if (eventName == 'pusher:ping') {
        channel.sink.add(
          jsonEncode(<String, dynamic>{
            'event': 'pusher:pong',
            'data': const <String, dynamic>{},
          }),
        );
        return;
      }

      if (eventName == 'pusher:error') {
        final payload = _asMap(envelope['data']);
        await emitFailure(
          _asString(payload?['message']) ??
              _asString(envelope['message']) ??
              'Chat realtime connection failed.',
        );
        return;
      }

      if (eventName.startsWith('pusher:') ||
          eventName.startsWith('pusher_internal:')) {
        return;
      }

      if (!_isChatGenerationEvent(eventName)) {
        return;
      }

      final payload = _asMap(envelope['data']);
      if (payload == null || payload.isEmpty) {
        return;
      }

      final update = ChatImageGenerationUpdate.fromJson(payload);
      final resolvedBatchId = update.batchId?.trim();
      if (resolvedBatchId != null &&
          resolvedBatchId.isNotEmpty &&
          resolvedBatchId != batchId) {
        return;
      }

      controller.add(update);
      _logDebug(
        'ChatGenerationRealtimeService.update status=${update.status} progress=${update.progress} images=${update.imageUrls.length} batchId=${update.batchId}',
      );

      if (update.isFailed || update.isCompleted) {
        isTerminalMessageReceived = true;
        await closeSession();
      }
    }

    subscription = channel.stream.listen(
      (dynamic message) async {
        try {
          await handleMessage(message);
        } catch (error, stackTrace) {
          await emitFailure(error, stackTrace);
        }
      },
      onError: (Object error, StackTrace stackTrace) async {
        await emitFailure(error, stackTrace);
      },
      onDone: () async {
        if (isClosed || isTerminalMessageReceived) {
          return;
        }

        await emitFailure(
          'Chat image generation connection closed before results were received.',
        );
      },
      cancelOnError: false,
    );

    try {
      await channel.ready;
    } catch (error, stackTrace) {
      await emitFailure(error, stackTrace);
      rethrow;
    }

    return ChatGenerationRealtimeSession._(controller.stream, closeSession);
  }

  Future<Map<String, dynamic>> _buildSubscribePayload({
    required String channelName,
    required String socketId,
  }) async {
    if (!_requiresAuthorization(channelName)) {
      return <String, dynamic>{'channel': channelName};
    }

    final authorization = await _authorizeChannel(
      channelName: channelName,
      socketId: socketId,
    );

    return <String, dynamic>{
      'channel': channelName,
      'auth': authorization.auth,
      if (authorization.channelData != null)
        'channel_data': authorization.channelData,
    };
  }

  Future<_ChatChannelAuthorization> _authorizeChannel({
    required String channelName,
    required String socketId,
  }) async {
    final userId = await _authSessionRepository.getAuthenticatedUserId();
    final response = await _dioClient.dio.postUri(
      Uri.parse(EnvConfig.reverbAuthEndpoint),
      data: <String, dynamic>{
        'socket_id': socketId,
        'channel_name': channelName,
        ...?userId == null ? null : <String, dynamic>{'user_id': userId},
      },
      options: Options(
        headers: const <String, String>{'Accept': 'application/json'},
        extra: <String, dynamic>{
          ApiConstants.requiresAppAttestationExtra: true,
        },
      ),
    );

    final source = _asMap(response.data);
    final data = _asMap(source?['data']);
    final auth = _asString(source?['auth']) ?? _asString(data?['auth']);

    if (auth == null) {
      throw 'Chat realtime authorization failed for $channelName.';
    }

    return _ChatChannelAuthorization(
      auth: auth,
      channelData:
          _asString(source?['channel_data']) ??
          _asString(source?['channelData']) ??
          _asString(data?['channel_data']) ??
          _asString(data?['channelData']),
    );
  }

  String _resolveChannelName({required String userId, String? channelName}) {
    final normalizedChannelName = _normalizeChannelName(channelName);
    if (normalizedChannelName != null) {
      return normalizedChannelName;
    }

    return '$_chatUserChannelPrefix$userId';
  }

  String _subscriptionChannelName(String channelName) {
    if (_requiresAuthorization(channelName)) {
      return channelName;
    }

    return 'private-$channelName';
  }
}

void _logDebug(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}

class ChatGenerationRealtimeSession {
  ChatGenerationRealtimeSession._(this.updates, this._close);

  final Stream<ChatImageGenerationUpdate> updates;
  final Future<void> Function() _close;

  Future<void> close() => _close();
}

class ChatImageGenerationUpdate {
  const ChatImageGenerationUpdate({
    this.userId,
    this.sessionId,
    this.messageId,
    this.batchId,
    this.status,
    this.progress,
    this.imageUrls = const <String>[],
    this.errorMessage,
  });

  factory ChatImageGenerationUpdate.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    final data = _asMap(source?['data']);

    return ChatImageGenerationUpdate(
      userId: _asInt(source?['user_id']) ?? _asInt(data?['user_id']),
      sessionId: _asInt(source?['session_id']) ?? _asInt(data?['session_id']),
      messageId: _asInt(source?['message_id']) ?? _asInt(data?['message_id']),
      batchId:
          _asString(source?['batch_id']) ??
          _asString(data?['batch_id']) ??
          _asString(source?['batch_uuid']) ??
          _asString(data?['batch_uuid']),
      status: _asString(source?['status']) ?? _asString(data?['status']),
      progress:
          _asInt(source?['progress']) ??
          _asInt(data?['progress']) ??
          _asInt(source?['percentage']) ??
          _asInt(data?['percentage']),
      imageUrls: _stringListFromDynamic(
        source?['image_urls'] ??
            data?['image_urls'] ??
            source?['images'] ??
            data?['images'],
      ),
      errorMessage:
          _asString(source?['error_message']) ??
          _asString(data?['error_message']) ??
          _asString(source?['message']) ??
          _asString(data?['message']),
    );
  }

  final int? userId;
  final int? sessionId;
  final int? messageId;
  final String? batchId;
  final String? status;
  final int? progress;
  final List<String> imageUrls;
  final String? errorMessage;

  bool get isFailed => _isFailedStatus(status);

  bool get isCompleted =>
      _isCompletedStatus(status) || (progress != null && progress! >= 100);
}

class _ChatChannelAuthorization {
  const _ChatChannelAuthorization({required this.auth, this.channelData});

  final String auth;
  final String? channelData;
}

bool _requiresAuthorization(String channelName) {
  return channelName.startsWith('private-') ||
      channelName.startsWith('presence-');
}

bool _isChatGenerationEvent(String eventName) {
  final normalized = eventName.trim().toLowerCase();
  return normalized == ChatGenerationRealtimeService._chatUpdatedEvent ||
      normalized.startsWith('chat.image.');
}

String? _normalizeChannelName(String? channelName) {
  final normalized = _asString(channelName);
  if (normalized == null) {
    return null;
  }

  if (normalized.startsWith('private-')) {
    return normalized.substring('private-'.length);
  }

  if (normalized.startsWith('presence-')) {
    return normalized.substring('presence-'.length);
  }

  return normalized;
}

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(trimmed);
      return _asMap(decoded);
    } catch (_) {
      return null;
    }
  }

  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
  }

  return null;
}

List<String> _stringListFromDynamic(dynamic value) {
  if (value is! List) {
    return const <String>[];
  }

  return value
      .map((entry) => _asString(entry))
      .whereType<String>()
      .toList(growable: false);
}

String? _asString(dynamic value) {
  final normalized = value?.toString().trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
}

int? _asInt(dynamic value) {
  if (value is int) {
    return value;
  }

  if (value is double) {
    return value.round();
  }

  return int.tryParse(value?.toString() ?? '');
}

bool _isCompletedStatus(String? value) {
  final normalized = value?.trim().toLowerCase();
  return const <String>{
    'complete',
    'completed',
    'done',
    'success',
    'succeeded',
    'finished',
  }.contains(normalized);
}

bool _isFailedStatus(String? value) {
  final normalized = value?.trim().toLowerCase();
  return const <String>{
    'failed',
    'error',
    'cancelled',
    'canceled',
    'rejected',
  }.contains(normalized);
}

String _sanitizeErrorMessage(String value, {required String fallback}) {
  final normalized = value.trim();
  if (normalized.isEmpty || normalized.toLowerCase() == 'null') {
    return fallback;
  }

  return normalized.replaceFirst(RegExp(r'^(Exception|Error):\s*'), '').trim();
}

String _formatDebugData(dynamic value) {
  try {
    if (value is Map || value is List) {
      return const JsonEncoder.withIndent('  ').convert(value);
    }
  } catch (_) {}

  return value?.toString() ?? 'null';
}
