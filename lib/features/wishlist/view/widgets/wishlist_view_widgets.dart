part of '../wishlist_view.dart';

class _WishlistContent extends StatelessWidget {
  const _WishlistContent({
    required this.l10n,
    required this.contentWidth,
    required this.onRefresh,
  });

  final AppLocalizations l10n;
  final double contentWidth;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistBloc, WishlistState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.items != current.items ||
          previous.currentPage != current.currentPage ||
          previous.totalPages != current.totalPages ||
          previous.perPage != current.perPage ||
          previous.sort != current.sort ||
          previous.hasLoaded != current.hasLoaded ||
          previous.isRefreshing != current.isRefreshing ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        final gridColumns = contentWidth >= 980
            ? 4
            : contentWidth >= 720
            ? 3
            : 2;
        final gridAspectRatio = contentWidth >= 980
            ? 0.84
            : contentWidth >= 720
            ? 0.8
            : 0.78;

        if (state.isInitialLoading) {
          return WishlistLoadingGrid(columns: gridColumns);
        }

        if (state.status == WishlistStatus.failure && state.items.isEmpty) {
          return WishlistMessageView(
            title: l10n.wishlistUnableToLoad,
            description: state.errorMessage ?? l10n.somethingWentWrong,
            actionLabel: l10n.retry,
            onAction: () {
              context.read<WishlistBloc>().add(
                LoadWishlist(
                  page: state.currentPage,
                  perPage: state.perPage,
                  sort: state.sort,
                ),
              );
            },
          );
        }

        return RefreshIndicator(
          color: AppColors.secondary,
          backgroundColor: AppColors.lightBg,
          onRefresh: onRefresh,
          child: state.items.isEmpty
              ? WishlistMessageView(
                  title: l10n.wishlistEmptyTitle,
                  description: l10n.wishlistEmptySubtitle,
                  actionLabel: l10n.cartContinueShopping,
                  onAction: () => context.goNamed(AppRoutes.shop),
                )
              : CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        0,
                        AppSizes.s8,
                        0,
                        AppSizes.s24,
                      ),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final item = state.items[index];
                          final productId = item.id;

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.s4,
                            ),
                            child: WishlistProductCard(
                              key: ValueKey(
                                'wishlist-item-${item.id ?? index}',
                              ),
                              product: item,
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
                              onRemoveTap: () {
                                if (productId == null) {
                                  return;
                                }

                                context.read<WishlistBloc>().add(
                                  ToggleWishlistProduct(productId: productId),
                                );
                              },
                            ),
                          );
                        }, childCount: state.items.length),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gridColumns,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: AppSizes.s18,
                          childAspectRatio: gridAspectRatio,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, AppSizes.s36),
                        child: ShopPaginationControls(
                          currentPage: state.currentPage,
                          totalPages: state.totalPages,
                          centerContent: true,
                          onPageSelected: (page) {
                            context.read<WishlistBloc>().add(
                              ChangeWishlistPage(page),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
