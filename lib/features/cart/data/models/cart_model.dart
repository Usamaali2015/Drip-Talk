import 'package:equatable/equatable.dart';

class CartResponseModel {
  const CartResponseModel({this.status, this.message, this.data, this.errors});

  factory CartResponseModel.fromJson(Map<String, dynamic>? json) {
    return CartResponseModel(
      status: _stringValue(json?['status']),
      message: _stringValue(json?['message']),
      data: CartData.fromJson(_mapValue(json?['data'])),
      errors: json?['errors'],
    );
  }

  final String? status;
  final String? message;
  final CartData? data;
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

class CartData extends Equatable {
  const CartData({
    this.id,
    this.items = const <CartItem>[],
    this.summary = const CartSummary(),
    this.itemCount,
    this.totalQuantity,
  });

  factory CartData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return nullCartData;
    }

    final items = _listValue(
      _firstPresent(
        json['items'],
        json['cart_items'],
        json['products'],
        _mapValue(json['products'])?['items'],
      ),
      CartItem.fromJson,
    );

    final summary = CartSummary.fromJson(
      _mapValue(
        _firstPresent(
          json['summary'],
          json['totals'],
          json['order_summary'],
          json['pricing'],
          json['amounts'],
        ),
      ),
    ).normalize(items);

    return CartData(
      id: _intValue(json['id']),
      items: items,
      summary: summary,
      itemCount: _intValue(
        _firstPresent(
          json['item_count'],
          json['items_count'],
          json['count'],
          json['total_items'],
          summary.itemCount,
        ),
      ),
      totalQuantity: _intValue(
        _firstPresent(
          json['total_quantity'],
          json['quantity'],
          json['items_quantity'],
        ),
      ),
    );
  }

  static const CartData nullCartData = CartData();

  final int? id;
  final List<CartItem> items;
  final CartSummary summary;
  final int? itemCount;
  final int? totalQuantity;

  int get resolvedItemCount => itemCount ?? summary.itemCount ?? items.length;

  int get resolvedTotalQuantity =>
      totalQuantity ??
      items.fold<int>(0, (total, item) => total + item.quantity.clamp(0, 9999));

  bool get hasMeaningfulData =>
      items.isNotEmpty ||
      summary.hasValues ||
      resolvedItemCount > 0 ||
      resolvedTotalQuantity > 0;

  CartData copyWith({
    int? id,
    List<CartItem>? items,
    CartSummary? summary,
    int? itemCount,
    int? totalQuantity,
  }) {
    final nextItems = items ?? this.items;
    return CartData(
      id: id ?? this.id,
      items: nextItems,
      summary: summary != null
          ? summary.normalize(nextItems)
          : this.summary.recalculate(nextItems),
      itemCount: itemCount ?? this.itemCount,
      totalQuantity: totalQuantity ?? this.totalQuantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'summary': summary.toJson(),
      'item_count': itemCount,
      'total_quantity': totalQuantity,
    };
  }

  @override
  List<Object?> get props => [id, items, summary, itemCount, totalQuantity];
}

class CartItem extends Equatable {
  const CartItem({
    this.id,
    this.productId,
    this.productVariantId,
    this.quantity = 1,
    this.product,
    this.variant,
    this.title,
    this.slug,
    this.thumbnail,
    this.currency,
    this.unitPrice,
    this.comparePrice,
    this.lineTotal,
    this.sizeLabel,
    this.colorLabel,
    this.sku,
    this.inStock,
    this.stockQuantity,
  });

