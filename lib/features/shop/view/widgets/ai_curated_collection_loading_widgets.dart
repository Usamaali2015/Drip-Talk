import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class AiCuratedCollectionImagePlaceholder extends StatelessWidget {
  const AiCuratedCollectionImagePlaceholder({
    super.key,
    this.showIcon = true,
    this.iconSize = AppSizes.s40,
  });

  final bool showIcon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: DecoratedBox(
          decoration: const BoxDecoration(color: AppColors.lightBg),
          child: showIcon
              ? Center(
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.pureWhite.withValues(alpha: 0.74),
                    size: iconSize,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class AiCuratedCollectionListSkeletonCard extends StatelessWidget {
  const AiCuratedCollectionListSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.s150,
      margin: const EdgeInsets.only(right: AppSizes.s12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.r12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(color: AppColors.lightBg),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.transparent,
                    AppColors.pureBlack.withValues(alpha: 0.12),
                    AppColors.pureBlack.withValues(alpha: 0.38),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.s12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  _SkeletonBar(
                    width: AppSizes.s100,
                    height: AppSizes.s14,
                    borderRadius: AppRadius.r8,
                  ),
                  const AppGap(AppSizes.s6),
                  _SkeletonBar(
                    width: AppSizes.s64,
                    height: AppSizes.s10,
                    borderRadius: AppRadius.r8,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AiCuratedCollectionGridSkeletonCard extends StatelessWidget {
  const AiCuratedCollectionGridSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBg,
        borderRadius: BorderRadius.circular(AppRadius.r24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.r24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(color: AppColors.lightBg),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.pureBlack.withValues(alpha: 0.04),
                    AppColors.pureBlack.withValues(alpha: 0.14),
                    AppColors.pureBlack.withValues(alpha: 0.42),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.s14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SkeletonCircle(size: AppSizes.s36),
                  const Spacer(),
                  _SkeletonBar(
                    width: AppSizes.s120,
                    height: AppSizes.s14,
                    borderRadius: AppRadius.r8,
                  ),
                  const AppGap(AppSizes.s6),
                  _SkeletonBar(
                    width: AppSizes.s80,
                    height: AppSizes.s14,
                    borderRadius: AppRadius.r8,
                  ),
                  const AppGap(AppSizes.s10),
                  _SkeletonBar(
                    width: AppSizes.s80,
                    height: AppSizes.s28,
                    borderRadius: AppRadius.circular,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonBar extends StatelessWidget {
  const _SkeletonBar({
    required this.width,
    required this.height,
    required this.borderRadius,
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
        color: AppColors.pureWhite.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class _SkeletonCircle extends StatelessWidget {
  const _SkeletonCircle({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.pureWhite.withValues(alpha: 0.18),
        shape: BoxShape.circle,
      ),
    );
  }
}
