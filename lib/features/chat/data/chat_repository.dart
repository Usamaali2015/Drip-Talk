import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_ends_point.dart';
import 'package:drip_talk/core/services/api/api_service.dart';
import 'package:drip_talk/features/chat/data/ai_response_chat_model.dart';
import 'package:drip_talk/features/chat/data/models/ai_chat_request_model.dart';
import 'package:drip_talk/features/chat/data/models/fetch_all_messages_model.dart';
import 'package:drip_talk/features/chat/data/models/chat_sessions_model.dart';
import 'package:flutter/foundation.dart';

class ChatRepository {
  ChatRepository(this._apiService);

  final ApiService _apiService;
  static const Duration _chatRequestTimeout = Duration(seconds: 60);

  Future<AiResponseChatModel> sendMessage(
    AiChatRequestModel request, {
    CancelToken? cancelToken,
  }) async {
    _logDebug('Chat request payload: ${request.toJson()}');
    final requestOptions = Options(
      sendTimeout: _chatRequestTimeout,
      receiveTimeout: _chatRequestTimeout,
    );

    try {
      final response = request.hasImages
          ? await _apiService.uploadFile(
              ApiEndpoints.chat,
              fields: request.toMultipartFields(),
              files: request.imageFiles,
              fileKey: 'images[]',
              options: requestOptions,
              cancelToken: cancelToken,
              requiresAppAttestation: true,
            )
          : await _apiService.post(
              ApiEndpoints.chat,
              data: request.toJson(),
              options: requestOptions,
              cancelToken: cancelToken,
              requiresAppAttestation: true,
            );

      _logDebug('Chat success response: ${response.data}');
      return AiResponseChatModel.fromJson(_asMap(response.data));
    } on DioException catch (error) {
      _logDebug(
        'Chat error response: '
        'statusCode=${error.response?.statusCode}, data=${error.response?.data}',
      );
      rethrow;
    } catch (error) {
      _logDebug('Chat unexpected error: $error');
      rethrow;
    }
  }

  Future<FetchAllMessagesModel> fetchSessionMessages(
    int sessionId, {
    CancelToken? cancelToken,
  }) async {
    _logDebug('Chat history fetch start: sessionId=$sessionId');

    try {
      final response = await _apiService.get(
        ApiEndpoints.chatSession(sessionId),
        cancelToken: cancelToken,
      );
      _logDebug('Chat history raw response: ${response.data}');

      final history = FetchAllMessagesModel.fromJson(_asMap(response.data));
      _logDebug(
        'Chat history fetch success: '
        'requestedSessionId=$sessionId, '
        'resolvedSessionId=${history.meta?.session?.id}, '
        'messages=${history.data.length}, '
        'success=${history.success}',
      );

      return history;
    } on DioException catch (error) {
      _logDebug(
        'Chat history fetch error: '
        'sessionId=$sessionId, '
        'statusCode=${error.response?.statusCode}, '
        'data=${error.response?.data}',
      );
      rethrow;
    } catch (error) {
      _logDebug(
        'Chat history fetch unexpected error: '
        'sessionId=$sessionId, error=$error',
      );
      rethrow;
    }
  }

  Future<ChatSessionsModel> fetchSessions({CancelToken? cancelToken}) async {
    _logDebug('Chat sessions fetch start');

    try {
      final response = await _apiService.get(
        ApiEndpoints.chatSessions,
        cancelToken: cancelToken,
      );
      _logDebug('Chat sessions raw response: ${response.data}');

      final sessions = ChatSessionsModel.fromJson(_asMap(response.data));
      _logDebug(
        'Chat sessions fetch success: '
        'count=${sessions.sessions.length}, success=${sessions.success}',
      );

      return sessions;
    } on DioException catch (error) {
      _logDebug(
        'Chat sessions fetch error: '
        'statusCode=${error.response?.statusCode}, '
        'data=${error.response?.data}',
      );
      rethrow;
    } catch (error) {
      _logDebug('Chat sessions fetch unexpected error: $error');
      rethrow;
    }
  }

  Future<void> deleteSession(int sessionId, {CancelToken? cancelToken}) async {
    _logDebug('Chat session delete start: sessionId=$sessionId');

    try {
      final response = await _apiService.delete(
        ApiEndpoints.chatSession(sessionId),
        cancelToken: cancelToken,
      );
      _logDebug('Chat session delete success: ${response.data}');
    } on DioException catch (error) {
      _logDebug(
        'Chat session delete error: '
        'sessionId=$sessionId, '
        'statusCode=${error.response?.statusCode}, '
        'data=${error.response?.data}',
      );
      rethrow;
    } catch (error) {
      _logDebug(
        'Chat session delete unexpected error: '
        'sessionId=$sessionId, error=$error',
      );
      rethrow;
    }
  }
}

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
  }

  return null;
}

void _logDebug(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}
