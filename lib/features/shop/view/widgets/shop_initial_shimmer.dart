import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_padding.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShopInitialShimmer extends StatelessWidget {
  const ShopInitialShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primary.withValues(alpha: 0.1),
      highlightColor: AppColors.secondary.withValues(alpha: 0.2),
      child: SingleChildScrollView(
        padding: AppPadding.allMedium,
        child: Column(
          children: [
            Container(
              height: AppSizes.s56,
              width: AppSizes.fitWidth,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(AppRadius.r12),
              ),
            ),
            const AppGap(AppSizes.s20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.6,
              ),
              itemBuilder: (_, _) => Container(
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(AppRadius.r16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
