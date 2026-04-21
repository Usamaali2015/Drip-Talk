import 'package:equatable/equatable.dart';
import 'package:drip_talk/features/chat/data/ai_response_chat_model.dart';
import 'package:drip_talk/features/chat/data/models/chat_attachment.dart';

enum MessageType { user, bot }

enum ChatMessageTextKey {
  historyFallback,
  assistantSummaryAiAndCatalog,
  assistantSummaryAiOnly,
  assistantSummaryCatalogOnly,
  assistantSummaryGeneric,
  genericError,
}

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.text,
    required this.type,
    required this.time,
    this.title,
    this.attachments = const <ChatAttachment>[],
    this.response,
    this.isError = false,
    this.textKey,
    this.aiCount,
    this.catalogCount,
  });

  final String text;
  final MessageType type;
  final DateTime time;
  final String? title;
  final List<ChatAttachment> attachments;
  final AiResponseChatModel? response;
  final bool isError;
  final ChatMessageTextKey? textKey;
  final int? aiCount;
  final int? catalogCount;

  bool get hasText => textKey != null || text.trim().isNotEmpty || isIntroCard;
  bool get hasAttachments => attachments.isNotEmpty;
  bool get hasRecommendations => response?.hasRecommendations == true;
  bool get isIntroCard => title != null && title!.trim().isNotEmpty;

  @override
  List<Object?> get props => [
    text,
    type,
    time,
    title,
    attachments,
    response,
    isError,
    textKey,
    aiCount,
    catalogCount,
  ];
}
