class AiCuratedModel {
  const AiCuratedModel({this.status, this.message, this.data, this.errors});

  factory AiCuratedModel.fromJson(Map<String, dynamic>? json) {
    final root = _asMap(json);

    return AiCuratedModel(
      status: _asString(root?['status']),
      message: _asString(root?['message']),
      data: AiCuratedData.fromJson(_asMap(root?['data'])),
      errors: root?['errors'],
    );
  }

  final String? status;
  final String? message;
  final AiCuratedData? data;
  final dynamic errors;

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
      'errors': errors,
    };
  }
}

class AiCuratedData {
  const AiCuratedData({this.items, this.pagination});

  factory AiCuratedData.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return AiCuratedData(
      items: _asListOfMaps(source?['items']).map(AiCuratedItem.fromJson).toList(),
      pagination: AiCuratedPagination.fromJson(_asMap(source?['pagination'])),
    );
  }

  final List<AiCuratedItem>? items;
  final AiCuratedPagination? pagination;

  Map<String, dynamic> toJson() {
    return {
      'items': items?.map((item) => item.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}

class AiCuratedItem {
  const AiCuratedItem({
    this.id,
    this.slug,
    this.title,
    this.description,
    this.content,
    this.gender,
    this.occasion,
    this.season,
    this.image,
    this.productsCount,
    this.isFeatured,
    this.status,
    this.createdAt,
  });

  factory AiCuratedItem.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return AiCuratedItem(
      id: _asInt(source?['id']),
      slug: _asString(source?['slug']),
      title: _asString(source?['title']),
      description: _asString(source?['description']),
      content: _asString(source?['content']),
      gender: _asString(source?['gender']),
      occasion: _asString(source?['occasion']),
      season: _asString(source?['season']),
      image: _asString(source?['image']),
      productsCount: _asInt(source?['products_count']),
      isFeatured: _asBool(source?['is_featured']),
      status: _asString(source?['status']),
      createdAt: _asString(source?['created_at']),
    );
  }

  final int? id;
  final String? slug;
  final String? title;
  final String? description;
  final String? content;
  final String? gender;
  final String? occasion;
  final String? season;
  final String? image;
  final int? productsCount;
  final bool? isFeatured;
  final String? status;
  final String? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'title': title,
      'description': description,
      'content': content,
      'gender': gender,
      'occasion': occasion,
      'season': season,
      'image': image,
      'products_count': productsCount,
      'is_featured': isFeatured,
      'status': status,
      'created_at': createdAt,
    };
  }
}

class AiCuratedPagination {
  const AiCuratedPagination({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
  });

  factory AiCuratedPagination.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return AiCuratedPagination(
      currentPage: _asInt(source?['current_page']),
      lastPage: _asInt(source?['last_page']),
      perPage: _asInt(source?['per_page']),
      total: _asInt(source?['total']),
    );
  }

  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
    };
  }
}

String? _asString(dynamic value) {
  return value is String ? value : value?.toString();
}

int? _asInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value);
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

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
  }

  return null;
}

List<Map<String, dynamic>> _asListOfMaps(dynamic value) {
  if (value is! List) {
    return const <Map<String, dynamic>>[];
  }

  return value
      .map(_asMap)
      .whereType<Map<String, dynamic>>()
      .toList(growable: false);
}
