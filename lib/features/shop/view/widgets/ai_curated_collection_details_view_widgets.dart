part of '../ai_curated_collection_details_view.dart';

class _AiCuratedCollectionDetailsLoadingView extends StatelessWidget {
  const _AiCuratedCollectionDetailsLoadingView();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final horizontalPadding = width >= 960
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
              AppSizes.s20,
              horizontalPadding,
              AppSizes.s120,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: AppSizes.s48,
                      height: AppSizes.s48,
                      decoration: BoxDecoration(
                        color: AppColors.pureBlack,
                        borderRadius: BorderRadius.circular(AppSizes.s14),
                      ),
                    ),
                    const SizedBox(width: AppSizes.s12),
                    Container(
                      width: AppSizes.s160,
                      height: AppSizes.s18,
                      decoration: BoxDecoration(
                        color: AppColors.pureBlack,
                        borderRadius: BorderRadius.circular(AppSizes.s12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.s20),
                Container(
                  height: AppSizes.s55,
                  decoration: BoxDecoration(
                    color: AppColors.pureBlack,
                    borderRadius: BorderRadius.circular(AppSizes.s24),
                  ),
                ),
                const SizedBox(height: AppSizes.s20),
                Container(
                  height: AppSizes.s200,
                  decoration: BoxDecoration(
                    color: AppColors.pureBlack,
                    borderRadius: BorderRadius.circular(AppSizes.s28),
                  ),
                ),
                const SizedBox(height: AppSizes.s20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: columns * 2,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: AppSizes.s14,
                    mainAxisSpacing: AppSizes.s16,
                    childAspectRatio: columns >= 4
                        ? 0.84
                        : columns == 3
                        ? 0.8
                        : 0.7,
                  ),
                  itemBuilder: (context, index) => Container(
                    decoration: BoxDecoration(
                      color: AppColors.pureBlack,
                      borderRadius: BorderRadius.circular(AppSizes.s24),
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
