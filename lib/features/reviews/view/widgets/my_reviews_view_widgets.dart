part of '../my_reviews_view.dart';

class _ReviewsStats extends StatelessWidget {
  const _ReviewsStats({required this.summary});

  final ReviewSummaryData summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.s16),
      decoration: BoxDecoration(
        color: AppColors.reviewsPanelBackground,
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              value: summary.totalCount.toString().padLeft(2, '0'),
              label: AppLocalizations.of(context)!.reviewsStatTotal,
            ),
          ),
          Expanded(
            child: _StatItem(
              value: summary.averageRating == 0
                  ? '0.0'
                  : summary.averageRating.toStringAsFixed(1),
              label: AppLocalizations.of(context)!.reviewsStatAverage,
            ),
          ),
          Expanded(
            child: _StatItem(
              value: summary.pendingCount.toString().padLeft(2, '0'),
              label: AppLocalizations.of(context)!.reviewsStatPending,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(
          text: value,
          variant: AppTextVariant.ts24,
          textColor: AppColors.secondary,
          fontWeight: FontWeight.w800,
        ),
        const AppGap(AppSizes.s4),
        AppText(
          text: label,
          variant: AppTextVariant.ts10,
          textColor: AppColors.pureWhite.withValues(alpha: 0.72),
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}

class _ReviewFilterRow extends StatelessWidget {
  const _ReviewFilterRow({required this.activeFilter, required this.onChanged});

  final ReviewFilter activeFilter;
  final ValueChanged<ReviewFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filters = <(ReviewFilter, String)>[
      (ReviewFilter.all, l10n.reviewsFilterAll),
      (ReviewFilter.fiveStars, l10n.reviewsFilterFiveStars),
      (ReviewFilter.fourStars, l10n.reviewsFilterFourStars),
      (ReviewFilter.pending, l10n.reviewsFilterPending),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((entry) {
          final isActive = entry.$1 == activeFilter;
          return Padding(
            padding: const EdgeInsets.only(right: AppSizes.s10),
            child: InkWell(
              onTap: () => onChanged(entry.$1),
              borderRadius: BorderRadius.circular(AppRadius.circular),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.s16,
                  vertical: AppSizes.s10,
                ),
                decoration: BoxDecoration(
                  gradient: isActive
                      ? const LinearGradient(
                          colors: [AppColors.secondary, AppColors.primary],
                        )
                      : null,
                  color: isActive ? null : AppColors.lightBg,
                  borderRadius: BorderRadius.circular(AppRadius.circular),
                  border: Border.all(
                    color: isActive
                        ? AppColors.transparent
                        : AppColors.pureWhite.withValues(alpha: 0.1),
                  ),
                ),
                child: AppText(
                  text: entry.$2,
                  variant: AppTextVariant.ts12,
                  textColor: isActive
                      ? AppColors.pureWhite
                      : AppColors.pureWhite.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _EmptyReviewsState extends StatelessWidget {
  const _EmptyReviewsState({
    required this.hasFilter,
    required this.onResetFilter,
  });

  final bool hasFilter;
  final VoidCallback onResetFilter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.s20),
      decoration: BoxDecoration(
        color: AppColors.lightBg.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(AppRadius.r20),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.rate_review_outlined,
            color: AppColors.pureWhite70,
            size: AppSizes.s40,
          ),
          const AppGap(AppSizes.s12),
          AppText(
            text: hasFilter
                ? l10n.reviewsEmptyFilteredTitle
                : l10n.reviewsEmptyTitle,
            variant: AppTextVariant.ts18,
            textColor: AppColors.pureWhite,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
          ),
          const AppGap(AppSizes.s8),
          AppText(
            text: hasFilter
                ? l10n.reviewsEmptyFilteredSubtitle
                : l10n.reviewsEmptySubtitle,
            variant: AppTextVariant.ts14,
            textColor: AppColors.pureWhite.withValues(alpha: 0.72),
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
          if (hasFilter) ...[
            const AppGap(AppSizes.s16),
            AppButton(
              text: l10n.reviewsShowAllAction,
              onPressed: onResetFilter,
              height: AppSizes.s48,
              borderRadius: AppRadius.r16,
              gradientColors: const [AppColors.secondary, AppColors.primary],
              fontSize: AppSizes.s14,
            ),
          ],
        ],
      ),
    );
  }
}

class _ReviewsRefreshingIndicator extends StatelessWidget {
  const _ReviewsRefreshingIndicator();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.r12),
      child: const LinearProgressIndicator(
        minHeight: 4,
        backgroundColor: AppColors.reviewsPanelBackground,
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
      ),
    );
  }
}

class _ReviewsPaginationBar extends StatelessWidget {
  const _ReviewsPaginationBar({
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
  });

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkBg,
        border: const Border(
          top: BorderSide(color: AppColors.pureWhite12, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.s16),
          child: ShopPaginationControls(
            currentPage: currentPage,
            totalPages: totalPages,
            centerContent: true,
            onPageSelected: onPageSelected,
          ),
        ),
      ),
    );
  }
}
