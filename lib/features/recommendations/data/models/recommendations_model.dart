import 'dart:convert';

class RecommendationsModel {
  const RecommendationsModel({
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  factory RecommendationsModel.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return RecommendationsModel(
      status: _asString(source?['status']),
      message: _asString(source?['message']),
      data: RecommendationsData.fromJson(_asMap(source?['data'])),
      errors: source?['errors'],
    );
  }

  factory RecommendationsModel.fromRawJson(String value) =>
      RecommendationsModel.fromJson(
        json.decode(value) as Map<String, dynamic>?,
      );

  final String? status;
  final String? message;
  final RecommendationsData? data;
  final dynamic errors;

  List<RecommendationItem> get items =>
      data?.items ?? const <RecommendationItem>[];

  bool get hasItems => items.isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
      'errors': errors,
    };
  }

  String toRawJson() => json.encode(toJson());
}

class RecommendationsData {
  const RecommendationsData({this.items, this.count, this.limit});

  factory RecommendationsData.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return RecommendationsData(
      items: _asList(source?['items'], RecommendationItem.fromJson),
      count: _asInt(source?['count']),
      limit: _asInt(source?['limit']),
    );
  }

  final List<RecommendationItem>? items;
  final int? count;
  final int? limit;

  Map<String, dynamic> toJson() {
    return {
      'items': items?.map((item) => item.toJson()).toList(),
      'count': count,
      'limit': limit,
    };
  }
}

class RecommendationItem {
  const RecommendationItem({
    this.id,
    this.title,
    this.slug,
    this.price,
    this.salePrice,
    this.currency,
    this.thumbnail,
    this.isFeatured,
    this.freeDelivery,
    this.category,
    this.variants,
    this.matchScore,
  });

  factory RecommendationItem.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return RecommendationItem(
      id: _asInt(source?['id']),
      title: _asString(source?['title']),
      slug: _asString(source?['slug']),
      price: _asString(source?['price']),
      salePrice: _asString(source?['sale_price']),
      currency: _asString(source?['currency']),
      thumbnail: _asString(source?['thumbnail']),
      isFeatured: _asBool(source?['is_featured']),
      freeDelivery: _asBool(source?['free_delivery']),
      category: RecommendationCategory.fromJson(_asMap(source?['category'])),
      variants: _asRawList(source?['variants']),
      matchScore: _asInt(source?['match_score']),
    );
  }

  final int? id;
  final String? title;
  final String? slug;
  final String? price;
  final String? salePrice;
  final String? currency;
  final String? thumbnail;
  final bool? isFeatured;
  final bool? freeDelivery;
  final RecommendationCategory? category;
  final List<dynamic>? variants;
  final int? matchScore;

  String? get effectivePrice =>
      salePrice?.trim().isNotEmpty == true ? salePrice : price;

  String? get priceLabel =>
      _composePriceLabel(price: effectivePrice, currency: currency);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'price': price,
      'sale_price': salePrice,
      'currency': currency,
      'thumbnail': thumbnail,
      'is_featured': isFeatured,
      'free_delivery': freeDelivery,
      'category': category?.toJson(),
      'variants': variants,
      'match_score': matchScore,
    };
  }
}

class RecommendationCategory {
  const RecommendationCategory({
    this.id,
    this.parentId,
    this.name,
    this.icon,
    this.image,
    this.isFeatured,
    this.status,
  });

  factory RecommendationCategory.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return RecommendationCategory(
      id: _asInt(source?['id']),
      parentId: _asInt(source?['parent_id']),
      name: _asString(source?['name']),
      icon: _asString(source?['icon']),
      image: _asString(source?['image']),
      isFeatured: _asBool(source?['is_featured']),
      status: _asString(source?['status']),
    );
  }

  final int? id;
  final int? parentId;
  final String? name;
  final String? icon;
  final String? image;
  final bool? isFeatured;
  final String? status;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'name': name,
      'icon': icon,
      'image': image,
      'is_featured': isFeatured,
      'status': status,
    };
  }
}

typedef RecomendationsModel = RecommendationsModel;
typedef Data = RecommendationsData;
typedef Items = RecommendationItem;
typedef Category = RecommendationCategory;

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
  }

  return null;
}

String? _asString(dynamic value) {
  final normalized = value?.toString().trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
}

int? _asInt(dynamic value) {
  if (value is int) {
    return value;
  }

  if (value is double) {
    return value.toInt();
  }

  return int.tryParse(value?.toString() ?? '');
}

bool? _asBool(dynamic value) {
  if (value is bool) {
    return value;
  }

  final normalized = value?.toString().trim().toLowerCase();
  switch (normalized) {
    case '1':
    case 'true':
      return true;
    case '0':
    case 'false':
      return false;
    default:
      return null;
  }
}

List<T> _asList<T>(
  dynamic value,
  T Function(Map<String, dynamic>? json) fromJson,
) {
  if (value is! List) {
    return <T>[];
  }

  return value
      .map((item) => item is Map ? fromJson(_asMap(item)) : null)
      .whereType<T>()
      .toList(growable: false);
}

List<dynamic>? _asRawList(dynamic value) {
  if (value is! List) {
    return null;
  }

  return List<dynamic>.from(value);
}

String? _composePriceLabel({
  required String? price,
  required String? currency,
}) {
  final normalizedPrice = price?.trim();
  if (normalizedPrice == null || normalizedPrice.isEmpty) {
    return null;
  }

  final normalizedCurrency = currency?.trim();
  if (normalizedCurrency == null || normalizedCurrency.isEmpty) {
    return normalizedPrice;
  }

  return '$normalizedPrice $normalizedCurrency';
}
