import 'package:drip_talk/features/chat/data/ai_response_chat_model.dart';
import 'package:drip_talk/features/chat/data/models/chat_attachment.dart';

class FetchAllMessagesModel {
  const FetchAllMessagesModel({
    this.status,
    this.message,
    this.success = false,
    this.data = const <ChatHistoryMessage>[],
    this.meta,
    this.errors,
  });

  factory FetchAllMessagesModel.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    final dataObj = _asMap(source?['data']);

    // API returns: { status: "success", data: { messages: [...], session: {...} } }
    // Legacy format: { success: bool, data: [...], meta: { session: {...} } }
    final messages = dataObj?['messages'] ?? source?['data'];
    final sessionJson =
        _asMap(dataObj?['session']) ??
        _asMap(_asMap(source?['meta'])?['session']);

    final status = source?['status'];
    final success =
        (status is String && status.toLowerCase() == 'success') ||
        _asBool(source?['success']) == true;

    return FetchAllMessagesModel(
      status: _asString(source?['status']),
      message: _asString(source?['message']),
      success: success,
      data: _asList(messages, ChatHistoryMessage.fromJson),
      meta: ChatHistoryMeta.fromJson(
        sessionJson != null
            ? {'session': sessionJson}
            : _asMap(source?['meta']),
      ),
      errors: source?['errors'],
    );
  }

  final String? status;
  final String? message;
  final bool success;
  final List<ChatHistoryMessage> data;
  final ChatHistoryMeta? meta;
  final dynamic errors;

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'success': success,
      'data': data.map((item) => item.toJson()).toList(),
      'meta': meta?.toJson(),
      'errors': errors,
    };
  }
}

class ChatHistoryMessage {
  const ChatHistoryMessage({
    this.id,
    this.chatSessionId,
    this.sender,
    this.message,
    this.messageType,
    this.payload,
    this.attachments = const <ChatAttachment>[],
    this.createdAt,
    this.updatedAt,
  });

  factory ChatHistoryMessage.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    final payloadJson = _asMap(source?['payload']);
    final payloadSource = payloadJson ?? source;
    final payloadData = _asMap(payloadSource?['data']);
    final contentJson =
        _asMap(source?['content']) ??
        _asMap(payloadSource?['content']) ??
        _asMap(payloadData?['content']);
    final contentAttachmentsJson = _asMap(contentJson?['attachments']);
    final generationJson =
        _asMap(source?['generation']) ??
        _asMap(source?['image_generation']) ??
        _asMap(payloadSource?['generation']) ??
        _asMap(payloadSource?['image_generation']) ??
        _asMap(payloadData?['generation']) ??
        _asMap(payloadData?['image_generation']);

    return ChatHistoryMessage(
      id: _asInt(source?['id']),
      chatSessionId: _asInt(source?['chat_session_id']),
      sender: _asString(source?['sender']),
      message:
          _asString(source?['message']) ??
          _asString(contentJson?['text']) ??
          _asString(_asMap(payloadData?['content'])?['text']),
      messageType:
          _asString(source?['message_type']) ?? _asString(source?['type']),
      payload: ChatHistoryPayload.fromJson(payloadJson ?? source),
      attachments: _mergeAttachments([
        source?['attachments'],
        source?['images'],
        contentAttachmentsJson?['images'],
        contentAttachmentsJson?['files'],
        contentAttachmentsJson?['attachments'],
        payloadSource?['attachments'],
        payloadSource?['images'],
        payloadData?['attachments'],
        payloadData?['images'],
        payloadData?['image_urls'],
        contentJson?['images'],
        contentJson?['image_urls'],
        generationJson?['images'],
        generationJson?['results'],
      ]),
      createdAt:
          _asDateTime(source?['created_at']) ??
          _asDateTime(generationJson?['completed_at']),
      updatedAt: _asDateTime(source?['updated_at']),
    );
  }

  final int? id;
  final int? chatSessionId;
  final String? sender;
  final String? message;
  final String? messageType;
  final ChatHistoryPayload? payload;
  final List<ChatAttachment> attachments;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isUser {
    final normalizedSender = sender?.trim().toLowerCase();
    final normalizedType = messageType?.trim().toLowerCase();

    return normalizedSender == 'user' ||
        normalizedSender == 'human' ||
        normalizedType == 'user' ||
        normalizedType == 'human' ||
        normalizedType?.contains('user') == true;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_session_id': chatSessionId,
      'sender': sender,
      'message': message,
      'message_type': messageType,
      'payload': payload?.toJson(),
      'attachments': attachments
          .map((attachment) => attachment.toJson())
          .toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class ChatHistoryPayload {
  const ChatHistoryPayload({
    this.provider,
    this.model,
    this.mode,
    this.type,
    this.intent,
    this.aiResponse,
    this.content,
    this.imageGeneration,
    this.aiRecommended = const <AiRecommendedItem>[],
    this.products = const <CatalogItem>[],
    this.catalogSize,
  });

  factory ChatHistoryPayload.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    final data = _asMap(source?['data']);
    final contentJson = _asMap(source?['content']) ?? _asMap(data?['content']);
    final aiResponseJson =
        _asMap(source?['ai_response']) ??
        _asStringMap(
          _asString(source?['text']) ??
              _asString(source?['message']) ??
              _asString(data?['message']) ??
              _asString(contentJson?['text']),
        );

    return ChatHistoryPayload(
      provider: _asString(source?['provider']) ?? _asString(data?['provider']),
      model: _asString(source?['model']) ?? _asString(data?['model']),
      mode: _asString(source?['mode']) ?? _asString(data?['mode']),
      type:
          _asString(source?['type']) ??
          _asString(source?['message_type']) ??
          _asString(data?['type']),
      intent: _asString(source?['intent']) ?? _asString(data?['intent']),
      aiResponse: ChatHistoryAiResponse.fromJson(aiResponseJson),
      content: ChatResponseContent.fromJson(contentJson),
      imageGeneration: ChatImageGeneration.fromJson(
        _asMap(source?['generation']) ??
            _asMap(source?['image_generation']) ??
            _asMap(data?['generation']) ??
            _asMap(data?['image_generation']),
      ),
      aiRecommended: _asList(
        source?['ai_recommended'] ?? data?['ai_recommended'],
        AiRecommendedItem.fromJson,
      ),
      products: _asList(
        source?['products'] ??
            source?['catalog_items'] ??
            source?['catalog'] ??
            data?['products'] ??
            data?['catalog_items'] ??
            data?['catalog'],
        CatalogItem.fromJson,
      ),
      catalogSize:
          _asInt(source?['catalog_size']) ?? _asInt(data?['catalog_size']),
    );
  }

  final String? provider;
  final String? model;
  final String? mode;
  final String? type;
  final String? intent;
  final ChatHistoryAiResponse? aiResponse;
  final ChatResponseContent? content;
  final ChatImageGeneration? imageGeneration;
  final List<AiRecommendedItem> aiRecommended;
  final List<CatalogItem> products;
  final int? catalogSize;

  bool get hasRecommendations =>
      aiRecommended.isNotEmpty ||
      products.isNotEmpty ||
      aiResponse?.text != null ||
      content?.text?.trim().isNotEmpty == true ||
      content?.products.isNotEmpty == true ||
      content?.images.isNotEmpty == true ||
      content?.outfits.isNotEmpty == true ||
      imageGeneration?.images.isNotEmpty == true ||
      imageGeneration?.isEnabled == true;

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'model': model,
      'mode': mode,
      'type': type,
      'intent': intent,
      'ai_response': aiResponse?.toJson(),
      'content': content?.toJson(),
      'image_generation': imageGeneration?.toJson(),
      'ai_recommended': aiRecommended.map((item) => item.toJson()).toList(),
      'products': products.map((product) => product.toJson()).toList(),
      'catalog_size': catalogSize,
    };
  }
}

