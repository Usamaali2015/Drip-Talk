import 'package:drip_talk/core/common/constants/app_padding.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/common/widgets/app_asset_image.dart';
import 'package:drip_talk/core/common/widgets/app_button.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_sizes.dart';
import 'app_gap.dart';
import 'app_text.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? content;
  final String primaryButtonText;
  final VoidCallback onPrimaryPressed;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;
  final IconData? icon;
  final String? assetPath;
  final Color? iconColor;

  const AppDialog({
    super.key,
    required this.title,
    required this.primaryButtonText,
    required this.onPrimaryPressed,
    this.description,
    this.content,
    this.secondaryButtonText,
    this.onSecondaryPressed,
    this.icon,
    this.iconColor,
    this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(AppSizes.s24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r28),
        side: BorderSide(color: AppColors.primary, width: 1.5),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Container(
      padding: AppPadding.allLarge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r28),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: (iconColor ?? Colors.blue).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: iconColor ?? Colors.blue),
            ),
            const AppGap(AppSizes.s20),
          ] else ...[
            AppAssetImage(assetPath: assetPath.toString()),
            AppGap(AppSizes.s24),
          ],

          AppText(
            text: title.toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 2,
            style: AppTextStyles.ts20(
              context,
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w800,
            ),
          ),
          const AppGap(AppSizes.s10),

          if (description != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: AppText(
                text: description ?? '',
                textAlign: TextAlign.center,
                style: AppTextStyles.ts14(
                  context,
                  color: AppColors.black,
                  fontWeight: FontWeight.w300,
                ),
                maxLines: 3,
              ),
            ),

          if (content != null) ...[const AppGap(AppSizes.s24), content!],

          Row(
            children: [
              if (secondaryButtonText != null) ...[
                Expanded(
                  child: AppButton(
                    text: secondaryButtonText ?? "",
                    onPressed: onSecondaryPressed,
                  ),
                ),
                AppGap(AppSizes.s10),
              ],

              Expanded(
                child: AppButton(
                  text: primaryButtonText,
                  onPressed: onPrimaryPressed,
                  borderRadius: AppRadius.circular,
                  gradientColors: [AppColors.secondary, AppColors.primary],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
