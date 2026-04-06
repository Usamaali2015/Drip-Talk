import 'dart:async';

import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/common/widgets/app_action_icon.dart';
import 'package:drip_talk/core/common/widgets/app_asset_image.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_gradient_background.dart';
import 'package:drip_talk/core/common/widgets/app_gradient_border.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:drip_talk/core/services/get_it/service_locator.dart';
import 'package:drip_talk/core/utils/responsive/break_points.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/core/utils/routes/route_paths.dart';
import 'package:drip_talk/features/cart/view/widgets/cart_action_button.dart';
import 'package:drip_talk/features/shop/domain/shop_bloc.dart';
import 'package:drip_talk/features/shop/domain/shop_event.dart';
import 'package:drip_talk/features/shop/domain/shop_filters.dart';
import 'package:drip_talk/features/shop/domain/shop_state.dart';
import 'package:drip_talk/features/shop/view/widgets/filter_sheet/shop_filter_bottom_sheet.dart';
import 'package:drip_talk/generated/assets.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'widgets/dashboard_side_bar.dart';

class DashboardShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  final String currentLocation;

  const DashboardShell({
    super.key,
    required this.navigationShell,
    required this.currentLocation,
  });

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  late final ShopBloc _shopBloc;
  late final TextEditingController _shopSearchController;
  Timer? _searchDebounce;
  bool _didRequestInitialShopLoad = false;

  @override
  void initState() {
    super.initState();
    _shopBloc = getIt<ShopBloc>();
    _shopSearchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _shopSearchController.dispose();
    _shopBloc.close();
    super.dispose();
  }

  void _ensureShopLoaded() {
    if (_didRequestInitialShopLoad) {
      return;
    }

    _didRequestInitialShopLoad = true;
    _shopBloc.add(const LoadShopData());
  }

  void _onShopSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) {
        return;
      }

      _shopBloc.add(SearchProducts(value));
    });
  }

  void _syncSearchField(String value) {
    if (_shopSearchController.text == value) {
      return;
    }

    _shopSearchController.value = _shopSearchController.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
      composing: TextRange.empty,
    );
  }

  Future<void> _openShopFilterSheet(
    BuildContext context,
    ShopState state,
  ) async {
    final nextFilters = await showModalBottomSheet<ShopFilters>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) {
        return ShopFilterBottomSheet(
          initialFilters: state.filters,
          categories: state.filterCategories,
          brandOptions: state.availableBrandNames,
          sizeOptions: state.availableSizeValues,
          genderOptions: state.availableGenderValues,
        );
      },
    );

    if (!mounted || nextFilters == null || nextFilters == state.filters) {
      return;
    }

    _shopBloc.add(ApplyShopFilters(nextFilters));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (_, constraints) {
        final isDesktop = constraints.maxWidth >= Breakpoints.desktop;
        final isProfileBranch = widget.navigationShell.currentIndex == 2;
        final isShopRootRoute = widget.currentLocation == RoutePaths.shop;
        final isCartRoute = widget.currentLocation == RoutePaths.cart;
        final showShellAppBar = !isDesktop && !isProfileBranch && !isCartRoute;

        if (isShopRootRoute) {
          _ensureShopLoaded();
          _syncSearchField(_shopBloc.state.searchQuery);
        }

        return BlocProvider.value(
          value: _shopBloc,
          child: BlocListener<ShopBloc, ShopState>(
            listenWhen: (previous, current) =>
                previous.searchQuery != current.searchQuery,
            listener: (_, state) {
              _syncSearchField(state.searchQuery);
            },
            child: CustomScaffold(
              showBottomNav: !isDesktop,
              appBar: showShellAppBar
                  ? AppBar(
                      toolbarHeight: isShopRootRoute ? AppSizes.s100 : null,
                      surfaceTintColor: AppColors.transparent,
                      backgroundColor: AppColors.transparent,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      centerTitle: false,
                      leading: isShopRootRoute
                          ? null
                          : Padding(
                              padding: const EdgeInsets.only(
                                left: AppSizes.s10,
                              ),
                              child: AppAssetImage(
                                assetPath: Assets.iconsSimplelogo,
                              ),
                            ),
                      title: isShopRootRoute
                          ? const SizedBox.shrink()
                          : _buildSearchBar(context, color: AppColors.lightBg),
                      actions: [
                        if (isShopRootRoute) ...[
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: l10n.shopDripTalkPicksTitle,
                                  style: AppTextStyles.ts18(
                                    context,
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const AppGap(AppSizes.s10, axis: Axis.vertical),
                                _buildSearchBar(
                                  context,
                                  color: AppColors.lightBg,
                                  isShopSearch: true,
                                ),
                              ],
                            ),
                          ),
                          const AppGap(AppSizes.s8, axis: Axis.horizontal),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const AppGap(AppSizes.s36),
                              BlocBuilder<ShopBloc, ShopState>(
                                buildWhen: (previous, current) =>
                                    previous.filters != current.filters ||
                                    previous.categories != current.categories ||
                                    previous.products != current.products,
                                builder: (context, state) {
                                  final activeFilterCount =
                                      state.filters.advancedSelectionCount;

                                  return AppActionIcon(
                                    icon: Assets.filter,
                                    badge: activeFilterCount > 0
                                        ? '$activeFilterCount'
                                        : null,
                                    onTap: () =>
                                        _openShopFilterSheet(context, state),
                                  );
                                },
                              ),
                            ],
                          ),
                          const AppGap(AppSizes.s8, axis: Axis.horizontal),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const AppGap(AppSizes.s36),
                              CartActionButton(
                                onTap: () => context.pushNamed(AppRoutes.cart),
                              ),
                            ],
                          ),
                        ] else ...[
                          GradientBorder(
                            onTap: () {},
                            enableShadow: false,
                            backgroundColor: AppColors.lightBg,
                            borderRadius: AppRadius.circular,
                            colors: [
                              AppColors.primary,
                              AppColors.cyan,
                              AppColors.secondary,
                            ],
                            child: AppAssetImage(assetPath: Assets.profileIcon),
                          ),
                        ],
                        const AppGap(AppSizes.s16, axis: Axis.horizontal),
                      ],
                    )
                  : null,
              bottomNav: !isDesktop ? _buildBottomNavBar(context) : null,
              child: SafeArea(
                bottom: false,
                child: isDesktop
                    ? Row(
                        children: [
                          DashboardSidebar(
                            navigationShell: widget.navigationShell,
                          ),
                          Expanded(child: widget.navigationShell),
                        ],
                      )
                    : widget.navigationShell,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(
    BuildContext context, {
    Color? color,
    bool isShopSearch = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.5),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(AppRadius.circular),
      ),
      height: AppSizes.s48,
      child: SearchBar(
        controller: isShopSearch ? _shopSearchController : null,
        onChanged: isShopSearch ? _onShopSearchChanged : null,
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(
          color ?? AppColors.darkBg.withValues(alpha: 0.9),
        ),
        textStyle: WidgetStatePropertyAll(
          AppTextStyles.ts12(
            context,
            color: AppColors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: AppAssetImage(
            assetPath: Assets.iconsSearch,
            height: AppSizes.s14,
          ),
        ),
        hintText: 'Search...',
        hintStyle: WidgetStatePropertyAll(
          AppTextStyles.ts12(
            context,
            color: AppColors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    final items = [
      {'icon': Assets.homeLight, 'active': Assets.homeWhite, 'label': 'Home'},
      {'icon': Assets.shopLight, 'active': Assets.shopWhite, 'label': 'Shop'},
      {'icon': Assets.chatLight, 'active': Assets.chatWhite, 'label': 'Chat'},
      {
        'icon': Assets.profileLight,
        'active': Assets.profileWhite,
        'label': 'Profile',
      },
    ];

    return Container(
      height: AppSizes.s80,
      decoration: const BoxDecoration(
        color: AppColors.darkBg,
        border: Border(top: BorderSide(color: Colors.white12, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final shellIndex = widget.navigationShell.currentIndex;
          final isSelected = (index == 2)
              ? false
              : (index < 2 ? shellIndex == index : shellIndex == index - 1);

          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.circular),
              onTap: () {
                if (index == 2) {
                  context.pushNamed(AppRoutes.chat);
                } else {
                  final targetBranch = index > 2 ? index - 1 : index;
                  widget.navigationShell.goBranch(targetBranch);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.s16,
                  vertical: AppSizes.s10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.circular),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      isSelected
                          ? items[index]['active']!
                          : items[index]['icon']!,
                      height: AppSizes.s24,
                      width: AppSizes.s24,
                    ),
                    if (isSelected) ...[
                      const AppGap(AppSizes.s8, axis: Axis.horizontal),
                      AppText(
                        text: items[index]['label']!,
                        style: AppTextStyles.ts12(
                          context,
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
