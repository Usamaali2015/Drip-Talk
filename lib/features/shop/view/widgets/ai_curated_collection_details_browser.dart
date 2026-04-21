import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/cart/view/widgets/cart_action_button.dart';
import 'package:drip_talk/features/product/view/helpers/product_add_to_cart_flow.dart';
import 'package:drip_talk/features/shop/data/models/ai_collection_details_model.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart'
    as shop_models;
import 'package:drip_talk/features/shop/data/models/shop_model.dart'
    as shop_models;
import 'package:drip_talk/features/shop/domain/ai_curated_collection_details_state.dart';
import 'package:drip_talk/features/wishlist/domain/bloc/wishlist_bloc.dart';
import 'package:drip_talk/features/wishlist/domain/bloc/wishlist_event.dart';
import 'package:drip_talk/features/wishlist/domain/bloc/wishlist_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';
import 'ai_curated_back_button.dart';
import 'ai_curated_collection_hero_card.dart';
import 'product_card.dart';

class AiCuratedCollectionDetailsBrowser extends StatelessWidget {
  const AiCuratedCollectionDetailsBrowser({
    super.key,
    required this.state,
    required this.searchController,
    required this.onSearchChanged,
  });

  final AiCuratedCollectionDetailsState state;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final collection = state.collection!;
    final products = state.visibleProducts;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final horizontalPadding = width >= 960
            ? 32.0
            : width >= 720
            ? 24.0
            : 16.0;
        final gridColumns = width >= 1040
            ? 4
            : width >= 720
            ? 3
            : 2;
        final gridAspectRatio = gridColumns >= 4
            ? 0.84
            : gridColumns == 3
            ? 0.82
            : 0.9;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            0,
            horizontalPadding,
            AppSizes.s120,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: AppSizes.s8,
                    ),
                    child: AiCuratedBackButton(
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const AppGap(AppSizes.s12, axis: Axis.horizontal),
                  Expanded(
                    child: AppText(
                      text: l10n.shopDripTalkPicksTitle,
                      style: AppTextStyles.ts18(
                        context,
                        color: AppColors.pureWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const AppGap(AppSizes.s18, axis: Axis.vertical),
              Row(
                children: [
                  Expanded(
                    child: _CollectionDetailsSearchField(
                      controller: searchController,
                      hintText: l10n.shopSearchCollectionProductsHint,
                      onChanged: onSearchChanged,
                    ),
                  ),
                  const AppGap(AppSizes.s12, axis: Axis.horizontal),
                  CartActionButton(
                    onTap: () => context.pushNamed(AppRoutes.cart),
                  ),
                ],
              ),
              const AppGap(AppSizes.s20, axis: Axis.vertical),
              AiCuratedCollectionHeroCard(
                imageUrl: collection.image,
                title:
                    collection.resolvedTitle ?? l10n.shopAiCuratedCollections,
                description:
                    collection.resolvedDescription ??
                    l10n.shopNoCuratedCollections,
                productsCountLabel: l10n.shopCollectionItems(
                  collection.totalProducts,
                ),
              ),
              const AppGap(AppSizes.s20, axis: Axis.vertical),
              if (state.isRefreshing)
                _CollectionDetailsProductsShimmer(
                  columns: gridColumns,
                  aspectRatio: gridAspectRatio,
                )
              else if (products.isEmpty)
                _ProductsEmptyState(
                  message: state.searchQuery.trim().isEmpty
                      ? l10n.shopNoProductsInCollection
                      : l10n.shopNoProductsFound,
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridColumns,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: AppSizes.s16,
                    childAspectRatio: gridAspectRatio,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final productId = product.id;
                    return Padding(
                      padding: AppPadding.horizontalSmall,
                      child:
                          BlocSelector<
                            WishlistBloc,
                            WishlistState,
                            ({bool isSaved, bool isPending})
                          >(
                            selector: (wishlistState) => (
                              isSaved: wishlistState.isProductSaved(productId),
                              isPending: wishlistState.isProductPending(
                                productId,
                              ),
                            ),
                            builder: (context, wishlistViewState) =>
                                ProductCard(
                                  key: ValueKey(product.id),
                                  product: _mapToShopProduct(product),
                                  isSaved: wishlistViewState.isSaved,
                                  isSavePending: wishlistViewState.isPending,
                                  onAddToCartTap: () {
                                    if (productId == null) {
                                      return;
                                    }

                                    quickAddCatalogProductToCart(
                                      context,
                                      productId: productId,
                                      l10n: l10n,
                                    );
                                  },
                                  onSaveTap: () {
                                    if (productId == null) {
                                      return;
                                    }

                                    context.read<WishlistBloc>().add(
                                      ToggleWishlistProduct(
                                        productId: productId,
                                      ),
                                    );
                                  },
                                  onTap: () {
                                    if (productId == null) {
                                      return;
                                    }

                                    context.pushNamed(
                                      AppRoutes.products,
                                      pathParameters: {
                                        'id': productId.toString(),
                                      },
                                    );
                                  },
                                ),
                          ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _CollectionDetailsProductsShimmer extends StatelessWidget {
  const _CollectionDetailsProductsShimmer({
    required this.columns,
    required this.aspectRatio,
  });

  final int columns;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: columns * 2,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 0,
          mainAxisSpacing: AppSizes.s16,
          childAspectRatio: aspectRatio,
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: AppPadding.horizontalSmall,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.lightBg,
                borderRadius: BorderRadius.circular(AppRadius.r15),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CollectionDetailsSearchField extends StatelessWidget {
  const _CollectionDetailsSearchField({
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.s56,
      decoration: BoxDecoration(
        color: AppColors.lightBg,
        borderRadius: BorderRadius.circular(AppRadius.circular),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.44)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyles.ts14(
          context,
          color: AppColors.pureWhite,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: AppColors.cyan,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.pureWhite,
          ),
          hintText: hintText,
          hintStyle: AppTextStyles.ts12(
            context,
            color: AppColors.pureWhite.withValues(alpha: 0.56),
            fontWeight: FontWeight.w400,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s16,
            vertical: AppSizes.s16,
          ),
        ),
      ),
    );
  }
}

class _ProductsEmptyState extends StatelessWidget {
  const _ProductsEmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.s24),
      decoration: BoxDecoration(
        color: AppColors.darkBg.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(AppRadius.r24),
        border: Border.all(color: AppColors.pureWhite12),
      ),
      child: shop_models.AppText(
        text: message,
        textAlign: TextAlign.center,
        style: AppTextStyles.ts14(
          context,
          color: AppColors.pureWhite.withValues(alpha: 0.8),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

shop_models.Items _mapToShopProduct(AiCollectionProductItem product) {
  return shop_models.Items(
    id: product.id,
    title: product.title,
    slug: product.slug,
    price: product.primaryPrice ?? product.price,
    salePrice: product.comparePrice,
    currency: product.currency,
    thumbnail: product.thumbnail,
    category: _mapToShopCategory(product.category),
  );
}

shop_models.Category? _mapToShopCategory(
  AiCollectionProductCategory? category,
) {
  if (category == null) {
    return null;
  }

  return shop_models.Category(
    id: category.id,
    parentId: category.parentId,
    name: category.name,
    icon: category.icon,
    image: category.image,
    isFeatured: category.isFeatured,
    status: category.status,
  );
}
