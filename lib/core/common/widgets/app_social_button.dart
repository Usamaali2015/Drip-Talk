import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/app_assets.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/common/widgets/app_asset_image.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import '../constants/app_sizes.dart';
import 'app_gap.dart';
import 'app_text.dart';

enum SocialAuthType { google, apple }

class SocialAuthButton extends StatelessWidget {
  final SocialAuthType type;
  final VoidCallback onPressed;
  final double? width;
  final Color? backgroundColor;
  final double? borderRadius;

  const SocialAuthButton({
    super.key,
    required this.type,
    required this.onPressed,
    this.width,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isGoogle = type == SocialAuthType.google;

    return SizedBox(
      width: width ?? AppSizes.fitWidth,
      height: AppSizes.s50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.transparent,
          side: BorderSide(
            color: AppColors.secondary,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.r12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Logo
            AppAssetImage(
              assetPath: isGoogle ? AppAssets.googleLogo : AppAssets.appleLogo,
              width: AppSizes.s24,
              height: AppSizes.s24,
            ),

            const AppGap(AppSizes.s12, axis: Axis.horizontal),

            /// Text
            AppText(
              text: isGoogle
                  ? AppLocalizations.of(context)!.continueWithGoogle
                  : AppLocalizations.of(context)!.continueWithApple,
              style: AppTextStyles.ts14(context,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
