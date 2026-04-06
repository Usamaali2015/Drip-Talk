import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drip_talk/features/chat/data/ai_response_chat_model.dart';
import 'package:drip_talk/features/chat/data/chat_repository.dart';
import 'package:drip_talk/features/chat/data/models/ai_chat_request_model.dart';
import 'package:drip_talk/features/chat/data/models/chat_message.dart';
import 'package:drip_talk/features/chat/domain/chat_event.dart';
import 'package:drip_talk/features/chat/domain/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(this._repository) : super(const ChatState()) {
    on<LoadInitialMessages>(_onLoadInitial);
    on<SendMessageRequested>(_onSendMessageRequested);
  }

  final ChatRepository _repository;

  void _onLoadInitial(LoadInitialMessages event, Emitter<ChatState> emit) {
    if (state.messages.isNotEmpty) {
      return;
    }

    emit(
      state.copyWith(
        status: ChatStatus.success,
        messages: [
          ChatMessage(
            title: "Hello! I'm Your AI Stylist",
            text:
                'I can help you with outfit recommendations, styling tips, fashion advice, and more. Try asking me anything about fashion!',
            type: MessageType.bot,
            time: DateTime.now(),
          ),
        ],
      ),
    );
  }

  Future<void> _onSendMessageRequested(
    SendMessageRequested event,
    Emitter<ChatState> emit,
  ) async {
    final normalizedMessage = event.message.trim();
    if (normalizedMessage.isEmpty || state.isSending) {
      return;
    }

    final enrichedPreferences = event.preferences.withDerivedValues(
      normalizedMessage,
    );
    final userMessage = ChatMessage(
      text: normalizedMessage,
      type: MessageType.user,
      time: DateTime.now(),
    );

    final pendingMessages = List<ChatMessage>.from(state.messages)
      ..insert(0, userMessage);

    emit(
      state.copyWith(
        status: ChatStatus.success,
        messages: pendingMessages,
        isSending: true,
        lastUsedPreferences: enrichedPreferences,
      ),
    );

    try {
      final response = await _repository.sendMessage(
        AiChatRequestModel(
          message: normalizedMessage,
          sessionId: state.sessionId,
          userPreferences: enrichedPreferences,
        ),
      );

      final assistantMessage = ChatMessage(
        text: _resolveAssistantMessage(response),
        type: MessageType.bot,
        time: DateTime.now(),
        response: response,
      );

      emit(
        state.copyWith(
          status: ChatStatus.success,
          messages: List<ChatMessage>.from(pendingMessages)
            ..insert(0, assistantMessage),
          isSending: false,
          sessionId: response.data?.sessionId,
          lastUsedPreferences: enrichedPreferences,
        ),
      );
    } catch (error) {
      final failureMessage = ChatMessage(
        text: _resolveErrorMessage(error),
        type: MessageType.bot,
        time: DateTime.now(),
        isError: true,
      );

      emit(
        state.copyWith(
          status: ChatStatus.failure,
          messages: List<ChatMessage>.from(pendingMessages)
            ..insert(0, failureMessage),
          isSending: false,
          lastUsedPreferences: enrichedPreferences,
        ),
      );
    }
  }

  String _resolveAssistantMessage(AiResponseChatModel response) {
    final explicitMessage = response.message?.trim();
    if (explicitMessage != null &&
        explicitMessage.isNotEmpty &&
        !_genericMessages.contains(explicitMessage.toLowerCase())) {
      return explicitMessage;
    }

    final aiCount = response.aiRecommendedItems.length;
    final catalogCount = response.catalogRecommendationItems.length;

    if (aiCount > 0 && catalogCount > 0) {
      return 'I found $aiCount AI picks and $catalogCount catalog matches for this look.';
    }

    if (aiCount > 0) {
      return 'I found $aiCount AI-picked products you can shop right away.';
    }

    if (catalogCount > 0) {
      return 'I found $catalogCount catalog matches from the app for this request.';
    }

    return 'I analyzed your request and pulled together a few recommendations.';
  }

  String _resolveErrorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        final message = data['message']?.toString().trim();
        if (message != null && message.isNotEmpty) {
          return message;
        }
      } else if (data is Map) {
        final message = data['message']?.toString().trim();
        if (message != null && message.isNotEmpty) {
          return message;
        }
      }

      final dioMessage = error.message?.trim();
      if (dioMessage != null && dioMessage.isNotEmpty) {
        return dioMessage;
      }
    }

    return 'I could not load recommendations right now. Please try again.';
  }
}

const Set<String> _genericMessages = <String>{
  'success',
  'ok',
  'recommendations fetched successfully',
};
