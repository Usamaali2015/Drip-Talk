import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/get_it/service_locator.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/features/cart/data/models/cart_model.dart';
import 'package:drip_talk/features/cart/domain/bloc/cart_bloc.dart';
import 'package:drip_talk/features/cart/domain/bloc/cart_event.dart';
import 'package:drip_talk/features/product/data/models/product_details_model.dart';
import 'package:drip_talk/features/product/data/repository/product_preferences_repository.dart';
import 'package:drip_talk/features/product/data/repository/product_repository.dart';
import 'package:drip_talk/features/product/domain/bloc/product_state.dart';
import 'package:drip_talk/features/product/view/widgets/product_size_guide_sheet.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
part '../widgets/product_add_to_cart_flow_widgets.dart';

Future<void> addCurrentProductToCart(
  BuildContext context, {
  required ProductState state,
  required AppLocalizations l10n,
}) async {
  final product = state.product;
  if (product == null) {
    return;
  }

  if (state.isOutOfStock) {
    _showError(context, l10n.productOutOfStock);
    return;
  }

  final selectedSizeId = state.selectedSizeId;
  final resolvedVariant = _resolveVariant(
    product,
    sizeId: selectedSizeId,
    colorId: state.selectedColorId,
  );
  final variantId = resolvedVariant?.id;

  if (variantId == null) {
    _showError(context, l10n.cartVariantUnavailable);
    return;
  }

  context.read<CartBloc>().add(
    AddCartItem(
      productVariantId: variantId,
      optimisticItem: _buildOptimisticCartItem(
        product,
        variant: resolvedVariant,
        selectedSizeId: selectedSizeId,
        selectedColorId: state.selectedColorId,
      ),
    ),
  );
}

Future<void> quickAddCatalogProductToCart(
  BuildContext context, {
  required int productId,
  required AppLocalizations l10n,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    useRootNavigator: true,
    backgroundColor: AppColors.transparent,
    builder: (_) => _ProductQuickAddSheet(productId: productId, l10n: l10n),
  );
}

CartItem? _buildOptimisticCartItem(
  ProductDetailsData product, {
  ProductVariant? variant,
  int? selectedSizeId,
  int? selectedColorId,
}) {
  final resolvedVariant =
      variant ??
      _resolveVariant(
        product,
        sizeId: selectedSizeId,
        colorId: selectedColorId,
      );
  final variantId = resolvedVariant?.id;

  if (variantId == null) {
    return null;
  }

  return CartItem.optimistic(
    productId: product.id,
    productVariantId: variantId,
    quantity: 1,
    title: product.title,
    slug: product.slug,
    thumbnail:
        resolvedVariant?.displayImage ??
        (product.imageUrls.isNotEmpty ? product.imageUrls.first : null),
    currency: product.pricing?.currency,
    unitPrice: double.tryParse(
      (resolvedVariant?.currentPrice ?? product.primaryPrice ?? '').trim(),
    ),
    comparePrice: double.tryParse(
      (resolvedVariant?.comparePrice ?? product.comparePrice ?? '').trim(),
    ),
    sizeLabel:
        resolvedVariant?.size?.name ??
        _resolveSizeName(product, selectedSizeId),
    colorLabel:
        resolvedVariant?.color?.name ??
        _resolveColorName(product, selectedColorId),
  );
}

int? _resolveSelectedSizeId(ProductDetailsData product, int? savedSizeId) {
  if (savedSizeId != null &&
      product.availableSizes.any((size) => size.id == savedSizeId)) {
    return savedSizeId;
  }

  final preferredSizeId =
      product.selectedVariant?.sizeId ?? _firstVariant(product)?.sizeId;
  if (preferredSizeId != null) {
    return preferredSizeId;
  }

  if (product.availableSizes.isEmpty) {
    return null;
  }

  return product.availableSizes.first.id;
}

int? _resolveSelectedColorId(
  ProductDetailsData product, {
  int? preferredSizeId,
}) {
  final matchedVariant = _resolveVariant(product, sizeId: preferredSizeId);
  if (matchedVariant?.colorId != null) {
    return matchedVariant?.colorId;
  }

  final preferredColorId =
      product.selectedVariant?.colorId ?? _firstVariant(product)?.colorId;
  if (preferredColorId != null) {
    return preferredColorId;
  }

  if (product.availableColors.isEmpty) {
    return null;
  }

  return product.availableColors.first.id;
}

