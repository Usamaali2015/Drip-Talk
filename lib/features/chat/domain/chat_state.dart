import 'package:drip_talk/features/chat/data/models/ai_chat_request_model.dart';
import 'package:drip_talk/features/chat/data/models/chat_message.dart';
import 'package:equatable/equatable.dart';

enum ChatStatus { initial, success, failure }

class ChatState extends Equatable {
  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const <ChatMessage>[],
    this.isSending = false,
    this.sessionId,
    this.lastUsedPreferences = const AiChatUserPreferences(),
  });

  final ChatStatus status;
  final List<ChatMessage> messages;
  final bool isSending;
  final int? sessionId;
  final AiChatUserPreferences lastUsedPreferences;

  ChatState copyWith({
    ChatStatus? status,
    List<ChatMessage>? messages,
    bool? isSending,
    int? sessionId,
    AiChatUserPreferences? lastUsedPreferences,
    bool preserveSessionId = true,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      sessionId: preserveSessionId ? (sessionId ?? this.sessionId) : sessionId,
      lastUsedPreferences: lastUsedPreferences ?? this.lastUsedPreferences,
    );
  }

  @override
  List<Object?> get props => [
    status,
    messages,
    isSending,
    sessionId,
    lastUsedPreferences,
  ];
}
