import 'dart:convert';
import 'dart:io';

import 'package:drip_talk/features/chat/data/models/chat_attachment.dart';

enum ChatComposerMode {
  wardrobe('wardrobe'),
  generate('generate');

  const ChatComposerMode(this.apiValue);

  final String apiValue;

  String get label => switch (this) {
    ChatComposerMode.wardrobe => 'Wardrobe',
    ChatComposerMode.generate => 'Generate',
  };

  static ChatComposerMode fromDynamic(dynamic value) {
    final normalized = value?.toString().trim().toLowerCase();
    return normalized == ChatComposerMode.generate.apiValue
        ? ChatComposerMode.generate
        : ChatComposerMode.wardrobe;
  }
}

class AiChatRequestModel {
  const AiChatRequestModel({
    required this.message,
    this.provider = 'openai',
    this.mode = ChatComposerMode.wardrobe,
    this.sessionId,
    this.images = const <ChatAttachment>[],
    this.imageUrls = const <String>[],
  });

  factory AiChatRequestModel.fromRawJson(String value) =>
      AiChatRequestModel.fromJson(json.decode(value) as Map<String, dynamic>);

  factory AiChatRequestModel.fromJson(Map<String, dynamic> json) {
    return AiChatRequestModel(
      provider: json['provider']?.toString() ?? 'openai',
      message: json['message']?.toString() ?? '',
      mode: ChatComposerMode.fromDynamic(json['mode']),
      sessionId: _asInt(json['session_id']),
      images: ChatAttachment.listFromDynamic(
        json['images'] ?? json['attachments'],
      ),
      imageUrls: _stringListFromDynamic(json['image_urls']),
    );
  }

  final String provider;
  final String message;
  final ChatComposerMode mode;
  final int? sessionId;
  final List<ChatAttachment> images;
  final List<String> imageUrls;

  List<File> get imageFiles =>
      images.map((image) => image.file).whereType<File>().toList();

  bool get hasImages => imageFiles.isNotEmpty;
  bool get hasRemoteImageUrls => requestImageUrls.isNotEmpty;

  List<String> get requestImageUrls {
    final urls = <String>{...imageUrls};
    for (final image in images) {
      final remoteUrl = image.remoteUrl?.trim();
      if (remoteUrl != null && remoteUrl.isNotEmpty) {
        urls.add(remoteUrl);
      }
    }
    return urls.toList(growable: false);
  }

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'message': message,
      'mode': mode.apiValue,
      if (sessionId != null) 'session_id': sessionId,
      if (requestImageUrls.isNotEmpty) 'image_urls': requestImageUrls,
    };
  }

  Map<String, dynamic> toMultipartFields() {
    final fields = <String, dynamic>{
      'provider': provider,
      'message': message,
      'mode': mode.apiValue,
      if (sessionId != null) 'session_id': sessionId,
      if (requestImageUrls.isNotEmpty) 'image_urls[]': requestImageUrls,
    };

    return fields;
  }

  String toRawJson() => json.encode(toJson());
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

List<String> _stringListFromDynamic(dynamic value) {
  if (value is! List) {
    return const <String>[];
  }

  final urls = <String>[];
  for (final entry in value) {
    final normalized = entry?.toString().trim();
    if (normalized == null || normalized.isEmpty) {
      continue;
    }
    urls.add(normalized);
  }

  return urls;
}
