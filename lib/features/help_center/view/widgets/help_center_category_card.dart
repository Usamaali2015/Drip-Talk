import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class HelpCenterCategoryCard extends StatelessWidget {
  const HelpCenterCategoryCard({
    super.key,
    required this.title,
    this.iconAsset,
    this.iconUrl,
    this.isSelected = false,
    this.onTap,
  });

  final String title;
  final String? iconAsset;
  final String? iconUrl;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GradientBorder(
      onTap: onTap,
      enableShadow: false,
      borderWidth: 1,
      borderRadius: AppRadius.r16,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s12,
        vertical: AppSizes.s18,
      ),
      backgroundColor: AppColors.lightBg,
      colors: isSelected
          ? [AppColors.secondary, AppColors.secondary]
          : [
              AppColors.secondary.withValues(alpha: 0.06),
              AppColors.secondary.withValues(alpha: 0.06),
            ],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _CategoryIcon(iconAsset: iconAsset, iconUrl: iconUrl),
          const AppGap(AppSizes.s10),
          AppText(
            text: title,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: AppTextStyles.ts12(
              context,
              color: AppColors.pureWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({this.iconAsset, this.iconUrl});

  final String? iconAsset;
  final String? iconUrl;

  @override
  Widget build(BuildContext context) {
    if (iconAsset != null && iconAsset!.isNotEmpty) {
      return AppAssetImage(
        assetPath: iconAsset!,
        width: AppSizes.s40,
        height: AppSizes.s40,
      );
    }

    final normalizedUrl = iconUrl?.trim();
    if (normalizedUrl != null && normalizedUrl.isNotEmpty) {
      return AppCachedNetworkImage(
        imageUrl: normalizedUrl,
        width: AppSizes.s40,
        height: AppSizes.s40,
        fit: BoxFit.contain,
        errorWidget: _fallbackIcon,
      );
    }

    return _fallbackIcon;
  }

  Widget get _fallbackIcon => const Icon(
    Icons.help_outline_rounded,
    color: AppColors.secondary,
    size: AppSizes.s40,
  );
}
