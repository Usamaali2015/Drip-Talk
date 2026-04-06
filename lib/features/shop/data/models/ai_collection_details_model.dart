class AiCollectionDetailsModel {
  const AiCollectionDetailsModel({
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  factory AiCollectionDetailsModel.fromJson(Map<String, dynamic>? json) {
    final root = _asMap(json);

    return AiCollectionDetailsModel(
      status: _asString(root?['status']),
      message: _asString(root?['message']),
      data: AiCollectionDetailsData.fromJson(_asMap(root?['data'])),
      errors: root?['errors'],
    );
  }

  final String? status;
  final String? message;
  final AiCollectionDetailsData? data;
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

class AiCollectionDetailsData {
  const AiCollectionDetailsData({
    this.outfit,
    this.products,
  });

  factory AiCollectionDetailsData.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return AiCollectionDetailsData(
      outfit: AiCollectionOutfit.fromJson(_asMap(source?['outfit'])),
      products: AiCollectionProducts.fromJson(_asMap(source?['products'])),
    );
  }

  final AiCollectionOutfit? outfit;
  final AiCollectionProducts? products;

  String? get image => outfit?.image;

  String? get resolvedTitle => outfit?.resolvedTitle;

  String? get resolvedDescription => outfit?.resolvedDescription;

  int get totalProducts =>
      outfit?.productsCount ??
      products?.pagination?.total ??
      products?.items.length ??
      0;

  List<AiCollectionProductItem> get items =>
      products?.items ?? const <AiCollectionProductItem>[];

  Map<String, dynamic> toJson() {
    return {
      'outfit': outfit?.toJson(),
      'products': products?.toJson(),
    };
  }
}

class AiCollectionOutfit {
  const AiCollectionOutfit({
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

  factory AiCollectionOutfit.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return AiCollectionOutfit(
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

  String? get resolvedTitle {
    final candidates = <String?>[
      title,
      description,
      _humanize(slug),
      _combineLabels(occasion, season),
    ];

    for (final candidate in candidates) {
      final normalized = candidate?.trim();
      if (normalized != null && normalized.isNotEmpty) {
        return normalized;
      }
    }

    return null;
  }

  String? get resolvedDescription {
    final candidates = <String?>[
      description,
      content,
      _combineLabels(gender, occasion),
      _combineLabels(occasion, season),
    ];

    for (final candidate in candidates) {
      final normalized = candidate?.trim();
      if (normalized != null && normalized.isNotEmpty) {
        return normalized;
      }
    }

    return null;
  }

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

class AiCollectionProducts {
  const AiCollectionProducts({
    this.items = const <AiCollectionProductItem>[],
    this.pagination,
  });

  factory AiCollectionProducts.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return AiCollectionProducts(
      items: _asList(source?['items'], AiCollectionProductItem.fromJson),
      pagination: AiCollectionProductsPagination.fromJson(
        _asMap(source?['pagination']),
      ),
    );
  }

  final List<AiCollectionProductItem> items;
  final AiCollectionProductsPagination? pagination;

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}

class AiCollectionProductItem {
  const AiCollectionProductItem({
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
  });

  factory AiCollectionProductItem.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return AiCollectionProductItem(
      id: _asInt(source?['id']),
      title: _asString(source?['title']),
      slug: _asString(source?['slug']),
      price: _asString(source?['price']),
      salePrice: _asString(source?['sale_price']),
      currency: _asString(source?['currency']),
      thumbnail: _asString(source?['thumbnail']),
      isFeatured: _asBool(source?['is_featured']),
      freeDelivery: _asBool(source?['free_delivery']),
      category: AiCollectionProductCategory.fromJson(_asMap(source?['category'])),
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
  final AiCollectionProductCategory? category;

  String? get primaryPrice {
    final normalizedSalePrice = salePrice?.trim();
    if (normalizedSalePrice != null && normalizedSalePrice.isNotEmpty) {
      return normalizedSalePrice;
    }

    final normalizedPrice = price?.trim();
    if (normalizedPrice == null || normalizedPrice.isEmpty) {
      return null;
    }

    return normalizedPrice;
  }

  String? get comparePrice {
    final normalizedPrice = price?.trim();
    final normalizedSalePrice = salePrice?.trim();

    if (normalizedPrice == null ||
        normalizedPrice.isEmpty ||
        normalizedSalePrice == null ||
        normalizedSalePrice.isEmpty ||
        normalizedPrice == normalizedSalePrice) {
      return null;
    }

    return normalizedPrice;
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
    };
  }
}

class AiCollectionProductCategory {
  const AiCollectionProductCategory({
    this.id,
    this.parentId,
    this.name,
    this.icon,
    this.image,
    this.isFeatured,
    this.status,
  });

  factory AiCollectionProductCategory.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return AiCollectionProductCategory(
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

class AiCollectionProductsPagination {
  const AiCollectionProductsPagination({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.from,
    this.to,
  });

  factory AiCollectionProductsPagination.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return AiCollectionProductsPagination(
      currentPage: _asInt(source?['current_page']),
      lastPage: _asInt(source?['last_page']),
      perPage: _asInt(source?['per_page']),
      total: _asInt(source?['total']),
      from: _asInt(source?['from']),
      to: _asInt(source?['to']),
    );
  }

  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;
  final int? from;
  final int? to;

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
      'from': from,
      'to': to,
    };
  }
}

String? _asString(dynamic value) {
  final normalized = value?.toString().trim();
  if (normalized == null || normalized.isEmpty || normalized == 'null') {
    return null;
  }

  return normalized;
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
  T Function(Map<String, dynamic>? json) fromJson,
) {
  if (value is! List) {
    return <T>[];
  }

  return value
      .map(_asMap)
      .whereType<Map<String, dynamic>>()
      .map(fromJson)
      .toList(growable: false);
}

String? _combineLabels(String? first, String? second) {
  final labels = [first, second]
      .map((value) => value?.trim())
      .whereType<String>()
      .where((value) => value.isNotEmpty)
      .toList();

  if (labels.isEmpty) {
    return null;
  }

  return labels.join(' • ');
}

String? _humanize(String? value) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) {
    return null;
  }

  return normalized
      .replaceAll(RegExp(r'[_-]+'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}
