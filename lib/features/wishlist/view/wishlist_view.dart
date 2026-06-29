import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/product/barrels/product_barrels.dart';
import 'package:drip_talk/features/shop/barrels/shop_barrels.dart';
import 'package:drip_talk/features/wishlist/barrels/wishlist_barrels.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
part 'widgets/wishlist_view_widgets.dart';

class WishListView extends StatefulWidget {
  const WishListView({super.key});

  @override
  State<WishListView> createState() => _WishListViewState();
}

class _WishListViewState extends State<WishListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final bloc = context.read<WishlistBloc>();
      final state = bloc.state;
      bloc.add(
        LoadWishlist(
          page: state.currentPage,
          perPage: state.perPage,
          sort: state.sort,
          showLoader: !state.hasLoaded,
        ),
      );
    });
  }

  Future<void> _handleRefresh(BuildContext context) async {
    final bloc = context.read<WishlistBloc>();
    final state = bloc.state;
    bloc.add(
      LoadWishlist(
        page: state.currentPage,
        perPage: state.perPage,
        sort: state.sort,
        showLoader: false,
      ),
    );
    await bloc.stream.firstWhere((nextState) => !nextState.isRefreshing);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppResponsivePageLayout(
      mobileMaxWidth: 430,
      tabletMaxWidth: 720,
      tabletLargeMaxWidth: 960,
      desktopMaxWidth: 1180,
      headerBuilder: (context, _) => WishlistPageHeader(
        title: l10n.savedItems,
        subtitle: l10n.wishlistSubtitle,
        onBack: () => _handleBack(context),
      ),
      bodyBuilder: (context, contentWidth) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocSelector<WishlistBloc, WishlistState, String?>(
              selector: (state) => state.sort,
              builder: (context, selectedSort) {
                return WishlistSortChips(
                  selectedSort: selectedSort,
                  onSortSelected: (value) {
                    context.read<WishlistBloc>().add(
                      ChangeWishlistSort(value),
                    );
                  },
                );
              },
            ),
            const AppGap(AppSizes.s10),
            Expanded(
              child: _WishlistContent(
                l10n: l10n,
                contentWidth: contentWidth,
                onRefresh: () => _handleRefresh(context),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleBack(BuildContext context) {
    if (GoRouter.of(context).canPop()) {
      context.pop();
      return;
    }

    context.goNamed(AppRoutes.profiles);
  }
}
