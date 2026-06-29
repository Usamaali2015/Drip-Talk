import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class ReviewLoadingView extends StatelessWidget {
  const ReviewLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.s16,
          AppSizes.s16,
          AppSizes.s16,
          AppSizes.s24,
        ),
        itemCount: 4,
        separatorBuilder: (_, _) => const AppGap(AppSizes.s16),
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.all(1.2),
          decoration: BoxDecoration(
            color: AppColors.pureBlack,
            borderRadius: BorderRadius.circular(AppRadius.r20),
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
                  children: [
                    Container(
                      width: AppSizes.s50,
                      height: AppSizes.s50,
                      decoration: BoxDecoration(
                        color: AppColors.pureBlack,
                        borderRadius: BorderRadius.circular(AppRadius.r12),
                      ),
                    ),
                    const AppGap(AppSizes.s12, axis: Axis.horizontal),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: AppSizes.s18,
                            color: AppColors.pureBlack,
                          ),
                          const AppGap(AppSizes.s8),
                          Container(
                            width: AppSizes.s120,
                            height: AppSizes.s12,
                            color: AppColors.pureBlack,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const AppGap(AppSizes.s14),
                Container(
                  height: AppSizes.s80,
                  decoration: BoxDecoration(
                    color: AppColors.pureBlack,
                    borderRadius: BorderRadius.circular(AppRadius.r12),
                  ),
                ),
                const AppGap(AppSizes.s14),
                Row(
                  children: List.generate(
                    2,
                    (_) => Expanded(
                      child: Container(
                        height: AppSizes.s40,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: AppColors.pureBlack,
                          borderRadius: BorderRadius.circular(AppRadius.r16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
