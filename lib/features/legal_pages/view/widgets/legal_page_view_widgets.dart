part of '../legal_page_view.dart';

class _LegalPageSectionsGrid extends StatelessWidget {
  const _LegalPageSectionsGrid({
    required this.sections,
    required this.contentWidth,
    required this.sectionGap,
    required this.titleFallback,
  });

  final List<LegalPageSection> sections;
  final double contentWidth;
  final double sectionGap;
  final String titleFallback;

  @override
  Widget build(BuildContext context) {
    final isWideLayout = contentWidth >= 860;
    final cardWidth = isWideLayout
        ? (contentWidth - sectionGap) / 2
        : contentWidth;

    return Wrap(
      spacing: isWideLayout ? sectionGap : 0,
      runSpacing: AppSizes.s16,
      children: sections.map((section) {
        final resolvedTitle = section.title?.trim().isNotEmpty == true
            ? section.title!.trim()
            : titleFallback;
        final resolvedContent = section.htmlContent?.trim() ?? '';

        return SizedBox(
          width: cardWidth,
          child: LegalPageSectionCard(
            title: resolvedTitle,
            iconName: section.resolvedIconName,
            htmlContent: resolvedContent,
          ),
        );
      }).toList(),
    );
  }
}

class _LegalPageLoadingState extends StatelessWidget {
  const _LegalPageLoadingState({
    required this.isWideLayout,
    required this.contentWidth,
    required this.sectionGap,
  });

  final bool isWideLayout;
  final double contentWidth;
  final double sectionGap;

  @override
  Widget build(BuildContext context) {
    final cardWidth = isWideLayout
        ? (contentWidth - sectionGap) / 2
        : contentWidth;

    return Shimmer.fromColors(
      baseColor: AppColors.lightBg.withValues(alpha: 0.88),
      highlightColor: AppColors.primary.withValues(alpha: 0.28),
      child: Wrap(
        spacing: isWideLayout ? sectionGap : 0,
        runSpacing: AppSizes.s16,
        children: [
          SizedBox(
            width: cardWidth,
            child: const _LegalPageLoadingCard(height: 144),
          ),
          SizedBox(
            width: cardWidth,
            child: const _LegalPageLoadingCard(height: 164),
          ),
          SizedBox(
            width: cardWidth,
            child: const _LegalPageLoadingCard(height: 152),
          ),
        ],
      ),
    );
  }
}

class _LegalPageLoadingCard extends StatelessWidget {
  const _LegalPageLoadingCard({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(AppRadius.r24),
      ),
    );
  }
}

class _LegalPageMessageCard extends StatelessWidget {
  const _LegalPageMessageCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.s18),
      decoration: BoxDecoration(
        color: AppColors.sectionCardBackground,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.7)),
      ),
      child: AppText(
        text: message,
        textAlign: TextAlign.center,
        style: AppTextStyles.ts14(
          context,
          color: AppColors.pureWhite.withValues(alpha: 0.92),
        ).copyWith(height: 1.45),
      ),
    );
  }
}
