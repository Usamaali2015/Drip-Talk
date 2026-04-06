import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_padding.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/cart/view/widgets/cart_action_button.dart';
import 'package:drip_talk/features/product/view/helpers/product_add_to_cart_flow.dart';
import 'package:drip_talk/features/shop/data/models/ai_collection_details_model.dart';
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

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.s12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _TopActionButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => context.pop(),
              ),
              const AppGap(AppSizes.s12, axis: Axis.horizontal),
              Expanded(
                child: AppText(
                  text: l10n.shopDripTalkPicksTitle,
                  style: AppTextStyles.ts18(
                    context,
                    color: AppColors.white,
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
              CartActionButton(onTap: () => context.pushNamed(AppRoutes.cart)),
            ],
          ),
          const AppGap(AppSizes.s20, axis: Axis.vertical),
          AiCuratedCollectionHeroCard(
            imageUrl: collection.image,
            title: collection.resolvedTitle ?? l10n.shopAiCuratedCollections,
            description:
                collection.resolvedDescription ?? l10n.shopNoCuratedCollections,
            productsCountLabel: l10n.shopCollectionItems(
              collection.totalProducts,
            ),
          ),
          const AppGap(AppSizes.s20, axis: Axis.vertical),
          if (state.isRefreshing)
            const _CollectionDetailsProductsShimmer()
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                mainAxisSpacing: AppSizes.s16,
                childAspectRatio: 0.9,
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
                          isPending: wishlistState.isProductPending(productId),
                        ),
                        builder: (context, wishlistViewState) => ProductCard(
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
                              ToggleWishlistProduct(productId: productId),
                            );
                          },
                          onTap: () {
                            if (productId == null) {
                              return;
                            }

                            context.pushNamed(
                              AppRoutes.products,
                              pathParameters: {'id': productId.toString()},
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
  }
}

class _CollectionDetailsProductsShimmer extends StatelessWidget {
  const _CollectionDetailsProductsShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primary.withValues(alpha: 0.12),
      highlightColor: AppColors.secondary.withValues(alpha: 0.18),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 0,
          mainAxisSpacing: AppSizes.s16,
          childAspectRatio: 0.9,
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
          color: AppColors.white,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: AppColors.cyan,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.white),
          hintText: hintText,
          hintStyle: AppTextStyles.ts12(
            context,
            color: AppColors.white.withValues(alpha: 0.56),
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

class _TopActionButton extends StatelessWidget {
  const _TopActionButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.s14),
        onTap: onTap,
        child: Container(
          width: AppSizes.s48,
          height: AppSizes.s48,
          decoration: BoxDecoration(
            color: AppColors.lightBg,
            borderRadius: BorderRadius.circular(AppSizes.s14),
            border: Border.all(
              color: AppColors.secondary.withValues(alpha: 0.42),
            ),
          ),
          child: Icon(icon, color: AppColors.white, size: AppSizes.s20),
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
        border: Border.all(color: Colors.white12),
      ),
      child: AppText(
        text: message,
        textAlign: TextAlign.center,
        style: AppTextStyles.ts14(
          context,
          color: AppColors.white.withValues(alpha: 0.8),
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
