import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/core/utils/responsive/responsive_extensions.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/cart/barrels/cart_barrels.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
part 'widgets/cart_view_widgets.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  late final TextEditingController _promoCodeController;

  @override
  void initState() {
    super.initState();
    _promoCodeController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<CartBloc>().add(
        LoadCart(showLoader: !context.read<CartBloc>().state.hasLoaded),
      );
    });
  }

  @override
  void dispose() {
    _promoCodeController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh(BuildContext context) async {
    final bloc = context.read<CartBloc>();
    bloc.add(const LoadCart(showLoader: false));
    await bloc.stream.firstWhere((state) => !state.isRefreshing);
  }

  void _showPromoUnavailable(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ToastUtils.show(context, l10n.cartPromoUnavailable, type: ToastType.info);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final showCheckoutBar = !context.isWideScreen;

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return AppResponsivePageLayout(
          mobileMaxWidth: 430,
          tabletMaxWidth: 720,
          tabletLargeMaxWidth: 840,
          desktopMaxWidth: 920,
          showBottomNav: showCheckoutBar && state.items.isNotEmpty,
          bottomNav: CartCheckoutBar(
            enabled: state.items.isNotEmpty,
            label: l10n.cartCheckoutTotal(
              formatCartPrice(
                state.summary.total,
                currency: state.summary.currency,
              ),
            ),
            onTap: state.items.isEmpty
                ? null
                : () => _showPromoUnavailable(context),
          ),
          headerBuilder: (context, _) => CartPageHeader(
            title: l10n.cartTitle,
            itemsLabel: l10n.cartItemsCount(state.totalQuantity),
            onBack: () => context.pop(),
          ),
          bodyBuilder: (context, contentWidth) {
            final isWideLayout = contentWidth >= 760;

            if (state.isInitialLoading) {
              return _CartLoadingBody(isWideLayout: isWideLayout);
            }

            if (state.status == CartStatus.failure && state.items.isEmpty) {
              return _CartMessageView(
                title: l10n.cartUnableToLoad,
                description: state.errorMessage ?? l10n.somethingWentWrong,
                actionLabel: l10n.retry,
                onAction: () {
                  context.read<CartBloc>().add(const LoadCart());
                },
              );
            }

            return RefreshIndicator(
              color: AppColors.secondary,
              backgroundColor: AppColors.lightBg,
              onRefresh: () => _handleRefresh(context),
              child: state.items.isEmpty
                  ? _CartMessageView(
                      title: l10n.cartEmptyTitle,
                      description: l10n.cartEmptySubtitle,
                      actionLabel: l10n.cartContinueShopping,
                      onAction: () {
                        context.goNamed(AppRoutes.shop);
                      },
                    )
                  : isWideLayout
                  ? _WideCartContent(
                      state: state,
                      l10n: l10n,
                      promoCodeController: _promoCodeController,
                      onApplyPromo: () => _showPromoUnavailable(context),
                    )
                  : CustomScrollView(
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(
                            0,
                            AppSizes.s16,
                            0,
                            AppSizes.s16,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (index.isOdd) {
                                  return const AppGap(
                                    AppSizes.s24,
                                    axis: Axis.vertical,
                                  );
                                }

                                final itemIndex = index ~/ 2;
                                final item = state.items[itemIndex];
                                final cartItemId = item.id;
                                final isBusy = state.isCartItemPending(
                                  cartItemId,
                                );
                                final bloc = context.read<CartBloc>();

                                return CartItemCard(
                                  key: ValueKey(
                                    'cart-item-${cartItemId ?? item.productVariantId ?? index}',
                                  ),
                                  item: item,
                                  isBusy: isBusy,
                                  onIncrease: cartItemId == null
                                      ? null
                                      : () {
                                          final currentQuantity =
                                              bloc.state
                                                  .itemForCartItemId(cartItemId)
                                                  ?.quantity ??
                                              item.quantity;

                                          bloc.add(
                                            UpdateCartItemQuantity(
                                              cartItemId: cartItemId,
                                              quantity: currentQuantity + 1,
                                            ),
                                          );
                                        },
                                  onDecrease:
                                      cartItemId == null || item.quantity <= 1
                                      ? null
                                      : () {
                                          final currentQuantity =
                                              bloc.state
                                                  .itemForCartItemId(cartItemId)
                                                  ?.quantity ??
                                              item.quantity;

                                          bloc.add(
                                            UpdateCartItemQuantity(
                                              cartItemId: cartItemId,
                                              quantity: currentQuantity - 1,
                                            ),
                                          );
                                        },
                                  onRemove: cartItemId == null
                                      ? null
                                      : () => context.read<CartBloc>().add(
                                          RemoveCartItem(
                                            cartItemId: cartItemId,
                                          ),
                                        ),
                                );
                              },
                              childCount: state.items.isEmpty
                                  ? 0
                                  : (state.items.length * 2) - 1,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              0,
                              0,
                              0,
                              AppSizes.s24,
                            ),
                            child: CartOrderSummaryCard(
                              summary: state.summary,
                              title: l10n.cartOrderSummary,
                              subtotalLabel: l10n.cartSubtotal,
                              shippingLabel: l10n.cartShipping,
                              discountLabel: l10n.cartDiscount,
                              taxLabel: l10n.cartTax,
                              totalLabel: l10n.cartTotal,
                              promoHintText: l10n.cartPromoCodeHint,
                              applyLabel: l10n.cartApply,
                              promoController: _promoCodeController,
                              onApplyPromo: () =>
                                  _showPromoUnavailable(context),
                            ),
                          ),
                        ),
                      ],
                    ),
            );
          },
        );
      },
    );
  }
}
