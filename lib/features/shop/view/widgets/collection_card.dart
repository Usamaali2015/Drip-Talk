import 'package:flutter/material.dart';
import 'package:drip_talk/core/utils/responsive/responsive_extensions.dart';

import 'ai_curated_collection_loading_widgets.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

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
    final cardWidth = context.responsive(
      150.0,
      tablet: 180.0,
      tabletLarge: 210.0,
      desktop: 230.0,
    );
    final marginEnd = context.responsive(
      AppSizes.s12.toDouble(),
      tablet: 14.0,
      desktop: 16.0,
    );

    return Container(
      width: cardWidth,
      margin: EdgeInsets.only(right: marginEnd),
      child: Material(
        color: AppColors.transparent,
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
                      placeholder: const AiCuratedCollectionImagePlaceholder(),
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
                        AppColors.transparent,
                        AppColors.pureBlack.withValues(alpha: 0.8),
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
                          color: AppColors.pureWhite,
                          fontWeight: FontWeight.w600,
                          customFontFamily: AppTextStyles.fontFamilyPrimary,
                        ),
                      ),
                      AppText(
                        text: itemsText,
                        maxLines: 1,
                        style: AppTextStyles.ts10(
                          context,
                          color: AppColors.pureWhite.withValues(alpha: 0.6),
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
          color: AppColors.pureWhite.withValues(alpha: 0.85),
          size: AppSizes.s40,
        ),
      ),
    );
  }
}
