import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_ends_point.dart';
import 'package:drip_talk/core/services/api/api_service.dart';
import 'package:drip_talk/features/chat/data/ai_response_chat_model.dart';
import 'package:drip_talk/features/chat/data/models/ai_chat_request_model.dart';
import 'package:drip_talk/features/chat/data/models/fetch_all_messages_model.dart';
import 'package:flutter/foundation.dart';

class ChatRepository {
  ChatRepository(this._apiService);

  final ApiService _apiService;

  Future<AiResponseChatModel> sendMessage(
    AiChatRequestModel request, {
    CancelToken? cancelToken,
  }) async {
    debugPrint('Chat request payload: ${request.toJson()}');

    try {
      final response = request.hasImages
          ? await _apiService.uploadFile(
              ApiEndpoints.chat,
              fields: request.toMultipartFields(),
              files: request.imageFiles,
              fileKey: 'images[]',
              cancelToken: cancelToken,
            )
          : await _apiService.post(
              ApiEndpoints.chat,
              data: request.toJson(),
              cancelToken: cancelToken,
            );

      debugPrint('Chat success response: ${response.data}');
      return AiResponseChatModel.fromJson(_asMap(response.data));
    } on DioException catch (error) {
      debugPrint(
        'Chat error response: '
        'statusCode=${error.response?.statusCode}, data=${error.response?.data}',
      );
      rethrow;
    } catch (error) {
      debugPrint('Chat unexpected error: $error');
      rethrow;
    }
  }

  Future<FetchAllMessagesModel> fetchSessionMessages(
    int sessionId, {
    CancelToken? cancelToken,
  }) async {
    debugPrint('Chat history fetch start: sessionId=$sessionId');

    try {
      final response = await _apiService.get(
        ApiEndpoints.chatSessionMessages(sessionId),
        cancelToken: cancelToken,
      );
      debugPrint('Chat history raw response: ${response.data}');

      final history = FetchAllMessagesModel.fromJson(_asMap(response.data));
      debugPrint(
        'Chat history fetch success: '
        'requestedSessionId=$sessionId, '
        'resolvedSessionId=${history.meta?.session?.id}, '
        'messages=${history.data.length}, '
        'success=${history.success}',
      );

      return history;
    } on DioException catch (error) {
      debugPrint(
        'Chat history fetch error: '
        'sessionId=$sessionId, '
        'statusCode=${error.response?.statusCode}, '
        'data=${error.response?.data}',
      );
      rethrow;
    } catch (error) {
      debugPrint(
        'Chat history fetch unexpected error: '
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
