import 'package:drip_talk/generated/assets.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class AiPromoBanner extends StatelessWidget {
  final VoidCallback? onTap;

  const AiPromoBanner({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.r20),
          gradient: const LinearGradient(
            colors: [
              AppColors.secondary,
              AppColors.cyan,
              AppColors.primaryDark,
            ],
          ),
        ),
        child: Container(
          width: AppSizes.fitWidth,
          padding: AppPadding.allMedium,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r20),

            gradient: const LinearGradient(
              colors: [AppColors.primaryDark, AppColors.cyan],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: l10n.shopAiStyleProfileText,
                style: AppTextStyles.ts14(
                  context,
                  color: AppColors.pureWhite,
                  fontWeight: FontWeight.w600,
                  customFontFamily: AppTextStyles.fontFamilyPrimary,
                ),
              ),
              const AppGap(AppSizes.s12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.s16,
                  vertical: AppSizes.s8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.pureWhite.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.circular),
                  border: Border.all(color: AppColors.pureWhite30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppAssetImage(assetPath: Assets.chatWhite),
                    const AppGap(AppSizes.s8, axis: Axis.horizontal),
                    AppText(
                      text: l10n.shopAskAiShoppingAdvice,
                      style: AppTextStyles.ts12(
                        context,
                        color: AppColors.pureWhite,
                        fontWeight: FontWeight.w600,
                        customFontFamily: AppTextStyles.fontFamilyPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
