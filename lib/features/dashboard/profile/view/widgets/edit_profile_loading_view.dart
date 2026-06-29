import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class EditProfileLoadingView extends StatelessWidget {
  const EditProfileLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.s20,
          AppSizes.s12,
          AppSizes.s20,
          AppSizes.s24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SkeletonHeader(),
            const AppGap(AppSizes.s24),
            Center(
              child: Column(
                children: [
                  Container(
                    width: AppSizes.s128,
                    height: AppSizes.s128,
                    decoration: BoxDecoration(
                      color: AppColors.materialGrey400,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const AppGap(AppSizes.s12),
                  Container(
                    width: 220,
                    height: AppSizes.s16,
                    decoration: BoxDecoration(
                      color: AppColors.materialGrey400,
                      borderRadius: BorderRadius.circular(AppRadius.circular),
                    ),
                  ),
                ],
              ),
            ),
            const AppGap(AppSizes.s28),
            const _SectionSkeleton(),
            const AppGap(AppSizes.s16),
            const _FieldSkeleton(),
            const AppGap(AppSizes.s16),
            const _FieldSkeleton(),
            const AppGap(AppSizes.s6),
            Container(
              width: 160,
              height: AppSizes.s12,
              decoration: BoxDecoration(
                color: AppColors.materialGrey400,
                borderRadius: BorderRadius.circular(AppRadius.circular),
              ),
            ),
            const AppGap(AppSizes.s16),
            const _FieldSkeleton(),
            const AppGap(AppSizes.s16),
            const _FieldSkeleton(),
            const AppGap(AppSizes.s16),
            const _FieldSkeleton(),
            const AppGap(AppSizes.s28),
            const _SectionSkeleton(),
            const AppGap(AppSizes.s16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.s18),
              decoration: BoxDecoration(
                color: AppColors.lightBg.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(AppRadius.r24),
                border: Border.all(color: AppColors.materialGrey400),
              ),
              child: const Column(
                children: [
                  _InfoRowSkeleton(),
                  AppGap(AppSizes.s12),
                  _InfoRowSkeleton(),
                  AppGap(AppSizes.s12),
                  _InfoRowSkeleton(),
                  AppGap(AppSizes.s12),
                  _InfoRowSkeleton(),
                ],
              ),
            ),
            const AppGap(AppSizes.s14),
            const _ButtonSkeleton(),
            const AppGap(AppSizes.s28),
            const _SectionSkeleton(),
            const AppGap(AppSizes.s16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.s16),
              decoration: BoxDecoration(
                color: AppColors.lightBg.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(AppRadius.r24),
                border: Border.all(color: AppColors.materialGrey400),
              ),
              child: const Column(
                children: [
                  _TileSkeleton(),
                  AppGap(AppSizes.s12),
                  _TileSkeleton(),
                  AppGap(AppSizes.s12),
                  _TileSkeleton(),
                ],
              ),
            ),
            const AppGap(AppSizes.s28),
            const _ButtonSkeleton(),
          ],
        ),
      ),
    );
  }
}

class _SkeletonHeader extends StatelessWidget {
  const _SkeletonHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSizes.s40,
          height: AppSizes.s40,
          decoration: BoxDecoration(
            color: AppColors.materialGrey400,
            borderRadius: BorderRadius.circular(AppRadius.r12),
          ),
        ),
        const AppGap(AppSizes.s12, axis: Axis.horizontal),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 140,
                height: AppSizes.s18,
                decoration: BoxDecoration(
                  color: AppColors.materialGrey400,
                  borderRadius: BorderRadius.circular(AppRadius.circular),
                ),
              ),
              const AppGap(AppSizes.s8),
              Container(
                width: 190,
                height: AppSizes.s12,
                decoration: BoxDecoration(
                  color: AppColors.materialGrey400,
                  borderRadius: BorderRadius.circular(AppRadius.circular),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionSkeleton extends StatelessWidget {
  const _SectionSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: AppSizes.s18,
      decoration: BoxDecoration(
        color: AppColors.materialGrey400,
        borderRadius: BorderRadius.circular(AppRadius.circular),
      ),
    );
  }
}

class _FieldSkeleton extends StatelessWidget {
  const _FieldSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 130,
          height: AppSizes.s14,
          decoration: BoxDecoration(
            color: AppColors.materialGrey400,
            borderRadius: BorderRadius.circular(AppRadius.circular),
          ),
        ),
        const AppGap(AppSizes.s8),
        Container(
          width: double.infinity,
          height: AppSizes.s50,
          decoration: BoxDecoration(
            color: AppColors.materialGrey400,
            borderRadius: BorderRadius.circular(AppRadius.r24),
          ),
        ),
      ],
    );
  }
}

class _InfoRowSkeleton extends StatelessWidget {
  const _InfoRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 80,
          height: AppSizes.s14,
          decoration: BoxDecoration(
            color: AppColors.materialGrey400,
            borderRadius: BorderRadius.circular(AppRadius.circular),
          ),
        ),
        const Spacer(),
        Container(
          width: 120,
          height: AppSizes.s14,
          decoration: BoxDecoration(
            color: AppColors.materialGrey400,
            borderRadius: BorderRadius.circular(AppRadius.circular),
          ),
        ),
      ],
    );
  }
}

class _TileSkeleton extends StatelessWidget {
  const _TileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppSizes.s48,
      decoration: BoxDecoration(
        color: AppColors.materialGrey400,
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
    );
  }
}

class _ButtonSkeleton extends StatelessWidget {
  const _ButtonSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppSizes.s56,
      decoration: BoxDecoration(
        color: AppColors.materialGrey400,
        borderRadius: BorderRadius.circular(AppRadius.circular),
      ),
    );
  }
}
