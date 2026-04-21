import 'package:dio/dio.dart';
import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drip_talk/features/chat/data/ai_response_chat_model.dart';
import 'package:drip_talk/features/chat/data/chat_repository.dart';
import 'package:drip_talk/features/chat/data/chat_session_repository.dart';
import 'package:drip_talk/features/chat/data/models/ai_chat_request_model.dart';
import 'package:drip_talk/features/chat/data/models/chat_attachment.dart';
import 'package:drip_talk/features/chat/data/models/chat_message.dart';
import 'package:drip_talk/features/chat/data/models/fetch_all_messages_model.dart';
import 'package:drip_talk/features/chat/domain/chat_event.dart';
import 'package:drip_talk/features/chat/domain/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(this._repository, this._sessionRepository)
    : super(const ChatState()) {
    on<InitializeChatRequested>(_onInitializeChatRequested);
    on<StartNewChatRequested>(_onStartNewChatRequested);
    on<ContinueOldChatRequested>(_onContinueOldChatRequested);
    on<AddChatAttachmentsRequested>(_onAddChatAttachmentsRequested);
    on<RemoveChatAttachmentRequested>(_onRemoveChatAttachmentRequested);
    on<SendMessageRequested>(_onSendMessageRequested);
  }

  final ChatRepository _repository;
  final ChatSessionRepository _sessionRepository;

  Future<void> _onInitializeChatRequested(
    InitializeChatRequested event,
    Emitter<ChatState> emit,
  ) async {
    if (state.status != ChatStatus.initial) {
      debugPrint('Chat initialize skipped: currentStatus=${state.status.name}');
      return;
    }

    final savedSessionId = await _sessionRepository.getSavedSessionId();
    final savedPreferences = await _sessionRepository.getSavedPreferences();
    debugPrint(
      'Chat initialize resolved: '
      'savedSessionId=$savedSessionId, '
      'hasSavedPreferences=${!savedPreferences.isEmpty}',
    );

    emit(
      state.copyWith(
        status: ChatStatus.success,
        messages: [_buildWelcomeMessage()],
        composerAttachments: const <ChatAttachment>[],
        sessionId: savedSessionId,
        lastUsedPreferences: savedPreferences,
        launchSheetMode: savedSessionId == null
            ? ChatLaunchSheetMode.newChatOnly
            : ChatLaunchSheetMode.resumeOrNew,
        preserveSessionId: false,
      ),
    );
  }

  Future<void> _onStartNewChatRequested(
    StartNewChatRequested event,
    Emitter<ChatState> emit,
  ) async {
    await _tryClearSession();
    await _tryClearPreferences();

    emit(
      state.copyWith(
        status: ChatStatus.success,
        messages: [_buildWelcomeMessage()],
        composerAttachments: const <ChatAttachment>[],
        isLoadingHistory: false,
        launchSheetMode: ChatLaunchSheetMode.hidden,
        lastUsedPreferences: const AiChatUserPreferences(),
        sessionId: null,
        preserveSessionId: false,
      ),
    );
  }

  Future<void> _onContinueOldChatRequested(
    ContinueOldChatRequested event,
    Emitter<ChatState> emit,
  ) async {
    final savedSessionId = state.sessionId;
    debugPrint(
      'Chat continue old requested: '
      'stateSessionId=$savedSessionId, '
      'currentMessages=${state.messages.length}',
    );
    if (savedSessionId == null) {
      debugPrint('Chat continue old fallback: no saved session id found');
      add(const StartNewChatRequested());
      return;
    }

    emit(
      state.copyWith(
        status: ChatStatus.loading,
        messages: const <ChatMessage>[],
        composerAttachments: const <ChatAttachment>[],
        isLoadingHistory: true,
        launchSheetMode: ChatLaunchSheetMode.hidden,
      ),
    );

    try {
      final history = await _repository.fetchSessionMessages(savedSessionId);
      final resolvedMessages = _mapHistoryMessages(history);
      final resolvedPreferences = _resolveLastPreferences(history);
      final resolvedSessionId = history.meta?.session?.id ?? savedSessionId;
      debugPrint(
        'Chat history mapped: '
        'requestedSessionId=$savedSessionId, '
        'resolvedSessionId=$resolvedSessionId, '
        'rawMessages=${history.data.length}, '
        'mappedMessages=${resolvedMessages.length}',
      );

      await _trySaveSessionId(resolvedSessionId);
      await _trySavePreferences(resolvedPreferences);

      emit(
        state.copyWith(
          status: ChatStatus.success,
          messages: resolvedMessages.isEmpty
              ? [_buildWelcomeMessage()]
              : resolvedMessages,
          composerAttachments: const <ChatAttachment>[],
          isLoadingHistory: false,
          sessionId: resolvedSessionId,
          lastUsedPreferences: resolvedPreferences,
        ),
      );
    } catch (error) {
      debugPrint(
        'Chat continue old failed: '
        'requestedSessionId=$savedSessionId, error=$error',
      );
      final explicitErrorMessage = _extractErrorMessage(error);
      emit(
        state.copyWith(
          status: ChatStatus.failure,
          messages: [
            _buildWelcomeMessage(),
            ChatMessage(
              text: explicitErrorMessage ?? '',
              type: MessageType.bot,
              time: DateTime.now(),
              isError: true,
              textKey: explicitErrorMessage == null
                  ? ChatMessageTextKey.genericError
                  : null,
            ),
          ],
          composerAttachments: const <ChatAttachment>[],
          isLoadingHistory: false,
        ),
      );
    }
  }

  void _onAddChatAttachmentsRequested(
    AddChatAttachmentsRequested event,
    Emitter<ChatState> emit,
  ) {
    if (state.isBusy || event.attachments.isEmpty) {
      return;
    }

    final mergedAttachments = <ChatAttachment>[...state.composerAttachments];
    final existingIds = mergedAttachments
        .map((attachment) => attachment.id)
        .toSet();

    for (final attachment in event.attachments) {
      if (existingIds.add(attachment.id)) {
        mergedAttachments.add(attachment);
      }
    }

    emit(state.copyWith(composerAttachments: mergedAttachments));
  }

  void _onRemoveChatAttachmentRequested(
    RemoveChatAttachmentRequested event,
    Emitter<ChatState> emit,
  ) {
    emit(
      state.copyWith(
        composerAttachments: state.composerAttachments
            .where((attachment) => attachment.id != event.attachmentId)
            .toList(),
      ),
    );
  }

  Future<void> _onSendMessageRequested(
    SendMessageRequested event,
    Emitter<ChatState> emit,
  ) async {
    final normalizedMessage = event.message.trim();
    final composerAttachments = List<ChatAttachment>.from(
      state.composerAttachments,
    );
    if ((normalizedMessage.isEmpty && composerAttachments.isEmpty) ||
        state.isBusy) {
      debugPrint(
        'Chat send skipped: '
        'isEmpty=${normalizedMessage.isEmpty && composerAttachments.isEmpty}, '
        'isBusy=${state.isBusy}',
      );
      return;
    }

    final enrichedPreferences = event.preferences.withDerivedValues(
      normalizedMessage,
    );
    debugPrint(
      'Chat send start: '
      'sessionId=${state.sessionId}, '
      'messageLength=${normalizedMessage.length}',
    );
    await _trySavePreferences(enrichedPreferences);
    final userMessage = ChatMessage(
      text: normalizedMessage,
      type: MessageType.user,
      time: DateTime.now(),
      attachments: composerAttachments,
    );

    final pendingMessages = List<ChatMessage>.from(state.messages)
      ..insert(0, userMessage);

    emit(
      state.copyWith(
        status: ChatStatus.success,
        messages: pendingMessages,
        composerAttachments: const <ChatAttachment>[],
        isSending: true,
        lastUsedPreferences: enrichedPreferences,
      ),
    );

    try {
      final response = await _repository.sendMessage(
        AiChatRequestModel(
          message: normalizedMessage,
          sessionId: state.sessionId,
          images: composerAttachments,
          userPreferences: enrichedPreferences,
        ),
      );

      final explicitAssistantMessage = _resolveExplicitAssistantMessage(
        response,
      );
      final assistantMessage = ChatMessage(
        text: explicitAssistantMessage ?? '',
        type: MessageType.bot,
        time: DateTime.now(),
        response: response,
        textKey: explicitAssistantMessage == null
            ? _resolveAssistantMessageTextKey(response)
            : null,
        aiCount: response.aiRecommendedItems.length,
        catalogCount: response.catalogRecommendationItems.length,
      );
      final resolvedSessionId = response.data?.sessionId ?? state.sessionId;
      if (resolvedSessionId != null) {
        await _trySaveSessionId(resolvedSessionId);
      }
      debugPrint(
        'Chat send success: '
        'previousSessionId=${state.sessionId}, '
        'resolvedSessionId=$resolvedSessionId, '
        'aiItems=${response.aiRecommendedItems.length}, '
        'catalogItems=${response.catalogRecommendationItems.length}',
      );

      emit(
        state.copyWith(
          status: ChatStatus.success,
          messages: List<ChatMessage>.from(pendingMessages)
            ..insert(0, assistantMessage),
          composerAttachments: const <ChatAttachment>[],
          isSending: false,
          sessionId: resolvedSessionId,
          launchSheetMode: ChatLaunchSheetMode.hidden,
        ),
      );
    } catch (error) {
      debugPrint('Chat send flow error: $error');
      final explicitErrorMessage = _extractErrorMessage(error);
      final failureMessage = ChatMessage(
        text: explicitErrorMessage ?? '',
        type: MessageType.bot,
        time: DateTime.now(),
        isError: true,
        textKey: explicitErrorMessage == null
            ? ChatMessageTextKey.genericError
            : null,
      );

      emit(
        state.copyWith(
          status: ChatStatus.failure,
          messages: List<ChatMessage>.from(pendingMessages)
            ..insert(0, failureMessage),
          composerAttachments: const <ChatAttachment>[],
          isSending: false,
        ),
      );
    }
  }

  ChatMessage _buildWelcomeMessage() {
    return ChatMessage(
      title: localizedString(
        fallback: "Hello! I'm Your AI Stylist",
        select: (l10n) => l10n.chatIntroTitle,
      ),
      text: localizedString(
        fallback:
            'I can help you with outfit recommendations, styling tips, fashion advice, and more. Try asking me anything about fashion!',
        select: (l10n) => l10n.chatIntroMessage,
      ),
      type: MessageType.bot,
      time: DateTime.now(),
    );
  }

  List<ChatMessage> _mapHistoryMessages(FetchAllMessagesModel history) {
    final entries = List<ChatHistoryMessage>.from(history.data)
      ..sort((first, second) {
        final firstTime =
            first.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final secondTime =
            second.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return secondTime.compareTo(firstTime);
      });

    return entries.map(_mapHistoryMessage).toList();
  }

  ChatMessage _mapHistoryMessage(ChatHistoryMessage historyMessage) {
    final timestamp = historyMessage.createdAt ?? DateTime.now();

    if (historyMessage.isUser) {
      return ChatMessage(
        text: historyMessage.message ?? '',
        type: MessageType.user,
        time: timestamp,
        attachments: historyMessage.attachments,
      );
    }

    final response = _buildHistoryResponse(historyMessage);
    final explicitMessage = _resolveHistoryMessageText(historyMessage);
    return ChatMessage(
      text: explicitMessage ?? '',
      type: MessageType.bot,
      time: timestamp,
      attachments: historyMessage.attachments,
      response: response,
      textKey: explicitMessage == null
          ? (response != null
                ? _resolveAssistantMessageTextKey(response)
                : ChatMessageTextKey.historyFallback)
          : null,
      aiCount: response?.aiRecommendedItems.length,
      catalogCount: response?.catalogRecommendationItems.length,
    );
  }

  AiResponseChatModel? _buildHistoryResponse(
    ChatHistoryMessage historyMessage,
  ) {
    final payload = historyMessage.payload;
    if (payload == null || !payload.hasRecommendations) {
      return null;
    }

    return AiResponseChatModel(
      message: payload.aiResponse?.text ?? historyMessage.message,
      data: RecommendationData(
        provider: payload.provider,
        model: payload.model,
        sessionId: historyMessage.chatSessionId,
        messageId: historyMessage.id,
        messageType: historyMessage.messageType,
        aiRecommended: payload.aiRecommended.isEmpty
            ? null
            : payload.aiRecommended,
        catalogItems: payload.products.isEmpty ? null : payload.products,
        catalogSize: payload.catalogSize,
      ),
    );
  }

  String? _resolveHistoryMessageText(ChatHistoryMessage historyMessage) {
    final responseText = historyMessage.payload?.aiResponse?.text?.trim();
    if (responseText != null && responseText.isNotEmpty) {
      return responseText;
    }

    final messageText = historyMessage.message?.trim();
    if (messageText != null && messageText.isNotEmpty) {
      return messageText;
    }

    return null;
  }

  AiChatUserPreferences _resolveLastPreferences(FetchAllMessagesModel history) {
    final entries = List<ChatHistoryMessage>.from(history.data)
      ..sort((first, second) {
        final firstTime =
            first.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final secondTime =
            second.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return secondTime.compareTo(firstTime);
      });

    for (final entry in entries) {
      final preferences = entry.payload?.userPreferences;
      if (preferences != null && !preferences.isEmpty) {
        return preferences;
      }
    }

    return state.lastUsedPreferences;
  }

  String? _resolveExplicitAssistantMessage(AiResponseChatModel response) {
    final explicitMessage = response.message?.trim();
    if (explicitMessage != null &&
        explicitMessage.isNotEmpty &&
        !_genericMessages.contains(explicitMessage.toLowerCase())) {
      return explicitMessage;
    }

    return null;
  }

  ChatMessageTextKey _resolveAssistantMessageTextKey(
    AiResponseChatModel response,
  ) {
    final aiCount = response.aiRecommendedItems.length;
    final catalogCount = response.catalogRecommendationItems.length;

    if (aiCount > 0 && catalogCount > 0) {
      return ChatMessageTextKey.assistantSummaryAiAndCatalog;
    }

    if (aiCount > 0) {
      return ChatMessageTextKey.assistantSummaryAiOnly;
    }

    if (catalogCount > 0) {
      return ChatMessageTextKey.assistantSummaryCatalogOnly;
    }

    return ChatMessageTextKey.assistantSummaryGeneric;
  }

  String? _extractErrorMessage(Object error) {
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

    final fallbackMessage = error.toString().trim();
    if (fallbackMessage.isNotEmpty) {
      return fallbackMessage;
    }

    return null;
  }

  Future<void> _trySavePreferences(AiChatUserPreferences preferences) async {
    try {
      await _sessionRepository.savePreferences(preferences);
    } catch (error) {
      debugPrint('Chat preferences save failed: $error');
    }
  }

  Future<void> _trySaveSessionId(int sessionId) async {
    try {
      await _sessionRepository.saveSessionId(sessionId);
    } catch (error) {
      debugPrint('Chat session save failed: $error');
    }
  }

  Future<void> _tryClearSession() async {
    try {
      await _sessionRepository.clearSessionId();
    } catch (error) {
      debugPrint('Chat session clear failed: $error');
    }
  }

  Future<void> _tryClearPreferences() async {
    try {
      await _sessionRepository.clearPreferences();
    } catch (error) {
      debugPrint('Chat preferences clear failed: $error');
    }
  }
}

const Set<String> _genericMessages = <String>{
  'success',
  'ok',
  'recommendations fetched successfully',
};
