import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/cart/domain/bloc/cart_bloc.dart';
import 'package:drip_talk/features/cart/domain/bloc/cart_state.dart';
import 'package:drip_talk/features/product/view/helpers/product_add_to_cart_flow.dart';
import 'package:drip_talk/features/shop/domain/shop_bloc.dart';
import 'package:drip_talk/features/shop/domain/shop_state.dart';
import 'package:drip_talk/features/wishlist/domain/bloc/wishlist_bloc.dart';
import 'package:drip_talk/features/wishlist/domain/bloc/wishlist_event.dart';
import 'package:drip_talk/features/wishlist/domain/bloc/wishlist_state.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import 'product_card.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class ShopProductSection extends StatelessWidget {
  const ShopProductSection({
    super.key,
    required this.contentWidth,
    required this.horizontalPadding,
  });

  final double contentWidth;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final columns = contentWidth >= 1040
        ? 4
        : contentWidth >= 720
        ? 3
        : 2;
    final spacing = columns >= 4 ? 16.0 : 12.0;
    final aspectRatio = columns >= 4
        ? 0.84
        : columns == 3
        ? 0.82
        : 0.9;

    return BlocBuilder<ShopBloc, ShopState>(
      buildWhen: (previous, current) =>
          previous.products != current.products ||
          previous.status != current.status ||
          previous.isRefreshing != current.isRefreshing,
      builder: (context, state) {
        if (state.isRefreshing) {
          return _ProductGridShimmerSliver(
            columns: columns,
            spacing: spacing,
            aspectRatio: aspectRatio,
            horizontalPadding: horizontalPadding,
          );
        }

        if (state.products.isEmpty && state.status == ShopStatus.failure) {
          return _SectionMessageSliver(
            message: l10n.shopUnableToLoadProducts,
            horizontalPadding: horizontalPadding,
          );
        }

        if (state.products.isEmpty && state.status == ShopStatus.success) {
          return _SectionMessageSliver(
            message: l10n.shopNoProductsFound,
            horizontalPadding: horizontalPadding,
          );
        }

        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding - 4),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              final product = state.products[index];
              final productId = product.id?.toInt();

              return Padding(
                padding: AppPadding.horizontalSmall,
                child: BlocSelector<CartBloc, CartState, bool>(
                  selector: (cartState) =>
                      cartState.isVariantPending(product.primaryVariantId),
                  builder: (context, isAddingToCart) =>
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
                          product: product,
                          isAddingToCart: isAddingToCart,
                          isSaved: wishlistViewState.isSaved,
                          isSavePending: wishlistViewState.isPending,
                          onTap: () {
                            if (productId == null) {
                              return;
                            }

                            context.pushNamed(
                              AppRoutes.products,
                              pathParameters: {'id': productId.toString()},
                            );
                          },
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
                        ),
                      ),
                ),
              );
            }, childCount: state.products.length),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: spacing,
              crossAxisSpacing: 0,
              childAspectRatio: aspectRatio,
            ),
          ),
        );
      },
    );
  }
}

class _SectionMessageSliver extends StatelessWidget {
  const _SectionMessageSliver({
    required this.message,
    required this.horizontalPadding,
  });

  final String message;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: AppSizes.s32,
        ),
        child: Center(
          child: AppText(
            text: message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.pureWhite54),
          ),
        ),
      ),
    );
  }
}

class _ProductGridShimmerSliver extends StatelessWidget {
  const _ProductGridShimmerSliver({
    required this.columns,
    required this.spacing,
    required this.aspectRatio,
    required this.horizontalPadding,
  });

  final int columns;
  final double spacing;
  final double aspectRatio;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding - 4),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Padding(
            padding: AppPadding.horizontalSmall,
            child: Shimmer.fromColors(
              baseColor: AppColors.shimmerBase,
              highlightColor: AppColors.shimmerHighlight,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.lightBg,
                  borderRadius: BorderRadius.circular(AppRadius.r15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.pureBlack,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(AppRadius.r15),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: AppPadding.allExtraSmall,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: AppSizes.s12,
                            width: AppSizes.s100,
                            decoration: BoxDecoration(
                              color: AppColors.pureBlack,
                              borderRadius: BorderRadius.circular(
                                AppRadius.r12,
                              ),
                            ),
                          ),
                          const AppGap(AppSizes.s8),
                          Container(
                            height: AppSizes.s14,
                            width: AppSizes.s72,
                            decoration: BoxDecoration(
                              color: AppColors.pureBlack,
                              borderRadius: BorderRadius.circular(
                                AppRadius.r12,
                              ),
                            ),
                          ),
                          const AppGap(AppSizes.s12),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: AppSizes.s32,
                                  decoration: BoxDecoration(
                                    color: AppColors.pureBlack,
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.circular,
                                    ),
                                  ),
                                ),
                              ),
                              const AppGap(AppSizes.s6, axis: Axis.horizontal),
                              Container(
                                height: AppSizes.s32,
                                width: AppSizes.s55,
                                decoration: BoxDecoration(
                                  color: AppColors.pureBlack,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.circular,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }, childCount: columns * 2),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: spacing,
          crossAxisSpacing: 0,
          childAspectRatio: aspectRatio,
        ),
      ),
    );
  }
}
