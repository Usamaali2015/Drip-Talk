import 'dart:async';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/features/shop/barrels/shop_barrels.dart';
import 'package:drip_talk/l10n/app_localizations.dart';


class AiCuratedCollectionsView extends StatefulWidget {
  const AiCuratedCollectionsView({super.key});

  @override
  State<AiCuratedCollectionsView> createState() =>
      _AiCuratedCollectionsViewState();
}

class _AiCuratedCollectionsViewState extends State<AiCuratedCollectionsView> {
  late final TextEditingController _searchController;
  Timer? _searchDebounce;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    final bloc = context.read<ShopBloc>();
    final state = bloc.state;

    if (state.curatedCollections.isEmpty &&
        state.collectionsStatus != ShopCollectionsStatus.loading) {
      bloc.add(const LoadAiCuratedCollections());
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    final nextQuery = value.trim();
    if (nextQuery != _searchQuery) {
      setState(() {
        _searchQuery = nextQuery;
      });
    }

    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 320), () {
      if (!mounted) {
        return;
      }

      context.read<ShopBloc>().add(
        LoadAiCuratedCollections(
          page: 1,
          searchQuery: nextQuery.isEmpty ? null : nextQuery,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppResponsivePageLayout(
      mobileMaxWidth: 430,
      tabletMaxWidth: 720,
      tabletLargeMaxWidth: 960,
      desktopMaxWidth: 1180,
      useSafeArea: false,
      showHeaderDivider: false,
      showBottomNav: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: AppColors.transparent,
        surfaceTintColor: AppColors.transparent,
     leading: Padding(
       padding: AppPadding.allExtraSmall,
       child:  AiCuratedBackButton(
        onTap: () => context.pop(),
       ),
     ),   
        titleSpacing: 0,
        centerTitle: false,
        title: AppText(
          text: l10n.shopDripTalkPicksTitle,
          style: AppTextStyles.ts20(
            context,
            color: AppColors.pureWhite,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      bottomNav: BlocBuilder<ShopBloc, ShopState>(
        buildWhen: (previous, current) =>
            previous.collectionsCurrentPage != current.collectionsCurrentPage ||
            previous.collectionsTotalPages != current.collectionsTotalPages,
        builder: (context, state) {
          if (state.collectionsTotalPages <= 1) {
            return const SizedBox.shrink();
          }

          return Container(
            decoration: BoxDecoration(
              color: AppColors.darkBg.withValues(alpha: 0.94),
              border: const Border(
                top: BorderSide(color: AppColors.pureWhite12, width: 0.5),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.s16),
                child: ShopPaginationControls(
                  currentPage: state.collectionsCurrentPage,
                  totalPages: state.collectionsTotalPages,
                  centerContent: true,
                  onPageSelected: (page) {
                    context.read<ShopBloc>().add(
                      ChangeCuratedCollectionsPage(
                        page,
                        searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
      pageBuilder: (context, _) => SafeArea(
        child: AiCuratedCollectionsBrowser(
          searchController: _searchController,
          searchQuery: _searchQuery,
          onSearchChanged: _onSearchChanged,
          searchHintText: l10n.shopSearchCollectionsHint,
        ),
      ),
    );
  }
}
