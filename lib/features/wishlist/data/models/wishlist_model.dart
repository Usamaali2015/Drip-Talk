import 'package:equatable/equatable.dart';

class WishListModel {
  const WishListModel({this.status, this.message, this.data, this.errors});

  factory WishListModel.fromJson(Map<String, dynamic>? json) {
    return WishListModel(
      status: _stringValue(json?['status']),
      message: _stringValue(json?['message']),
      data: WishListData.fromJson(_mapValue(json?['data'])),
      errors: json?['errors'],
    );
  }

  final String? status;
  final String? message;
  final WishListData? data;
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

class WishListData extends Equatable {
  const WishListData({this.items = const <WishListItem>[], this.pagination});

  factory WishListData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const WishListData();
    }

    return WishListData(
      items: _listValue(json['items'], WishListItem.fromJson),
      pagination: WishListPagination.fromJson(_mapValue(json['pagination'])),
    );
  }

  final List<WishListItem> items;
  final WishListPagination? pagination;

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }

  @override
  List<Object?> get props => [items, pagination];
}

class WishListItem extends Equatable {
  const WishListItem({
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
    this.variants = const <WishListVariant>[],
  });

  factory WishListItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const WishListItem();
    }

    return WishListItem(
      id: _intValue(json['id']),
      title: _stringValue(json['title']),
      slug: _stringValue(json['slug']),
      price: _stringValue(json['price']),
      salePrice: _stringValue(json['sale_price']),
      currency: _stringValue(json['currency']),
      thumbnail: _stringValue(json['thumbnail']),
      isFeatured: _boolValue(json['is_featured']),
      freeDelivery: _boolValue(json['free_delivery']),
      category: WishListCategory.fromJson(_mapValue(json['category'])),
      variants: _listValue(json['variants'], WishListVariant.fromJson),
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
  final WishListCategory? category;
  final List<WishListVariant> variants;

  WishListVariant? get primaryVariant {
    for (final variant in variants) {
      if (variant.inStock == true) {
        return variant;
      }
    }

    if (variants.isEmpty) {
      return null;
    }

    return variants.first;
  }

  int? get primaryVariantId => primaryVariant?.id;

  String? get resolvedThumbnail => _stringValue(
    _firstPresent(primaryVariant?.imageUrl, primaryVariant?.image, thumbnail),
  );

  String? get resolvedPrice =>
      _stringValue(_firstPresent(primaryVariant?.finalPrice, salePrice, price));

  double? get resolvedPriceValue =>
      _doubleValue(_firstPresent(primaryVariant?.finalPrice, salePrice, price));

  double? get comparePriceValue =>
      _doubleValue(_firstPresent(primaryVariant?.price, price));

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
      'variants': variants.map((variant) => variant.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    slug,
    price,
    salePrice,
    currency,
    thumbnail,
    isFeatured,
    freeDelivery,
    category,
    variants,
  ];
}

class WishListCategory extends Equatable {
  const WishListCategory({
    this.id,
    this.parentId,
    this.name,
    this.icon,
    this.image,
    this.isFeatured,
    this.status,
  });

  factory WishListCategory.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const WishListCategory();
    }

    return WishListCategory(
      id: _intValue(json['id']),
      parentId: _intValue(json['parent_id']),
      name: _stringValue(json['name']),
      icon: _stringValue(json['icon']),
      image: _stringValue(json['image']),
      isFeatured: _boolValue(json['is_featured']),
      status: _stringValue(json['status']),
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

  @override
  List<Object?> get props => [
    id,
    parentId,
    name,
    icon,
    image,
    isFeatured,
    status,
  ];
}

class WishListVariant extends Equatable {
  const WishListVariant({
    this.id,
    this.productId,
    this.sizeId,
    this.colorId,
    this.image,
    this.imageUrl,
    this.sku,
    this.price,
    this.salePrice,
    this.finalPrice,
    this.stock,
    this.stockQuantity,
    this.inStock,
    this.color,
    this.size,
    this.colorDetails,
    this.sizeDetails,
  });

