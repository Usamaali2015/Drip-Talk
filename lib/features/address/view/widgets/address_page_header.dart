import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class AddressPageHeader extends StatelessWidget {
  const AddressPageHeader({
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
    return Column(
      children: [
        Row(
          children: [
            GradientBorder(
              padding: AppPadding.allExtraSmall,
              onTap: onBack,
              enableShadow: false,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              backgroundColor: AppColors.lightBg,
              borderRadius: AppRadius.r12,
              colors: const [AppColors.primary, AppColors.secondary],
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.surface,
                size: AppSizes.s20,
              ),
            ),
            const AppGap(AppSizes.s12, axis: Axis.horizontal),
            Expanded(
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
                  AppText(
                    text: subtitle,
                    style: AppTextStyles.ts12(
                      context,
                      color: AppColors.pureWhite.withValues(alpha: 0.74),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const AppGap(AppSizes.s18),
        Container(
          width: double.infinity,
          height: 1,
          color: AppColors.secondary.withValues(alpha: 0.35),
        ),
      ],
    );
  }
}
