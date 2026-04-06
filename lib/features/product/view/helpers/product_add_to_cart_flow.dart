import 'package:dio/dio.dart';
import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/widgets/app_button.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
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

Future<void> addCurrentProductToCart(
  BuildContext context, {
  required ProductState state,
  required AppLocalizations l10n,
}) async {
  final product = state.product;
  if (product == null) {
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
    backgroundColor: Colors.transparent,
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
      return _QuickAddStateSheet(
        child: const _QuickAddSheetShimmer(),
      );
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
              textColor: AppColors.white,
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            const AppGap(AppSizes.s20),
            AppButton(
              text: widget.l10n.retry,
              height: 50,
              borderRadius: 24,
              gradientColors: const [AppColors.secondary, Color(0xFFFF1E87)],
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

class _QuickAddStateSheet extends StatelessWidget {
  const _QuickAddStateSheet({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.92,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2B1B55),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
          border: Border(top: BorderSide(width: 4, color: AppColors.secondary)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 56,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 22),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(AppRadius.circular),
                  ),
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.secondary),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const AppGap(AppSizes.s14, axis: Axis.horizontal),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: AppLocalizations.of(context)!.productSizeGuide,
                          variant: AppTextVariant.ts18,
                          textColor: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        const AppGap(2),
                        AppText(
                          text: AppLocalizations.of(
                            context,
                          )!.productSizeGuideSubtitle,
                          variant: AppTextVariant.ts14,
                          textColor: Colors.white70,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(child: Center(child: child)),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAddSheetShimmer extends StatelessWidget {
  const _QuickAddSheetShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withValues(alpha: 0.08),
      highlightColor: Colors.white.withValues(alpha: 0.18),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppGap(AppSizes.s24),
            _QuickAddSkeletonBox(
              height: 148,
              borderRadius: 22,
              width: double.infinity,
            ),
            const AppGap(AppSizes.s24),
            const _QuickAddSkeletonLine(width: 120, height: 20),
            const AppGap(AppSizes.s16),
            Wrap(
              spacing: AppSizes.s12,
              runSpacing: AppSizes.s12,
              children: List.generate(
                5,
                (_) => const _QuickAddSkeletonBox(
                  width: 64,
                  height: 46,
                  borderRadius: AppRadius.circular,
                ),
              ),
            ),
            const AppGap(AppSizes.s20),
            _QuickAddSkeletonBox(
              height: 214,
              borderRadius: 24,
              width: double.infinity,
            ),
            const AppGap(AppSizes.s24),
            _QuickAddSkeletonBox(
              height: 54,
              borderRadius: 28,
              width: double.infinity,
            ),
            const AppGap(AppSizes.s24),
          ],
        ),
      ),
    );
  }
}

class _QuickAddSkeletonBox extends StatelessWidget {
  const _QuickAddSkeletonBox({
    required this.height,
    required this.borderRadius,
    this.width = double.infinity,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class _QuickAddSkeletonLine extends StatelessWidget {
  const _QuickAddSkeletonLine({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return _QuickAddSkeletonBox(
      width: width,
      height: height,
      borderRadius: AppRadius.r12,
    );
  }
}
