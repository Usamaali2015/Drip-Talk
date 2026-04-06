import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_padding.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/common/widgets/app_asset_image.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:drip_talk/generated/assets.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class AiPromoBanner extends StatelessWidget {
  final VoidCallback? onTap;

  const AiPromoBanner({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: AppSizes.fitWidth,
        padding: AppPadding.allMedium,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.r20),
          border: Border.all(color: AppColors.secondary, width: 1),
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
                color: Colors.white,
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
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.circular),
                border: Border.all(color: Colors.white30),
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
                      color: AppColors.white,
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
    );
  }
}
