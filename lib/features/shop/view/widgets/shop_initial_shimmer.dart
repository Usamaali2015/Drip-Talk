import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class ShopInitialShimmer extends StatelessWidget {
  const ShopInitialShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final horizontalPadding = width >= 940
            ? 32.0
            : width >= 720
            ? 24.0
            : 16.0;
        final columns = width >= 1040
            ? 4
            : width >= 720
            ? 3
            : 2;

        return Shimmer.fromColors(
          baseColor: AppColors.shimmerBase,
          highlightColor: AppColors.shimmerHighlight,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              horizontalPadding,
              horizontalPadding,
              AppSizes.s100,
            ),
            child: Column(
              children: [
                Container(
                  height: AppSizes.s56,
                  width: AppSizes.fitWidth,
                  decoration: BoxDecoration(
                    color: AppColors.pureBlack,
                    borderRadius: BorderRadius.circular(AppRadius.r12),
                  ),
                ),
                const AppGap(AppSizes.s20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: columns * 2,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: columns >= 4
                        ? 0.78
                        : columns == 3
                        ? 0.72
                        : 0.6,
                  ),
                  itemBuilder: (_, _) => Container(
                    decoration: BoxDecoration(
                      color: AppColors.pureBlack,
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
