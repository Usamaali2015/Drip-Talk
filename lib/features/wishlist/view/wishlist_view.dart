import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/product/view/helpers/product_add_to_cart_flow.dart';
import 'package:drip_talk/features/shop/view/widgets/shop_pagination_controls.dart';
import 'package:drip_talk/features/wishlist/domain/bloc/wishlist_bloc.dart';
import 'package:drip_talk/features/wishlist/domain/bloc/wishlist_event.dart';
import 'package:drip_talk/features/wishlist/domain/bloc/wishlist_state.dart';
import 'package:drip_talk/features/wishlist/view/widgets/wishlist_loading_grid.dart';
import 'package:drip_talk/features/wishlist/view/widgets/wishlist_message_view.dart';
import 'package:drip_talk/features/wishlist/view/widgets/wishlist_page_header.dart';
import 'package:drip_talk/features/wishlist/view/widgets/wishlist_product_card.dart';
import 'package:drip_talk/features/wishlist/view/widgets/wishlist_sort_chips.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WishListView extends StatefulWidget {
  const WishListView({super.key});

  @override
  State<WishListView> createState() => _WishListViewState();
}

class _WishListViewState extends State<WishListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final bloc = context.read<WishlistBloc>();
      final state = bloc.state;
      bloc.add(
        LoadWishlist(
          page: state.currentPage,
          perPage: state.perPage,
          sort: state.sort,
          showLoader: !state.hasLoaded,
        ),
      );
    });
  }

  Future<void> _handleRefresh(BuildContext context) async {
    final bloc = context.read<WishlistBloc>();
    final state = bloc.state;
    bloc.add(
      LoadWishlist(
        page: state.currentPage,
        perPage: state.perPage,
        sort: state.sort,
        showLoader: false,
      ),
    );
    await bloc.stream.firstWhere((nextState) => !nextState.isRefreshing);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      bottom: false,
      child: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.s20,
                  AppSizes.s20,
                  AppSizes.s20,
                  AppSizes.s12,
                ),
                child: WishlistPageHeader(
                  title: l10n.savedItems,
                  subtitle: l10n.wishlistSubtitle,
                  onBack: () => context.pop(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.s20),
                child: WishlistSortChips(
                  selectedSort: state.sort,
                  onSortSelected: (value) {
                    context.read<WishlistBloc>().add(ChangeWishlistSort(value));
                  },
                ),
              ),
              const AppGap(AppSizes.s10),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state.isInitialLoading) {
                      return const WishlistLoadingGrid();
                    }

                    if (state.status == WishlistStatus.failure &&
                        state.items.isEmpty) {
                      return WishlistMessageView(
                        title: l10n.wishlistUnableToLoad,
                        description:
                            state.errorMessage ?? l10n.somethingWentWrong,
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
                      onRefresh: () => _handleRefresh(context),
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
                                    AppSizes.s20,
                                    AppSizes.s8,
                                    AppSizes.s20,
                                    AppSizes.s24,
                                  ),
                                  sliver: SliverGrid(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
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
                                                pathParameters: {
                                                  'id': productId.toString(),
                                                },
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
                                                ToggleWishlistProduct(
                                                  productId: productId,
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      childCount: state.items.length,
                                    ),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 0,
                                          mainAxisSpacing: AppSizes.s18,
                                          childAspectRatio: 0.78,
                                        ),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      AppSizes.s20,
                                      0,
                                      AppSizes.s20,
                                      AppSizes.s36,
                                    ),
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