  factory CartItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CartItem();
    }

    final product = CartProduct.fromJson(
      _mapValue(
        _firstPresent(json['product'], json['item'], json['fashion_product']),
      ),
    );
    final variant = CartVariant.fromJson(
      _mapValue(
        _firstPresent(
          json['variant'],
          json['product_variant'],
          json['selected_variant'],
        ),
      ),
    );

    return CartItem(
      id: _intValue(_firstPresent(json['id'], json['cart_item_id'])),
      productId: _intValue(
        _firstPresent(json['product_id'], product.id, variant.productId),
      ),
      productVariantId: _intValue(
        _firstPresent(
          json['product_variant_id'],
          json['variant_id'],
          variant.id,
        ),
      ),
      quantity: _intValue(_firstPresent(json['quantity'], json['qty'])) ?? 1,
      product: product.isEmpty ? null : product,
      variant: variant.isEmpty ? null : variant,
      title: _stringValue(
        _firstPresent(
          json['title'],
          json['name'],
          json['product_title'],
          product.title,
          product.name,
        ),
      ),
      slug: _stringValue(_firstPresent(json['slug'], product.slug)),
      thumbnail: _stringValue(
        _firstPresent(
          variant.imageUrl,
          variant.image,
          json['image_url'],
          json['image'],
          json['thumbnail'],
          product.thumbnail,
          product.image,
          product.imageUrl,
        ),
      ),
      currency: _stringValue(_firstPresent(json['currency'], product.currency)),
      unitPrice: _doubleValue(
        _firstPresent(
          json['price'],
          json['unit_price'],
          json['final_price'],
          product.finalPrice,
          product.salePrice,
          product.price,
          variant.finalPrice,
          variant.salePrice,
          variant.price,
        ),
      ),
      comparePrice: _doubleValue(
        _firstPresent(
          json['compare_price'],
          json['sale_price'],
          product.price,
          variant.regularPrice,
        ),
      ),
      lineTotal: _doubleValue(
        _firstPresent(
          json['item_total'],
          json['line_total'],
          json['subtotal'],
          json['total'],
          json['amount'],
        ),
      ),
      sizeLabel: _stringValue(
        _firstPresent(
          json['size'],
          json['size_name'],
          variant.size,
          variant.sizeName,
        ),
      ),
      colorLabel: _stringValue(
        _firstPresent(
          json['color'],
          json['color_name'],
          variant.color?.name,
          variant.colorName,
        ),
      ),
      sku: _stringValue(_firstPresent(json['sku'], variant.sku)),
      inStock: _boolValue(_firstPresent(json['in_stock'], variant.inStock)),
      stockQuantity: _intValue(
        _firstPresent(json['stock_quantity'], variant.stockQuantity),
      ),
    );
  }

  factory CartItem.optimistic({
    required int productVariantId,
    required int quantity,
    String? title,
    String? thumbnail,
    String? currency,
    double? unitPrice,
    double? comparePrice,
    String? sizeLabel,
    String? colorLabel,
    String? slug,
    int? productId,
  }) {
    return CartItem(
      productId: productId,
      productVariantId: productVariantId,
      quantity: quantity,
      product: CartProduct(
        id: productId,
        title: title,
        slug: slug,
        thumbnail: thumbnail,
        currency: currency,
      ),
      variant: CartVariant(
        id: productVariantId,
        price: unitPrice,
        regularPrice: comparePrice,
        size: sizeLabel,
        color: colorLabel == null ? null : CartVariantColor(name: colorLabel),
      ),
      title: title,
      thumbnail: thumbnail,
      currency: currency,
      unitPrice: unitPrice,
      comparePrice: comparePrice,
      sizeLabel: sizeLabel,
      colorLabel: colorLabel,
      slug: slug,
      inStock: true,
    );
  }

  final int? id;
  final int? productId;
  final int? productVariantId;
  final int quantity;
  final CartProduct? product;
  final CartVariant? variant;
  final String? title;
  final String? slug;
  final String? thumbnail;
  final String? currency;
  final double? unitPrice;
  final double? comparePrice;
  final double? lineTotal;
  final String? sizeLabel;
  final String? colorLabel;
  final String? sku;
  final bool? inStock;
  final int? stockQuantity;

  double get resolvedUnitPrice => unitPrice ?? 0;

  double get resolvedLineTotal => lineTotal ?? (resolvedUnitPrice * quantity);

  CartItem copyWith({
    int? id,
    int? productId,
    int? productVariantId,
    int? quantity,
    CartProduct? product,
    CartVariant? variant,
    String? title,
    String? slug,
    String? thumbnail,
    String? currency,
    double? unitPrice,
    double? comparePrice,
    double? lineTotal,
    String? sizeLabel,
    String? colorLabel,
    String? sku,
    bool? inStock,
    int? stockQuantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productVariantId: productVariantId ?? this.productVariantId,
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
      variant: variant ?? this.variant,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      thumbnail: thumbnail ?? this.thumbnail,
      currency: currency ?? this.currency,
      unitPrice: unitPrice ?? this.unitPrice,
      comparePrice: comparePrice ?? this.comparePrice,
      lineTotal: lineTotal ?? this.lineTotal,
      sizeLabel: sizeLabel ?? this.sizeLabel,
      colorLabel: colorLabel ?? this.colorLabel,
      sku: sku ?? this.sku,
      inStock: inStock ?? this.inStock,
      stockQuantity: stockQuantity ?? this.stockQuantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_variant_id': productVariantId,
      'quantity': quantity,
      'product': product?.toJson(),
      'variant': variant?.toJson(),
      'title': title,
      'slug': slug,
      'thumbnail': thumbnail,
      'currency': currency,
      'price': unitPrice,
      'compare_price': comparePrice,
      'line_total': lineTotal,
      'size': sizeLabel,
      'color': colorLabel,
      'sku': sku,
      'in_stock': inStock,
      'stock_quantity': stockQuantity,
    };
  }

  @override
  List<Object?> get props => [
    id,
    productId,
    productVariantId,
    quantity,
    product,
    variant,
    title,
    slug,
    thumbnail,
    currency,
    unitPrice,
    comparePrice,
    lineTotal,
    sizeLabel,
    colorLabel,
    sku,
    inStock,
    stockQuantity,
  ];
}

