import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'app_rating.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class ProductDetailsCard extends StatelessWidget {
  final String? productName;
  final String? productType;
  final String? productPrice;
  final String? productOffPrice;
  final String? productRating;
  final String? productReviews;
  final String? productOFFPercentage;
  final String? productDescription;
  final String? availabilityLabel;
  final Color? availabilityColor;
  final VoidCallback? onReviewPressed;
  final bool isReviewActionLoading;
  final String? reviewActionText;

  const ProductDetailsCard({
    super.key,
    this.productName,
    this.productType,
    this.productPrice,
    this.productDescription,
    this.productOffPrice,
    this.productRating,
    this.productReviews,
    this.productOFFPercentage,
    this.availabilityLabel,
    this.availabilityColor,
    this.onReviewPressed,
    this.isReviewActionLoading = false,
    this.reviewActionText,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasComparePrice =
        productOffPrice != null && productOffPrice!.trim().isNotEmpty;
    final hasDiscount =
        productOFFPercentage != null && productOFFPercentage!.trim().isNotEmpty;
    final hasType = productType != null && productType!.trim().isNotEmpty;
    final hasAvailability =
        availabilityLabel != null && availabilityLabel!.trim().isNotEmpty;

    return Container(
      width: AppSizes.fitWidth,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondary, AppColors.cyan, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(AppRadius.r24),
      ),
      child: Container(
        padding: AppPadding.allMediumLarge,
        decoration: BoxDecoration(
          color: AppColors.lightBg,
          borderRadius: BorderRadius.circular(AppRadius.r24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppText(
                    text: productName ?? '--',
                    variant: AppTextVariant.ts18,
                    maxLines: 2,
                    isBold: true,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.secondary,
                        AppColors.secondary,
                        AppColors.pureWhite,
                      ],
                    ),
                  ),
                ),
                if (hasAvailability)
                  Container(
                    margin: const EdgeInsets.only(left: AppSizes.s10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.s10,
                      vertical: AppSizes.s6,
                    ),
                    decoration: BoxDecoration(
                      color: (availabilityColor ?? AppColors.materialGreen)
                          .withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(AppRadius.r12),
                      border: Border.all(
                        color: availabilityColor ?? AppColors.materialGreen,
                      ),
                    ),
                    child: AppText(
                      text: availabilityLabel!,
                      variant: AppTextVariant.ts10,
                      fontWeight: FontWeight.w700,
                      textColor:
                          availabilityColor ?? AppColors.materialGreen,
                    ),
                  ),
              ],
            ),
            if (hasType) ...[
              AppText(
                text: productType!,
                variant: AppTextVariant.ts14,
                textColor: AppColors.pureWhite.withValues(alpha: 0.6),
              ),
              const AppGap(AppSizes.s8),
            ],
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSizes.s8,
              runSpacing: AppSizes.s8,
              children: [
                AppText(
                  text: productPrice ?? '--',
                  variant: AppTextVariant.ts20,
                  fontWeight: FontWeight.w600,
                  textColor: AppColors.cyan,
                ),
                if (hasComparePrice)
                  AppText(
                    text: productOffPrice!,
                    variant: AppTextVariant.ts14,
                    fontWeight: FontWeight.w500,
                    textColor: AppColors.pureWhite.withValues(alpha: 0.5),
                    textDecoration: TextDecoration.lineThrough,
                  ),
                if (hasDiscount)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(AppRadius.r12),
                    ),
                    child: AppText(
                      text: productOFFPercentage!,
                      variant: AppTextVariant.ts10,
                      fontWeight: FontWeight.bold,
                      textColor: AppColors.pureWhite,
                    ),
                  ),
              ],
            ),
            const AppGap(AppSizes.s8),
            AppRatingBar(rating: productRating, reviews: productReviews),
            if (productDescription != null &&
                productDescription!.trim().isNotEmpty) ...[
              const AppGap(AppSizes.s8),
              AppHtmlContent(
                html: productDescription!,
                enableReadMore: true,
                collapsedHeight: 132,
              ),
            ],
            if (onReviewPressed != null) ...[
              const AppGap(AppSizes.s16),
              AppButton(
                text: reviewActionText ?? l10n.reviewsWriteAction,
                onPressed: onReviewPressed,
                isLoading: isReviewActionLoading,
                height: AppSizes.s48,
                borderRadius: AppRadius.r16,
                gradientColors: const [AppColors.secondary, AppColors.primary],
                fontSize: AppSizes.s14,
                leadingIcon: const Icon(
                  Icons.rate_review_outlined,
                  color: AppColors.pureWhite,
                  size: AppSizes.s18,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