  factory WishListVariant.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const WishListVariant();
    }

    return WishListVariant(
      id: _intValue(json['id']),
      productId: _intValue(json['product_id']),
      sizeId: _intValue(json['size_id']),
      colorId: _intValue(json['color_id']),
      image: _stringValue(json['image']),
      imageUrl: _stringValue(json['image_url']),
      sku: _stringValue(json['sku']),
      price: _stringValue(json['price']),
      salePrice: _stringValue(json['sale_price']),
      finalPrice: _stringValue(json['final_price']),
      stock: _intValue(json['stock']),
      stockQuantity: _intValue(json['stock_quantity']),
      inStock: _boolValue(json['in_stock']),
      color: _stringValue(json['color']),
      size: _stringValue(json['size']),
      colorDetails: WishListColorDetails.fromJson(
        _mapValue(json['color_details']),
      ),
      sizeDetails: WishListSizeDetails.fromJson(
        _mapValue(json['size_details']),
      ),
    );
  }

  final int? id;
  final int? productId;
  final int? sizeId;
  final int? colorId;
  final String? image;
  final String? imageUrl;
  final String? sku;
  final String? price;
  final String? salePrice;
  final String? finalPrice;
  final int? stock;
  final int? stockQuantity;
  final bool? inStock;
  final String? color;
  final String? size;
  final WishListColorDetails? colorDetails;
  final WishListSizeDetails? sizeDetails;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'size_id': sizeId,
      'color_id': colorId,
      'image': image,
      'image_url': imageUrl,
      'sku': sku,
      'price': price,
      'sale_price': salePrice,
      'final_price': finalPrice,
      'stock': stock,
      'stock_quantity': stockQuantity,
      'in_stock': inStock,
      'color': color,
      'size': size,
      'color_details': colorDetails?.toJson(),
      'size_details': sizeDetails?.toJson(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    productId,
    sizeId,
    colorId,
    image,
    imageUrl,
    sku,
    price,
    salePrice,
    finalPrice,
    stock,
    stockQuantity,
    inStock,
    color,
    size,
    colorDetails,
    sizeDetails,
  ];
}

class WishListColorDetails extends Equatable {
  const WishListColorDetails({this.id, this.name, this.hexCode, this.image});

  factory WishListColorDetails.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const WishListColorDetails();
    }

    return WishListColorDetails(
      id: _intValue(json['id']),
      name: _stringValue(json['name']),
      hexCode: _stringValue(json['hex_code']),
      image: _stringValue(json['image']),
    );
  }

  final int? id;
  final String? name;
  final String? hexCode;
  final String? image;

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'hex_code': hexCode, 'image': image};
  }

  @override
  List<Object?> get props => [id, name, hexCode, image];
}

class WishListSizeDetails extends Equatable {
  const WishListSizeDetails({
    this.id,
    this.name,
    this.chest,
    this.waist,
    this.length,
    this.gender,
  });

  factory WishListSizeDetails.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const WishListSizeDetails();
    }

    return WishListSizeDetails(
      id: _intValue(json['id']),
      name: _stringValue(json['name']),
      chest: _stringValue(json['chest']),
      waist: _stringValue(json['waist']),
      length: _stringValue(json['length']),
      gender: _stringValue(json['gender']),
    );
  }

  final int? id;
  final String? name;
  final String? chest;
  final String? waist;
  final String? length;
  final String? gender;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'chest': chest,
      'waist': waist,
      'length': length,
      'gender': gender,
    };
  }

  @override
  List<Object?> get props => [id, name, chest, waist, length, gender];
}

class WishListPagination extends Equatable {
  const WishListPagination({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
  });

  factory WishListPagination.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const WishListPagination();
    }

    return WishListPagination(
      currentPage: _intValue(json['current_page']),
      lastPage: _intValue(json['last_page']),
      perPage: _intValue(json['per_page']),
      total: _intValue(json['total']),
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

  @override
  List<Object?> get props => [currentPage, lastPage, perPage, total];
}

class WishlistActionResponse {
  const WishlistActionResponse({
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  factory WishlistActionResponse.fromJson(Map<String, dynamic>? json) {
    return WishlistActionResponse(
      status: _stringValue(json?['status']),
      message: _stringValue(json?['message']),
      data: _mapValue(json?['data']),
      errors: json?['errors'],
    );
  }

  final String? status;
  final String? message;
  final Map<String, dynamic>? data;
  final dynamic errors;
}

Map<String, dynamic>? _mapValue(dynamic value) {
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
  T Function(Map<String, dynamic>? json) builder,
) {
  if (value is! List) {
    return <T>[];
  }

  return value.map<T>((item) => builder(_mapValue(item))).toList();
}

String? _stringValue(dynamic value) {
  if (value == null) {
    return null;
  }

  final stringValue = value.toString().trim();
  return stringValue.isEmpty ? null : stringValue;
}

int? _intValue(dynamic value) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value?.toString() ?? '');
}

double? _doubleValue(dynamic value) {
  if (value is double) {
    return value;
  }

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '');
}

bool? _boolValue(dynamic value) {
  if (value is bool) {
    return value;
  }

  if (value is num) {
    return value != 0;
  }

  final normalizedValue = value?.toString().trim().toLowerCase();
  if (normalizedValue == null || normalizedValue.isEmpty) {
    return null;
  }

  if (normalizedValue == 'true' || normalizedValue == '1') {
    return true;
  }

  if (normalizedValue == 'false' || normalizedValue == '0') {
    return false;
  }

  return null;
}

dynamic _firstPresent(
  dynamic first, [
  dynamic second,
  dynamic third,
  dynamic fourth,
]) {
  if (first != null) {
    return first;
  }
  if (second != null) {
    return second;
  }
  if (third != null) {
    return third;
  }
  return fourth;
}