class CartProduct extends Equatable {
  const CartProduct({
    this.id,
    this.title,
    this.name,
    this.slug,
    this.thumbnail,
    this.image,
    this.imageUrl,
    this.currency,
    this.price,
    this.salePrice,
    this.finalPrice,
  });

  factory CartProduct.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CartProduct();
    }

    return CartProduct(
      id: _intValue(json['id']),
      title: _stringValue(json['title']),
      name: _stringValue(json['name']),
      slug: _stringValue(json['slug']),
      thumbnail: _stringValue(json['thumbnail']),
      image: _stringValue(json['image']),
      imageUrl: _stringValue(_firstPresent(json['image_url'], json['image'])),
      currency: _stringValue(json['currency']),
      price: _doubleValue(json['price']),
      salePrice: _doubleValue(json['sale_price']),
      finalPrice: _doubleValue(json['final_price']),
    );
  }

  final int? id;
  final String? title;
  final String? name;
  final String? slug;
  final String? thumbnail;
  final String? image;
  final String? imageUrl;
  final String? currency;
  final double? price;
  final double? salePrice;
  final double? finalPrice;

  bool get isEmpty =>
      id == null &&
      title == null &&
      name == null &&
      slug == null &&
      thumbnail == null &&
      image == null &&
      imageUrl == null &&
      currency == null &&
      price == null &&
      salePrice == null &&
      finalPrice == null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'name': name,
      'slug': slug,
      'thumbnail': thumbnail,
      'image': image,
      'image_url': imageUrl,
      'currency': currency,
      'price': price,
      'sale_price': salePrice,
      'final_price': finalPrice,
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    name,
    slug,
    thumbnail,
    image,
    imageUrl,
    currency,
    price,
    salePrice,
    finalPrice,
  ];
}

class CartVariant extends Equatable {
  const CartVariant({
    this.id,
    this.productId,
    this.sku,
    this.price,
    this.salePrice,
    this.finalPrice,
    this.regularPrice,
    this.size,
    this.sizeName,
    this.colorName,
    this.color,
    this.image,
    this.imageUrl,
    this.inStock,
    this.stockQuantity,
  });

