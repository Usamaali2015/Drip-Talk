import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_padding.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/widgets/app_error_retry.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/features/cart/domain/bloc/cart_bloc.dart';
import 'package:drip_talk/features/cart/domain/bloc/cart_state.dart';
import 'package:drip_talk/features/product/domain/bloc/product_bloc.dart';
import 'package:drip_talk/features/product/domain/bloc/product_event.dart';
import 'package:drip_talk/features/product/domain/bloc/product_state.dart';
import 'package:drip_talk/features/product/view/helpers/product_add_to_cart_flow.dart';
import 'package:drip_talk/features/product/view/widgets/ai_style_insights_card.dart';
import 'package:drip_talk/features/product/view/widgets/product_app_bar.dart';
import 'package:drip_talk/features/product/view/widgets/product_bottom_bar.dart';
import 'package:drip_talk/features/product/view/widgets/product_color_selector.dart';
import 'package:drip_talk/features/product/view/widgets/product_details_card.dart';
import 'package:drip_talk/features/product/view/widgets/product_image_carousel.dart';
import 'package:drip_talk/features/product/view/widgets/product_size_selector.dart';
import 'package:drip_talk/features/product/view/widgets/recomended_section.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class MobileProductView extends StatelessWidget {
  const MobileProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const ProductAppBar(),
          bottomNavigationBar: state.hasProduct
              ? BlocSelector<CartBloc, CartState, bool>(
                  selector: (cartState) =>
                      cartState.isVariantPending(state.selectedVariant?.id),
                  builder: (context, isAddToCartLoading) => Padding(
                    padding: AppPadding.allExtraSmall,
                    child: ProductBottomBar(
                      isOutOfStock: state.isOutOfStock,
                      isAddToCartLoading: isAddToCartLoading,
                      onFavoritePressed: () {},
                      onAddToCartPressed: () => addCurrentProductToCart(
                        context,
                        state: state,
                        l10n: l10n,
                      ),
                      onBuyNowPressed: () {},
                    ),
                  ),
                )
              : null,
          body: Builder(
            builder: (context) {
              if (state.isInitialLoading) {
                return const _ProductLoadingView();
              }

              if (!state.hasProduct) {
                return ErrorRetryWidget(
                  message: state.errorMessage ?? l10n.productUnableToLoad,
                  onRetry: () {
                    final productId = state.productId;
                    if (productId == null) {
                      return;
                    }

                    context.read<ProductBloc>().add(
                      LoadProductDetails(productId),
                    );
                  },
                );
              }

              final product = state.product!;

              return SingleChildScrollView(
                padding: AppPadding.allLarge,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductImageCarousel(
                      imageUrls: state.imageUrls,
                      currentIndex: state.currentIndex,
                    ),
                    const AppGap(AppSizes.s24),
                    ProductDetailsCard(
                      productName: product.title,
                      productType: product.subtitle?.toUpperCase(),
                      productPrice: _formatPrice(
                        amount: state.currentPrice,
                        currency: product.pricing?.currency,
                      ),
                      productOffPrice: state.comparePrice == null
                          ? null
                          : _formatPrice(
                              amount: state.comparePrice,
                              currency: product.pricing?.currency,
                            ),
                      productOFFPercentage: _discountLabel(
                        product.pricing?.discountPercentage,
                        l10n,
                      ),
                      productRating: _formatRating(product.rating?.average),
                      productReviews: product.reviewCount.toString(),
                      productDescription:
                          product.description ?? product.shortDescription,
                      availabilityLabel: state.isOutOfStock
                          ? l10n.productOutOfStock
                          : l10n.productInStock,
                      availabilityColor: state.isOutOfStock
                          ? AppColors.secondary
                          : AppColors.green,
                    ),
                    if (product.availableSizes.isNotEmpty) ...[
                      const AppGap(AppSizes.s24),
                      ProductSizeSelector(
                        sizes: product.availableSizes,
                        selectedSizeId: state.selectedSizeId,
                        sizeGuide: product.sizeGuide,
                      ),
                    ],
                    if (product.availableColors.isNotEmpty) ...[
                      const AppGap(AppSizes.s24),
                      ProductColorSelector(
                        colors: product.availableColors,
                        selectedColorId: state.selectedColorId,
                      ),
                    ],
                    const AppGap(AppSizes.s24),
                    const AIStyleInsightsCard(),
                    if (product.relatedProducts.isNotEmpty) ...[
                      const AppGap(AppSizes.s24),
                      RecommendedSection(
                        relatedProducts: product.relatedProducts,
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _ProductLoadingView extends StatelessWidget {
  const _ProductLoadingView();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primary.withValues(alpha: 0.12),
      highlightColor: AppColors.secondary.withValues(alpha: 0.18),
      child: SingleChildScrollView(
        padding: AppPadding.allLarge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: AppSizes.s300,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(AppRadius.r30),
              ),
            ),
            const AppGap(AppSizes.s24),
            Container(
              padding: AppPadding.allMediumLarge,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(AppRadius.r24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _SkeletonLine(width: 180, height: 18),
                  AppGap(AppSizes.s10),
                  _SkeletonLine(width: 110),
                  AppGap(AppSizes.s20),
                  _SkeletonLine(width: 140, height: 22),
                  AppGap(AppSizes.s12),
                  _SkeletonLine(width: 160),
                  AppGap(AppSizes.s16),
                  _SkeletonLine(width: double.infinity, height: 12),
                  AppGap(AppSizes.s8),
                  _SkeletonLine(width: double.infinity, height: 12),
                  AppGap(AppSizes.s8),
                  _SkeletonLine(width: 220, height: 12),
                ],
              ),
            ),
            const AppGap(AppSizes.s24),
            const _SelectorLoadingBlock(),
            const AppGap(AppSizes.s24),
            const _SelectorLoadingBlock(),
          ],
        ),
      ),
    );
  }
}

class _SelectorLoadingBlock extends StatelessWidget {
  const _SelectorLoadingBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SkeletonLine(width: 120),
        const AppGap(AppSizes.s16),
        Wrap(
          spacing: AppSizes.s12,
          runSpacing: AppSizes.s12,
          children: List.generate(
            5,
            (_) => Container(
              width: AppSizes.s55,
              height: AppSizes.s55,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(AppRadius.r16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({required this.width, this.height = 14});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
    );
  }
}

String _formatPrice({required String? amount, required String? currency}) {
  final normalizedAmount = amount?.trim();
  if (normalizedAmount == null || normalizedAmount.isEmpty) {
    return '--';
  }

  final normalizedCurrency = currency?.trim();
  if (normalizedCurrency == null || normalizedCurrency.isEmpty) {
    return normalizedAmount;
  }

  return '$normalizedAmount $normalizedCurrency';
}

String? _discountLabel(int? percentage, AppLocalizations l10n) {
  if (percentage == null || percentage <= 0) {
    return null;
  }

  return l10n.productDiscountPercentage(percentage);
}

String _formatRating(double? rating) {
  if (rating == null) {
    return '0.0';
  }

  return rating.toStringAsFixed(rating.truncateToDouble() == rating ? 0 : 1);
}
