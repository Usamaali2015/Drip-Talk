import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';

class WishlistLoadingGrid extends StatelessWidget {
  const WishlistLoadingGrid({
    super.key,
    this.itemCount = 6,
    this.columns = 2,
  });

  final int itemCount;
  final int columns;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            0,
            AppSizes.s8,
            0,
            AppSizes.s32,
          ),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Shimmer.fromColors(
                baseColor: AppColors.shimmerBase,
                highlightColor: AppColors.shimmerHighlight,
                child: Container(
                  margin: AppPadding.horizontalExtraSmall,
                  decoration: BoxDecoration(
                    color: AppColors.lightBg,
                    borderRadius: BorderRadius.circular(AppRadius.r20),
                  ),
                ),
              ),
              childCount: itemCount,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 0,
              mainAxisSpacing: AppSizes.s18,
              childAspectRatio: columns >= 4
                  ? 0.84
                  : columns == 3
                  ? 0.8
                  : 0.78,
            ),
          ),
        ),
      ],
    );
  }
}
