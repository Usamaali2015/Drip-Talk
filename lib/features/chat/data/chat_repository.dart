import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_ends_point.dart';
import 'package:drip_talk/core/services/api/api_service.dart';
import 'package:drip_talk/features/chat/data/ai_response_chat_model.dart';
import 'package:drip_talk/features/chat/data/models/ai_chat_request_model.dart';

class ChatRepository {
  ChatRepository(this._apiService);

  final ApiService _apiService;

  Future<AiResponseChatModel> sendMessage(
    AiChatRequestModel request, {
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.chat,
      data: request.toJson(),
      cancelToken: cancelToken,
    );

    return AiResponseChatModel.fromJson(_asMap(response.data));
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
