class ProductDetailsModel {
  ProductDetailsModel({
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic>? json) {
    return ProductDetailsModel(
      status: _stringValue(json?['status']),
      message: _stringValue(json?['message']),
      data: _productDetailsDataValue(json?['data']),
      errors: json?['errors'],
    );
  }

  final String? status;
  final String? message;
  final ProductDetailsData? data;
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

class ProductDetailsData {
  const ProductDetailsData({
    this.id,
    this.slug,
    this.title,
    this.description,
    this.shortDescription,
    this.isFeatured,
    this.status,
    this.pricing,
    this.category,
    this.brand,
    this.media,
    this.stock,
    this.rating,
    this.availableSizes = const <ProductAvailableSize>[],
    this.availableColors = const <ProductAvailableColor>[],
    this.variants = const <ProductVariant>[],
    this.selectedVariant,
    this.reviews = const <ProductReview>[],
    this.sizeGuide = const <ProductSizeGuide>[],
    this.relatedProducts = const <ProductRelatedProduct>[],
  });

  factory ProductDetailsData.fromJson(Map<String, dynamic> json) {
    return ProductDetailsData(
      id: _intValue(json['id']),
      slug: _stringValue(json['slug']),
      title: _stringValue(json['title']),
      description: _stringValue(json['description']),
      shortDescription: _stringValue(json['short_description']),
      isFeatured: _boolValue(json['is_featured']),
      status: _boolValue(json['status']),
      pricing: ProductPricing.fromJson(_mapValue(json['pricing'])),
      category: ProductCategory.fromJson(_mapValue(json['category'])),
      brand: ProductBrand.fromJson(_mapValue(json['brand'])),
      media: ProductMedia.fromJson(_mapValue(json['media'])),
      stock: ProductStock.fromJson(_mapValue(json['stock'])),
      rating: ProductRating.fromJson(_mapValue(json['rating'])),
      availableSizes: _listValue(
        json['available_sizes'],
        ProductAvailableSize.fromJson,
      ),
      availableColors: _listValue(
        json['available_colors'],
        ProductAvailableColor.fromJson,
      ),
      variants: _listValue(json['variants'], ProductVariant.fromJson),
      selectedVariant: _productVariantValue(json['selected_variant']),
      reviews: _listValue(json['reviews'], ProductReview.fromJson),
      sizeGuide: _listValue(json['size_guide'], ProductSizeGuide.fromJson),
      relatedProducts: _listValue(
        json['related_products'],
        ProductRelatedProduct.fromJson,
      ),
    );
  }

  final int? id;
  final String? slug;
  final String? title;
  final String? description;
  final String? shortDescription;
  final bool? isFeatured;
  final bool? status;
  final ProductPricing? pricing;
  final ProductCategory? category;
  final ProductBrand? brand;
  final ProductMedia? media;
  final ProductStock? stock;
  final ProductRating? rating;
  final List<ProductAvailableSize> availableSizes;
  final List<ProductAvailableColor> availableColors;
  final List<ProductVariant> variants;
  final ProductVariant? selectedVariant;
  final List<ProductReview> reviews;
  final List<ProductSizeGuide> sizeGuide;
  final List<ProductRelatedProduct> relatedProducts;

  String? get primaryPrice =>
      pricing?.finalPrice ?? pricing?.salePrice ?? pricing?.basePrice;

  String? get comparePrice {
    final basePrice = pricing?.basePrice;
    if (basePrice == null || basePrice == primaryPrice) {
      return null;
    }
    return basePrice;
  }

  int get reviewCount => rating?.count ?? reviews.length;

  String? get subtitle => brand?.name ?? category?.name;

  List<String> get imageUrls {
    final urls = <String>[];
    final seenUrls = <String>{};

    final thumbnail = media?.thumbnail?.trim();
    if (thumbnail != null && thumbnail.isNotEmpty && seenUrls.add(thumbnail)) {
      urls.add(thumbnail);
    }

    for (final image in media?.gallery ?? const <ProductGalleryImage>[]) {
      final url = image.image?.trim();
      if (url == null || url.isEmpty || !seenUrls.add(url)) {
        continue;
      }
      urls.add(url);
    }

    return urls;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'title': title,
      'description': description,
      'short_description': shortDescription,
      'is_featured': isFeatured,
      'status': status,
      'pricing': pricing?.toJson(),
      'category': category?.toJson(),
      'brand': brand?.toJson(),
      'media': media?.toJson(),
      'stock': stock?.toJson(),
      'rating': rating?.toJson(),
      'available_sizes': availableSizes.map((item) => item.toJson()).toList(),
      'available_colors': availableColors
          .map((item) => item.toJson())
          .toList(),
      'variants': variants.map((item) => item.toJson()).toList(),
      'selected_variant': selectedVariant?.toJson(),
      'reviews': reviews.map((item) => item.toJson()).toList(),
      'size_guide': sizeGuide.map((item) => item.toJson()).toList(),
      'related_products': relatedProducts.map((item) => item.toJson()).toList(),
    };
  }
}

class ProductPricing {
  const ProductPricing({
    this.basePrice,
    this.salePrice,
    this.finalPrice,
    this.discountPercentage,
    this.currency,
  });

