import 'package:flutter/material.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class AppRatingBar extends StatelessWidget {
  final String? rating;
  final String? reviews;
  final double iconSize;

  const AppRatingBar({
    super.key,
    this.rating,
    this.reviews,
    this.iconSize = AppSizes.s16,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final double ratingValue = double.tryParse(rating ?? '0') ?? 0.0;
    final reviewCount = int.tryParse(reviews ?? '0') ?? 0;

    return Row(
      children: [
        Row(
          children: List.generate(5, (index) {
            IconData icon;
            if (index < ratingValue.floor()) {
              icon = Icons.star;
            } else if (index < ratingValue) {
              icon = Icons.star_half;
            } else {
              icon = Icons.star_border;
            }
            return Icon(icon, color: AppColors.materialAmber, size: iconSize);
          }),
        ),
        const AppGap(AppSizes.s8, axis: Axis.horizontal),
        AppText(
          text: rating ?? '0.0',
          variant: AppTextVariant.ts14,
          fontWeight: FontWeight.w600,
        ),
        const AppGap(AppSizes.s4, axis: Axis.horizontal),
        AppText(
          text: l10n.productReviewsCount(reviewCount),
          variant: AppTextVariant.ts12,
          textColor: AppColors.pureWhite.withValues(alpha: 0.5),
        ),
      ],
    );
  }
}
