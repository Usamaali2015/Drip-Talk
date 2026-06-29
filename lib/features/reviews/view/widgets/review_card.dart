import 'package:drip_talk/features/reviews/data/models/my_review_model.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.review,
    required this.onWritePressed,
    required this.onEditPressed,
    required this.onDeletePressed,
    this.isUpdating = false,
    this.isDeleting = false,
  });

  final MyReviewItemData review;
  final VoidCallback? onWritePressed;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;
  final bool isUpdating;
  final bool isDeleting;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final actionSection = review.hasReviewContent
        ? Row(
            children: [
              Expanded(
                child: AppButton(
                  text: l10n.editAction,
                  onPressed: isUpdating ? null : onEditPressed,
                  isLoading: isUpdating,
                  height: AppSizes.s40,
                  borderRadius: AppRadius.r10,
                  gradientColors: const [
                    AppColors.secondary,
                    AppColors.primary,
                  ],
                  fontSize: AppSizes.s14,
                  leadingIcon: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.pureWhite,
                    size: AppSizes.s16,
                  ),
                ),
              ),
              const AppGap(AppSizes.s10, axis: Axis.horizontal),
              Expanded(
                child: AppButton(
                  text: l10n.deleteAction,
                  onPressed: isDeleting ? null : onDeletePressed,
                  isLoading: isDeleting,
                  height: AppSizes.s40,
                  borderRadius: AppRadius.r10,
                  backgroundColor: AppColors.lightBg,
                  borderColor: AppColors.secondary,
                  textColor: AppColors.secondary,
                  fontSize: AppSizes.s14,
                  leadingIcon: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.secondary,
                    size: AppSizes.s16,
                  ),
                ),
              ),
            ],
          )
        : onWritePressed == null
        ? const SizedBox.shrink()
        : AppButton(
            text: l10n.reviewsWriteAction,
            onPressed: onWritePressed,
            height: AppSizes.s48,
            borderRadius: AppRadius.r16,
            gradientColors: const [AppColors.secondary, AppColors.primary],
            fontSize: AppSizes.s14,
            leadingIcon: const Icon(
              Icons.star_rounded,
              color: AppColors.pureWhite,
              size: AppSizes.s16,
            ),
          );

    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(1.2),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.secondary, AppColors.cyan, AppColors.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.r20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.18),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.s12),
          decoration: BoxDecoration(
            color: AppColors.lightBg,
            borderRadius: BorderRadius.circular(AppRadius.r20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.r12),
                    child:
                        review.productImageUrl != null &&
                            review.productImageUrl!.trim().isNotEmpty
                        ? AppCachedNetworkImage(
                            imageUrl: review.productImageUrl!,
                            width: AppSizes.s50,
                            height: AppSizes.s50,
                          )
                        : Container(
                            width: AppSizes.s50,
                            height: AppSizes.s50,
                            color: AppColors.pureWhite.withValues(alpha: 0.08),
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
                          variant: AppTextVariant.ts18,
                          fontWeight: FontWeight.w700,
                          textColor: AppColors.pureWhite,
                          maxLines: 2,
                        ),
                        const AppGap(AppSizes.s2),
                        AppText(
                          text: _formatDate(review.createdAt, l10n),
                          variant: AppTextVariant.ts12,
                          textColor: AppColors.pureWhite.withValues(alpha: 0.7),
                        ),
                        const AppGap(AppSizes.s8),
                        review.hasReviewContent
                            ? _RatingRow(rating: review.rating ?? 0)
                            : _PendingBadge(),
                      ],
                    ),
                  ),
                ],
              ),
              const AppGap(AppSizes.s14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.s12),
                decoration: BoxDecoration(
                  color: AppColors.reviewTagBackground,
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                ),
                child: AppText(
                  text: review.hasReviewContent
                      ? review.reviewText?.trim().isNotEmpty == true
                            ? review.reviewText!.trim()
                            : l10n.reviewsFallbackComment
                      : l10n.reviewsPromptComment,
                  variant: AppTextVariant.ts14,
                  textColor: AppColors.pureWhite.withValues(alpha: 0.88),
                  maxLines: review.hasReviewContent ? 4 : 2,
                ),
              ),
              const AppGap(AppSizes.s14),
              actionSection,
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          index < rating ? Icons.star_rounded : Icons.star_border_rounded,
          size: AppSizes.s18,
          color: AppColors.starGold,
        ),
      ),
    );
  }
}

class _PendingBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s10,
        vertical: AppSizes.s6,
      ),
      decoration: BoxDecoration(
        color: AppColors.ratingBackground,
        borderRadius: BorderRadius.circular(AppRadius.circular),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.schedule_rounded,
            size: AppSizes.s14,
            color: AppColors.starGold,
          ),
          const AppGap(AppSizes.s6, axis: Axis.horizontal),
          AppText(
            text: AppLocalizations.of(context)!.reviewsPendingLabel,
            variant: AppTextVariant.ts10,
            textColor: AppColors.starGold,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime? date, AppLocalizations l10n) {
  if (date == null) {
    return l10n.reviewsRecentlyLabel;
  }

  return DateFormat('MMMM dd, yyyy').format(date);
}
