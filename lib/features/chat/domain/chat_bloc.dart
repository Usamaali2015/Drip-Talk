import 'dart:async';

import 'package:dio/dio.dart';
import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_session_repository.dart';
import 'package:drip_talk/features/chat/data/ai_response_chat_model.dart';
import 'package:drip_talk/features/chat/data/chat_repository.dart';
import 'package:drip_talk/features/chat/data/chat_session_repository.dart';
import 'package:drip_talk/features/chat/data/models/ai_chat_request_model.dart';
import 'package:drip_talk/features/chat/data/models/chat_attachment.dart';
import 'package:drip_talk/features/chat/data/models/chat_message.dart';
import 'package:drip_talk/features/chat/data/models/fetch_all_messages_model.dart';
import 'package:drip_talk/features/chat/data/services/chat_generation_realtime_service.dart';
import 'package:drip_talk/features/chat/domain/chat_event.dart';
import 'package:drip_talk/features/chat/domain/chat_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(
    this._repository,
    this._sessionRepository,
    this._authSessionRepository,
    this._chatGenerationRealtimeService,
  ) : super(const ChatState()) {
    on<InitializeChatRequested>(_onInitializeChatRequested);
    on<ChatSessionsRequested>(_onChatSessionsRequested);
    on<StartNewChatRequested>(_onStartNewChatRequested);
    on<ChatSessionOpenedRequested>(_onChatSessionOpenedRequested);
    on<ChatSessionDeletedRequested>(_onChatSessionDeletedRequested);
    on<AddChatAttachmentsRequested>(_onAddChatAttachmentsRequested);
    on<RemoveChatAttachmentRequested>(_onRemoveChatAttachmentRequested);
    on<ChatComposerModeChanged>(_onChatComposerModeChanged);
    on<SendMessageRequested>(_onSendMessageRequested);
    on<RetryFailedMessageRequested>(_onRetryFailedMessageRequested);
    on<ChatImageGenerationUpdated>(_onChatImageGenerationUpdated);
    on<ChatImageGenerationFailed>(_onChatImageGenerationFailed);
  }

  final ChatRepository _repository;
  final ChatSessionRepository _sessionRepository;
  final AuthSessionRepository _authSessionRepository;
  final ChatGenerationRealtimeService _chatGenerationRealtimeService;

  final Map<String, ChatGenerationRealtimeSession> _generationSessions =
      <String, ChatGenerationRealtimeSession>{};
  final Map<String, StreamSubscription<ChatImageGenerationUpdate>>
  _generationSubscriptions =
      <String, StreamSubscription<ChatImageGenerationUpdate>>{};
  int? _pendingRestoreSessionId;

  @override
  Future<void> close() async {
    await _releaseAllGenerationSessions();
    return super.close();
  }

  Future<void> _onInitializeChatRequested(
    InitializeChatRequested event,
    Emitter<ChatState> emit,
  ) async {
    if (state.status != ChatStatus.initial) {
      debugPrint('Chat initialize skipped: currentStatus=${state.status.name}');
      return;
    }

    final savedSessionId = await _sessionRepository.getSavedSessionId();
    final requiresStartupRecommendations = await _authSessionRepository
        .isRecommendationsFlowRequired();
    _pendingRestoreSessionId = requiresStartupRecommendations
        ? null
        : savedSessionId;

    emit(
      state.copyWith(
        status: ChatStatus.success,
        messages: <ChatMessage>[_buildWelcomeMessage()],
        selectedMode: ChatComposerMode.wardrobe,
        composerAttachments: const <ChatAttachment>[],
        sessionId: null,
        requiresStartupRecommendations: requiresStartupRecommendations,
        sessionActionErrorMessage: null,
        preserveSessionId: false,
      ),
    );

    add(const ChatSessionsRequested(silent: true));
  }

  Future<void> _onChatSessionsRequested(
    ChatSessionsRequested event,
    Emitter<ChatState> emit,
  ) async {
    if (state.isLoadingSessions) {
      return;
    }

    final shouldShowLoading = !event.silent || !state.hasSessions;
    if (shouldShowLoading || state.sessionActionErrorMessage != null) {
      emit(
        state.copyWith(
          isLoadingSessions: shouldShowLoading,
          sessionActionErrorMessage: null,
        ),
      );
    }

    try {
      final response = await _repository.fetchSessions();
      emit(
        state.copyWith(
          sessions: response.sessions,
          isLoadingSessions: false,
          sessionActionErrorMessage: null,
        ),
      );

      final pendingRestoreSessionId = _pendingRestoreSessionId;
      if (pendingRestoreSessionId == null ||
          state.requiresStartupRecommendations) {
        return;
      }

      _pendingRestoreSessionId = null;
      final hasPendingSession = response.sessions.any(
        (session) => session.id == pendingRestoreSessionId,
      );
      if (hasPendingSession) {
        add(
          ChatSessionOpenedRequested(
            sessionId: pendingRestoreSessionId,
            showLoader: true,
          ),
        );
        return;
      }

      await _tryClearSession();
    } catch (error) {
      debugPrint('Chat sessions load failed: $error');
      emit(
        state.copyWith(
          isLoadingSessions: false,
          sessionActionErrorMessage: event.silent
              ? null
              : _extractErrorMessage(error) ?? _chatSessionsLoadFailedMessage(),
        ),
      );
    }
  }

  Future<void> _onStartNewChatRequested(
    StartNewChatRequested event,
    Emitter<ChatState> emit,
  ) async {
    await _releaseAllGenerationSessions();
    await _tryClearSession();
    _pendingRestoreSessionId = null;

    emit(
      state.copyWith(
        status: ChatStatus.success,
        messages: <ChatMessage>[_buildWelcomeMessage()],
        selectedMode: ChatComposerMode.wardrobe,
        composerAttachments: const <ChatAttachment>[],
        isLoadingHistory: false,
        sessionId: null,
        requiresStartupRecommendations: false,
        deletingSessionId: null,
        sessionActionErrorMessage: null,
        preserveSessionId: false,
      ),
    );
  }

  Future<void> _onChatSessionOpenedRequested(
    ChatSessionOpenedRequested event,
    Emitter<ChatState> emit,
  ) async {
    await _releaseAllGenerationSessions();
    _pendingRestoreSessionId = null;

    final previousSessionId = state.sessionId;
    final previousMessages = List<ChatMessage>.from(state.messages);

    emit(
      state.copyWith(
        status: event.showLoader ? ChatStatus.loading : ChatStatus.success,
        messages: event.showLoader ? const <ChatMessage>[] : state.messages,
        selectedMode: ChatComposerMode.wardrobe,
        composerAttachments: const <ChatAttachment>[],
        isLoadingHistory: true,
        requiresStartupRecommendations: false,
        sessionId: event.sessionId,
        sessionActionErrorMessage: null,
      ),
    );

    try {
      final history = await _repository.fetchSessionMessages(event.sessionId);
      final resolvedMessages = _mapHistoryMessages(history);
      final resolvedSessionId = history.meta?.session?.id ?? event.sessionId;

      await _trySaveSessionId(resolvedSessionId);

      emit(
        state.copyWith(
          status: ChatStatus.success,
          messages: resolvedMessages.isEmpty
              ? <ChatMessage>[_buildWelcomeMessage()]
              : resolvedMessages,
          composerAttachments: const <ChatAttachment>[],
          isLoadingHistory: false,
          sessionId: resolvedSessionId,
          sessionActionErrorMessage: null,
        ),
      );
      add(const ChatSessionsRequested(silent: true));
      await _restoreActiveGenerationStreams(resolvedMessages);
    } catch (error) {
      if (_isMissingChatSessionError(error)) {
        _pendingRestoreSessionId = null;
        await _tryClearSession();
        emit(
          state.copyWith(
            status: ChatStatus.success,
            messages: previousMessages.isEmpty
                ? <ChatMessage>[_buildWelcomeMessage()]
                : previousMessages,
            composerAttachments: const <ChatAttachment>[],
            isLoadingHistory: false,
            sessionId: previousSessionId,
            sessionActionErrorMessage: null,
            preserveSessionId: previousSessionId != null,
          ),
        );
        add(const ChatSessionsRequested(silent: true));
        return;
      }

      final explicitErrorMessage = _extractErrorMessage(error);
      final fallbackMessages = previousMessages.isEmpty
          ? <ChatMessage>[
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
            ]
          : previousMessages;

      emit(
        state.copyWith(
          status: previousMessages.isEmpty
              ? ChatStatus.failure
              : ChatStatus.success,
          messages: fallbackMessages,
          composerAttachments: const <ChatAttachment>[],
          isLoadingHistory: false,
          sessionId: previousSessionId,
          sessionActionErrorMessage:
              explicitErrorMessage ?? _chatSessionOpenFailedMessage(),
          preserveSessionId: false,
        ),
      );
    }
  }

  Future<void> _onChatSessionDeletedRequested(
    ChatSessionDeletedRequested event,
    Emitter<ChatState> emit,
  ) async {
    if (state.deletingSessionId == event.sessionId) {
      return;
    }

    emit(
      state.copyWith(
        deletingSessionId: event.sessionId,
        sessionActionErrorMessage: null,
      ),
    );

    try {
      await _repository.deleteSession(event.sessionId);

      final remainingSessions = state.sessions
          .where((session) => session.id != event.sessionId)
          .toList(growable: false);
      final isCurrentSession = state.sessionId == event.sessionId;
      if (_pendingRestoreSessionId == event.sessionId) {
        _pendingRestoreSessionId = null;
      }

      if (isCurrentSession) {
        await _releaseAllGenerationSessions();
        await _tryClearSession();
        _pendingRestoreSessionId = null;
      }

      emit(
        state.copyWith(
          sessions: remainingSessions,
          deletingSessionId: null,
          sessionActionErrorMessage: null,
          sessionId: isCurrentSession ? null : state.sessionId,
          messages: isCurrentSession
              ? <ChatMessage>[_buildWelcomeMessage()]
              : state.messages,
          selectedMode: isCurrentSession
              ? ChatComposerMode.wardrobe
              : state.selectedMode,
          composerAttachments: isCurrentSession
              ? const <ChatAttachment>[]
              : state.composerAttachments,
          isLoadingHistory: false,
          preserveSessionId: !isCurrentSession,
        ),
      );
      add(const ChatSessionsRequested(silent: true));
    } catch (error) {
      emit(
        state.copyWith(
          deletingSessionId: null,
          sessionActionErrorMessage:
              _extractErrorMessage(error) ?? _chatSessionDeleteFailedMessage(),
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
            .toList(growable: false),
      ),
    );
  }

  void _onChatComposerModeChanged(
    ChatComposerModeChanged event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(selectedMode: event.mode));
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
      return;
    }
    _pendingRestoreSessionId = null;

    final userMessage = ChatMessage(
      text: normalizedMessage,
      type: MessageType.user,
      time: DateTime.now(),
      mode: event.mode,
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
      ),
    );

    await _submitAssistantResponse(
      emit: emit,
      pendingMessages: pendingMessages,
      request: ChatRetryRequest(
        message: normalizedMessage,
        mode: event.mode,
        attachments: composerAttachments,
      ),
    );
  }

  Future<void> _onRetryFailedMessageRequested(
    RetryFailedMessageRequested event,
    Emitter<ChatState> emit,
  ) async {
    if (state.isBusy) {
      return;
    }

    final retryRequest = event.message.retryRequest;
    if (retryRequest == null) {
      return;
    }

    final pendingMessages = List<ChatMessage>.from(state.messages)
      ..remove(event.message);

    emit(
      state.copyWith(
        status: ChatStatus.success,
        messages: pendingMessages,
        composerAttachments: const <ChatAttachment>[],
        isSending: true,
        sessionActionErrorMessage: null,
      ),
    );

    await _submitAssistantResponse(
      emit: emit,
      pendingMessages: pendingMessages,
      request: retryRequest,
    );
  }

  void _onChatImageGenerationUpdated(
    ChatImageGenerationUpdated event,
    Emitter<ChatState> emit,
  ) {
    final index = _findGenerationMessageIndex(
      batchId: event.batchId,
      messageId: event.update.messageId,
    );
    if (index < 0) {
      return;
    }

    final currentMessage = state.messages[index];
    final nextGeneration =
        (currentMessage.generation ??
                ChatMessageGeneration(batchId: event.batchId))
            .copyWith(
              batchId: event.update.batchId ?? event.batchId,
              status: event.update.status,
              progress: event.update.progress,
              errorMessage: event.update.isFailed
                  ? event.update.errorMessage
                  : null,
            );
    final nextAttachments = _mergeRemoteAttachments(
      currentMessage.attachments,
      event.update.imageUrls,
    );

    var nextText = currentMessage.text;
    var nextTextKey = currentMessage.textKey;
    if (currentMessage.text.trim().isEmpty && currentMessage.textKey == null) {
      if (nextGeneration.isFailed) {
        nextText = event.update.errorMessage ?? _chatGenerationFailedMessage();
        nextTextKey = null;
      } else if (nextGeneration.isCompleted && nextAttachments.isNotEmpty) {
        nextText = _chatGenerationCompletedMessage();
      }
    }

    final nextMessages = List<ChatMessage>.from(state.messages);
    nextMessages[index] = currentMessage.copyWith(
      text: nextText,
      textKey: nextTextKey,
      attachments: nextAttachments,
      generation: nextGeneration,
      isError: nextGeneration.isFailed || currentMessage.isError,
    );

    emit(state.copyWith(messages: nextMessages));

    if (nextGeneration.isCompleted || nextGeneration.isFailed) {
      unawaited(_releaseGenerationSession(event.batchId));
    }
  }

  void _onChatImageGenerationFailed(
    ChatImageGenerationFailed event,
    Emitter<ChatState> emit,
  ) {
    final index = _findGenerationMessageIndex(batchId: event.batchId);
    if (index < 0) {
      final fallbackMessage = ChatMessage(
        text: event.message,
        type: MessageType.bot,
        time: DateTime.now(),
        isError: true,
      );
      emit(
        state.copyWith(
          messages: List<ChatMessage>.from(state.messages)
            ..insert(0, fallbackMessage),
        ),
      );
      unawaited(_releaseGenerationSession(event.batchId));
      return;
    }

    final nextMessages = List<ChatMessage>.from(state.messages);
    final currentMessage = nextMessages[index];
    nextMessages[index] = currentMessage.copyWith(
      text: currentMessage.text.trim().isEmpty
          ? event.message
          : currentMessage.text,
      generation:
          (currentMessage.generation ??
                  ChatMessageGeneration(batchId: event.batchId))
              .copyWith(status: 'failed', errorMessage: event.message),
      isError: true,
      textKey: null,
    );

    emit(state.copyWith(messages: nextMessages));
    unawaited(_releaseGenerationSession(event.batchId));
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
      ..sort(_compareHistoryMessagesDescending);

    return entries.map(_mapHistoryMessage).toList(growable: false);
  }

  ChatMessage _mapHistoryMessage(ChatHistoryMessage historyMessage) {
    final timestamp = historyMessage.createdAt ?? DateTime.now();
    final response = historyMessage.isUser
        ? null
        : _buildHistoryResponse(historyMessage);
    final responseAttachments =
        response?.contentImages ?? const <ChatAttachment>[];
    final mergedAttachments = _mergeAttachments(
      historyMessage.attachments,
      responseAttachments,
    );
    final historyMode = ChatComposerMode.fromDynamic(
      historyMessage.payload?.mode,
    );

    if (historyMessage.isUser) {
      return ChatMessage(
        text: historyMessage.message ?? '',
        type: MessageType.user,
        time: timestamp,
        serverMessageId: historyMessage.id,
        mode: historyMode,
        attachments: mergedAttachments,
      );
    }

    final explicitMessage = _resolveHistoryMessageText(historyMessage);
    final generation = _resolveGenerationState(response);
    return ChatMessage(
      text:
          explicitMessage ??
          (generation != null && mergedAttachments.isEmpty
              ? _chatGenerationQueuedMessage()
              : ''),
      type: MessageType.bot,
      time: timestamp,
      serverMessageId: historyMessage.id,
      attachments: mergedAttachments,
      response: response,
      generation: generation,
      textKey: explicitMessage == null && generation == null
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
        mode: payload.mode,
        type: payload.type,
        intent: payload.intent,
        content: payload.content,
        imageGeneration: payload.imageGeneration,
        aiRecommended: payload.aiRecommended.isEmpty
            ? null
            : payload.aiRecommended,
        catalogItems: payload.products.isEmpty ? null : payload.products,
        catalogSize: payload.catalogSize,
      ),
    );
  }

  String? _resolveHistoryMessageText(ChatHistoryMessage historyMessage) {
    final contentText = historyMessage.payload?.content?.text?.trim();
    if (contentText != null && contentText.isNotEmpty) {
      return contentText;
    }

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

  String? _resolveExplicitAssistantMessage(AiResponseChatModel response) {
    final candidates = <String?>[response.contentText, response.message];

    for (final candidate in candidates) {
      final normalized = candidate?.trim();
      if (normalized == null ||
          normalized.isEmpty ||
          _genericMessages.contains(normalized.toLowerCase())) {
        continue;
      }

      return normalized;
    }

    return null;
  }

  ChatMessageGeneration? _resolveGenerationState(
    AiResponseChatModel? response,
  ) {
    final imageGeneration = response?.imageGeneration;
    if (imageGeneration == null || !imageGeneration.isEnabled) {
      return null;
    }

    final generation = ChatMessageGeneration.fromResponse(imageGeneration);
    return generation.isVisible ? generation : null;
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

  Future<void> _submitAssistantResponse({
    required Emitter<ChatState> emit,
    required List<ChatMessage> pendingMessages,
    required ChatRetryRequest request,
  }) async {
    try {
      final response = await _sendChatRequest(request, emit);
      final assistantMessage = _buildAssistantMessage(
        response: response,
        requestedMode: request.mode,
      );
      final generation = assistantMessage.generation;
      final resolvedSessionId = response.data?.sessionId ?? state.sessionId;
      if (resolvedSessionId != null) {
        await _trySaveSessionId(resolvedSessionId);
      }

      emit(
        state.copyWith(
          status: ChatStatus.success,
          messages: List<ChatMessage>.from(pendingMessages)
            ..insert(0, assistantMessage),
          composerAttachments: const <ChatAttachment>[],
          isSending: false,
          sessionId: resolvedSessionId,
          sessionActionErrorMessage: null,
        ),
      );
      add(const ChatSessionsRequested(silent: true));

      final batchId = generation?.batchId?.trim();
      if (batchId != null && batchId.isNotEmpty) {
        await _bindImageGenerationUpdates(batchId: batchId);
      }
    } catch (error) {
      emit(
        state.copyWith(
          status: ChatStatus.success,
          messages: List<ChatMessage>.from(pendingMessages)
            ..insert(0, _buildRetryableFailureMessage(error, request)),
          composerAttachments: const <ChatAttachment>[],
          isSending: false,
        ),
      );
    }
  }

  Future<AiResponseChatModel> _sendChatRequest(
    ChatRetryRequest request,
    Emitter<ChatState> emit,
  ) async {
    var activeSessionId = state.sessionId;

    try {
      return await _repository.sendMessage(
        AiChatRequestModel(
          message: request.message,
          sessionId: activeSessionId,
          images: request.attachments,
          mode: request.mode,
        ),
      );
    } catch (error) {
      if (activeSessionId != null && _isMissingChatSessionError(error)) {
        await _tryClearSession();
        activeSessionId = null;
        emit(
          state.copyWith(
            sessionId: null,
            sessionActionErrorMessage: null,
            preserveSessionId: false,
          ),
        );

        return _repository.sendMessage(
          AiChatRequestModel(
            message: request.message,
            images: request.attachments,
            mode: request.mode,
          ),
        );
      }

      rethrow;
    }
  }

  ChatMessage _buildAssistantMessage({
    required AiResponseChatModel response,
    required ChatComposerMode requestedMode,
  }) {
    final generation = _resolveGenerationState(response);
    final explicitAssistantMessage = _resolveExplicitAssistantMessage(response);

    return ChatMessage(
      text:
          explicitAssistantMessage ??
          (generation != null ? _chatGenerationQueuedMessage() : ''),
      type: MessageType.bot,
      time: DateTime.now(),
      serverMessageId: response.data?.messageId,
      mode: ChatComposerMode.fromDynamic(
        response.mode ?? requestedMode.apiValue,
      ),
      attachments: response.contentImages,
      response: response,
      generation: generation,
      textKey: explicitAssistantMessage == null && generation == null
          ? _resolveAssistantMessageTextKey(response)
          : null,
      aiCount: response.aiRecommendedItems.length,
      catalogCount: response.catalogRecommendationItems.length,
    );
  }

  ChatMessage _buildRetryableFailureMessage(
    Object error,
    ChatRetryRequest request,
  ) {
    final explicitErrorMessage = _extractErrorMessage(error);
    final resolvedText = _isTimeoutError(error)
        ? _chatResponseDelayedMessage()
        : explicitErrorMessage?.trim().isNotEmpty == true
        ? explicitErrorMessage!.trim()
        : _chatSendFailedMessage();

    return ChatMessage(
      text: resolvedText,
      type: MessageType.bot,
      time: DateTime.now(),
      isError: true,
      retryRequest: request,
    );
  }

  Future<void> _bindImageGenerationUpdates({required String batchId}) async {
    if (_generationSessions.containsKey(batchId)) {
      return;
    }

    try {
      final realtimeSession = await _chatGenerationRealtimeService.connect(
        batchId: batchId,
      );
      _generationSessions[batchId] = realtimeSession;
      _generationSubscriptions[batchId] = realtimeSession.updates.listen(
        (ChatImageGenerationUpdate update) {
          add(ChatImageGenerationUpdated(batchId: batchId, update: update));
        },
        onError: (Object error, StackTrace stackTrace) {
          add(
            ChatImageGenerationFailed(
              batchId: batchId,
              message:
                  _extractErrorMessage(error) ??
                  'Unable to receive image generation updates right now.',
            ),
          );
        },
      );
    } catch (error) {
      add(
        ChatImageGenerationFailed(
          batchId: batchId,
          message:
              _extractErrorMessage(error) ??
              'Unable to receive image generation updates right now.',
        ),
      );
    }
  }

  Future<void> _restoreActiveGenerationStreams(
    List<ChatMessage> messages,
  ) async {
    for (final message in messages) {
      final generation = message.generation;
      final batchId = generation?.batchId?.trim();
      if (generation == null ||
          generation.isCompleted ||
          generation.isFailed ||
          batchId == null ||
          batchId.isEmpty) {
        continue;
      }

      await _bindImageGenerationUpdates(batchId: batchId);
    }
  }

  Future<void> _releaseGenerationSession(String batchId) async {
    final subscription = _generationSubscriptions.remove(batchId);
    await subscription?.cancel();
    final session = _generationSessions.remove(batchId);
    await session?.close();
  }

  Future<void> _releaseAllGenerationSessions() async {
    final batchIds = <String>{
      ..._generationSubscriptions.keys,
      ..._generationSessions.keys,
    };

    for (final batchId in batchIds) {
      await _releaseGenerationSession(batchId);
    }
  }

  int _findGenerationMessageIndex({required String batchId, int? messageId}) {
    return state.messages.indexWhere(
      (message) =>
          message.generation?.batchId == batchId ||
          (messageId != null && message.serverMessageId == messageId),
    );
  }

  List<ChatAttachment> _mergeRemoteAttachments(
    List<ChatAttachment> previous,
    List<String> imageUrls,
  ) {
    if (imageUrls.isEmpty) {
      return previous;
    }

    final attachments = <ChatAttachment>[...previous];
    final existingIds = attachments.map((attachment) => attachment.id).toSet();
    for (final imageUrl in imageUrls) {
      final attachment = ChatAttachment.fromRemoteUrl(imageUrl);
      if (existingIds.add(attachment.id)) {
        attachments.add(attachment);
      }
    }

    return attachments;
  }

  List<ChatAttachment> _mergeAttachments(
    List<ChatAttachment> first,
    List<ChatAttachment> second,
  ) {
    if (first.isEmpty) {
      return second;
    }

    if (second.isEmpty) {
      return first;
    }

    final merged = <ChatAttachment>[...first];
    final existingIds = merged.map((attachment) => attachment.id).toSet();
    for (final attachment in second) {
      if (existingIds.add(attachment.id)) {
        merged.add(attachment);
      }
    }
    return merged;
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

  int _compareHistoryMessagesDescending(
    ChatHistoryMessage first,
    ChatHistoryMessage second,
  ) {
    final firstTime = first.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    final secondTime =
        second.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    final timeComparison = secondTime.compareTo(firstTime);
    if (timeComparison != 0) {
      return timeComparison;
    }

    final firstId = first.id ?? -1;
    final secondId = second.id ?? -1;
    final idComparison = secondId.compareTo(firstId);
    if (idComparison != 0) {
      return idComparison;
    }

    if (first.isUser != second.isUser) {
      return first.isUser ? 1 : -1;
    }

    return 0;
  }

  bool _isMissingChatSessionError(Object error) {
    if (error is DioException && error.response?.statusCode == 404) {
      return true;
    }

    final message = _extractErrorMessage(error)?.toLowerCase() ?? '';
    return message.contains('chat session not found') ||
        message.contains('session not found');
  }

  bool _isTimeoutError(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return true;
        case DioExceptionType.badResponse:
        case DioExceptionType.cancel:
        case DioExceptionType.connectionError:
        case DioExceptionType.badCertificate:
        case DioExceptionType.unknown:
          break;
      }
    }

    final message = _extractErrorMessage(error)?.toLowerCase() ?? '';
    return message.contains('timed out') || message.contains('timeout');
  }

  String _chatSessionsLoadFailedMessage() {
    return 'Unable to load chat history right now. Please try again.';
  }

  String _chatSessionOpenFailedMessage() {
    return 'Unable to open this chat right now. Please try again.';
  }

  String _chatSessionDeleteFailedMessage() {
    return 'Unable to delete this chat right now. Please try again.';
  }

  String _chatGenerationQueuedMessage() {
    return 'Image generation started. Updates will appear here as soon as they are ready.';
  }

  String _chatGenerationCompletedMessage() {
    return 'Your generated images are ready.';
  }

  String _chatGenerationFailedMessage() {
    return 'Image generation could not be completed right now.';
  }

  String _chatSendFailedMessage() {
    return 'I could not send that message right now.';
  }

  String _chatResponseDelayedMessage() {
    return 'This response is taking longer than expected.';
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
}

const Set<String> _genericMessages = <String>{
  'success',
  'ok',
  'recommendations fetched successfully',
  'image generation started',
};

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
  }

  return null;
}
