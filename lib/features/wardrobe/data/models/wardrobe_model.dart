import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:drip_talk/core/services/api/api_constants.dart';
import 'package:equatable/equatable.dart';

class WardrobeResponseModel {
  const WardrobeResponseModel({
    this.status,
    this.message,
    this.data = const WardrobeDataModel(),
    this.errors,
  });

  factory WardrobeResponseModel.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return WardrobeResponseModel(
      status: _asString(source?['status']),
      message: _asString(source?['message']),
      data: WardrobeDataModel.fromJson(_asMap(source?['data'])),
      errors: source?['errors'],
    );
  }

  final String? status;
  final String? message;
  final WardrobeDataModel data;
  final dynamic errors;

  List<WardrobeModel> get wardrobes => data.items;

  bool get isSuccessful {
    final normalizedStatus = status?.trim().toLowerCase();
    return normalizedStatus == null ||
        normalizedStatus == 'success' ||
        normalizedStatus == 'ok';
  }

  WardrobeModel? wardrobeById(int wardrobeId) {
    for (final wardrobe in wardrobes) {
      if (wardrobe.id == wardrobeId) {
        return wardrobe;
      }
    }
    return null;
  }

  WardrobeModel? get firstWardrobe {
    if (wardrobes.isEmpty) {
      return null;
    }

    return wardrobes.first;
  }
}

class WardrobeDataModel extends Equatable {
  const WardrobeDataModel({this.items = const <WardrobeModel>[]});

  factory WardrobeDataModel.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    return WardrobeDataModel(items: _extractWardrobes(source));
  }

  final List<WardrobeModel> items;

  @override
  List<Object?> get props => [items];
}

class WardrobeModel extends Equatable {
  const WardrobeModel({
    this.id,
    this.title,
    this.coverImage,
    this.totalItems,
    this.inWardrobeCount,
    this.inLaundryCount,
    this.createdAt,
    this.updatedAt,
    this.items = const <WardrobeItemModel>[],
  });

  factory WardrobeModel.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    if (source == null || source.isEmpty) {
      return const WardrobeModel();
    }

    final items = _listValue(source['items'], WardrobeItemModel.fromJson);
    final inWardrobeCount =
        _asInt(source['in_wardrobe_count']) ??
        items.where((item) => item.isInWardrobeLike).length;
    final inLaundryCount =
        _asInt(source['in_laundry_count']) ??
        items.where((item) => item.isInLaundry).length;

    return WardrobeModel(
      id: _asInt(source['id']),
      title: _asString(source['title']),
      coverImage: _asString(source['cover_image']),
      totalItems: _asInt(source['total_items']) ?? items.length,
      inWardrobeCount: inWardrobeCount,
      inLaundryCount: inLaundryCount,
      createdAt: _asDateTime(source['created_at']),
      updatedAt: _asDateTime(source['updated_at']),
      items: items,
    );
  }

  final int? id;
  final String? title;
  final String? coverImage;
  final int? totalItems;
  final int? inWardrobeCount;
  final int? inLaundryCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<WardrobeItemModel> items;

  String get displayTitle {
    final normalized = title?.trim();
    return (normalized == null || normalized.isEmpty)
        ? localizedString(
            fallback: 'Untitled Wardrobe',
            select: (l10n) => l10n.wardrobeUntitledTitle,
          )
        : _toTitleCase(normalized);
  }

  int get resolvedTotalItems => totalItems ?? items.length;

  int get resolvedInWardrobeCount =>
      inWardrobeCount ?? items.where((item) => item.isInWardrobeLike).length;

  int get resolvedInLaundryCount =>
      inLaundryCount ?? items.where((item) => item.isInLaundry).length;

  String? get resolvedCoverImageUrl {
    final directCover = _resolveApiImageUrl(coverImage);
    if (directCover != null) {
      return directCover;
    }

    if (items.isEmpty) {
      return null;
    }

    return items.first.resolvedImageUrl;
  }

  WardrobeModel copyWith({
    int? id,
    String? title,
    String? coverImage,
    int? totalItems,
    int? inWardrobeCount,
    int? inLaundryCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<WardrobeItemModel>? items,
  }) {
    return WardrobeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      coverImage: coverImage ?? this.coverImage,
      totalItems: totalItems ?? this.totalItems,
      inWardrobeCount: inWardrobeCount ?? this.inWardrobeCount,
      inLaundryCount: inLaundryCount ?? this.inLaundryCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    coverImage,
    totalItems,
    inWardrobeCount,
    inLaundryCount,
    createdAt,
    updatedAt,
    items,
  ];
}

class WardrobeItemModel extends Equatable {
  const WardrobeItemModel({
    this.id,
    this.wardrobeId,
    this.imagePath,
    this.status,
    this.metadata,
    this.aiProcessed,
    this.createdAt,
    this.updatedAt,
  });

  factory WardrobeItemModel.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    if (source == null || source.isEmpty) {
      return const WardrobeItemModel();
    }

