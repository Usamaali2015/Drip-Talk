import 'package:flutter/material.dart';

import 'ai_curated_collection_loading_widgets.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class AiCuratedCollectionHeroCard extends StatelessWidget {
  const AiCuratedCollectionHeroCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.productsCountLabel,
  });

  final String? imageUrl;
  final String title;
  final String description;
  final String productsCountLabel;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.cyan, AppColors.secondary, AppColors.primary],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.r28 - 1),
        child: AspectRatio(
          aspectRatio: 1.55,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryDark, AppColors.secondary],
                  ),
                ),
              ),
              if (hasImage)
                AppCachedNetworkImage(
                  imageUrl: imageUrl!.trim(),
                  fit: BoxFit.cover,
                  placeholder: const AiCuratedCollectionImagePlaceholder(),
                ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.pureBlack.withValues(alpha: 0.4),
                      AppColors.pureBlack.withValues(alpha: 0.5),
                      AppColors.pureBlack.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSizes.s18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppText(
                      text: title,
                      maxLines: 2,
                      style: AppTextStyles.ts18(
                        context,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const AppGap(AppSizes.s6, axis: Axis.vertical),
                    AppText(
                      text: description,
                      maxLines: 3,
                      style: AppTextStyles.ts12(
                        context,
                        color: AppColors.pureWhite,
                        fontWeight: FontWeight.w400,
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