class ChatHistoryAiResponse {
  const ChatHistoryAiResponse({this.text, this.provider, this.model});

  factory ChatHistoryAiResponse.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return ChatHistoryAiResponse(
      text: _asString(source?['text']),
      provider: _asString(source?['provider']),
      model: _asString(source?['model']),
    );
  }

  final String? text;
  final String? provider;
  final String? model;

  Map<String, dynamic> toJson() {
    return {'text': text, 'provider': provider, 'model': model};
  }
}

class ChatHistoryMeta {
  const ChatHistoryMeta({this.session});

  factory ChatHistoryMeta.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return ChatHistoryMeta(
      session: ChatHistorySession.fromJson(_asMap(source?['session'])),
    );
  }

  final ChatHistorySession? session;

  Map<String, dynamic> toJson() {
    return {'session': session?.toJson()};
  }
}

class ChatHistorySession {
  const ChatHistorySession({
    this.id,
    this.userId,
    this.title,
    this.latestMessage,
    this.createdAt,
    this.updatedAt,
    this.messagesCount,
  });

  factory ChatHistorySession.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return ChatHistorySession(
      id: _asInt(source?['id']),
      userId: _asInt(source?['user_id']),
      title: _asString(source?['title']),
      latestMessage: ChatHistoryMessage.fromJson(
        _asMap(source?['latest_message']) ?? _asMap(source?['last_message']),
      ),
      createdAt: _asDateTime(source?['created_at']),
      updatedAt: _asDateTime(source?['updated_at']),
      messagesCount: _asInt(source?['messages_count']),
    );
  }

  final int? id;
  final int? userId;
  final String? title;
  final ChatHistoryMessage? latestMessage;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? messagesCount;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'latest_message': latestMessage?.toJson(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'messages_count': messagesCount,
    };
  }
}

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
  }

  return null;
}

List<T> _asList<T>(
  dynamic value,
  T Function(Map<String, dynamic>? json) builder,
) {
  if (value is! List) {
    return <T>[];
  }

  return value.map((entry) => builder(_asMap(entry))).toList();
}

List<ChatAttachment> _mergeAttachments(List<dynamic> values) {
  final attachments = <ChatAttachment>[];
  final seenIds = <String>{};

  for (final value in values) {
    for (final attachment in ChatAttachment.listFromDynamic(value)) {
      if (seenIds.add(attachment.id)) {
        attachments.add(attachment);
      }
    }
  }

  return attachments;
}

Map<String, dynamic>? _asStringMap(String? value) {
  if (value == null) {
    return null;
  }

  return <String, dynamic>{'text': value};
}

String? _asString(dynamic value) {
  if (value == null) {
    return null;
  }

  final normalized = value.toString().trim();
  return normalized.isEmpty ? null : normalized;
}

int? _asInt(dynamic value) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  if (value is String) {
    return int.tryParse(value.trim());
  }

  return null;
}

bool? _asBool(dynamic value) {
  if (value is bool) {
    return value;
  }

  if (value is num) {
    return value != 0;
  }

  if (value is String) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'true' || normalized == '1') {
      return true;
    }
    if (normalized == 'false' || normalized == '0') {
      return false;
    }
  }

  return null;
}

DateTime? _asDateTime(dynamic value) {
  if (value is DateTime) {
    return value;
  }

  if (value is String) {
    return DateTime.tryParse(value.trim());
  }

  return null;
}
