import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class SupportedPaymentChip extends StatelessWidget {
  const SupportedPaymentChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s16,
        vertical: AppSizes.s16,
      ),
      decoration: BoxDecoration(
        color: AppColors.paymentChipBackground,
        borderRadius: BorderRadius.circular(AppRadius.r15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.credit_card_rounded,
            color: AppColors.pureWhite,
            size: AppSizes.s20,
          ),
          const AppGap(AppSizes.s8, axis: Axis.horizontal),
          Flexible(
            child: AppText(
              text: label,
              maxLines: 1,
              style: AppTextStyles.ts18(
                context,
                color: AppColors.pureWhite,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
