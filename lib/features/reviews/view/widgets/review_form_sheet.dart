import 'package:drip_talk/features/reviews/data/models/my_review_model.dart';
import 'package:drip_talk/features/reviews/data/models/review_upsert_request_model.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

enum ReviewFormMode { create, edit }

class ReviewFormSheet extends StatefulWidget {
  const ReviewFormSheet({super.key, required this.review, required this.mode});

  final MyReviewItemData review;
  final ReviewFormMode mode;

  static Future<ReviewUpsertRequestModel?> show(
    BuildContext context, {
    required MyReviewItemData review,
    required ReviewFormMode mode,
  }) {
    return showModalBottomSheet<ReviewUpsertRequestModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      barrierColor: AppColors.pureBlack.withValues(alpha: 0.6),
      builder: (_) => ReviewFormSheet(review: review, mode: mode),
    );
  }

  @override
  State<ReviewFormSheet> createState() => _ReviewFormSheetState();
}

class _ReviewFormSheetState extends State<ReviewFormSheet> {
  late final TextEditingController _reviewController;
  late int _selectedRating;
  String? _ratingError;
  String? _reviewError;

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.review.rating ?? 0;
    _reviewController = TextEditingController(
      text: widget.review.reviewText ?? '',
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  bool get _isCreateMode => widget.mode == ReviewFormMode.create;

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    final normalizedReview = _reviewController.text.trim();
    setState(() {
      _ratingError = _selectedRating > 0 ? null : l10n.reviewsRatingRequired;
      _reviewError = normalizedReview.isNotEmpty
          ? null
          : l10n.reviewsTextRequired;
    });

    if (_ratingError != null || _reviewError != null) {
      return;
    }

    context.pop(
      ReviewUpsertRequestModel(
        productId: widget.review.productId,
        rating: _selectedRating,
        review: normalizedReview,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;
    final maxSheetHeight = mediaQuery.size.height * 0.9;

    return SafeArea(
      top: false,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: bottomInset),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxSheetHeight),
          child: Container(
            padding: const EdgeInsets.all(AppSizes.s20),
            decoration: const BoxDecoration(
              color: AppColors.pureWhite,
              border: Border(
                top: BorderSide(color: AppColors.secondary, width: 4),
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadius.r30),
              ),
            ),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          text: _isCreateMode
                              ? l10n.reviewsWriteTitle
                              : l10n.reviewsEditTitle,
                          variant: AppTextVariant.ts28,
                          fontWeight: FontWeight.w800,
                          textColor: AppColors.lightBg,
                        ),
                      ),
                      InkWell(
                        onTap: () => context.pop(),
                        borderRadius: BorderRadius.circular(AppRadius.circular),
                        child: Container(
                          width: AppSizes.s28,
                          height: AppSizes.s28,
                          decoration: const BoxDecoration(
                            color: AppColors.lightBg,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: AppColors.pureWhite,
                            size: AppSizes.s18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const AppGap(AppSizes.s20),
                  _ProductInfoCard(
                    review: widget.review,
                    subtitlePrefix: _isCreateMode
                        ? l10n.reviewsDeliveredPrefix
                        : l10n.reviewsReviewedPrefix,
                  ),
                  const AppGap(AppSizes.s14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.s16,
                      vertical: AppSizes.s18,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightBg,
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            5,
                            (index) => InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedRating = index + 1;
                                  _ratingError = null;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: Icon(
                                  index < _selectedRating
                                      ? Icons.star_rounded
                                      : Icons.star_border_rounded,
                                  color: index < _selectedRating
                                      ? AppColors.starGold
                                      : AppColors.pureWhite.withValues(
                                          alpha: 0.9,
                                        ),
                                  size: AppSizes.s36,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (_ratingError != null) ...[
                          const AppGap(AppSizes.s10),
                          AppText(
                            text: _ratingError!,
                            variant: AppTextVariant.ts12,
                            textColor: AppColors.secondary,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const AppGap(AppSizes.s14),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.roseSurface,
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                      border: Border.all(
                        color: AppColors.secondary,
                        width: 1.1,
                      ),
                    ),
                    child: TextField(
                      controller: _reviewController,
                      minLines: 4,
                      maxLines: 8,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      scrollPadding: const EdgeInsets.only(
                        bottom: AppSizes.s160,
                      ),
                      onChanged: (_) {
                        if (_reviewError == null) {
                          return;
                        }
                        setState(() => _reviewError = null);
                      },
                      style: AppTextStyles.ts14(
                        context,
                        color: AppColors.lightBg,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.reviewsInputHint,
                        hintStyle: AppTextStyles.ts14(
                          context,
                          color: AppColors.grey,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(AppSizes.s16),
                      ),
                    ),
                  ),
                  if (_reviewError != null) ...[
                    const AppGap(AppSizes.s8),
                    AppText(
                      text: _reviewError!,
                      variant: AppTextVariant.ts12,
                      textColor: AppColors.secondary,
                    ),
                  ],
                  const AppGap(AppSizes.s18),
                  AppButton(
                    text: _isCreateMode
                        ? l10n.reviewsSubmitAction
                        : l10n.reviewsUpdateAction,
                    onPressed: _submit,
                    height: AppSizes.s48,
                    borderRadius: AppRadius.r16,
                    gradientColors: const [
                      AppColors.secondary,
                      AppColors.primary,
                    ],
                    leadingIcon: const Icon(
                      Icons.near_me_rounded,
                      color: AppColors.pureWhite,
                      size: AppSizes.s18,
                    ),
                    fontSize: AppSizes.s16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductInfoCard extends StatelessWidget {
  const _ProductInfoCard({required this.review, required this.subtitlePrefix});

  final MyReviewItemData review;
  final String subtitlePrefix;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.s12),
      decoration: BoxDecoration(
        color: AppColors.lightBg,
        borderRadius: BorderRadius.circular(AppRadius.r16),
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
                    width: AppSizes.s48,
                    height: AppSizes.s48,
                  )
                : Container(
                    width: AppSizes.s48,
                    height: AppSizes.s48,
                    color: AppColors.pureWhite.withValues(alpha: 0.12),
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
                  text: (review.productName ?? l10n.productFallbackLabel)
                      .toUpperCase(),
                  variant: AppTextVariant.ts18,
                  fontWeight: FontWeight.w800,
                  textColor: AppColors.pureWhite,
                  maxLines: 2,
                ),
                const AppGap(AppSizes.s4),
                AppText(
                  text:
                      '$subtitlePrefix: ${_formatDate(review.createdAt, l10n)}',
                  variant: AppTextVariant.ts12,
                  textColor: AppColors.pureWhite.withValues(alpha: 0.78),
                ),
              ],
            ),
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

  return DateFormat('MMM d, yyyy').format(date);
}
