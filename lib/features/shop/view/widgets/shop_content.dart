import 'package:drip_talk/features/shop/domain/shop_bloc.dart';
import 'package:drip_talk/features/shop/domain/shop_event.dart';
import 'package:drip_talk/features/shop/domain/shop_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'shop_ai_curated_section.dart';
import 'shop_category_filter.dart';
import 'shop_pagination_section.dart';
import 'shop_product_section.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class ShopContent extends StatelessWidget {
  const ShopContent({super.key});

  Future<void> _onRefresh(BuildContext context) async {
    final bloc = context.read<ShopBloc>();
    final refreshCompleted = bloc.stream.firstWhere(
      (state) =>
          state.status != ShopStatus.loading &&
          state.collectionsStatus != ShopCollectionsStatus.loading &&
          !state.isRefreshing &&
          !state.isCollectionsRefreshing,
    );

    bloc.add(const RefreshShopData());
    await refreshCompleted;
  }

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

        return RefreshIndicator(
          color: AppColors.secondary,
          backgroundColor: AppColors.darkBg,
          onRefresh: () => _onRefresh(context),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              const SliverToBoxAdapter(
                child: AppGap(AppSizes.s16, axis: Axis.vertical),
              ),
              SliverToBoxAdapter(
                child: ShopAiCuratedSection(
                  horizontalPadding: horizontalPadding,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: const ShopCategoryFilter(),
                ),
              ),
              const SliverToBoxAdapter(
                child: AppGap(AppSizes.s16, axis: Axis.vertical),
              ),
              ShopProductSection(
                contentWidth: width,
                horizontalPadding: horizontalPadding,
              ),
              const SliverToBoxAdapter(
                child: AppGap(AppSizes.s32, axis: Axis.vertical),
              ),
              const SliverToBoxAdapter(
                child: Center(child: ShopPaginationSection()),
              ),
              const SliverToBoxAdapter(
                child: AppGap(AppSizes.s100, axis: Axis.vertical),
              ),
            ],
          ),
        );
      },
    );
  }
}
