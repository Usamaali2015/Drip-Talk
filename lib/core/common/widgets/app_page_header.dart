import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_gradient_border.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:flutter/material.dart';

class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.onBack,
    this.backgroundColor = AppColors.lightBg,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onBack;
  final Color backgroundColor;

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
          backgroundColor: backgroundColor,
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
