import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/common/widgets/app_cached_network_image.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:flutter/material.dart';

class AiCuratedCollectionTile extends StatelessWidget {
  const AiCuratedCollectionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.itemsText,
    required this.imageUrl,
    required this.isFeatured,
    required this.tags,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final String itemsText;
  final String? imageUrl;
  final bool isFeatured;
  final List<String> tags;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.r24 - 1),
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.r24 - 1),
          child: Stack(
            fit: StackFit.expand,
            children: [
              const _CollectionTileFallback(),
              if (hasImage)
                Positioned.fill(
                  child: AppCachedNetworkImage(
                    imageUrl: imageUrl!.trim(),
                    fit: BoxFit.cover,
                    placeholder: const ColoredBox(color: AppColors.lightBg),
                    errorWidget: const _CollectionTileFallback(),
                  ),
                ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.08),
                      Colors.black.withValues(alpha: 0.18),
                      Colors.black.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSizes.s14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isFeatured)
                      const _IconBadge(icon: Icons.auto_awesome_rounded),
                    const Spacer(),
                    if (tags.isNotEmpty)
                      const AppGap(AppSizes.s10, axis: Axis.vertical),
                    AppText(
                      text: title,
                      maxLines: 2,
                      style: AppTextStyles.ts16(
                        context,
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    _LabelPill(label: itemsText),
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

class _CollectionTileFallback extends StatelessWidget {
  const _CollectionTileFallback();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.secondary],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.auto_awesome_rounded,
          color: AppColors.white,
          size: AppSizes.s40,
        ),
      ),
    );
  }
}

class _LabelPill extends StatelessWidget {
  const _LabelPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s10,
        vertical: AppSizes.s6,
      ),
      decoration: BoxDecoration(
        color: AppColors.darkBg.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(AppRadius.circular),
        border: Border.all(color: Colors.white12),
      ),
      child: AppText(
        text: label,
        variant: AppTextVariant.ts10,
        textColor: AppColors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.s36,
      width: AppSizes.s36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppColors.secondary.withValues(alpha: 0.95),
            AppColors.primary.withValues(alpha: 0.95),
          ],
        ),
      ),
      child: Icon(icon, size: AppSizes.s18, color: AppColors.white),
    );
  }
}