  factory CartVariant.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CartVariant();
    }

    return CartVariant(
      id: _intValue(json['id']),
      productId: _intValue(json['product_id']),
      sku: _stringValue(json['sku']),
      price: _doubleValue(json['price']),
      salePrice: _doubleValue(json['sale_price']),
      finalPrice: _doubleValue(json['final_price']),
      regularPrice: _doubleValue(
        _firstPresent(json['regular_price'], json['price']),
      ),
      size: _stringValue(json['size']),
      sizeName: _stringValue(_mapValue(json['size'])?['name']),
      colorName: _stringValue(json['color_name']),
      color: CartVariantColor.fromJson(_mapValue(json['color'])),
      image: _stringValue(json['image']),
      imageUrl: _stringValue(_firstPresent(json['image_url'], json['image'])),
      inStock: _boolValue(json['in_stock']),
      stockQuantity: _intValue(json['stock_quantity']),
    );
  }

  final int? id;
  final int? productId;
  final String? sku;
  final double? price;
  final double? salePrice;
  final double? finalPrice;
  final double? regularPrice;
  final String? size;
  final String? sizeName;
  final String? colorName;
  final CartVariantColor? color;
  final String? image;
  final String? imageUrl;
  final bool? inStock;
  final int? stockQuantity;

  bool get isEmpty =>
      id == null &&
      productId == null &&
      sku == null &&
      price == null &&
      salePrice == null &&
      finalPrice == null &&
      regularPrice == null &&
      size == null &&
      sizeName == null &&
      colorName == null &&
      (color == null || color!.isEmpty) &&
      image == null &&
      imageUrl == null &&
      inStock == null &&
      stockQuantity == null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'sku': sku,
      'price': price,
      'sale_price': salePrice,
      'final_price': finalPrice,
      'regular_price': regularPrice,
      'size': size,
      'color_name': colorName,
      'color': color?.toJson(),
      'image': image,
      'image_url': imageUrl,
      'in_stock': inStock,
      'stock_quantity': stockQuantity,
    };
  }

  @override
  List<Object?> get props => [
    id,
    productId,
    sku,
    price,
    salePrice,
    finalPrice,
    regularPrice,
    size,
    sizeName,
    colorName,
    color,
    image,
    imageUrl,
    inStock,
    stockQuantity,
  ];
}

class CartVariantColor extends Equatable {
  const CartVariantColor({this.name, this.hex});

  factory CartVariantColor.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CartVariantColor();
    }

    return CartVariantColor(
      name: _stringValue(json['name']),
      hex: _stringValue(_firstPresent(json['hex'], json['hex_code'])),
    );
  }

  final String? name;
  final String? hex;

  bool get isEmpty => name == null && hex == null;

  Map<String, dynamic> toJson() {
    return {'name': name, 'hex': hex};
  }

  @override
  List<Object?> get props => [name, hex];
}

class CartSummary extends Equatable {
  const CartSummary({
    this.itemCount,
    this.subtotal,
    this.shipping,
    this.discount,
    this.tax,
    this.total,
    this.currency,
  });

