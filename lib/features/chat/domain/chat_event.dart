import 'package:drip_talk/features/chat/data/models/ai_chat_request_model.dart';
import 'package:drip_talk/features/chat/data/models/chat_attachment.dart';
import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class InitializeChatRequested extends ChatEvent {
  const InitializeChatRequested();
}

class StartNewChatRequested extends ChatEvent {
  const StartNewChatRequested();
}

class ContinueOldChatRequested extends ChatEvent {
  const ContinueOldChatRequested();
}

class AddChatAttachmentsRequested extends ChatEvent {
  const AddChatAttachmentsRequested({required this.attachments});

  final List<ChatAttachment> attachments;

  @override
  List<Object?> get props => [attachments];
}

class RemoveChatAttachmentRequested extends ChatEvent {
  const RemoveChatAttachmentRequested({required this.attachmentId});

  final String attachmentId;

  @override
  List<Object?> get props => [attachmentId];
}

class SendMessageRequested extends ChatEvent {
  const SendMessageRequested({
    required this.message,
    required this.preferences,
  });

  final String message;
  final AiChatUserPreferences preferences;

  @override
  List<Object?> get props => [message, preferences];
}