  factory ProductPricing.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductPricing();
    }

    return ProductPricing(
      basePrice: _stringValue(json['base_price']),
      salePrice: _stringValue(json['sale_price']),
      finalPrice: _stringValue(json['final_price']),
      discountPercentage: _intValue(json['discount_percentage']),
      currency: _stringValue(json['currency']),
    );
  }

  final String? basePrice;
  final String? salePrice;
  final String? finalPrice;
  final int? discountPercentage;
  final String? currency;

  Map<String, dynamic> toJson() {
    return {
      'base_price': basePrice,
      'sale_price': salePrice,
      'final_price': finalPrice,
      'discount_percentage': discountPercentage,
      'currency': currency,
    };
  }
}

class ProductCategory {
  const ProductCategory({
    this.id,
    this.parentId,
    this.name,
    this.icon,
    this.image,
    this.isFeatured,
    this.status,
  });

  factory ProductCategory.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductCategory();
    }

    return ProductCategory(
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
}

class ProductBrand {
  const ProductBrand({
    this.id,
    this.name,
    this.description,
    this.logo,
    this.isFeatured,
    this.status,
  });

  factory ProductBrand.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductBrand();
    }

    return ProductBrand(
      id: _intValue(json['id']),
      name: _stringValue(json['name']),
      description: _stringValue(json['description']),
      logo: _stringValue(json['logo']),
      isFeatured: _boolValue(json['is_featured']),
      status: _stringValue(json['status']),
    );
  }

  final int? id;
  final String? name;
  final String? description;
  final String? logo;
  final bool? isFeatured;
  final String? status;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logo': logo,
      'is_featured': isFeatured,
      'status': status,
    };
  }
}

class ProductMedia {
  const ProductMedia({
    this.thumbnail,
    this.gallery = const <ProductGalleryImage>[],
  });

  factory ProductMedia.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductMedia();
    }

    return ProductMedia(
      thumbnail: _stringValue(json['thumbnail']),
      gallery: _listValue(json['gallery'], ProductGalleryImage.fromJson),
    );
  }

  final String? thumbnail;
  final List<ProductGalleryImage> gallery;

  Map<String, dynamic> toJson() {
    return {
      'thumbnail': thumbnail,
      'gallery': gallery.map((item) => item.toJson()).toList(),
    };
  }
}

class ProductGalleryImage {
  const ProductGalleryImage({
    this.image,
    this.sortOrder,
  });

  factory ProductGalleryImage.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductGalleryImage();
    }

    return ProductGalleryImage(
      image: _stringValue(json['image']),
      sortOrder: _intValue(json['sort_order']),
    );
  }

  final String? image;
  final int? sortOrder;

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'sort_order': sortOrder,
    };
  }
}

class ProductStock {
  const ProductStock({
    this.inStock,
    this.quantity,
  });

  factory ProductStock.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductStock();
    }

    return ProductStock(
      inStock: _boolValue(json['in_stock']),
      quantity: _intValue(json['quantity']),
    );
  }

  final bool? inStock;
  final int? quantity;

  Map<String, dynamic> toJson() {
    return {
      'in_stock': inStock,
      'quantity': quantity,
    };
  }
}

class ProductRating {
  const ProductRating({
    this.average,
    this.count,
  });

  factory ProductRating.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductRating();
    }

    return ProductRating(
      average: _doubleValue(json['average']),
      count: _intValue(json['count']),
    );
  }

  final double? average;
  final int? count;

  Map<String, dynamic> toJson() {
    return {
      'average': average,
      'count': count,
    };
  }
}

class ProductAvailableSize {
  const ProductAvailableSize({
    this.id,
    this.name,
  });

  factory ProductAvailableSize.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductAvailableSize();
    }

    return ProductAvailableSize(
      id: _intValue(json['id']),
      name: _stringValue(json['name']),
    );
  }

  final int? id;
  final String? name;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class ProductAvailableColor {
  const ProductAvailableColor({
    this.id,
    this.name,
    this.hexCode,
  });

  factory ProductAvailableColor.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductAvailableColor();
    }

    return ProductAvailableColor(
      id: _intValue(json['id']),
      name: _stringValue(json['name']),
      hexCode: _stringValue(json['hex_code']),
    );
  }

  final int? id;
  final String? name;
  final String? hexCode;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'hex_code': hexCode,
    };
  }
}

class ProductVariant {
  const ProductVariant({
    this.id,
    this.productId,
    this.sizeId,
    this.colorId,
    this.sku,
    this.price,
    this.salePrice,
    this.finalPrice,
    this.stockQuantity,
    this.inStock,
    this.image,
    this.imageUrl,
    this.color,
    this.size,
  });

