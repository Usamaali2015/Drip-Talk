import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/common/widgets/app_cached_network_image.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:flutter/material.dart';

class CollectionCard extends StatelessWidget {
  final String title;
  final String itemsText;
  final String? imageUrl;
  final VoidCallback? onTap;

  const CollectionCard({
    super.key,
    required this.title,
    required this.itemsText,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return Container(
      width: AppSizes.s150,
      margin: const EdgeInsets.only(right: AppSizes.s12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.r12),
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                const _CollectionCardFallback(),
                if (hasImage)
                  Positioned.fill(
                    child: AppCachedNetworkImage(
                      imageUrl: imageUrl!.trim(),
                      fit: BoxFit.cover,
                      placeholder: const ColoredBox(color: AppColors.lightBg),
                      errorWidget: const _CollectionCardFallback(),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(AppSizes.s12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: title,
                        maxLines: 2,
                        style: AppTextStyles.ts14(
                          context,
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          customFontFamily: AppTextStyles.fontFamilyPrimary,
                        ),
                      ),
                      AppText(
                        text: itemsText,
                        maxLines: 1,
                        style: AppTextStyles.ts10(
                          context,
                          color: AppColors.white.withValues(alpha: 0.6),
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
      ),
    );
  }
}

class _CollectionCardFallback extends StatelessWidget {
  const _CollectionCardFallback();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.secondary],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.auto_awesome_rounded,
          color: AppColors.white.withValues(alpha: 0.85),
          size: AppSizes.s40,
        ),
      ),
    );
  }
}
