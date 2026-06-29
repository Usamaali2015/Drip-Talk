import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class AddressLoadingList extends StatelessWidget {
  const AddressLoadingList({super.key, this.itemCount = 2});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (index) => Padding(
          padding: EdgeInsets.only(
            bottom: index == itemCount - 1 ? 0 : AppSizes.s14,
          ),
          child: Shimmer.fromColors(
            baseColor: AppColors.shimmerBase,
            highlightColor: AppColors.shimmerHighlight,
            child: Container(
              padding: const EdgeInsets.all(1.2),
              decoration: BoxDecoration(
                color: AppColors.materialGrey400,
                borderRadius: BorderRadius.circular(AppRadius.r24),
              ),
              child: Container(
                padding: const EdgeInsets.all(AppSizes.s16),
                decoration: BoxDecoration(
                  color: AppColors.lightBg,
                  borderRadius: BorderRadius.circular(AppRadius.r24),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _SkeletonBox(width: 60, height: 24),
                        AppGap(AppSizes.s8, axis: Axis.horizontal),
                        _SkeletonBox(width: 68, height: 24),
                      ],
                    ),
                    AppGap(AppSizes.s16),
                    _SkeletonBox(width: double.infinity, height: 14),
                    AppGap(AppSizes.s8),
                    _SkeletonBox(width: 170, height: 14),
                    AppGap(AppSizes.s8),
                    _SkeletonBox(width: 150, height: 14),
                    AppGap(AppSizes.s8),
                    _SkeletonBox(width: 130, height: 14),
                    AppGap(AppSizes.s16),
                    _SkeletonBox(width: 150, height: 14),
                    AppGap(AppSizes.s18),
                    Row(
                      children: [
                        Expanded(
                          child: _SkeletonBox(
                            width: double.infinity,
                            height: 44,
                          ),
                        ),
                        AppGap(AppSizes.s12, axis: Axis.horizontal),
                        Expanded(
                          child: _SkeletonBox(
                            width: double.infinity,
                            height: 44,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.materialGrey400,
        borderRadius: BorderRadius.circular(AppRadius.circular),
      ),
    );
  }
}