ProductVariant? _resolveVariant(
  ProductDetailsData product, {
  int? sizeId,
  int? colorId,
}) {
  if (product.variants.isEmpty) {
    return null;
  }

  ProductVariant? sizeMatch;
  ProductVariant? colorMatch;

  for (final variant in product.variants) {
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

  return sizeMatch ?? colorMatch ?? product.variants.first;
}

ProductVariant? _firstVariant(ProductDetailsData product) {
  if (product.variants.isEmpty) {
    return null;
  }

  return product.variants.first;
}

String? _resolveSizeName(ProductDetailsData product, int? selectedSizeId) {
  for (final size in product.availableSizes) {
    if (size.id == selectedSizeId) {
      return size.name;
    }
  }

  return null;
}

String? _resolveColorName(ProductDetailsData product, int? selectedColorId) {
  for (final color in product.availableColors) {
    if (color.id == selectedColorId) {
      return color.name;
    }
  }

  return null;
}

String _resolveErrorMessage(Object error, AppLocalizations l10n) {
  if (error is DioException) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message']?.toString().trim();
      if (message != null && message.isNotEmpty) {
        return message;
      }
    } else if (data is Map) {
      final message = data['message']?.toString().trim();
      if (message != null && message.isNotEmpty) {
        return message;
      }
    }

    final message = error.message?.trim();
    if (message != null && message.isNotEmpty) {
      return message;
    }
  }

  return l10n.productUnableToLoad;
}

void _showError(BuildContext context, String message) {
  ToastUtils.show(context, message, type: ToastType.error);
}

class _ProductQuickAddSheet extends StatefulWidget {
  const _ProductQuickAddSheet({required this.productId, required this.l10n});

  final int productId;
  final AppLocalizations l10n;

  @override
  State<_ProductQuickAddSheet> createState() => _ProductQuickAddSheetState();
}

class _ProductQuickAddSheetState extends State<_ProductQuickAddSheet> {
  final ProductRepository _productRepository = getIt<ProductRepository>();
  final ProductPreferencesRepository _preferencesRepository =
      getIt<ProductPreferencesRepository>();

  ProductDetailsData? _product;
  int? _initialSelectedSizeId;
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _QuickAddStateSheet(child: const _QuickAddSheetShimmer());
    }

    final product = _product;
    if (product == null) {
      return _QuickAddStateSheet(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              text: _errorMessage ?? widget.l10n.productUnableToLoad,
              variant: AppTextVariant.ts16,
              textColor: AppColors.pureWhite,
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            const AppGap(AppSizes.s20),
            AppButton(
              text: widget.l10n.retry,
              height: 50,
              borderRadius: 24,
              gradientColors: const [AppColors.secondary, AppColors.hotPink],
              onPressed: _loadProduct,
            ),
          ],
        ),
      );
    }

    return ProductSizeGuideSheet(
      sizes: product.availableSizes,
      sizeGuide: product.sizeGuide,
      initialSelectedSizeId: _initialSelectedSizeId,
      primaryActionLabel: widget.l10n.shopAddToCart,
      heightFactor: 0.92,
      primaryActionPinned: false,
      onPrimaryAction: _handleAddToCart,
    );
  }

  Future<void> _loadProduct() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _productRepository.getProductDetails(
        productId: widget.productId,
      );

      final product = response.data;
      if (!mounted) {
        return;
      }

      if (product?.id == null) {
        setState(() {
          _product = null;
          _isLoading = false;
          _errorMessage = response.message ?? widget.l10n.productUnableToLoad;
        });
        return;
      }

      final savedSizeId = await _preferencesRepository.getSelectedSizeId(
        product!.id!,
      );
      if (!mounted) {
        return;
      }

      setState(() {
        _product = product;
        _initialSelectedSizeId = _resolveSelectedSizeId(product, savedSizeId);
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _product = null;
        _isLoading = false;
        _errorMessage = _resolveErrorMessage(error, widget.l10n);
      });
    }
  }

  Future<bool> _handleAddToCart(int? selectedSizeId) async {
    final product = _product;
    if (product == null || !mounted) {
      return false;
    }

    final cartBloc = context.read<CartBloc>();

    if (product.availableSizes.isNotEmpty && selectedSizeId == null) {
      return false;
    }

    if (product.id != null && selectedSizeId != null) {
      await _preferencesRepository.saveSelectedSizeId(
        productId: product.id!,
        sizeId: selectedSizeId,
      );
    }

    if (!mounted) {
      return false;
    }

    final selectedColorId = _resolveSelectedColorId(
      product,
      preferredSizeId: selectedSizeId,
    );
    final resolvedVariant = _resolveVariant(
      product,
      sizeId: selectedSizeId,
      colorId: selectedColorId,
    );
    final variantId = resolvedVariant?.id;

    if (variantId == null) {
      _showError(context, widget.l10n.cartVariantUnavailable);
      return false;
    }

    cartBloc.add(
      AddCartItem(
        productVariantId: variantId,
        optimisticItem: _buildOptimisticCartItem(
          product,
          variant: resolvedVariant,
          selectedSizeId: selectedSizeId,
          selectedColorId: selectedColorId,
        ),
      ),
    );

    return true;
  }
}
