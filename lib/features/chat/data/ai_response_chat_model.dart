import 'dart:convert';

class AiResponseChatModel {
  const AiResponseChatModel({
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  factory AiResponseChatModel.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return AiResponseChatModel(
      status: _asString(source?['status']),
      message: _asString(source?['message']),
      data: RecommendationData.fromJson(_asMap(source?['data'])),
      errors: source?['errors'],
    );
  }

  factory AiResponseChatModel.fromRawJson(String value) =>
      AiResponseChatModel.fromJson(json.decode(value) as Map<String, dynamic>?);

  final String? status;
  final String? message;
  final RecommendationData? data;
  final dynamic errors;

  List<AiRecommendedItem> get aiRecommendedItems =>
      data?.aiRecommended ?? const <AiRecommendedItem>[];

  List<CatalogItem> get catalogRecommendationItems =>
      data?.catalogItems ?? const <CatalogItem>[];

  bool get hasAiRecommendations => aiRecommendedItems.isNotEmpty;

  bool get hasCatalogRecommendations => catalogRecommendationItems.isNotEmpty;

  bool get hasRecommendations =>
      hasAiRecommendations || hasCatalogRecommendations;

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

class RecommendationData {
  const RecommendationData({
    this.provider,
    this.model,
    this.sessionId,
    this.messageId,
    this.messageType,
    this.aiRecommended,
    this.catalogItems,
    this.catalogSize,
  });

  factory RecommendationData.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return RecommendationData(
      provider: _asString(source?['provider']),
      model: _asString(source?['model']),
      sessionId: _asInt(source?['session_id']),
      messageId: _asInt(source?['message_id']),
      messageType: _asString(source?['message_type']),
      aiRecommended: _asList(
        source?['ai_recommended'] ?? source?['recommendations'],
        AiRecommendedItem.fromJson,
      ),
      catalogItems: _asList(
        source?['catalog_items'] ??
            source?['products'] ??
            source?['catalog_recommendations'],
        CatalogItem.fromJson,
      ),
      catalogSize: _asInt(source?['catalog_size']),
    );
  }

  final String? provider;
  final String? model;
  final int? sessionId;
  final int? messageId;
  final String? messageType;
  final List<AiRecommendedItem>? aiRecommended;
  final List<CatalogItem>? catalogItems;
  final int? catalogSize;

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'model': model,
      'session_id': sessionId,
      'message_id': messageId,
      'message_type': messageType,
      'ai_recommended': aiRecommended?.map((item) => item.toJson()).toList(),
      'catalog_items': catalogItems?.map((item) => item.toJson()).toList(),
      'catalog_size': catalogSize,
    };
  }
}

class AiRecommendedItem {
  const AiRecommendedItem({
    this.title,
    this.source,
    this.provider,
    this.merchant,
    this.price,
    this.currency,
    this.imageUrl,
    this.productUrl,
    this.rating,
    this.reviews,
    this.delivery,
    this.reason,
  });

  factory AiRecommendedItem.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return AiRecommendedItem(
      title: _asString(source?['title']),
      source: _asString(source?['source']),
      provider: _asString(source?['provider']),
      merchant: _asString(source?['merchant']),
      price: _asString(source?['price']),
      currency: _asString(source?['currency']),
      imageUrl: _asString(source?['image_url']),
      productUrl: _asString(source?['product_url']),
      rating: _asDouble(source?['rating']),
      reviews: _asInt(source?['reviews']),
      delivery: _asString(source?['delivery']),
      reason: _asString(source?['reason']),
    );
  }

  final String? title;
  final String? source;
  final String? provider;
  final String? merchant;
  final String? price;
  final String? currency;
  final String? imageUrl;
  final String? productUrl;
  final double? rating;
  final int? reviews;
  final String? delivery;
  final String? reason;

  String? get priceLabel {
    return _composePriceLabel(price: price, currency: currency);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'source': source,
      'provider': provider,
      'merchant': merchant,
      'price': price,
      'currency': currency,
      'image_url': imageUrl,
      'product_url': productUrl,
      'rating': rating,
      'reviews': reviews,
      'delivery': delivery,
      'reason': reason,
    };
  }
}

class CatalogItem {
  const CatalogItem({
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
  });

  factory CatalogItem.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return CatalogItem(
      id: _asInt(source?['id']),
      title: _asString(source?['title']),
      slug: _asString(source?['slug']),
      price: _asString(source?['price']),
      salePrice: _asString(source?['sale_price']),
      currency: _asString(source?['currency']),
      thumbnail: _asString(source?['thumbnail']),
      isFeatured: _asBool(source?['is_featured']),
      freeDelivery: _asBool(source?['free_delivery']),
      category: CatalogCategory.fromJson(_asMap(source?['category'])),
      variants: _asRawList(source?['variants']),
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
  final CatalogCategory? category;
  final List<dynamic>? variants;

  String? get priceLabel {
    return _composePriceLabel(
      price: salePrice?.trim().isNotEmpty == true ? salePrice : price,
      currency: currency,
    );
  }

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
    };
  }
}

class CatalogCategory {
  const CatalogCategory({
    this.id,
    this.parentId,
    this.name,
    this.icon,
    this.image,
    this.isFeatured,
    this.status,
  });

  factory CatalogCategory.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return CatalogCategory(
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

List<dynamic>? _asRawList(dynamic value) {
  if (value is List<dynamic>) {
    return value;
  }

  if (value is List) {
    return value.cast<dynamic>();
  }

  return null;
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

double? _asDouble(dynamic value) {
  if (value is double) {
    return value;
  }

  if (value is num) {
    return value.toDouble();
  }

  if (value is String) {
    return double.tryParse(value.trim());
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

String? _composePriceLabel({
  required String? price,
  required String? currency,
}) {
  final resolvedPrice = price?.trim();
  if (resolvedPrice == null || resolvedPrice.isEmpty) {
    return null;
  }

  final resolvedCurrency = currency?.trim();
  if (resolvedCurrency == null || resolvedCurrency.isEmpty) {
    return resolvedPrice;
  }

  final normalizedPrice = resolvedPrice.toLowerCase();
  final normalizedCurrency = resolvedCurrency.toLowerCase();
  final currencySymbol = _currencySymbolFor(normalizedCurrency);

  if (normalizedPrice.startsWith(normalizedCurrency)) {
    return resolvedPrice;
  }

  if (resolvedPrice.startsWith(resolvedCurrency)) {
    return resolvedPrice;
  }

  if (currencySymbol != null && resolvedPrice.startsWith(currencySymbol)) {
    return resolvedPrice;
  }

  if (_isCurrencySymbol(resolvedCurrency)) {
    return '$resolvedCurrency$resolvedPrice';
  }

  if (currencySymbol != null) {
    return '$currencySymbol$resolvedPrice';
  }

  return '$resolvedCurrency $resolvedPrice';
}

bool _isCurrencySymbol(String value) {
  return const <String>{'\$', '€', '£', '¥', '₹', '₨'}.contains(value);
}

String? _currencySymbolFor(String value) {
  switch (value) {
    case 'usd':
    case 'us\$':
    case '\$':
      return '\$';
    case 'eur':
    case '€':
      return '€';
    case 'gbp':
    case '£':
      return '£';
    case 'inr':
    case '₹':
      return '₹';
    case 'pkr':
    case '₨':
    case 'rs':
      return '₨';
    default:
      return null;
  }
}
