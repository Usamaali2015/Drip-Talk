import 'package:drip_talk/features/chat/data/models/ai_chat_request_model.dart';
import 'package:drip_talk/features/chat/data/models/chat_attachment.dart';
import 'package:drip_talk/features/chat/data/models/chat_message.dart';
import 'package:equatable/equatable.dart';

enum ChatStatus { initial, loading, success, failure }

enum ChatLaunchSheetMode { hidden, newChatOnly, resumeOrNew }

class ChatState extends Equatable {
  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const <ChatMessage>[],
    this.composerAttachments = const <ChatAttachment>[],
    this.isSending = false,
    this.isLoadingHistory = false,
    this.sessionId,
    this.lastUsedPreferences = const AiChatUserPreferences(),
    this.launchSheetMode = ChatLaunchSheetMode.hidden,
  });

  final ChatStatus status;
  final List<ChatMessage> messages;
  final List<ChatAttachment> composerAttachments;
  final bool isSending;
  final bool isLoadingHistory;
  final int? sessionId;
  final AiChatUserPreferences lastUsedPreferences;
  final ChatLaunchSheetMode launchSheetMode;

  bool get isBusy => isSending || isLoadingHistory;
  bool get hasSavedPreferences => !lastUsedPreferences.isEmpty;
  bool get hasComposerAttachments => composerAttachments.isNotEmpty;

  ChatState copyWith({
    ChatStatus? status,
    List<ChatMessage>? messages,
    List<ChatAttachment>? composerAttachments,
    bool? isSending,
    bool? isLoadingHistory,
    int? sessionId,
    AiChatUserPreferences? lastUsedPreferences,
    ChatLaunchSheetMode? launchSheetMode,
    bool preserveSessionId = true,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      composerAttachments: composerAttachments ?? this.composerAttachments,
      isSending: isSending ?? this.isSending,
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
      sessionId: preserveSessionId ? (sessionId ?? this.sessionId) : sessionId,
      lastUsedPreferences: lastUsedPreferences ?? this.lastUsedPreferences,
      launchSheetMode: launchSheetMode ?? this.launchSheetMode,
    );
  }

  @override
  List<Object?> get props => [
    status,
    messages,
    composerAttachments,
    isSending,
    isLoadingHistory,
    sessionId,
    lastUsedPreferences,
    launchSheetMode,
  ];
}
