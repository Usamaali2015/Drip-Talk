import 'package:drip_talk/features/chat/data/models/ai_chat_request_model.dart';
import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadInitialMessages extends ChatEvent {
  const LoadInitialMessages();
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
