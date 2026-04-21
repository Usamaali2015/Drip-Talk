import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class ShopFilterChoiceChip extends StatelessWidget {
  const ShopFilterChoiceChip({
    super.key,
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.r12),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          height: AppSizes.s40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r12),

            color: isSelected
                ? AppColors.secondary.withValues(alpha: 0.7)
                : AppColors.secondary.withValues(alpha: 0.18),
            border: Border.all(
              color: isSelected
                  ? AppColors.secondary.withValues(alpha: 0.18)
                  : AppColors.transparent,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.s12),
            child: AppText(
              text: label,
              textAlign: TextAlign.center,
              style: AppTextStyles.ts12(
                context,
                color: AppColors.pureWhite,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
