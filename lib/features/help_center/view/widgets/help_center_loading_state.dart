import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class HelpCenterLoadingState extends StatelessWidget {
  const HelpCenterLoadingState({
    super.key,
    required this.categoryColumns,
    required this.categoryAspectRatio,
  });

  final int categoryColumns;
  final double categoryAspectRatio;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 190,
            height: AppSizes.s24,
            decoration: BoxDecoration(
              color: AppColors.pureBlack,
              borderRadius: BorderRadius.circular(AppRadius.r10),
            ),
          ),
          const AppGap(AppSizes.s16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categoryColumns * 2,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: categoryColumns,
              mainAxisSpacing: AppSizes.s12,
              crossAxisSpacing: AppSizes.s12,
              childAspectRatio: categoryAspectRatio,
            ),
            itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(
                color: AppColors.pureBlack,
                borderRadius: BorderRadius.circular(AppRadius.r16),
              ),
            ),
          ),
          const AppGap(AppSizes.s28),
          Row(
            children: [
              Container(
                width: AppSizes.s16,
                height: AppSizes.s16,
                decoration: BoxDecoration(
                  color: AppColors.pureBlack,
                  borderRadius: BorderRadius.circular(AppRadius.r4),
                ),
              ),
              const AppGap(AppSizes.s8, axis: Axis.horizontal),
              Container(
                width: 180,
                height: AppSizes.s24,
                decoration: BoxDecoration(
                  color: AppColors.pureBlack,
                  borderRadius: BorderRadius.circular(AppRadius.r10),
                ),
              ),
            ],
          ),
          const AppGap(AppSizes.s12),
          ...List.generate(4, (index) => const _HelpCenterFaqShimmerTile()),
        ],
      ),
    );
  }
}

class _HelpCenterFaqShimmerTile extends StatelessWidget {
  const _HelpCenterFaqShimmerTile();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.s16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: AppSizes.s16,
                      decoration: BoxDecoration(
                        color: AppColors.pureBlack,
                        borderRadius: BorderRadius.circular(AppRadius.r8),
                      ),
                    ),
                    const AppGap(AppSizes.s8),
                    Container(
                      width: 170,
                      height: AppSizes.s16,
                      decoration: BoxDecoration(
                        color: AppColors.pureBlack,
                        borderRadius: BorderRadius.circular(AppRadius.r8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.s12),
              Container(
                width: AppSizes.s20,
                height: AppSizes.s20,
                decoration: BoxDecoration(
                  color: AppColors.pureBlack,
                  borderRadius: BorderRadius.circular(AppRadius.r10),
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: AppColors.pureWhite.withValues(alpha: 0.14),
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }
}
