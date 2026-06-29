import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class HelpCenterPageHeader extends StatelessWidget {
  const HelpCenterPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientBorder(
          onTap: onBack,
          enableShadow: false,
          borderWidth: 1.2,
          borderRadius: AppRadius.r12,
          padding: const EdgeInsets.all(AppSizes.s8),
          backgroundColor: AppColors.lightBg,
          colors: const [AppColors.primary, AppColors.secondary],
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.pureWhite,
            size: AppSizes.s20,
          ),
        ),
        const AppGap(AppSizes.s12, axis: Axis.horizontal),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: AppSizes.s2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: title,
                  style: AppTextStyles.ts20(
                    context,
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const AppGap(AppSizes.s4),
                AppText(
                  text: subtitle,
                  style: AppTextStyles.ts12(
                    context,
                    color: AppColors.pureWhite.withValues(alpha: 0.68),
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
