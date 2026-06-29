import 'dart:async';
import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/common/widgets/app_action_icon.dart';
import 'package:drip_talk/core/common/widgets/app_asset_image.dart';
import 'package:drip_talk/core/common/widgets/app_cached_network_image.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_gradient_background.dart';
import 'package:drip_talk/core/common/widgets/app_gradient_border.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:drip_talk/core/services/get_it/service_locator.dart';
import 'package:drip_talk/core/utils/responsive/break_points.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/core/utils/routes/route_paths.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_session_repository.dart';
import 'package:drip_talk/features/cart/view/widgets/cart_action_button.dart';
import 'package:drip_talk/features/shop/domain/shop_bloc.dart';
import 'package:drip_talk/features/shop/domain/shop_event.dart';
import 'package:drip_talk/features/shop/domain/shop_filters.dart';
import 'package:drip_talk/features/shop/domain/shop_state.dart';

import 'package:drip_talk/generated/assets.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:drip_talk/l10n/bloc/localization_bloc.dart';
import 'package:drip_talk/l10n/bloc/localization_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../shop/view/widgets/filter_sheet/shop_filter_bottom_sheet.dart';
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
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _shopBloc = getIt<ShopBloc>();
    _shopSearchController = TextEditingController();
    _syncShopRouteState();
    _loadProfileImage();
  }

  @override
  void didUpdateWidget(covariant DashboardShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentLocation != widget.currentLocation ||
        oldWidget.navigationShell.currentIndex !=
            widget.navigationShell.currentIndex) {
      _syncShopRouteState();
      _loadProfileImage();
    }
  }

  Future<void> _loadProfileImage() async {
    final user = await getIt<AuthSessionRepository>().getAuthenticatedUser();
    if (!mounted) return;
    final raw = user?['profile_image']?.toString().trim();
    final url = (raw != null && raw.isNotEmpty && raw.toLowerCase() != 'null')
        ? raw
        : null;
    if (url != _profileImageUrl) {
      setState(() => _profileImageUrl = url);
    }
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

  void _syncShopRouteState() {
    if (widget.currentLocation != RoutePaths.shop) {
      return;
    }

    _ensureShopLoaded();
    _syncSearchField(_shopBloc.state.searchQuery);
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
      backgroundColor: AppColors.transparent,
      barrierColor: AppColors.pureBlack.withValues(alpha: 0.55),
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
        final isWardrobeBranch = widget.navigationShell.currentIndex == 2;
        final isProfileBranch = widget.navigationShell.currentIndex == 3;
        final isShopRootRoute = widget.currentLocation == RoutePaths.shop;
        final isCartRoute = widget.currentLocation == RoutePaths.cart;
        final showShellAppBar =
            !isDesktop && !isProfileBranch && !isWardrobeBranch && !isCartRoute;

        return BlocProvider.value(
          value: _shopBloc,
          child: BlocListener<LocalizationBloc, LocalizationState>(
            listenWhen: (previous, current) =>
                previous.locale != current.locale,
            listener: (context, state) {
              if (_didRequestInitialShopLoad) {
                _shopBloc.add(const RefreshShopData());
              }
            },
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
                                padding: const EdgeInsetsDirectional.only(
                                  start: AppSizes.s10,
                                ),
                                child: AppAssetImage(
                                  assetPath: Assets.iconsSimplelogo,
                                ),
                              ),
                        title: isShopRootRoute
                            ? const SizedBox.shrink()
                            : _buildSearchBar(
                                context,
                                color: AppColors.lightBg,
                              ),
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
                                      color: AppColors.pureWhite,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const AppGap(
                                    AppSizes.s10,
                                    axis: Axis.vertical,
                                  ),
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
                                      previous.categories !=
                                          current.categories ||
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
                                  onTap: () =>
                                      context.pushNamed(AppRoutes.cart),
                                ),
                              ],
                            ),
                          ] else ...[
                            GradientBorder(
                              onTap: () => widget.navigationShell.goBranch(3),
                              enableShadow: false,
                              backgroundColor: _profileImageUrl != null
                                  ? AppColors.transparent
                                  : AppColors.lightBg,
                              borderRadius: AppRadius.circular,
                              padding: _profileImageUrl != null
                                  ? EdgeInsets.zero
                                  : const EdgeInsets.all(12),
                              colors: [
                                AppColors.primary,
                                AppColors.cyan,
                                AppColors.secondary,
                              ],
                              child: _profileImageUrl != null
                                  ? ClipOval(
                                      child: SizedBox(
                                        width: AppSizes.s40,
                                        height: AppSizes.s40,
                                        child: AppCachedNetworkImage(
                                          imageUrl: _profileImageUrl!,
                                          fit: BoxFit.cover,
                                          errorWidget: AppAssetImage(
                                            assetPath: Assets.profileIcon,
                                          ),
                                        ),
                                      ),
                                    )
                                  : AppAssetImage(
                                      assetPath: Assets.profileIcon,
                                    ),
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
    final l10n = AppLocalizations.of(context)!;

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
            color: AppColors.pureWhite,
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
        hintText: l10n.dashboardSearchHint,
        hintStyle: WidgetStatePropertyAll(
          AppTextStyles.ts12(
            context,
            color: AppColors.pureWhite,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const int wardrobeBranchIndex = 2;
    const int profileBranchIndex = 3;

    final items = [
      _DashboardNavItem.asset(
        icon: Assets.chatLight,
        activeIcon: Assets.chatWhite,
        label: l10n.navChat,
      ),
      const _DashboardNavItem.asset(
        icon: Assets.wadrobeUnfilled,
        activeIcon: Assets.wadrobe,
        label: 'Wardrobe',
        branchIndex: wardrobeBranchIndex,
        inactiveTint: AppColors.pureWhite70,
        activeTint: AppColors.pureWhite,
      ),
      _DashboardNavItem.asset(
        icon: Assets.profileLight,
        activeIcon: Assets.profileWhite,
        label: l10n.navProfile,
        branchIndex: profileBranchIndex,
      ),
    ];

    return Container(
      height: AppSizes.s80,
      decoration: const BoxDecoration(
        color: AppColors.darkBg,
        border: Border(
          top: BorderSide(color: AppColors.pureWhite12, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final shellIndex = widget.navigationShell.currentIndex;
          final item = items[index];

          // ── Check if this nav item is selected ──────────────────────────
          // For branch items: check branch index
          // For Chat: check if current location is the chat route
          final isSelected = item.branchIndex != null
              ? shellIndex == item.branchIndex
              : widget.currentLocation == RoutePaths.chat;

          return Material(
            color: AppColors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.circular),
              onTap: () {
                if (item.branchIndex == null) {
                  if (widget.navigationShell.currentIndex == profileBranchIndex) {
                    widget.navigationShell.goBranch(wardrobeBranchIndex);
                  }
                  context.pushNamed(AppRoutes.chat);
                } else {
                  widget.navigationShell.goBranch(item.branchIndex!);
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
                  color: isSelected ? AppColors.primary : AppColors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.circular),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      isSelected ? item.activeIcon : item.icon,
                      height: AppSizes.s24,
                      width: AppSizes.s24,
                      colorFilter:
                          (isSelected ? item.activeTint : item.inactiveTint) !=
                              null
                          ? ColorFilter.mode(
                              isSelected
                                  ? item.activeTint!
                                  : item.inactiveTint!,
                              BlendMode.srcIn,
                            )
                          : null,
                    ),
                    // ── Show label only for items with branchIndex (not Chat) ────
                    if (item.branchIndex != null && isSelected) ...[
                      const AppGap(AppSizes.s8, axis: Axis.horizontal),
                      AppText(
                        text: item.label,
                        style: AppTextStyles.ts12(
                          context,
                          color: AppColors.pureWhite,
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

class _DashboardNavItem {
  const _DashboardNavItem.asset({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.branchIndex,
    this.inactiveTint,
    this.activeTint,
  });

  final String icon;
  final String activeIcon;
  final String label;
  final int? branchIndex;
  final Color? inactiveTint;
  final Color? activeTint;
}
