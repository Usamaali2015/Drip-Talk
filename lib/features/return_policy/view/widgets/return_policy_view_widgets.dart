part of '../return_policy_view.dart';

class _ReturnPolicyHeadingCard extends StatelessWidget {
  const _ReturnPolicyHeadingCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return GradientBorder(
      enableShadow: false,
      borderWidth: 1,
      borderRadius: AppRadius.r20,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s20,
        vertical: AppSizes.s18,
      ),
      backgroundColor: AppColors.lightBg,
      colors: [
        AppColors.secondary.withValues(alpha: 0.88),
        AppColors.secondary.withValues(alpha: 0.88),
      ],
      child: Center(
        child: AppText(
          text: message,
          textAlign: TextAlign.center,
          maxLines: 3,
          style: AppTextStyles.ts18(
            context,
            color: AppColors.pureWhite,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ReturnPolicySectionHeading extends StatelessWidget {
  const _ReturnPolicySectionHeading({
    required this.title,
    required this.iconName,
  });

  final String title;
  final String? iconName;

  @override
  Widget build(BuildContext context) {
    final displayTitle = title.isEmpty ? '' : title;

    return Row(
      children: [
        ReturnPolicyBackendIcon(iconName: iconName, size: AppSizes.s14),
        const AppGap(AppSizes.s8, axis: Axis.horizontal),
        Expanded(
          child: AppText(
            text: displayTitle,
            style: AppTextStyles.ts20(
              context,
              color: AppColors.secondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReturnPolicyMessageCard extends StatelessWidget {
  const _ReturnPolicyMessageCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return GradientBorder(
      enableShadow: false,
      borderWidth: 1,
      borderRadius: AppRadius.r20,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s18,
        vertical: AppSizes.s18,
      ),
      backgroundColor: AppColors.lightBg,
      colors: [
        AppColors.secondary.withValues(alpha: 0.42),
        AppColors.secondary.withValues(alpha: 0.42),
      ],
      child: Center(
        child: AppText(
          text: message,
          textAlign: TextAlign.center,
          style: AppTextStyles.ts14(
            context,
            color: AppColors.pureWhite.withValues(alpha: 0.82),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ReturnPolicySectionsLayout extends StatelessWidget {
  const _ReturnPolicySectionsLayout({
    required this.sections,
    required this.contentWidth,
    required this.sectionGap,
  });

  final List<ReturnPolicySection> sections;
  final double contentWidth;
  final double sectionGap;

  @override
  Widget build(BuildContext context) {
    final isWideLayout = contentWidth >= 860;
    final cardWidth = isWideLayout
        ? (contentWidth - sectionGap) / 2
        : contentWidth;

    return Wrap(
      spacing: isWideLayout ? sectionGap : 0,
      runSpacing: AppSizes.s24,
      children: List.generate(sections.length, (index) {
        final section = sections[index];

        return SizedBox(
          width: cardWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((section.heading?.trim().isNotEmpty ?? false) ||
                  (section.icon?.trim().isNotEmpty ?? false)) ...[
                _ReturnPolicySectionHeading(
                  title: section.heading?.trim() ?? '',
                  iconName: section.icon,
                ),
                const AppGap(AppSizes.s14),
              ],
              if (section.items.isNotEmpty)
                ReturnPolicySectionCard(items: section.items),
            ],
          ),
        );
      }),
    );
  }
}

class _ReturnPolicyLoadingState extends StatelessWidget {
  const _ReturnPolicyLoadingState({
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
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 92,
            decoration: BoxDecoration(
              color: AppColors.pureBlack,
              borderRadius: BorderRadius.circular(AppRadius.r20),
            ),
          ),
          const AppGap(AppSizes.s24),
          Wrap(
            spacing: isWideLayout ? sectionGap : 0,
            runSpacing: AppSizes.s24,
            children: List.generate(2, (_) {
              return SizedBox(
                width: cardWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 190,
                      height: AppSizes.s20,
                      decoration: BoxDecoration(
                        color: AppColors.pureBlack,
                        borderRadius: BorderRadius.circular(AppRadius.r10),
                      ),
                    ),
                    const AppGap(AppSizes.s14),
                    Container(
                      width: double.infinity,
                      height: 176,
                      decoration: BoxDecoration(
                        color: AppColors.pureBlack,
                        borderRadius: BorderRadius.circular(AppRadius.r20),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const AppGap(AppSizes.s28),
          SizedBox(
            width: isWideLayout ? 280 : double.infinity,
            child: Container(
              height: AppSizes.s56,
              decoration: BoxDecoration(
                color: AppColors.pureBlack,
                borderRadius: BorderRadius.circular(AppRadius.r16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
