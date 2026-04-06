import 'package:drip_talk/features/product/data/models/product_details_model.dart';
import 'package:equatable/equatable.dart';

enum ProductStatus { initial, loading, success, failure }

class ProductState extends Equatable {
  const ProductState({
    this.status = ProductStatus.initial,
    this.productId,
    this.product,
    this.currentIndex = 0,
    this.selectedSizeId,
    this.selectedColorId,
    this.errorMessage,
  });

  final ProductStatus status;
  final int? productId;
  final ProductDetailsData? product;
  final int currentIndex;
  final int? selectedSizeId;
  final int? selectedColorId;
  final String? errorMessage;

  bool get isInitialLoading =>
      status == ProductStatus.loading && product == null;

  bool get hasProduct => product != null;

  ProductVariant? get selectedVariant =>
      resolveVariant(sizeId: selectedSizeId, colorId: selectedColorId);

  ProductVariant? resolveVariant({int? sizeId, int? colorId}) {
    final currentProduct = product;
    if (currentProduct == null || currentProduct.variants.isEmpty) {
      return null;
    }

    ProductVariant? sizeMatch;
    ProductVariant? colorMatch;

    for (final variant in currentProduct.variants) {
      final matchesSize = sizeId == null || variant.sizeId == sizeId;
      final matchesColor = colorId == null || variant.colorId == colorId;

      if (matchesSize && matchesColor) {
        return variant;
      }

      if (sizeMatch == null && sizeId != null && variant.sizeId == sizeId) {
        sizeMatch = variant;
      }

      if (colorMatch == null && colorId != null && variant.colorId == colorId) {
        colorMatch = variant;
      }
    }

    return sizeMatch ?? colorMatch ?? currentProduct.variants.first;
  }

  bool get isOutOfStock {
    final variantStock = selectedVariant?.inStock;
    if (variantStock != null) {
      return variantStock == false;
    }

    return product?.stock?.inStock == false;
  }

  List<String> get imageUrls {
    final currentProduct = product;
    if (currentProduct == null) {
      return const <String>[];
    }

    final urls = <String>[];
    final seenUrls = <String>{};

    final variantImage = selectedVariant?.displayImage?.trim();
    if (variantImage != null &&
        variantImage.isNotEmpty &&
        seenUrls.add(variantImage)) {
      urls.add(variantImage);
    }

    for (final imageUrl in currentProduct.imageUrls) {
      if (imageUrl.isEmpty || !seenUrls.add(imageUrl)) {
        continue;
      }
      urls.add(imageUrl);
    }

    return urls;
  }

  String? get currentPrice =>
      selectedVariant?.currentPrice ?? product?.primaryPrice;

  String? get comparePrice =>
      selectedVariant?.comparePrice ?? product?.comparePrice;

  ProductAvailableSize? get selectedSize {
    final currentProduct = product;
    if (currentProduct == null) {
      return null;
    }

    for (final size in currentProduct.availableSizes) {
      if (size.id == selectedSizeId) {
        return size;
      }
    }

    final variantSize = selectedVariant?.size;
    if (variantSize?.id != null) {
      return ProductAvailableSize(id: variantSize?.id, name: variantSize?.name);
    }

    return null;
  }

  ProductAvailableColor? get selectedColor {
    final currentProduct = product;
    if (currentProduct == null) {
      return null;
    }

    for (final color in currentProduct.availableColors) {
      if (color.id == selectedColorId) {
        return color;
      }
    }

    final variantColor = selectedVariant?.color;
    if (variantColor?.id != null) {
      return ProductAvailableColor(
        id: variantColor?.id,
        name: variantColor?.name,
        hexCode: variantColor?.hexCode,
      );
    }

    return null;
  }

  ProductState copyWith({
    ProductStatus? status,
    int? productId,
    ProductDetailsData? product,
    bool clearProduct = false,
    int? currentIndex,
    int? selectedSizeId,
    bool clearSelectedSize = false,
    int? selectedColorId,
    bool clearSelectedColor = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ProductState(
      status: status ?? this.status,
      productId: productId ?? this.productId,
      product: clearProduct ? null : (product ?? this.product),
      currentIndex: currentIndex ?? this.currentIndex,
      selectedSizeId: clearSelectedSize
          ? null
          : (selectedSizeId ?? this.selectedSizeId),
      selectedColorId: clearSelectedColor
          ? null
          : (selectedColorId ?? this.selectedColorId),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    productId,
    product,
    currentIndex,
    selectedSizeId,
    selectedColorId,
    errorMessage,
  ];
}
