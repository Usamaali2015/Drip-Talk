import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/cart/domain/bloc/cart_bloc.dart';
import 'package:drip_talk/features/cart/domain/bloc/cart_event.dart';
import 'package:drip_talk/features/cart/domain/bloc/cart_state.dart';
import 'package:drip_talk/features/cart/view/widgets/cart_checkout_bar.dart';
import 'package:drip_talk/features/cart/view/widgets/cart_item_card.dart';
import 'package:drip_talk/features/cart/view/widgets/cart_order_summary_card.dart';
import 'package:drip_talk/features/cart/view/widgets/cart_page_header.dart';
import 'package:drip_talk/features/cart/view/widgets/cart_price_formatter.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

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

    return SafeArea(
      bottom: false,
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.s24,
                  AppSizes.s20,
                  AppSizes.s24,
                  AppSizes.s8,
                ),
                child: CartPageHeader(
                  title: l10n.cartTitle,
                  itemsLabel: l10n.cartItemsCount(state.totalQuantity),
                  onBack: () => context.pop(),
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state.isInitialLoading) {
                      return const _CartLoadingBody();
                    }

                    if (state.status == CartStatus.failure &&
                        state.items.isEmpty) {
                      return _CartMessageView(
                        title: l10n.cartUnableToLoad,
                        description:
                            state.errorMessage ?? l10n.somethingWentWrong,
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
                          : CustomScrollView(
                              physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              ),
                              slivers: [
                                SliverPadding(
                                  padding: const EdgeInsets.fromLTRB(
                                    AppSizes.s24,
                                    AppSizes.s16,
                                    AppSizes.s24,
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
                                                      bloc
                                                          .state
                                                          .itemForCartItemId(
                                                            cartItemId,
                                                          )
                                                          ?.quantity ??
                                                      item.quantity;

                                                  bloc.add(
                                                    UpdateCartItemQuantity(
                                                      cartItemId: cartItemId,
                                                      quantity:
                                                          currentQuantity + 1,
                                                    ),
                                                  );
                                                },
                                          onDecrease:
                                              cartItemId == null ||
                                                  item.quantity <= 1
                                              ? null
                                              : () {
                                                  final currentQuantity =
                                                      bloc
                                                          .state
                                                          .itemForCartItemId(
                                                            cartItemId,
                                                          )
                                                          ?.quantity ??
                                                      item.quantity;

                                                  bloc.add(
                                                    UpdateCartItemQuantity(
                                                      cartItemId: cartItemId,
                                                      quantity:
                                                          currentQuantity - 1,
                                                    ),
                                                  );
                                                },
                                          onRemove: cartItemId == null
                                              ? null
                                              : () => context
                                                    .read<CartBloc>()
                                                    .add(
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
                                      AppSizes.s24,
                                      0,
                                      AppSizes.s24,
                                      AppSizes.s128,
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
                ),
              ),
              CartCheckoutBar(
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
            ],
          );
        },
      ),
    );
  }
}

class _CartMessageView extends StatelessWidget {
  const _CartMessageView({
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSizes.s24,
        AppSizes.s72,
        AppSizes.s24,
        AppSizes.s150,
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.s24),
          decoration: BoxDecoration(
            color: AppColors.lightBg.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(AppSizes.s28),
            border: Border.all(color: AppColors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            children: [
              Container(
                width: AppSizes.s72,
                height: AppSizes.s72,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.white,
                  size: AppSizes.s32,
                ),
              ),
              const AppGap(AppSizes.s20, axis: Axis.vertical),
              AppText(
                text: title,
                textAlign: TextAlign.center,
                style: AppTextStyles.ts18(
                  context,
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const AppGap(AppSizes.s10, axis: Axis.vertical),
              AppText(
                text: description,
                textAlign: TextAlign.center,
                style: AppTextStyles.ts14(
                  context,
                  color: AppColors.white.withValues(alpha: 0.68),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const AppGap(AppSizes.s24, axis: Axis.vertical),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onAction,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    minimumSize: const Size.fromHeight(AppSizes.s50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.s20),
                    ),
                  ),
                  child: Text(actionLabel),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CartLoadingBody extends StatelessWidget {
  const _CartLoadingBody();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primary.withValues(alpha: 0.12),
      highlightColor: AppColors.secondary.withValues(alpha: 0.18),
      child: ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSizes.s24,
          AppSizes.s16,
          AppSizes.s24,
          AppSizes.s150,
        ),
        children: [
          ...List.generate(
            2,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.s24),
              child: Container(
                height: AppSizes.s128,
                decoration: BoxDecoration(
                  color: AppColors.lightBg,
                  borderRadius: BorderRadius.circular(AppSizes.s28),
                ),
              ),
            ),
          ),
          Container(
            height: AppSizes.s280,
            decoration: BoxDecoration(
              color: AppColors.lightBg,
              borderRadius: BorderRadius.circular(AppSizes.s28),
            ),
          ),
        ],
      ),
    );
  }
}
