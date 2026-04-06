import 'responsive_barrels.dart';

class MobileHomeView extends StatelessWidget {
  const MobileHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadHomeData()),
      child: const _HomeViewContent(),
    );
  }
}

class _HomeViewContent extends StatelessWidget {
  const _HomeViewContent();

  static const List<Map<String, String>> _categories = [
    {'icon': Assets.iconsAiPicks, 'label': 'Ai Picks'},
    {'icon': Assets.iconsTrending, 'label': 'Trending'},
    {'icon': Assets.iconsStreetWear, 'label': 'Streetwear'},
    {'icon': Assets.iconsLuxury, 'label': 'Luxury'},
    {'icon': Assets.iconsCasual, 'label': 'Casual'},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Column(
          children: [
            const AppGap(AppSizes.s16, axis: Axis.vertical),
            SizedBox(
              height: AppSizes.s100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.s16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final isSelected = state.selectedCategoryIndex == index;
                  return GestureDetector(
                    onTap: () {
                      context.read<HomeBloc>().add(SelectCategory(index));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: AppSizes.s20),
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
                                : [Colors.white24, Colors.white24],
                            child: SvgPicture.asset(
                              _categories[index]['icon']!,
                              height: AppSizes.s24,
                              width: AppSizes.s24,
                            ),
                          ),
                          const AppGap(AppSizes.s8, axis: Axis.vertical),
                          AppText(
                            text: _categories[index]['label']!,
                            style: AppTextStyles.ts12(
                              context,
                              color: isSelected ? Colors.white : Colors.white70,
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
                  ? _buildShimmerGrid()
                  : _buildDataGrid(state.gridData),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDataGrid(List<Map<String, dynamic>> data) {
    List<Widget> leftColumnItems = [];
    List<Widget> rightColumnItems = [];

    for (int i = 0; i < data.length; i++) {
      final item = Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.s16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.s24),
          child: Image.network(
            data[i]['image'],
            height: data[i]['height'],
            width: AppSizes.fitWidth,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: data[i]['height'],
                color: Colors.white12,
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );
            },
          ),
        ),
      );

      if (i % 2 == 0) {
        leftColumnItems.add(item);
      } else {
        rightColumnItems.add(item);
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.s16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Column(children: leftColumnItems)),
          const AppGap(AppSizes.s16, axis: Axis.horizontal),
          Expanded(child: Column(children: rightColumnItems)),
        ],
      ),
    );
  }

  Widget _buildShimmerGrid() {
    final dummyHeights = [240.0, 180.0, 300.0, 220.0, 200.0, 260.0];
    List<Widget> leftColumnItems = [];
    List<Widget> rightColumnItems = [];

    for (int i = 0; i < dummyHeights.length; i++) {
      final item = Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.s16),
        child: Shimmer.fromColors(
          baseColor: Colors.white12,
          highlightColor: Colors.white24,
          child: Container(
            height: dummyHeights[i],
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(AppSizes.s24),
            ),
          ),
        ),
      );

      if (i % 2 == 0) {
        leftColumnItems.add(item);
      } else {
        rightColumnItems.add(item);
      }
    }

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.s16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Column(children: leftColumnItems)),
          const AppGap(AppSizes.s16, axis: Axis.horizontal),
          Expanded(child: Column(children: rightColumnItems)),
        ],
      ),
    );
  }
}
