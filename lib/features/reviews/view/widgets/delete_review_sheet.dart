import 'package:drip_talk/features/reviews/data/models/my_review_model.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class DeleteReviewSheet extends StatelessWidget {
  const DeleteReviewSheet({super.key, required this.review});

  final MyReviewItemData review;

  static Future<bool?> show(
    BuildContext context, {
    required MyReviewItemData review,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => DeleteReviewSheet(review: review),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.secondary, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.r30),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.s24,
          AppSizes.s18,
          AppSizes.s24,
          AppSizes.s24,
        ),
        decoration: const BoxDecoration(
          color: AppColors.lightBg,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.r30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 54,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.pureWhite.withValues(alpha: 0.24),
                  borderRadius: BorderRadius.circular(AppRadius.circular),
                ),
              ),
            ),
            const AppGap(AppSizes.s20),
            Center(
              child: Container(
                width: AppSizes.s56,
                height: AppSizes.s56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary.withValues(alpha: 0.16),
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.44),
                  ),
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.secondary,
                  size: AppSizes.s28,
                ),
              ),
            ),
            const AppGap(AppSizes.s18),
            Center(
              child: AppText(
                text: l10n.reviewsDeleteTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.ts22(
                  context,
                  color: AppColors.pureWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const AppGap(AppSizes.s8),
            Center(
              child: AppText(
                text: l10n.reviewsDeleteMessage,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: AppTextStyles.ts14(
                  context,
                  color: AppColors.pureWhite.withValues(alpha: 0.78),
                ),
              ),
            ),
            const AppGap(AppSizes.s20),
            _DeleteReviewProductCard(review: review),
            const AppGap(AppSizes.s24),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: l10n.cancel,
                    onPressed: () => context.pop(false),
                    height: 52,
                    borderRadius: AppRadius.r16,
                    backgroundColor: AppColors.lightBg.withValues(alpha: 0.82),
                    borderColor: AppColors.pureWhite.withValues(alpha: 0.16),
                    fontSize: 16,
                    textColor: AppColors.pureWhite,
                  ),
                ),
                const AppGap(AppSizes.s12, axis: Axis.horizontal),
                Expanded(
                  child: AppButton(
                    text: l10n.deleteAction,
                    onPressed: () => context.pop(true),
                    height: 52,
                    borderRadius: AppRadius.r16,
                    fontSize: 16,
                    gradientColors: const [
                      AppColors.secondary,
                      AppColors.primary,
                    ],
                    leadingIcon: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.pureWhite,
                      size: AppSizes.s18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DeleteReviewProductCard extends StatelessWidget {
  const _DeleteReviewProductCard({required this.review});

  final MyReviewItemData review;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(AppSizes.s12),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(
          color: AppColors.pureWhite.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            child:
                review.productImageUrl != null &&
                    review.productImageUrl!.trim().isNotEmpty
                ? AppCachedNetworkImage(
                    imageUrl: review.productImageUrl!,
                    width: AppSizes.s56,
                    height: AppSizes.s56,
                  )
                : Container(
                    width: AppSizes.s56,
                    height: AppSizes.s56,
                    color: AppColors.pureWhite.withValues(alpha: 0.08),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.image_outlined,
                      color: AppColors.pureWhite,
                    ),
                  ),
          ),
          const AppGap(AppSizes.s12, axis: Axis.horizontal),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: review.productName ?? l10n.productFallbackLabel,
                  variant: AppTextVariant.ts16,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.pureWhite,
                  maxLines: 2,
                ),
                if (review.reviewText?.trim().isNotEmpty == true) ...[
                  const AppGap(AppSizes.s6),
                  AppText(
                    text: review.reviewText!.trim(),
                    variant: AppTextVariant.ts12,
                    textColor: AppColors.pureWhite.withValues(alpha: 0.74),
                    maxLines: 2,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
