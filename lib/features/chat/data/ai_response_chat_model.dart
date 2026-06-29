import 'dart:convert';

import 'package:drip_talk/features/chat/data/models/chat_attachment.dart';

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

  String? get contentText => data?.content?.text ?? data?.text;
  String? get mode => data?.mode;
  String? get type => data?.type;
  String? get intent => data?.intent;
  ChatImageGeneration? get imageGeneration => data?.imageGeneration;

  List<AiRecommendedItem> get aiRecommendedItems =>
      data?.aiRecommended ?? const <AiRecommendedItem>[];

  List<CatalogItem> get catalogRecommendationItems =>
      data?.catalogItems ?? data?.content?.products ?? const <CatalogItem>[];

  List<ChatAttachment> get contentImages => _mergeAttachments(
    data?.content?.images ?? const <ChatAttachment>[],
    data?.imageGeneration?.images ?? const <ChatAttachment>[],
  );

  List<ChatOutfit> get outfits =>
      data?.content?.outfits ?? const <ChatOutfit>[];

  bool get hasAiRecommendations => aiRecommendedItems.isNotEmpty;

  bool get hasCatalogRecommendations => catalogRecommendationItems.isNotEmpty;

  bool get hasOutfits => outfits.isNotEmpty;

  bool get hasRecommendations =>
      hasAiRecommendations || hasCatalogRecommendations || hasOutfits;

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
    this.mode,
    this.type,
    this.intent,
    this.text,
    this.content,
    this.imageGeneration,
    this.aiRecommended,
    this.catalogItems,
    this.catalogSize,
  });

  factory RecommendationData.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    final content = ChatResponseContent.fromJson(_asMap(source?['content']));

    return RecommendationData(
      provider: _asString(source?['provider']),
      model: _asString(source?['model']),
      sessionId: _asInt(source?['session_id']),
      messageId: _asInt(source?['message_id']),
      messageType: _asString(source?['message_type']),
      mode: _asString(source?['mode']),
      type: _asString(source?['type']),
      intent: _asString(source?['intent']),
      text: _asString(source?['text']) ?? _asString(source?['response']),
      content: content,
      imageGeneration: ChatImageGeneration.fromJson(
        _asMap(source?['image_generation']) ?? _asMap(source?['generation']),
      ),
      aiRecommended: _asList(
        source?['ai_recommended'] ?? source?['recommendations'],
        AiRecommendedItem.fromJson,
      ),
      catalogItems: _asList(
        source?['catalog_items'] ??
            source?['products'] ??
            source?['catalog_recommendations'] ??
            _asMap(source?['content'])?['products'] ??
            _asMap(source?['content'])?['catalog'],
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
  final String? mode;
  final String? type;
  final String? intent;
  final String? text;
  final ChatResponseContent? content;
  final ChatImageGeneration? imageGeneration;
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
      'mode': mode,
      'type': type,
      'intent': intent,
      'text': text,
      'content': content?.toJson(),
      'image_generation': imageGeneration?.toJson(),
      'ai_recommended': aiRecommended?.map((item) => item.toJson()).toList(),
      'catalog_items': catalogItems?.map((item) => item.toJson()).toList(),
      'catalog_size': catalogSize,
    };
  }
}

class ChatResponseContent {
  const ChatResponseContent({
    this.text,
    this.products = const <CatalogItem>[],
    this.images = const <ChatAttachment>[],
    this.outfits = const <ChatOutfit>[],
  });

  factory ChatResponseContent.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    final outfitItems = _asList(source?['outfits'], ChatOutfit.fromJson);
    final wardrobeItems = _asList(source?['wardrobe'], ChatOutfitItem.fromJson);
    final contentImages = ChatAttachment.listFromDynamic(
      source?['images'] ??
          source?['image_urls'] ??
          source?['generated_images'] ??
          source?['results'] ??
          _asMap(source?['attachments'])?['images'],
    );
    final wardrobeImages = ChatAttachment.listFromDynamic(source?['wardrobe']);

    return ChatResponseContent(
      text: _asString(source?['text']),
      products: _asList(
        source?['products'] ?? source?['catalog'],
        CatalogItem.fromJson,
      ),
      images: _mergeAttachments(contentImages, wardrobeImages),
      outfits: _mergeOutfits(
        outfitItems,
        wardrobeItems.isEmpty
            ? const <ChatOutfit>[]
            : <ChatOutfit>[
                ChatOutfit(title: 'Wardrobe matches', items: wardrobeItems),
              ],
      ),
    );
  }

  final String? text;
  final List<CatalogItem> products;
  final List<ChatAttachment> images;
  final List<ChatOutfit> outfits;

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'products': products.map((product) => product.toJson()).toList(),
      'images': images.map((image) => image.toJson()).toList(),
      'outfits': outfits.map((outfit) => outfit.toJson()).toList(),
    };
  }
}

class ChatOutfit {
  const ChatOutfit({
    this.title,
    this.items = const <ChatOutfitItem>[],
    this.styleNotes,
  });

  factory ChatOutfit.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return ChatOutfit(
      title: _asString(source?['title']),
      items: _asList(source?['items'], ChatOutfitItem.fromJson),
      styleNotes: _asString(source?['style_notes']),
    );
  }

  final String? title;
  final List<ChatOutfitItem> items;
  final String? styleNotes;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'items': items.map((item) => item.toJson()).toList(),
      'style_notes': styleNotes,
    };
  }
}

