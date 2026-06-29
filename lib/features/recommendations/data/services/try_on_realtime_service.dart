import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_constants.dart';
import 'package:drip_talk/core/config/env_config.dart';
import 'package:drip_talk/core/services/api/dio_client.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_session_repository.dart';
import 'package:drip_talk/features/recommendations/data/models/try_on_result_model.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class TryOnRealtimeService {
  TryOnRealtimeService(this._dioClient, this._authSessionRepository);

  static const String _tryOnUpdatedEvent = 'try-on.updated';
  static const String _tryOnUserChannelPrefix = 'try-on.user.';

  final DioClient _dioClient;
  final AuthSessionRepository _authSessionRepository;

  Future<TryOnRealtimeSession> connect({
    required String batchId,
    String? channelName,
  }) async {
    final authToken = await _authSessionRepository.getAuthToken();
    if (authToken == null || authToken.isEmpty) {
      throw 'Try-on realtime session requires an authenticated user.';
    }

    final userId = await _authSessionRepository.getAuthenticatedUserId();
    if (userId == null || userId.isEmpty) {
      throw 'Try-on realtime session requires an authenticated user id.';
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
      throw StateError('Realtime try-on requires a secure websocket endpoint.');
    }

    _logDebug(
      'TryOnRealtimeService.connect channel=$resolvedChannelName subscription=$subscriptionChannelName batchId=$batchId',
    );

    final controller = StreamController<TryOnResultModel>();
    final channel = WebSocketChannel.connect(socketUri);
    StreamSubscription<dynamic>? subscription;
    var isClosed = false;
    var isTerminalMessageReceived = false;
    var hasSeenCompletionSignal = false;

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
                    'Try-on realtime connection failed before results were received.',
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
        'TryOnRealtimeService.websocket raw=${_formatDebugData(envelope)}',
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
            'Try-on realtime connection did not return a socket id.',
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
        _logDebug(
          'TryOnRealtimeService.websocket subscribe channel=$subscriptionChannelName payload=${_formatDebugData(subscribePayload)}',
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
              'Try-on realtime connection failed.',
        );
        return;
      }

      if (eventName.startsWith('pusher:') ||
          eventName.startsWith('pusher_internal:')) {
        return;
      }

      if (!_isTryOnEvent(eventName)) {
        return;
      }

      final payload = _asMap(envelope['data']);
      if (payload == null || payload.isEmpty) {
        return;
      }

      final result = _resolveTryOnResult(payload);
      if (result == null) {
        _logDebug(
          'TryOnRealtimeService.websocket event=$eventName payload_unparsed=${_formatDebugData(payload)}',
        );
        return;
      }

      if (result.isCompleted) {
        hasSeenCompletionSignal = true;
      }

      final resolvedBatchId = result.batchId?.trim();
      if (resolvedBatchId != null &&
          resolvedBatchId.isNotEmpty &&
          resolvedBatchId != batchId) {
        return;
      }

      controller.add(result);
      _logDebug(
        'TryOnRealtimeService.websocket event=$eventName parsed status=${result.status} progress=${result.progress} results=${result.results.length} payload=${_formatDebugData(payload)}',
      );

      if (result.isFailed || result.isCompleted) {
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
        if (isClosed || isTerminalMessageReceived || hasSeenCompletionSignal) {
          return;
        }

        await emitFailure(
          'Try-on realtime connection closed before results were received.',
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

    return TryOnRealtimeSession._(controller.stream, closeSession);
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

  Future<_TryOnChannelAuthorization> _authorizeChannel({
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

    _logDebug(
      'TryOnRealtimeService.authorize response=${_formatDebugData(response.data)}',
    );

    if (auth == null) {
      throw 'Try-on realtime authorization failed for $channelName.';
    }

    return _TryOnChannelAuthorization(
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

    return '$_tryOnUserChannelPrefix$userId';
  }

  String _subscriptionChannelName(String channelName) {
    if (_requiresAuthorization(channelName)) {
      return channelName;
    }

    return 'private-$channelName';
  }
}

class TryOnRealtimeSession {
  TryOnRealtimeSession._(this.updates, this._close);

  final Stream<TryOnResultModel> updates;
  final Future<void> Function() _close;

  Future<void> close() => _close();
}

class _TryOnChannelAuthorization {
  const _TryOnChannelAuthorization({required this.auth, this.channelData});

  final String auth;
  final String? channelData;
}

TryOnResultModel? _resolveTryOnResult(Map<String, dynamic> payload) {
  final candidates = <Map<String, dynamic>>[
    payload,
    ...<Map<String, dynamic>?>[
      _asMap(payload['data']),
      _asMap(payload['result']),
      _asMap(payload['batch']),
      _asMap(payload['tryon_result']),
      _asMap(payload['try_on_result']),
    ].whereType<Map<String, dynamic>>(),
  ];

  for (final candidate in candidates) {
    final result = TryOnResultModel.fromJson(candidate);
    if (_hasTryOnPayload(result, candidate)) {
      return result;
    }
  }

  return null;
}

bool _requiresAuthorization(String channelName) {
  return channelName.startsWith('private-') ||
      channelName.startsWith('presence-');
}

bool _isTryOnEvent(String eventName) {
  final normalized = eventName.trim().toLowerCase();
  return normalized == TryOnRealtimeService._tryOnUpdatedEvent ||
      normalized.startsWith('try-on.') ||
      normalized.startsWith('try_on.');
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

bool _hasTryOnPayload(TryOnResultModel result, Map<String, dynamic> payload) {
  if (result.hasResults ||
      result.progress != null ||
      result.status?.trim().isNotEmpty == true ||
      result.message?.trim().isNotEmpty == true ||
      result.batchId?.trim().isNotEmpty == true) {
    return true;
  }

  const keys = <String>{
    'items',
    'results',
    'images',
    'generated_images',
    'generated_results',
    'generated_looks',
    'tryon_results',
    'try_on_results',
    'output',
    'progress',
    'percentage',
    'percent',
    'status',
    'batch_status',
    'batch_id',
    'batchId',
  };

  return payload.keys.any(keys.contains);
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

String? _asString(dynamic value) {
  final normalized = value?.toString().trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
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

void _logDebug(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}
