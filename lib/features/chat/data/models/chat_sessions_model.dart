class ChatSessionsModel {
  const ChatSessionsModel({
    this.success = false,
    this.sessions = const <ChatSessionSummary>[],
  });

  factory ChatSessionsModel.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    final data = _asMap(source?['data']);
    final sessionsValue =
        data?['sessions'] ??
        data?['items'] ??
        data?['data'] ??
        source?['sessions'] ??
        source?['items'] ??
        source?['data'];
    final status = source?['status']?.toString().trim().toLowerCase();

    return ChatSessionsModel(
      success:
          status == 'success' ||
          status == 'ok' ||
          _asBool(source?['success']) == true,
      sessions: _asList(sessionsValue, ChatSessionSummary.fromJson)
        ..sort((left, right) => right.sortDate.compareTo(left.sortDate)),
    );
  }

  final bool success;
  final List<ChatSessionSummary> sessions;
}

class ChatSessionSummary {
  const ChatSessionSummary({
    this.id,
    this.userId,
    this.title,
    this.preview,
    this.createdAt,
    this.updatedAt,
    this.lastMessageAt,
    this.messagesCount,
  });

  factory ChatSessionSummary.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    final lastMessage =
        _asMap(source?['last_message']) ?? _asMap(source?['latest_message']);
    final lastMessageContent = _asMap(lastMessage?['content']);

    return ChatSessionSummary(
      id: _asInt(source?['id']),
      userId: _asInt(source?['user_id']),
      title: _asString(source?['title']),
      preview:
          _asString(source?['preview']) ??
          _asString(source?['message_preview']) ??
          _asString(source?['last_message_text']) ??
          _asString(source?['last_message']) ??
          _asString(lastMessage?['message']) ??
          _asString(lastMessage?['text']) ??
          _asString(lastMessageContent?['text']) ??
          _asString(source?['message']) ??
          _asString(source?['excerpt']),
      createdAt: _asDateTime(source?['created_at']),
      updatedAt: _asDateTime(source?['updated_at']),
      lastMessageAt:
          _asDateTime(source?['last_message_at']) ??
          _asDateTime(lastMessage?['created_at']),
      messagesCount:
          _asInt(source?['messages_count']) ?? _asInt(source?['message_count']),
    );
  }

  final int? id;
  final int? userId;
  final String? title;
  final String? preview;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastMessageAt;
  final int? messagesCount;

  String get resolvedTitle {
    final titleText = title?.trim();
    if (titleText != null && titleText.isNotEmpty) {
      return titleText;
    }

    final previewText = preview?.trim();
    if (previewText != null && previewText.isNotEmpty) {
      return previewText;
    }

    return 'New chat';
  }

  String? get resolvedPreview {
    final previewText = preview?.trim();
    if (previewText == null || previewText.isEmpty) {
      return null;
    }

    final titleText = title?.trim();
    if (titleText != null &&
        titleText.isNotEmpty &&
        previewText.toLowerCase() == titleText.toLowerCase()) {
      return null;
    }

    return previewText;
  }

  DateTime get sortDate =>
      updatedAt ??
      lastMessageAt ??
      createdAt ??
      DateTime.fromMillisecondsSinceEpoch(0);
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

  return int.tryParse(value?.toString() ?? '');
}

bool? _asBool(dynamic value) {
  if (value is bool) {
    return value;
  }

  if (value is num) {
    return value != 0;
  }

  final normalized = value?.toString().trim().toLowerCase();
  if (normalized == 'true' || normalized == '1') {
    return true;
  }
  if (normalized == 'false' || normalized == '0') {
    return false;
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
