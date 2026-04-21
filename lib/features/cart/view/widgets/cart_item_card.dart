import 'package:drip_talk/features/cart/data/models/cart_model.dart';
import 'package:drip_talk/features/cart/view/widgets/cart_price_formatter.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.item,
    this.isBusy = false,
    this.onIncrease,
    this.onDecrease,
    this.onRemove,
  });

  final CartItem item;
  final bool isBusy;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r28),
        gradient: const LinearGradient(
          colors: [AppColors.secondary, AppColors.cyan, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.s16),
        decoration: BoxDecoration(
          color: AppColors.lightBg.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(AppRadius.r28),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.r12),
              child: SizedBox(
                width: AppSizes.s64,
                height: AppSizes.s64,
                child: AppCachedNetworkImage(
                  imageUrl: item.thumbnail ?? '',
                  fit: BoxFit.cover,
                  placeholder: const _CartImagePlaceholder(),
                ),
              ),
            ),
            const AppGap(AppSizes.s14, axis: Axis.horizontal),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppText(
                          text: item.title ?? '',
                          maxLines: 2,
                          style: AppTextStyles.ts18(
                            context,
                            color: AppColors.pureWhite,
                            fontWeight: FontWeight.w700,
                          ).copyWith(fontSize: 15),
                        ),
                      ),
                      const AppGap(AppSizes.s10, axis: Axis.horizontal),
                      _IconActionButton(
                        icon: Icons.close_rounded,
                        onTap: isBusy ? null : onRemove,
                      ),
                    ],
                  ),
                  const AppGap(AppSizes.s8, axis: Axis.vertical),
                  _ItemMetaLine(
                    icon: Icons.straighten_rounded,
                    label: l10n.cartSize,
                    value: item.sizeLabel ?? '--',
                  ),
                  const AppGap(AppSizes.s4, axis: Axis.vertical),
                  _ItemMetaLine(
                    icon: Icons.palette_outlined,
                    label: l10n.cartColor,
                    value: item.colorLabel ?? '--',
                  ),
                  const AppGap(AppSizes.s14, axis: Axis.vertical),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AppText(
                          text: formatCartPrice(
                            item.resolvedUnitPrice,
                            currency: item.currency,
                          ),
                          style: AppTextStyles.ts18(
                            context,
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      _QuantityStepper(
                        quantity: item.quantity,
                        isBusy: isBusy,
                        onIncrease: onIncrease,
                        onDecrease: onDecrease,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemMetaLine extends StatelessWidget {
  const _ItemMetaLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondary, size: AppSizes.s12),
        const AppGap(AppSizes.s6, axis: Axis.horizontal),
        Flexible(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: AppTextStyles.ts12(
                    context,
                    color: AppColors.pureWhite.withValues(alpha: 0.86),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: AppTextStyles.ts12(
                    context,
                    color: AppColors.pureWhite.withValues(alpha: 0.68),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.quantity,
    required this.isBusy,
    this.onIncrease,
    this.onDecrease,
  });

  final int quantity;
  final bool isBusy;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.s36,
      width: AppSizes.s96,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.s8),
      decoration: BoxDecoration(
        color: AppColors.darkBg.withValues(alpha: 0.36),
        borderRadius: BorderRadius.circular(AppRadius.circular),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.7)),
      ),
      child: Row(
        children: [
          _StepperButton(
            icon: Icons.remove,
            enabled: !isBusy && quantity > 1,
            onTap: onDecrease,
          ),
          Expanded(
            child: Center(
              child: AppText(
                text: '$quantity',
                style: AppTextStyles.ts14(
                  context,
                  color: AppColors.pureWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          _StepperButton(icon: Icons.add, enabled: !isBusy, onTap: onIncrease),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.enabled, this.onTap});

  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(AppRadius.circular),
      child: SizedBox(
        width: AppSizes.s20,
        height: AppSizes.s20,
        child: Icon(
          icon,
          size: AppSizes.s14,
          color: enabled
              ? AppColors.pureWhite
              : AppColors.pureWhite.withValues(alpha: 0.28),
        ),
      ),
    );
  }
}

class _IconActionButton extends StatelessWidget {
  const _IconActionButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.circular),
      child: Container(
        width: AppSizes.s24,
        height: AppSizes.s24,
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: 0.18),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.pureWhite.withValues(alpha: 0.14),
          ),
        ),
        child: Icon(icon, color: AppColors.pureWhite, size: AppSizes.s16),
      ),
    );
  }
}

class _CartImagePlaceholder extends StatelessWidget {
  const _CartImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: Container(color: AppColors.lightBg),
      ),
    );
  }
}