    return WardrobeItemModel(
      id: _asInt(source['id']),
      wardrobeId: _asInt(source['wardrobe_id']),
      imagePath: _asString(source['image_path']),
      status: _asString(source['status']),
      metadata: WardrobeItemMetadataModel.fromJson(_asMap(source['metadata'])),
      aiProcessed: _asBool(source['ai_processed']),
      createdAt: _asDateTime(source['created_at']),
      updatedAt: _asDateTime(source['updated_at']),
    );
  }

  final int? id;
  final int? wardrobeId;
  final String? imagePath;
  final String? status;
  final WardrobeItemMetadataModel? metadata;
  final bool? aiProcessed;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get normalizedStatus => (status ?? '').trim().toLowerCase();

  bool get isInLaundry => normalizedStatus == 'in-laundry';

  bool get isInWardrobeLike =>
      normalizedStatus == 'in-wardrobe' || normalizedStatus == 'wearing';

  bool get isAiProcessed => aiProcessed ?? false;

  String? get resolvedImageUrl => _resolveApiImageUrl(imagePath);

  WardrobeItemModel copyWith({
    int? id,
    int? wardrobeId,
    String? imagePath,
    String? status,
    WardrobeItemMetadataModel? metadata,
    bool? aiProcessed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WardrobeItemModel(
      id: id ?? this.id,
      wardrobeId: wardrobeId ?? this.wardrobeId,
      imagePath: imagePath ?? this.imagePath,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
      aiProcessed: aiProcessed ?? this.aiProcessed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    wardrobeId,
    imagePath,
    status,
    metadata,
    aiProcessed,
    createdAt,
    updatedAt,
  ];
}

class WardrobeItemMetadataModel extends Equatable {
  const WardrobeItemMetadataModel({
    this.name,
    this.type,
    this.category,
    this.color,
    this.pattern,
    this.style,
    this.fit,
    this.material,
    this.formality,
    this.season,
    this.tags = const <String>[],
    this.notes,
  });

  factory WardrobeItemMetadataModel.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    if (source == null || source.isEmpty) {
      return const WardrobeItemMetadataModel();
    }

    return WardrobeItemMetadataModel(
      name: _asString(source['name']),
      type: _asString(source['type']),
      category: _asString(source['category']),
      color: _asString(source['color']),
      pattern: _asString(source['pattern']),
      style: _asString(source['style']),
      fit: _asString(source['fit']),
      material: _asString(source['material']),
      formality: _asString(source['formality']),
      season: _asString(source['season']),
      tags: _stringListValue(source['tags']),
      notes: _asString(source['notes']),
    );
  }

  final String? name;
  final String? type;
  final String? category;
  final String? color;
  final String? pattern;
  final String? style;
  final String? fit;
  final String? material;
  final String? formality;
  final String? season;
  final List<String> tags;
  final String? notes;

  String? get displayName => _normalizedLabel(name);
  String? get displayType => _normalizedLabel(type);
  String? get displayCategory => _normalizedLabel(category);
  String? get displayColor => _normalizedLabel(color);

  @override
  List<Object?> get props => [
    name,
    type,
    category,
    color,
    pattern,
    style,
    fit,
    material,
    formality,
    season,
    tags,
    notes,
  ];
}

List<WardrobeModel> _extractWardrobes(dynamic value) {
  if (value is List) {
    return value.map((item) => WardrobeModel.fromJson(_asMap(item))).toList();
  }

  final source = _asMap(value);
  if (source == null || source.isEmpty) {
    return const <WardrobeModel>[];
  }

  final itemsValue = source['items'];
  if (itemsValue is List) {
    return itemsValue
        .map((item) => WardrobeModel.fromJson(_asMap(item)))
        .toList();
  }

  final wardrobesValue = source['wardrobes'];
  if (wardrobesValue is List) {
    return wardrobesValue
        .map((item) => WardrobeModel.fromJson(_asMap(item)))
        .toList();
  }

  final nestedData = source['data'];
  if (nestedData != null && nestedData != value) {
    final nestedWardrobes = _extractWardrobes(nestedData);
    if (nestedWardrobes.isNotEmpty) {
      return nestedWardrobes;
    }
  }

  if (source.containsKey('title') ||
      source.containsKey('cover_image') ||
      source.containsKey('items') ||
      source.containsKey('total_items')) {
    return <WardrobeModel>[WardrobeModel.fromJson(source)];
  }

  return const <WardrobeModel>[];
}

String? _resolveApiImageUrl(String? value) {
  final normalized = value?.trim();
  if (normalized == null ||
      normalized.isEmpty ||
      normalized.toLowerCase() == 'null') {
    return null;
  }

  final uri = Uri.tryParse(normalized);
  if (uri != null && uri.hasScheme) {
    return normalized;
  }

  return Uri.parse(ApiConstants.baseUrl).resolve(normalized).toString();
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

List<T> _listValue<T>(
  dynamic value,
  T Function(Map<String, dynamic>? json) fromJson,
) {
  if (value is! List) {
    return <T>[];
  }

  return value.map((item) => fromJson(_asMap(item))).toList();
}

List<String> _stringListValue(dynamic value) {
  if (value is! List) {
    return const <String>[];
  }

  return value
      .map(_asString)
      .whereType<String>()
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();
}

String? _asString(dynamic value) {
  if (value == null) {
    return null;
  }

  final normalized = value.toString().trim();
  return normalized.isEmpty || normalized.toLowerCase() == 'null'
      ? null
      : normalized;
}

int? _asInt(dynamic value) {
  if (value is int) {
    return value;
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
  if (normalized == null || normalized.isEmpty) {
    return null;
  }

  if (normalized == 'true' || normalized == '1' || normalized == 'yes') {
    return true;
  }

  if (normalized == 'false' || normalized == '0' || normalized == 'no') {
    return false;
  }

  return null;
}

DateTime? _asDateTime(dynamic value) {
  if (value is DateTime) {
    return value;
  }

  final raw = value?.toString();
  if (raw == null || raw.trim().isEmpty) {
    return null;
  }

  return DateTime.tryParse(raw);
}

String _toTitleCase(String value) {
  final normalized = value.trim();
  if (normalized.isEmpty) {
    return normalized;
  }

  return normalized
      .split(RegExp(r'\s+'))
      .map(_normalizedLabel)
      .whereType<String>()
      .join(' ');
}

String? _normalizedLabel(String? value) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) {
    return null;
  }

  final lowerCased = normalized.toLowerCase();
  return lowerCased[0].toUpperCase() + lowerCased.substring(1);
}
