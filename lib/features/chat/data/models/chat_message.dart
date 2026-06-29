import 'package:equatable/equatable.dart';
import 'package:drip_talk/features/chat/data/ai_response_chat_model.dart';
import 'package:drip_talk/features/chat/data/models/ai_chat_request_model.dart';
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
    this.serverMessageId,
    this.mode,
    this.attachments = const <ChatAttachment>[],
    this.response,
    this.generation,
    this.isError = false,
    this.textKey,
    this.aiCount,
    this.catalogCount,
    this.retryRequest,
  });

  final String text;
  final MessageType type;
  final DateTime time;
  final String? title;
  final int? serverMessageId;
  final ChatComposerMode? mode;
  final List<ChatAttachment> attachments;
  final AiResponseChatModel? response;
  final ChatMessageGeneration? generation;
  final bool isError;
  final ChatMessageTextKey? textKey;
  final int? aiCount;
  final int? catalogCount;
  final ChatRetryRequest? retryRequest;

  bool get hasText => textKey != null || text.trim().isNotEmpty || isIntroCard;
  bool get hasAttachments => attachments.isNotEmpty;
  bool get hasRecommendations => response?.hasRecommendations == true;
  bool get isIntroCard => title != null && title!.trim().isNotEmpty;
  bool get hasGeneration => generation != null;
  bool get hasRetryRequest => retryRequest != null;

  ChatMessage copyWith({
    String? text,
    MessageType? type,
    DateTime? time,
    Object? title = _sentinel,
    Object? serverMessageId = _sentinel,
    Object? mode = _sentinel,
    List<ChatAttachment>? attachments,
    Object? response = _sentinel,
    Object? generation = _sentinel,
    bool? isError,
    Object? textKey = _sentinel,
    Object? aiCount = _sentinel,
    Object? catalogCount = _sentinel,
    Object? retryRequest = _sentinel,
  }) {
    return ChatMessage(
      text: text ?? this.text,
      type: type ?? this.type,
      time: time ?? this.time,
      title: title == _sentinel ? this.title : title as String?,
      serverMessageId: serverMessageId == _sentinel
          ? this.serverMessageId
          : serverMessageId as int?,
      mode: mode == _sentinel ? this.mode : mode as ChatComposerMode?,
      attachments: attachments ?? this.attachments,
      response: response == _sentinel
          ? this.response
          : response as AiResponseChatModel?,
      generation: generation == _sentinel
          ? this.generation
          : generation as ChatMessageGeneration?,
      isError: isError ?? this.isError,
      textKey: textKey == _sentinel
          ? this.textKey
          : textKey as ChatMessageTextKey?,
      aiCount: aiCount == _sentinel ? this.aiCount : aiCount as int?,
      catalogCount: catalogCount == _sentinel
          ? this.catalogCount
          : catalogCount as int?,
      retryRequest: retryRequest == _sentinel
          ? this.retryRequest
          : retryRequest as ChatRetryRequest?,
    );
  }

  @override
  List<Object?> get props => [
    text,
    type,
    time,
    title,
    serverMessageId,
    mode,
    attachments,
    response,
    generation,
    isError,
    textKey,
    aiCount,
    catalogCount,
    retryRequest,
  ];
}

class ChatRetryRequest extends Equatable {
  const ChatRetryRequest({
    required this.message,
    required this.mode,
    this.attachments = const <ChatAttachment>[],
  });

  final String message;
  final ChatComposerMode mode;
  final List<ChatAttachment> attachments;

  @override
  List<Object?> get props => [message, mode, attachments];
}

class ChatMessageGeneration extends Equatable {
  const ChatMessageGeneration({
    this.batchId,
    this.status,
    this.progress,
    this.errorMessage,
  });

  factory ChatMessageGeneration.fromResponse(ChatImageGeneration? source) {
    if (source == null || !source.isEnabled) {
      return const ChatMessageGeneration();
    }

    return ChatMessageGeneration(
      batchId: source.batchId,
      status: source.status,
      progress: null,
    );
  }

  final String? batchId;
  final String? status;
  final int? progress;
  final String? errorMessage;

  bool get isCompleted =>
      _isCompletedStatus(status) || (progress != null && progress! >= 100);

  bool get isFailed => _isFailedStatus(status) || errorMessage != null;

  bool get isActive => batchId?.trim().isNotEmpty == true;

  bool get isVisible =>
      isActive ||
      isFailed ||
      status?.trim().isNotEmpty == true ||
      progress != null;

  ChatMessageGeneration copyWith({
    Object? batchId = _sentinel,
    Object? status = _sentinel,
    Object? progress = _sentinel,
    Object? errorMessage = _sentinel,
  }) {
    return ChatMessageGeneration(
      batchId: batchId == _sentinel ? this.batchId : batchId as String?,
      status: status == _sentinel ? this.status : status as String?,
      progress: progress == _sentinel ? this.progress : progress as int?,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [batchId, status, progress, errorMessage];
}

const Object _sentinel = Object();

bool _isCompletedStatus(String? value) {
  final normalized = value?.trim().toLowerCase();
  return const <String>{
    'complete',
    'completed',
    'done',
    'success',
    'succeeded',
    'finished',
  }.contains(normalized);
}

bool _isFailedStatus(String? value) {
  final normalized = value?.trim().toLowerCase();
  return const <String>{
    'failed',
    'error',
    'cancelled',
    'canceled',
    'rejected',
  }.contains(normalized);
}