  factory CartSummary.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CartSummary();
    }

    return CartSummary(
      itemCount: _intValue(
        _firstPresent(json['item_count'], json['items_count'], json['count']),
      ),
      subtotal: _doubleValue(
        _firstPresent(json['subtotal'], json['sub_total'], json['items_total']),
      ),
      shipping: _doubleValue(
        _firstPresent(json['shipping'], json['shipping_fee']),
      ),
      discount: _doubleValue(
        _firstPresent(
          json['discount'],
          json['discount_total'],
          json['coupon_discount'],
        ),
      ),
      tax: _doubleValue(
        _firstPresent(json['tax'], json['tax_total'], json['vat']),
      ),
      total: _doubleValue(
        _firstPresent(
          json['total'],
          json['grand_total'],
          json['payable_total'],
        ),
      ),
      currency: _stringValue(
        _firstPresent(json['currency'], json['currency_code']),
      ),
    );
  }

  final int? itemCount;
  final double? subtotal;
  final double? shipping;
  final double? discount;
  final double? tax;
  final double? total;
  final String? currency;

  bool get hasValues =>
      itemCount != null ||
      subtotal != null ||
      shipping != null ||
      discount != null ||
      tax != null ||
      total != null;

  CartSummary normalize(List<CartItem> items) {
    final computedItemCount = items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );
    final computedSubtotal = items.fold<double>(
      0,
      (sum, item) => sum + item.resolvedLineTotal,
    );
    final resolvedSubtotal = subtotal ?? computedSubtotal;
    final resolvedShipping = shipping ?? 0;
    final resolvedDiscount = discount ?? 0;
    final resolvedTax = tax ?? 0;
    final resolvedTotal =
        total ??
        resolvedSubtotal + resolvedShipping + resolvedTax - resolvedDiscount;

    return copyWith(
      subtotal: resolvedSubtotal,
      shipping: resolvedShipping,
      discount: resolvedDiscount,
      tax: resolvedTax,
      total: resolvedTotal,
      itemCount: itemCount ?? computedItemCount,
      currency: currency ?? _resolveCurrency(items),
    );
  }

  CartSummary recalculate(List<CartItem> items) {
    final computedItemCount = items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );
    final computedSubtotal = items.fold<double>(
      0,
      (sum, item) => sum + item.resolvedLineTotal,
    );
    final resolvedShipping = shipping ?? 0;
    final resolvedDiscount = discount ?? 0;
    final resolvedTax = tax ?? 0;

    return copyWith(
      itemCount: computedItemCount,
      subtotal: computedSubtotal,
      shipping: resolvedShipping,
      discount: resolvedDiscount,
      tax: resolvedTax,
      total:
          computedSubtotal + resolvedShipping + resolvedTax - resolvedDiscount,
      currency: currency ?? _resolveCurrency(items),
    );
  }

  CartSummary copyWith({
    int? itemCount,
    double? subtotal,
    double? shipping,
    double? discount,
    double? tax,
    double? total,
    String? currency,
  }) {
    return CartSummary(
      itemCount: itemCount ?? this.itemCount,
      subtotal: subtotal ?? this.subtotal,
      shipping: shipping ?? this.shipping,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      currency: currency ?? this.currency,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_count': itemCount,
      'subtotal': subtotal,
      'shipping': shipping,
      'discount': discount,
      'tax': tax,
      'total': total,
      'currency': currency,
    };
  }

  @override
  List<Object?> get props => [
    itemCount,
    subtotal,
    shipping,
    discount,
    tax,
    total,
    currency,
  ];
}

String? _resolveCurrency(List<CartItem> items) {
  for (final item in items) {
    final currency = item.currency?.trim();
    if (currency != null && currency.isNotEmpty) {
      return currency;
    }
  }
  return null;
}

String? _stringValue(dynamic value) {
  final stringValue = value?.toString().trim();
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

  return int.tryParse(
    value?.toString().replaceAll(RegExp(r'[^0-9-]'), '') ?? '',
  );
}

double? _doubleValue(dynamic value) {
  if (value is double) {
    return value;
  }
  if (value is int) {
    return value.toDouble();
  }
  if (value is num) {
    return value.toDouble();
  }

  final rawValue = value?.toString();
  if (rawValue == null || rawValue.trim().isEmpty) {
    return null;
  }

  final normalized = rawValue.replaceAll(RegExp(r'[^0-9.\-]'), '');
  return double.tryParse(normalized);
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
    return value.map((key, mappedValue) {
      return MapEntry(key.toString(), mappedValue);
    });
  }
  return null;
}

List<T> _listValue<T>(
  dynamic value,
  T Function(Map<String, dynamic>? json) mapper,
) {
  if (value is! List) {
    return <T>[];
  }

  return value.map((item) => mapper(_mapValue(item))).toList();
}

dynamic _firstPresent(
  dynamic first,
  dynamic second, [
  dynamic third,
  dynamic fourth,
  dynamic fifth,
  dynamic sixth,
  dynamic seventh,
  dynamic eighth,
  dynamic ninth,
  dynamic tenth,
]) {
  final values = [
    first,
    second,
    third,
    fourth,
    fifth,
    sixth,
    seventh,
    eighth,
    ninth,
    tenth,
  ];
  for (final value in values) {
    if (value != null) {
      return value;
    }
  }
  return null;
}
