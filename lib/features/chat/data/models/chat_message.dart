import 'package:equatable/equatable.dart';
import 'package:drip_talk/features/chat/data/ai_response_chat_model.dart';

enum MessageType { user, bot }

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.text,
    required this.type,
    required this.time,
    this.title,
    this.response,
    this.isError = false,
  });

  final String text;
  final MessageType type;
  final DateTime time;
  final String? title;
  final AiResponseChatModel? response;
  final bool isError;

  bool get hasRecommendations => response?.hasRecommendations == true;
  bool get isIntroCard => title != null && title!.trim().isNotEmpty;

  @override
  List<Object?> get props => [text, type, time, title, response, isError];
}
