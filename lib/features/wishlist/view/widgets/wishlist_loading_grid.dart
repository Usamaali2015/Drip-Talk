import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_padding.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WishlistLoadingGrid extends StatelessWidget {
  const WishlistLoadingGrid({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.s20,
            AppSizes.s8,
            AppSizes.s20,
            AppSizes.s32,
          ),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Shimmer.fromColors(
                baseColor: AppColors.primary.withValues(alpha: 0.12),
                highlightColor: AppColors.secondary.withValues(alpha: 0.18),
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 0,
              mainAxisSpacing: AppSizes.s18,
              childAspectRatio: 0.78,
            ),
          ),
        ),
      ],
    );
  }
}
