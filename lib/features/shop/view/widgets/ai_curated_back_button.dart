import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:flutter/material.dart';

class AiCuratedBackButton extends StatelessWidget {
  const AiCuratedBackButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.s10),
        onTap: onTap,
        child: Container(
          width: AppSizes.s40,
          height: AppSizes.s40,
          decoration: BoxDecoration(
            color: AppColors.lightBg,
            borderRadius: BorderRadius.circular(AppSizes.s10),
            border: Border.all(
              color: AppColors.secondary.withValues(alpha: 0.42),
            ),
          ),
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.pureWhite,
            size: AppSizes.s20,
          ),
        ),
      ),
    );
  }
}
