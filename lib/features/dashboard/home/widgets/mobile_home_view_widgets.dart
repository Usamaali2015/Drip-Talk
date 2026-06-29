part of '../mobile_home_view.dart';

class _HomeViewContent extends StatelessWidget {
  const _HomeViewContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final horizontalPadding = context.responsive(
      AppSizes.s16.toDouble(),
      tablet: AppSizes.s24.toDouble(),
      tabletLarge: 28.0,
      desktop: AppSizes.s32.toDouble(),
    );
    final categorySpacing = context.responsive(
      20.0,
      tablet: 24.0,
      desktop: 28.0,
    );
    final columnGap = context.responsive(16.0, tablet: 20.0, desktop: 24.0);
    final columns = context.responsive(2, tablet: 3, tabletLarge: 3, desktop: 4);
    final categories = [
      {'icon': Assets.iconsAiPicks, 'label': l10n.homeCategoryAiPicks},
      {'icon': Assets.iconsTrending, 'label': l10n.homeCategoryTrending},
      {'icon': Assets.iconsStreetWear, 'label': l10n.homeCategoryStreetwear},
      {'icon': Assets.iconsLuxury, 'label': l10n.homeCategoryLuxury},
      {'icon': Assets.iconsCasual, 'label': l10n.homeCategoryCasual},
    ];

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Column(
          children: [
            const AppGap(AppSizes.s16, axis: Axis.vertical),
            SizedBox(
              height: AppSizes.s100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final isSelected = state.selectedCategoryIndex == index;
                  return GestureDetector(
                    onTap: () {
                      context.read<HomeBloc>().add(SelectCategory(index));
                    },
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(end: categorySpacing),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GradientBorder(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            enableShadow: false,
                            backgroundColor: AppColors.darkBg,
                            borderWidth: 2,
                            shape: BoxShape.circle,
                            padding: AppPadding.allMedium,
                            colors: isSelected
                                ? [
                                    AppColors.primary,
                                    AppColors.cyan,
                                    AppColors.secondary,
                                  ]
                                : [
                                    AppColors.pureWhite24,
                                    AppColors.pureWhite24,
                                  ],
                            child: SvgPicture.asset(
                              categories[index]['icon']!,
                              height: AppSizes.s24,
                              width: AppSizes.s24,
                            ),
                          ),
                          const AppGap(AppSizes.s8, axis: Axis.vertical),
                          AppText(
                            text: categories[index]['label']!,
                            style: AppTextStyles.ts12(
                              context,
                              color: isSelected
                                  ? AppColors.pureWhite
                                  : AppColors.pureWhite70,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const AppGap(AppSizes.s10, axis: Axis.vertical),
            Expanded(
              child: state.status == HomeStatus.loading
                  ? _buildShimmerGrid(
                      columns: columns,
                      horizontalPadding: horizontalPadding,
                      columnGap: columnGap,
                    )
                  : _buildDataGrid(
                      data: state.gridData,
                      columns: columns,
                      horizontalPadding: horizontalPadding,
                      columnGap: columnGap,
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDataGrid({
    required List<Map<String, dynamic>> data,
    required int columns,
    required double horizontalPadding,
    required double columnGap,
  }) {
    final columnItems = List.generate(columns, (_) => <Widget>[]);

    for (int i = 0; i < data.length; i++) {
      columnItems[i % columns].add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.s16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.s24),
            child: AppCachedNetworkImage(
              imageUrl: data[i]['image'] as String,
              height: data[i]['height'] as double,
              fit: BoxFit.cover,
              placeholder: Container(
                height: data[i]['height'] as double,
                color: AppColors.pureWhite12,
              ),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int column = 0; column < columns; column++) ...[
            if (column > 0) AppGap(columnGap, axis: Axis.horizontal),
            Expanded(child: Column(children: columnItems[column])),
          ],
        ],
      ),
    );
  }

  Widget _buildShimmerGrid({
    required int columns,
    required double horizontalPadding,
    required double columnGap,
  }) {
    final dummyHeights = List<double>.generate(
      columns * 3,
      (index) => [240.0, 180.0, 300.0, 220.0, 200.0, 260.0][index % 6],
    );
    final columnItems = List.generate(columns, (_) => <Widget>[]);

    for (int i = 0; i < dummyHeights.length; i++) {
      columnItems[i % columns].add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.s16),
          child: Shimmer.fromColors(
            baseColor: AppColors.shimmerBase,
            highlightColor: AppColors.shimmerHighlight,
            child: Container(
              height: dummyHeights[i],
              decoration: BoxDecoration(
                color: AppColors.pureBlack,
                borderRadius: BorderRadius.circular(AppSizes.s24),
              ),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int column = 0; column < columns; column++) ...[
            if (column > 0) AppGap(columnGap, axis: Axis.horizontal),
            Expanded(child: Column(children: columnItems[column])),
          ],
        ],
      ),
    );
  }
}
