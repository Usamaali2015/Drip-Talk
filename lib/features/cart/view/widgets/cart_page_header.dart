import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_gradient_border.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:flutter/material.dart';

class CartPageHeader extends StatelessWidget {
  const CartPageHeader({
    super.key,
    required this.title,
    required this.itemsLabel,
    this.onBack,
  });

  final String title;
  final String itemsLabel;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GradientBorder(
          onTap: onBack,
          enableShadow: false,
          backgroundColor: AppColors.lightBg,
          borderRadius: AppRadius.r12,
          colors: const [AppColors.primary, AppColors.secondary],
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.surface,
            size: AppSizes.s20,
          ),
        ),
        const AppGap(AppSizes.s16, axis: Axis.horizontal),
        Expanded(
          child: AppText(
            text: title,
            textAlign: TextAlign.center,
            style: AppTextStyles.ts18(
              context,
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const AppGap(AppSizes.s16, axis: Axis.horizontal),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s12,
            vertical: AppSizes.s8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.circular),
            gradient: const LinearGradient(
              colors: [AppColors.secondary, AppColors.primary],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: AppText(
            text: itemsLabel,
            style: AppTextStyles.ts14(
              context,
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
