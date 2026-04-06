import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_padding.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_html_content.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:flutter/material.dart';

import 'app_rating.dart';

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
  });

  @override
  Widget build(BuildContext context) {
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
                        AppColors.white,
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
                      color: (availabilityColor ?? AppColors.green).withValues(
                        alpha: 0.18,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.r12),
                      border: Border.all(
                        color: availabilityColor ?? AppColors.green,
                      ),
                    ),
                    child: AppText(
                      text: availabilityLabel!,
                      variant: AppTextVariant.ts10,
                      fontWeight: FontWeight.w700,
                      textColor: availabilityColor ?? AppColors.green,
                    ),
                  ),
              ],
            ),
            if (hasType) ...[
              AppText(
                text: productType!,
                variant: AppTextVariant.ts14,
                textColor: AppColors.white.withValues(alpha: 0.6),
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
                    textColor: AppColors.white.withValues(alpha: 0.5),
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
                      textColor: AppColors.white,
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
          ],
        ),
      ),
    );
  }
}
