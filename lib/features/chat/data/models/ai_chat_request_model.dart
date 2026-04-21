import 'dart:convert';
import 'dart:io';

import 'package:drip_talk/features/chat/data/models/chat_attachment.dart';
import 'package:equatable/equatable.dart';

class AiChatRequestModel {
  const AiChatRequestModel({
    required this.message,
    required this.userPreferences,
    this.provider = 'openai',
    this.sessionId,
    this.images = const <ChatAttachment>[],
  });

  factory AiChatRequestModel.fromRawJson(String value) =>
      AiChatRequestModel.fromJson(json.decode(value) as Map<String, dynamic>);

  factory AiChatRequestModel.fromJson(Map<String, dynamic> json) {
    return AiChatRequestModel(
      provider: json['provider']?.toString() ?? 'openai',
      message: json['message']?.toString() ?? '',
      sessionId: _asInt(json['session_id']),
      images: ChatAttachment.listFromDynamic(
        json['images'] ?? json['attachments'],
      ),
      userPreferences: AiChatUserPreferences.fromJson(
        json['user_preferences'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  final String provider;
  final String message;
  final int? sessionId;
  final List<ChatAttachment> images;
  final AiChatUserPreferences userPreferences;

  bool get hasImages => images.isNotEmpty;

  List<File> get imageFiles =>
      images.map((image) => image.file).whereType<File>().toList();

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'message': message,
      if (sessionId != null) 'session_id': sessionId,
      if (images.isNotEmpty)
        'images': images.map((image) => image.toJson()).toList(),
      'user_preferences': userPreferences.toJson(),
    };
  }

  Map<String, dynamic> toMultipartFields() {
    final fields = <String, dynamic>{
      'provider': provider,
      'message': message,
      if (sessionId != null) 'session_id': sessionId,
    };

    userPreferences.toJson().forEach((key, value) {
      if (value != null) {
        fields['user_preferences[$key]'] = value;
      }
    });

    return fields;
  }

  String toRawJson() => json.encode(toJson());
}

class AiChatUserPreferences extends Equatable {
  const AiChatUserPreferences({
    this.gender,
    this.occasion,
    this.style,
    this.color,
    this.season,
    this.maxBudget,
  });

  factory AiChatUserPreferences.fromJson(Map<String, dynamic> json) {
    return AiChatUserPreferences(
      gender: _asString(json['gender']),
      occasion: _asString(json['occasion']),
      style: _asString(json['style']),
      color: _asString(json['color']),
      season: _asString(json['season']),
      maxBudget: _asInt(json['max_budget']),
    );
  }

  final String? gender;
  final String? occasion;
  final String? style;
  final String? color;
  final String? season;
  final int? maxBudget;

  bool get isEmpty =>
      gender == null &&
      occasion == null &&
      style == null &&
      color == null &&
      season == null &&
      maxBudget == null;

  AiChatUserPreferences copyWith({
    String? gender,
    String? occasion,
    String? style,
    String? color,
    String? season,
    int? maxBudget,
    bool clearGender = false,
    bool clearOccasion = false,
    bool clearStyle = false,
    bool clearColor = false,
    bool clearSeason = false,
    bool clearMaxBudget = false,
  }) {
    return AiChatUserPreferences(
      gender: clearGender ? null : (gender ?? this.gender),
      occasion: clearOccasion ? null : (occasion ?? this.occasion),
      style: clearStyle ? null : (style ?? this.style),
      color: clearColor ? null : (color ?? this.color),
      season: clearSeason ? null : (season ?? this.season),
      maxBudget: clearMaxBudget ? null : (maxBudget ?? this.maxBudget),
    );
  }

  AiChatUserPreferences mergeFallbacks(AiChatUserPreferences other) {
    return AiChatUserPreferences(
      gender: gender ?? other.gender,
      occasion: occasion ?? other.occasion,
      style: style ?? other.style,
      color: color ?? other.color,
      season: season ?? other.season,
      maxBudget: maxBudget ?? other.maxBudget,
    );
  }

  AiChatUserPreferences withDerivedValues(String message) {
    final normalizedOccasion = occasion?.trim().toLowerCase();

    return AiChatUserPreferences(
      gender: _normalizeText(gender),
      occasion: _normalizeText(occasion),
      style: _normalizeText(style) ?? _styleFromOccasion(normalizedOccasion),
      color: _normalizeText(color) ?? _extractColor(message),
      season: _normalizeText(season),
      maxBudget: maxBudget ?? _extractBudget(message),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (gender != null) 'gender': gender,
      if (occasion != null) 'occasion': occasion,
      if (style != null) 'style': style,
      if (color != null) 'color': color,
      if (season != null) 'season': season,
      if (maxBudget != null) 'max_budget': maxBudget,
    };
  }

  @override
  List<Object?> get props => [
    gender,
    occasion,
    style,
    color,
    season,
    maxBudget,
  ];
}

int? _extractBudget(String message) {
  final regex = RegExp(
    r'(?:under|below|max|budget|within|around|about|upto|up to)?\s*[$€£₹₨]?\s*(\d{2,5})',
    caseSensitive: false,
  );
  final match = regex.firstMatch(message);
  if (match == null) {
    return null;
  }

  return int.tryParse(match.group(1) ?? '');
}

String? _extractColor(String message) {
  const colors = <String>[
    'beige',
    'neutral',
    'black',
    'white',
    'grey',
    'gray',
    'navy',
    'blue',
    'green',
    'olive',
    'brown',
    'tan',
    'cream',
    'pink',
    'red',
    'burgundy',
    'maroon',
    'purple',
    'yellow',
    'orange',
    'gold',
    'silver',
  ];

  final normalizedMessage = message.toLowerCase();
  for (final color in colors) {
    if (normalizedMessage.contains(color)) {
      return color == 'gray' ? 'grey' : color;
    }
  }

  return null;
}

String? _styleFromOccasion(String? occasion) {
  switch (occasion) {
    case 'wedding':
    case 'office':
      return 'formal';
    case 'party':
    case 'date_night':
      return 'elevated';
    case 'casual':
      return 'casual';
    case 'sports':
      return 'active';
    default:
      return null;
  }
}

String? _normalizeText(String? value) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) {
    return null;
  }

  return normalized;
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
