import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class HelpCenterMessageCard extends StatelessWidget {
  const HelpCenterMessageCard({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s18,
        vertical: AppSizes.s18,
      ),
      decoration: BoxDecoration(
        color: AppColors.sectionCardBackground,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.42)),
      ),
      child: AppText(
        text: message,
        textAlign: TextAlign.center,
        style: AppTextStyles.ts14(
          context,
          color: AppColors.pureWhite.withValues(alpha: 0.82),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
