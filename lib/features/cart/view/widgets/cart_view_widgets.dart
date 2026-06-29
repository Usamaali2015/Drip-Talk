part of '../cart_view.dart';

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
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.45,
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(AppSizes.s24),
              decoration: BoxDecoration(
                color: AppColors.lightBg.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(AppSizes.s28),
                border: Border.all(
                  color: AppColors.pureWhite.withValues(alpha: 0.1),
                ),
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
                      color: AppColors.pureWhite,
                      size: AppSizes.s32,
                    ),
                  ),
                  const AppGap(AppSizes.s20, axis: Axis.vertical),
                  AppText(
                    text: title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.ts18(
                      context,
                      color: AppColors.pureWhite,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const AppGap(AppSizes.s10, axis: Axis.vertical),
                  AppText(
                    text: description,
                    textAlign: TextAlign.center,
                    maxLines: 2,

                    style: AppTextStyles.ts14(
                      context,
                      color: AppColors.pureWhite.withValues(alpha: 0.68),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const AppGap(AppSizes.s24, axis: Axis.vertical),
                  SizedBox(
                    width: AppSizes.fitWidth,
                    child: FilledButton(
                      onPressed: onAction,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.pureWhite,
                        minimumSize: const Size.fromHeight(AppSizes.s50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppRadius.circular,
                          ),
                        ),
                      ),
                      child: Text(actionLabel),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WideCartContent extends StatelessWidget {
  const _WideCartContent({
    required this.state,
    required this.l10n,
    required this.promoCodeController,
    required this.onApplyPromo,
  });

  final CartState state;
  final AppLocalizations l10n;
  final TextEditingController promoCodeController;
  final VoidCallback onApplyPromo;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(0, AppSizes.s16, 0, AppSizes.s24),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 8,
              child: Column(
                children: [
                  for (int index = 0; index < state.items.length; index++) ...[
                    Builder(
                      builder: (context) {
                        final item = state.items[index];
                        final cartItemId = item.id;
                        final isBusy = state.isCartItemPending(cartItemId);
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
                          onDecrease: cartItemId == null || item.quantity <= 1
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
                                  RemoveCartItem(cartItemId: cartItemId),
                                ),
                        );
                      },
                    ),
                    if (index != state.items.length - 1)
                      const AppGap(AppSizes.s24, axis: Axis.vertical),
                  ],
                ],
              ),
            ),
            const AppGap(AppSizes.s24, axis: Axis.horizontal),
            Expanded(
              flex: 5,
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
                promoController: promoCodeController,
                onApplyPromo: onApplyPromo,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CartLoadingBody extends StatelessWidget {
  const _CartLoadingBody({required this.isWideLayout});

  final bool isWideLayout;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(0, AppSizes.s16, 0, AppSizes.s24),
        children: [
          if (isWideLayout)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 8,
                  child: Column(
                    children: List.generate(
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
                  ),
                ),
                const AppGap(AppSizes.s24, axis: Axis.horizontal),
                Expanded(
                  flex: 5,
                  child: Container(
                    height: AppSizes.s320,
                    decoration: BoxDecoration(
                      color: AppColors.lightBg,
                      borderRadius: BorderRadius.circular(AppSizes.s28),
                    ),
                  ),
                ),
              ],
            )
          else ...[
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
        ],
      ),
    );
  }
}
