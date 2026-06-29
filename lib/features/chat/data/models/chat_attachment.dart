import 'dart:io';

import 'package:equatable/equatable.dart';

class ChatAttachment extends Equatable {
  const ChatAttachment({
    required this.id,
    this.name,
    this.localPath,
    this.remoteUrl,
    this.status,
  });

  factory ChatAttachment.fromFile(File file) {
    final path = file.path.trim();

    return ChatAttachment(
      id: path,
      name: _resolveFileName(path),
      localPath: path,
    );
  }

  factory ChatAttachment.fromRemoteUrl(String url, {String? name}) {
    final normalizedUrl = url.trim();

    return ChatAttachment(
      id: normalizedUrl,
      name: name ?? _resolveFileName(normalizedUrl),
      remoteUrl: normalizedUrl,
    );
  }

  factory ChatAttachment.fromJson(Map<String, dynamic> json) {
    final normalized = _asMap(json) ?? const <String, dynamic>{};
    final remoteUrl = _firstNonEmptyString([
      normalized['url'],
      normalized['image_url'],
      normalized['full_url'],
      normalized['thumbnail'],
      normalized['preview_url'],
      normalized['file_url'],
      normalized['path'],
    ]);
    final localPath = _firstNonEmptyString([
      normalized['local_path'],
      normalized['file_path'],
    ]);
    final resolvedName = _firstNonEmptyString([
      normalized['name'],
      normalized['file_name'],
      normalized['original_name'],
      normalized['title'],
      normalized['alt'],
    ]);

    return ChatAttachment(
      id:
          _firstNonEmptyString([
            normalized['id'],
            localPath,
            remoteUrl,
            resolvedName,
          ]) ??
          '',
      name: resolvedName ?? _resolveFileName(localPath ?? remoteUrl ?? ''),
      localPath: localPath,
      remoteUrl: remoteUrl,
      status: _firstNonEmptyString([
        normalized['status'],
        normalized['item_status'],
      ]),
    );
  }

  static ChatAttachment? fromDynamic(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is String) {
      final normalized = value.trim();
      if (normalized.isEmpty) {
        return null;
      }

      return ChatAttachment.fromRemoteUrl(normalized);
    }

    final source = _asMap(value);
    if (source == null || source.isEmpty) {
      return null;
    }

    final attachment = ChatAttachment.fromJson(source);
    if (!attachment.isValid) {
      return null;
    }

    return attachment;
  }

  static List<ChatAttachment> listFromDynamic(dynamic value) {
    if (value == null) {
      return const <ChatAttachment>[];
    }

    if (value is List) {
      final attachments = <ChatAttachment>[];
      final seenIds = <String>{};

      for (final entry in value) {
        final attachment = ChatAttachment.fromDynamic(entry);
        if (attachment == null || !seenIds.add(attachment.id)) {
          continue;
        }
        attachments.add(attachment);
      }

      return attachments;
    }

    final source = _asMap(value);
    if (source != null && source.isNotEmpty) {
      final nestedAttachments = _mergeAttachments([
        source['images'],
        source['image_urls'],
        source['generated_images'],
        source['results'],
        source['attachments'],
        source['files'],
      ]);
      if (nestedAttachments.isNotEmpty) {
        return nestedAttachments;
      }
    }

    final singleAttachment = ChatAttachment.fromDynamic(value);
    if (singleAttachment == null) {
      return const <ChatAttachment>[];
    }

    return <ChatAttachment>[singleAttachment];
  }

  final String id;
  final String? name;
  final String? localPath;
  final String? remoteUrl;
  final String? status;

  bool get isLocal => localPath != null && localPath!.trim().isNotEmpty;

  bool get isRemote => remoteUrl != null && remoteUrl!.trim().isNotEmpty;
  bool get isValid => isLocal || isRemote;
  File? get file => isLocal ? File(localPath!) : null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name != null) 'name': name,
      if (localPath != null) 'local_path': localPath,
      if (remoteUrl != null) 'url': remoteUrl,
      if (status != null) 'status': status,
    };
  }

  @override
  List<Object?> get props => [id, name, localPath, remoteUrl, status];
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

String? _firstNonEmptyString(List<dynamic> values) {
  for (final value in values) {
    final normalized = value?.toString().trim();
    if (normalized != null && normalized.isNotEmpty) {
      return normalized;
    }
  }

  return null;
}

String _resolveFileName(String value) {
  final normalized = value.trim();
  if (normalized.isEmpty) {
    return 'image';
  }

  final sanitizedPath = normalized.split('?').first;
  final segments = sanitizedPath.split(RegExp(r'[\\/]'));
  final resolved = segments.last.trim();
  return resolved.isEmpty ? 'image' : resolved;
}

List<ChatAttachment> _mergeAttachments(List<dynamic> values) {
  final attachments = <ChatAttachment>[];
  final seenIds = <String>{};

  for (final value in values) {
    if (value == null) {
      continue;
    }

    if (value is List) {
      for (final entry in value) {
        final attachment = ChatAttachment.fromDynamic(entry);
        if (attachment == null || !seenIds.add(attachment.id)) {
          continue;
        }
        attachments.add(attachment);
      }
      continue;
    }

    final attachment = ChatAttachment.fromDynamic(value);
    if (attachment == null || !seenIds.add(attachment.id)) {
      continue;
    }
    attachments.add(attachment);
  }

  return attachments;
}
