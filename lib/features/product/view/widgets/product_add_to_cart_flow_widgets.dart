part of '../helpers/product_add_to_cart_flow.dart';

class _QuickAddStateSheet extends StatelessWidget {
  const _QuickAddStateSheet({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.92,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.productSheetBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
          border: Border(top: BorderSide(width: 4, color: AppColors.secondary)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 56,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 22),
                  decoration: BoxDecoration(
                    color: AppColors.pureWhite.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(AppRadius.circular),
                  ),
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.pureWhite.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.secondary),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.pureWhite,
                        size: 20,
                      ),
                    ),
                  ),
                  const AppGap(AppSizes.s14, axis: Axis.horizontal),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: AppLocalizations.of(context)!.productSizeGuide,
                          variant: AppTextVariant.ts18,
                          textColor: AppColors.pureWhite,
                          fontWeight: FontWeight.w700,
                        ),
                        const AppGap(2),
                        AppText(
                          text: AppLocalizations.of(
                            context,
                          )!.productSizeGuideSubtitle,
                          variant: AppTextVariant.ts14,
                          textColor: AppColors.pureWhite70,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(child: Center(child: child)),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAddSheetShimmer extends StatelessWidget {
  const _QuickAddSheetShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppGap(AppSizes.s24),
            _QuickAddSkeletonBox(
              height: 148,
              borderRadius: 22,
              width: double.infinity,
            ),
            const AppGap(AppSizes.s24),
            const _QuickAddSkeletonLine(width: 120, height: 20),
            const AppGap(AppSizes.s16),
            Wrap(
              spacing: AppSizes.s12,
              runSpacing: AppSizes.s12,
              children: List.generate(
                5,
                (_) => const _QuickAddSkeletonBox(
                  width: 64,
                  height: 46,
                  borderRadius: AppRadius.circular,
                ),
              ),
            ),
            const AppGap(AppSizes.s20),
            _QuickAddSkeletonBox(
              height: 214,
              borderRadius: 24,
              width: double.infinity,
            ),
            const AppGap(AppSizes.s24),
            _QuickAddSkeletonBox(
              height: 54,
              borderRadius: 28,
              width: double.infinity,
            ),
            const AppGap(AppSizes.s24),
          ],
        ),
      ),
    );
  }
}

class _QuickAddSkeletonBox extends StatelessWidget {
  const _QuickAddSkeletonBox({
    required this.height,
    required this.borderRadius,
    this.width = double.infinity,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class _QuickAddSkeletonLine extends StatelessWidget {
  const _QuickAddSkeletonLine({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return _QuickAddSkeletonBox(
      width: width,
      height: height,
      borderRadius: AppRadius.r12,
    );
  }
}
