import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/common/widgets/app_button.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:drip_talk/features/cart/data/models/cart_model.dart';
import 'package:drip_talk/features/cart/view/widgets/cart_price_formatter.dart';
import 'package:flutter/material.dart';

class CartOrderSummaryCard extends StatelessWidget {
  const CartOrderSummaryCard({
    super.key,
    required this.summary,
    required this.title,
    required this.subtotalLabel,
    required this.shippingLabel,
    required this.discountLabel,
    required this.taxLabel,
    required this.totalLabel,
    required this.promoHintText,
    required this.applyLabel,
    required this.promoController,
    this.onApplyPromo,
  });

  final CartSummary summary;
  final String title;
  final String subtotalLabel;
  final String shippingLabel;
  final String discountLabel;
  final String taxLabel;
  final String totalLabel;
  final String promoHintText;
  final String applyLabel;
  final TextEditingController promoController;
  final VoidCallback? onApplyPromo;

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(AppSizes.s18),
        decoration: BoxDecoration(
          color: AppColors.lightBg.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(AppRadius.r28),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.receipt_long_rounded,
                  color: AppColors.secondary,
                ),
                const AppGap(AppSizes.s10, axis: Axis.horizontal),
                AppText(
                  text: title,
                  style: AppTextStyles.ts18(
                    context,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const AppGap(AppSizes.s18, axis: Axis.vertical),
            _SummaryRow(
              label: subtotalLabel,
              value: formatCartPrice(
                summary.subtotal,
                currency: summary.currency,
              ),
            ),
            const AppGap(AppSizes.s8, axis: Axis.vertical),
            _SummaryRow(
              label: shippingLabel,
              value: formatCartPrice(
                summary.shipping,
                currency: summary.currency,
              ),
              valueColor: AppColors.white,
            ),
            const AppGap(AppSizes.s8, axis: Axis.vertical),
            _SummaryRow(
              label: discountLabel,
              value:
                  '-${formatCartPrice(summary.discount, currency: summary.currency)}',
              valueColor: AppColors.green,
            ),
            const AppGap(AppSizes.s8, axis: Axis.vertical),
            _SummaryRow(
              label: taxLabel,
              value: formatCartPrice(summary.tax, currency: summary.currency),
              valueColor: AppColors.green,
            ),
            const AppGap(AppSizes.s16, axis: Axis.vertical),
            Container(
              height: 1,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.white.withValues(alpha: 0.26),
                    width: 1,
                  ),
                ),
              ),
            ),
            const AppGap(AppSizes.s18, axis: Axis.vertical),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: totalLabel,
                  style: AppTextStyles.ts18(
                    context,
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppText(
                  text: formatCartPrice(
                    summary.total,
                    currency: summary.currency,
                  ),
                  style: AppTextStyles.ts18(
                    context,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w800,
                  ).copyWith(fontSize: 17),
                ),
              ],
            ),
            const AppGap(AppSizes.s18, axis: Axis.vertical),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: AppSizes.s48,
                    decoration: BoxDecoration(
                      color: AppColors.darkBg.withValues(alpha: 0.28),
                      borderRadius: BorderRadius.circular(AppRadius.circular),
                      border: Border.all(
                        color: AppColors.secondary.withValues(alpha: 0.72),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.s16,
                    ),
                    child: Center(
                      child: TextField(
                        controller: promoController,
                        style: AppTextStyles.ts14(
                          context,
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        cursorColor: AppColors.cyan,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: promoHintText,
                          hintStyle: AppTextStyles.ts12(
                            context,
                            color: AppColors.white.withValues(alpha: 0.5),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const AppGap(AppSizes.s10, axis: Axis.horizontal),
                AppButton(
                  text: applyLabel,
                  width: AppSizes.s96,
                  height: AppSizes.s48,
                  fontSize: 14,
                  borderRadius: AppRadius.circular,
                  gradientColors: const [
                    AppColors.secondary,
                    AppColors.primary,
                  ],
                  onPressed: onApplyPromo,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.white,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          text: label,
          style: AppTextStyles.ts14(
            context,
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        AppText(
          text: value,
          style: AppTextStyles.ts14(
            context,
            color: valueColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
