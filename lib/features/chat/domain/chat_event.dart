import 'package:drip_talk/features/chat/data/models/ai_chat_request_model.dart';
import 'package:drip_talk/features/chat/data/models/chat_attachment.dart';
import 'package:drip_talk/features/chat/data/models/chat_message.dart';
import 'package:drip_talk/features/chat/data/services/chat_generation_realtime_service.dart';
import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class InitializeChatRequested extends ChatEvent {
  const InitializeChatRequested();
}

class ChatSessionsRequested extends ChatEvent {
  const ChatSessionsRequested({this.silent = false});

  final bool silent;

  @override
  List<Object?> get props => [silent];
}

class StartNewChatRequested extends ChatEvent {
  const StartNewChatRequested();
}

class ChatSessionOpenedRequested extends ChatEvent {
  const ChatSessionOpenedRequested({
    required this.sessionId,
    this.showLoader = true,
  });

  final int sessionId;
  final bool showLoader;

  @override
  List<Object?> get props => [sessionId, showLoader];
}

class ChatSessionDeletedRequested extends ChatEvent {
  const ChatSessionDeletedRequested({required this.sessionId});

  final int sessionId;

  @override
  List<Object?> get props => [sessionId];
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

class ChatComposerModeChanged extends ChatEvent {
  const ChatComposerModeChanged({required this.mode});

  final ChatComposerMode mode;

  @override
  List<Object?> get props => [mode];
}

class SendMessageRequested extends ChatEvent {
  const SendMessageRequested({required this.message, required this.mode});

  final String message;
  final ChatComposerMode mode;

  @override
  List<Object?> get props => [message, mode];
}

class RetryFailedMessageRequested extends ChatEvent {
  const RetryFailedMessageRequested({required this.message});

  final ChatMessage message;

  @override
  List<Object?> get props => [message];
}

class ChatImageGenerationUpdated extends ChatEvent {
  const ChatImageGenerationUpdated({
    required this.batchId,
    required this.update,
  });

  final String batchId;
  final ChatImageGenerationUpdate update;

  @override
  List<Object?> get props => [batchId, update];
}

class ChatImageGenerationFailed extends ChatEvent {
  const ChatImageGenerationFailed({
    required this.batchId,
    required this.message,
  });

  final String batchId;
  final String message;

  @override
  List<Object?> get props => [batchId, message];
}
