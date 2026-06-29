import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';

class ProfileAvatarShimmer extends StatelessWidget {
  const ProfileAvatarShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.pureWhite.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