  factory ProductVariant.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductVariant();
    }

    return ProductVariant(
      id: _intValue(json['id']),
      productId: _intValue(json['product_id']),
      sizeId: _intValue(json['size_id']),
      colorId: _intValue(json['color_id']),
      sku: _stringValue(json['sku']),
      price: _stringValue(json['price']),
      salePrice: _stringValue(json['sale_price']),
      finalPrice: _stringValue(json['final_price']),
      stockQuantity: _intValue(json['stock_quantity']),
      inStock: _boolValue(json['in_stock']),
      image: _stringValue(json['image']),
      imageUrl: _stringValue(json['image_url']),
      color: ProductVariantColor.fromJson(_mapValue(json['color'])),
      size: ProductVariantSize.fromJson(_mapValue(json['size'])),
    );
  }

  final int? id;
  final int? productId;
  final int? sizeId;
  final int? colorId;
  final String? sku;
  final String? price;
  final String? salePrice;
  final String? finalPrice;
  final int? stockQuantity;
  final bool? inStock;
  final String? image;
  final String? imageUrl;
  final ProductVariantColor? color;
  final ProductVariantSize? size;

  String? get currentPrice => finalPrice ?? salePrice ?? price;

  String? get comparePrice {
    if (price == null || price == currentPrice) {
      return null;
    }
    return price;
  }

  String? get displayImage => imageUrl ?? image;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'size_id': sizeId,
      'color_id': colorId,
      'sku': sku,
      'price': price,
      'sale_price': salePrice,
      'final_price': finalPrice,
      'stock_quantity': stockQuantity,
      'in_stock': inStock,
      'image': image,
      'image_url': imageUrl,
      'color': color?.toJson(),
      'size': size?.toJson(),
    };
  }
}

class ProductVariantColor {
  const ProductVariantColor({
    this.id,
    this.name,
    this.hexCode,
    this.image,
  });

  factory ProductVariantColor.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductVariantColor();
    }

    return ProductVariantColor(
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
    return {
      'id': id,
      'name': name,
      'hex_code': hexCode,
      'image': image,
    };
  }
}

class ProductVariantSize {
  const ProductVariantSize({
    this.id,
    this.name,
    this.chest,
    this.waist,
    this.length,
    this.gender,
  });

  factory ProductVariantSize.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductVariantSize();
    }

    return ProductVariantSize(
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
}

class ProductReview {
  const ProductReview({
    this.id,
    this.user,
    this.rating,
    this.review,
    this.createdAt,
  });

  factory ProductReview.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductReview();
    }

    return ProductReview(
      id: _intValue(json['id']),
      user: ProductReviewUser.fromJson(_mapValue(json['user'])),
      rating: _intValue(json['rating']),
      review: _stringValue(json['review']),
      createdAt: _stringValue(json['created_at']),
    );
  }

  final int? id;
  final ProductReviewUser? user;
  final int? rating;
  final String? review;
  final String? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user?.toJson(),
      'rating': rating,
      'review': review,
      'created_at': createdAt,
    };
  }
}

class ProductReviewUser {
  const ProductReviewUser({
    this.id,
    this.name,
  });

  factory ProductReviewUser.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductReviewUser();
    }

    return ProductReviewUser(
      id: _intValue(json['id']),
      name: _stringValue(json['name']),
    );
  }

  final int? id;
  final String? name;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class ProductSizeGuide {
  const ProductSizeGuide({
    this.id,
    this.name,
    this.chest,
    this.waist,
    this.length,
    this.gender,
  });

  factory ProductSizeGuide.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductSizeGuide();
    }

    return ProductSizeGuide(
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
}

class ProductRelatedProduct {
  const ProductRelatedProduct({
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

  factory ProductRelatedProduct.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductRelatedProduct();
    }

    return ProductRelatedProduct(
      id: _intValue(json['id']),
      title: _stringValue(json['title']),
      slug: _stringValue(json['slug']),
      price: _stringValue(json['price']),
      salePrice: _stringValue(json['sale_price']),
      currency: _stringValue(json['currency']),
      thumbnail: _stringValue(json['thumbnail']),
      isFeatured: _boolValue(json['is_featured']),
      freeDelivery: _boolValue(json['free_delivery']),
      category: ProductCategory.fromJson(_mapValue(json['category'])),
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
  final ProductCategory? category;

  String? get primaryPrice {
    if (salePrice != null && salePrice!.trim().isNotEmpty) {
      return salePrice;
    }
    return price;
  }

  String? get comparePrice {
    if (salePrice == null || salePrice == price) {
      return null;
    }
    return price;
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

String? _stringValue(dynamic value) {
  final stringValue = value?.toString();
  if (stringValue == null || stringValue.isEmpty || stringValue == 'null') {
    return null;
  }
  return stringValue;
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

  final normalized = value?.toString().trim().toLowerCase();
  if (normalized == 'true' || normalized == '1') {
    return true;
  }
  if (normalized == 'false' || normalized == '0') {
    return false;
  }
  return null;
}

Map<String, dynamic>? _mapValue(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.cast<String, dynamic>();
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

  return value.map((item) => fromJson(_mapValue(item))).toList();
}

ProductDetailsData? _productDetailsDataValue(dynamic value) {
  final json = _mapValue(value);
  if (json == null) {
    return null;
  }

  return ProductDetailsData.fromJson(json);
}

ProductVariant? _productVariantValue(dynamic value) {
  final json = _mapValue(value);
  if (json == null) {
    return null;
  }

  return ProductVariant.fromJson(json);
}
