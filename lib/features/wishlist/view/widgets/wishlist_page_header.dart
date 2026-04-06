import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:flutter/material.dart';

class WishlistPageHeader extends StatelessWidget {
  const WishlistPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.onBack,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSizes.s16),
            onTap: onBack,
            child: Container(
              height: AppSizes.s48,
              width: AppSizes.s48,
              decoration: BoxDecoration(
                color: AppColors.lightBg,
                borderRadius: BorderRadius.circular(AppSizes.s16),
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.46),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.white,
                size: AppSizes.s20,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSizes.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: title,
                style: AppTextStyles.ts18(
                  context,
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSizes.s2),
              AppText(
                text: subtitle,
                style: AppTextStyles.ts12(
                  context,
                  color: AppColors.white.withValues(alpha: 0.72),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