class ChatOutfitItem {
  const ChatOutfitItem({
    this.source,
    this.wardrobeId,
    this.productId,
    this.catalogId,
    this.productUrl,
    this.type,
    this.name,
    this.imageUrl,
    this.color,
    this.style,
    this.fit,
    this.material,
    this.pattern,
    this.tags = const <String>[],
    this.capturedAt,
  });

  factory ChatOutfitItem.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return ChatOutfitItem(
      source: _asString(source?['source']),
      wardrobeId: _asString(source?['wardrobe_id']),
      productId: _asInt(source?['product_id']),
      catalogId: _asInt(source?['catalog_id']),
      productUrl: _asString(source?['product_url']),
      type: _asString(source?['type']),
      name: _asString(source?['name']),
      imageUrl: _asString(source?['image_url']),
      color: _asString(source?['color']),
      style: _asString(source?['style']),
      fit: _asString(source?['fit']),
      material: _asString(source?['material']),
      pattern: _asString(source?['pattern']),
      tags: _stringListFromDynamic(source?['tags']),
      capturedAt: _asString(source?['captured_at']),
    );
  }

  final String? source;
  final String? wardrobeId;
  final int? productId;
  final int? catalogId;
  final String? productUrl;
  final String? type;
  final String? name;
  final String? imageUrl;
  final String? color;
  final String? style;
  final String? fit;
  final String? material;
  final String? pattern;
  final List<String> tags;
  final String? capturedAt;

  Map<String, dynamic> toJson() {
    return {
      'source': source,
      'wardrobe_id': wardrobeId,
      'product_id': productId,
      'catalog_id': catalogId,
      'product_url': productUrl,
      'type': type,
      'name': name,
      'image_url': imageUrl,
      'color': color,
      'style': style,
      'fit': fit,
      'material': material,
      'pattern': pattern,
      'tags': tags,
      'captured_at': capturedAt,
    };
  }
}

class ChatImageGeneration {
  const ChatImageGeneration({
    this.enabled,
    this.batchId,
    this.status,
    this.images = const <ChatAttachment>[],
    this.completedAt,
  });

  factory ChatImageGeneration.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return ChatImageGeneration(
      enabled: _asBool(source?['enabled']),
      batchId:
          _asString(source?['batch_id']) ??
          _asString(source?['batch_uuid']) ??
          _asString(source?['batchId']),
      status: _asString(source?['status']),
      images: ChatAttachment.listFromDynamic(
        source?['images'] ?? source?['results'],
      ),
      completedAt: _asDateTime(source?['completed_at']),
    );
  }

  final bool? enabled;
  final String? batchId;
  final String? status;
  final List<ChatAttachment> images;
  final DateTime? completedAt;

  bool get isEnabled =>
      enabled == true ||
      hasBatchId ||
      images.isNotEmpty ||
      status?.trim().isNotEmpty == true;

  bool get hasBatchId => batchId?.trim().isNotEmpty == true;

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'batch_id': batchId,
      'status': status,
      'images': images.map((image) => image.toJson()).toList(),
      'completed_at': completedAt?.toIso8601String(),
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
    this.productUrl,
    this.brand,
    this.color,
    this.style,
    this.tags = const <String>[],
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
      id: _asInt(source?['id']) ?? _asInt(source?['product_id']),
      title: _asString(source?['title']) ?? _asString(source?['name']),
      slug: _asString(source?['slug']),
      productUrl: _asString(source?['product_url']),
      brand: _asString(source?['brand']),
      color: _asString(source?['color']),
      style: _asString(source?['style']),
      tags: _stringListFromDynamic(source?['tags']),
      price: _asString(source?['price']),
      salePrice: _asString(source?['sale_price']),
      currency: _asString(source?['currency']),
      thumbnail:
          _asString(source?['thumbnail']) ?? _asString(source?['image_url']),
      isFeatured: _asBool(source?['is_featured']),
      freeDelivery: _asBool(source?['free_delivery']),
      category: CatalogCategory.fromJson(_asMap(source?['category'])),
      variants: _asRawList(source?['variants']),
    );
  }

  final int? id;
  final String? title;
  final String? slug;
  final String? productUrl;
  final String? brand;
  final String? color;
  final String? style;
  final List<String> tags;
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
      'product_url': productUrl,
      'brand': brand,
      'color': color,
      'style': style,
      'tags': tags,
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

  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(trimmed);
      return _asMap(decoded);
    } catch (_) {
      return null;
    }
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

List<ChatAttachment> _mergeAttachments(
  List<ChatAttachment> first,
  List<ChatAttachment> second,
) {
  if (first.isEmpty) {
    return second;
  }

  if (second.isEmpty) {
    return first;
  }

  final attachments = <ChatAttachment>[...first];
  final seenIds = attachments.map((attachment) => attachment.id).toSet();

  for (final attachment in second) {
    if (seenIds.add(attachment.id)) {
      attachments.add(attachment);
    }
  }

  return attachments;
}

List<ChatOutfit> _mergeOutfits(
  List<ChatOutfit> first,
  List<ChatOutfit> second,
) {
  if (first.isEmpty) {
    return second;
  }

  if (second.isEmpty) {
    return first;
  }

  return <ChatOutfit>[...first, ...second];
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

List<String> _stringListFromDynamic(dynamic value) {
  if (value is! List) {
    return const <String>[];
  }

  return value
      .map((entry) => _asString(entry))
      .whereType<String>()
      .toList(growable: false);
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

DateTime? _asDateTime(dynamic value) {
  if (value is DateTime) {
    return value;
  }

  if (value is String) {
    return DateTime.tryParse(value.trim());
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
