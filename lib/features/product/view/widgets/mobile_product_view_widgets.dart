part of '../mobile_product_view.dart';

class _ProductBodySection extends StatelessWidget {
  const _ProductBodySection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ProductBloc, ProductState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.product != current.product ||
          previous.selectedSizeId != current.selectedSizeId ||
          previous.selectedColorId != current.selectedColorId ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
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

              context.read<ProductBloc>().add(LoadProductDetails(productId));
            },
          );
        }

        final product = state.product!;

        return SingleChildScrollView(
          padding: AppPadding.allLarge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ProductImageSection(),
              const AppGap(AppSizes.s24),
              BlocSelector<ProductReviewBloc, ProductReviewState, bool>(
                selector: (reviewState) => reviewState.isLoading,
                builder: (context, isReviewSubmitting) {
                  return ProductDetailsCard(
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
                        : AppColors.materialGreen,
                    reviewActionText: l10n.reviewsWriteAction,
                    isReviewActionLoading: isReviewSubmitting,
                    onReviewPressed: isReviewSubmitting
                        ? null
                        : () => _openProductReviewSheet(context, state),
                  );
                },
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
                RecommendedSection(relatedProducts: product.relatedProducts),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ProductImageSection extends StatelessWidget {
  const _ProductImageSection();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProductBloc, ProductState, _ProductImageViewData>(
      selector: (state) => _ProductImageViewData(
        imageUrls: state.imageUrls,
        currentIndex: state.currentIndex,
      ),
      builder: (context, imageViewData) {
        return ProductImageCarousel(
          imageUrls: imageViewData.imageUrls,
          currentIndex: imageViewData.currentIndex,
        );
      },
    );
  }
}

class _ProductBottomBarSection extends StatelessWidget {
  const _ProductBottomBarSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocSelector<
      ProductBloc,
      ProductState,
      ({bool hasProduct, int? productId, int? variantId, bool isOutOfStock})
    >(
      selector: (state) => (
        hasProduct: state.hasProduct,
        productId: state.product?.id,
        variantId: state.selectedVariant?.id,
        isOutOfStock: state.isOutOfStock,
      ),
      builder: (context, productViewState) {
        if (!productViewState.hasProduct) {
          return const SizedBox.shrink();
        }

        return BlocSelector<CartBloc, CartState, bool>(
          selector: (cartState) =>
              cartState.isVariantPending(productViewState.variantId),
          builder: (context, isAddToCartLoading) =>
              BlocSelector<
                WishlistBloc,
                WishlistState,
                ({bool isSaved, bool isPending})
              >(
                selector: (wishlistState) => (
                  isSaved: wishlistState.isProductSaved(
                    productViewState.productId,
                  ),
                  isPending: wishlistState.isProductPending(
                    productViewState.productId,
                  ),
                ),
                builder: (context, wishlistViewState) => Padding(
                  padding: AppPadding.allExtraSmall,
                  child: ProductBottomBar(
                    isOutOfStock: productViewState.isOutOfStock,
                    isAddToCartLoading: isAddToCartLoading,
                    isFavoriteSelected: wishlistViewState.isSaved,
                    isFavoritePending: wishlistViewState.isPending,
                    onFavoritePressed: () => _toggleProductWishlist(
                      context,
                      context.read<ProductBloc>().state,
                    ),
                    onAddToCartPressed: () => addCurrentProductToCart(
                      context,
                      state: context.read<ProductBloc>().state,
                      l10n: l10n,
                    ),
                    onBuyNowPressed: () {},
                  ),
                ),
              ),
        );
      },
    );
  }
}

Future<void> _openProductReviewSheet(
  BuildContext context,
  ProductState state,
) async {
  final product = state.product;
  final productId = product?.id;
  if (product == null || productId == null) {
    return;
  }

  final reviewSeed = MyReviewItemData(
    productId: productId,
    productName: product.title,
    productImageUrl: state.imageUrls.isEmpty ? null : state.imageUrls.first,
  );

  final request = await ReviewFormSheet.show(
    context,
    review: reviewSeed,
    mode: ReviewFormMode.create,
  );

  if (!context.mounted || request == null) {
    return;
  }

  context.read<ProductReviewBloc>().add(SubmitProductReviewRequested(request));
}

void _toggleProductWishlist(BuildContext context, ProductState state) {
  final productId = state.product?.id;
  if (productId == null) {
    return;
  }

  context.read<WishlistBloc>().add(ToggleWishlistProduct(productId: productId));
}

class _ProductImageViewData extends Equatable {
  const _ProductImageViewData({
    required this.imageUrls,
    required this.currentIndex,
  });

  final List<String> imageUrls;
  final int currentIndex;

  @override
  List<Object?> get props => [imageUrls, currentIndex];
}

class _ProductLoadingView extends StatelessWidget {
  const _ProductLoadingView();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: SingleChildScrollView(
        padding: AppPadding.allLarge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: AppSizes.s300,
              decoration: BoxDecoration(
                color: AppColors.pureBlack,
                borderRadius: BorderRadius.circular(AppRadius.r30),
              ),
            ),
            const AppGap(AppSizes.s24),
            Container(
              padding: AppPadding.allMediumLarge,
              decoration: BoxDecoration(
                color: AppColors.pureBlack,
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
                color: AppColors.pureBlack,
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
        color: AppColors.pureBlack,
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
