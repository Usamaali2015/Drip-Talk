import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ShopFilterCheckboxOption extends StatelessWidget {
  const ShopFilterCheckboxOption({
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
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.s10),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSizes.s12,
            horizontal: AppSizes.s2,
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                width: AppSizes.s16,
                height: AppSizes.s16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.s4),
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [AppColors.secondary, AppColors.primary],
                        )
                      : null,
                  color: isSelected ? null : Colors.transparent,
                  border: Border.all(
                    color: AppColors.secondary.withValues(
                      alpha: isSelected ? 0 : 0.7,
                    ),
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        size: AppSizes.s12,
                        color: AppColors.white,
                      )
                    : null,
              ),
              const AppGap(AppSizes.s10, axis: Axis.horizontal),
              Expanded(
                child: AppText(
                  text: label,
                  style: AppTextStyles.ts12(
                    context,
                    color: AppColors.white.withValues(alpha: 0.92),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
