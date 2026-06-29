import 'package:drip_talk/features/chat/data/models/ai_chat_request_model.dart';
import 'package:drip_talk/features/chat/data/models/chat_attachment.dart';
import 'package:drip_talk/features/chat/data/models/chat_message.dart';
import 'package:drip_talk/features/chat/data/models/chat_sessions_model.dart';
import 'package:equatable/equatable.dart';

enum ChatStatus { initial, loading, success, failure }

class ChatState extends Equatable {
  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const <ChatMessage>[],
    this.selectedMode = ChatComposerMode.wardrobe,
    this.composerAttachments = const <ChatAttachment>[],
    this.isSending = false,
    this.isLoadingHistory = false,
    this.sessionId,
    this.requiresStartupRecommendations = false,
    this.sessions = const <ChatSessionSummary>[],
    this.isLoadingSessions = false,
    this.deletingSessionId,
    this.sessionActionErrorMessage,
  });

  final ChatStatus status;
  final List<ChatMessage> messages;
  final ChatComposerMode selectedMode;
  final List<ChatAttachment> composerAttachments;
  final bool isSending;
  final bool isLoadingHistory;
  final int? sessionId;
  final bool requiresStartupRecommendations;
  final List<ChatSessionSummary> sessions;
  final bool isLoadingSessions;
  final int? deletingSessionId;
  final String? sessionActionErrorMessage;

  bool get isBusy => isSending || isLoadingHistory;
  bool get hasComposerAttachments => composerAttachments.isNotEmpty;
  bool get hasSessions => sessions.isNotEmpty;

  ChatState copyWith({
    ChatStatus? status,
    List<ChatMessage>? messages,
    ChatComposerMode? selectedMode,
    List<ChatAttachment>? composerAttachments,
    bool? isSending,
    bool? isLoadingHistory,
    int? sessionId,
    bool? requiresStartupRecommendations,
    List<ChatSessionSummary>? sessions,
    bool? isLoadingSessions,
    Object? deletingSessionId = _sentinel,
    Object? sessionActionErrorMessage = _sentinel,
    bool preserveSessionId = true,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      selectedMode: selectedMode ?? this.selectedMode,
      composerAttachments: composerAttachments ?? this.composerAttachments,
      isSending: isSending ?? this.isSending,
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
      sessionId: preserveSessionId ? (sessionId ?? this.sessionId) : sessionId,
      requiresStartupRecommendations:
          requiresStartupRecommendations ?? this.requiresStartupRecommendations,
      sessions: sessions ?? this.sessions,
      isLoadingSessions: isLoadingSessions ?? this.isLoadingSessions,
      deletingSessionId: deletingSessionId == _sentinel
          ? this.deletingSessionId
          : deletingSessionId as int?,
      sessionActionErrorMessage: sessionActionErrorMessage == _sentinel
          ? this.sessionActionErrorMessage
          : sessionActionErrorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    messages,
    selectedMode,
    composerAttachments,
    isSending,
    isLoadingHistory,
    sessionId,
    requiresStartupRecommendations,
    sessions,
    isLoadingSessions,
    deletingSessionId,
    sessionActionErrorMessage,
  ];
}

const Object _sentinel = Object();
