import 'dart:async';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/features/shop/barrels/shop_barrels.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
part 'widgets/ai_curated_collection_details_view_widgets.dart';

class AiCuratedCollectionDetailsView extends StatefulWidget {
  const AiCuratedCollectionDetailsView({super.key});

  @override
  State<AiCuratedCollectionDetailsView> createState() =>
      _AiCuratedCollectionDetailsViewState();
}

class _AiCuratedCollectionDetailsViewState
    extends State<AiCuratedCollectionDetailsView> {
  late final TextEditingController _searchController;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: context.read<AiCuratedCollectionDetailsBloc>().state.searchQuery,
    );
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    final nextQuery = value.trim();
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 320), () {
      if (!mounted) {
        return;
      }

      context.read<AiCuratedCollectionDetailsBloc>().add(
        SearchAiCuratedCollectionProducts(nextQuery),
      );
    });
  }

  void _syncSearchField(String value) {
    if (_searchController.text == value) {
      return;
    }

    _searchController.value = _searchController.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
      composing: TextRange.empty,
    );
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
      bottomNav:
          BlocBuilder<
            AiCuratedCollectionDetailsBloc,
            AiCuratedCollectionDetailsState
          >(
            buildWhen: (previous, current) =>
                previous.currentPage != current.currentPage ||
                previous.totalPages != current.totalPages,
            builder: (context, state) {
              if (state.totalPages <= 1) {
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
                      currentPage: state.currentPage,
                      totalPages: state.totalPages,
                      centerContent: true,
                      onPageSelected: (page) {
                        context.read<AiCuratedCollectionDetailsBloc>().add(
                          ChangeAiCuratedCollectionProductsPage(page),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
      pageBuilder: (context, _) => SafeArea(
        bottom: false,
        child:
            BlocListener<
              AiCuratedCollectionDetailsBloc,
              AiCuratedCollectionDetailsState
            >(
              listenWhen: (previous, current) =>
                  previous.searchQuery != current.searchQuery,
              listener: (_, state) {
                _syncSearchField(state.searchQuery);
              },
              child:
                  BlocBuilder<
                    AiCuratedCollectionDetailsBloc,
                    AiCuratedCollectionDetailsState
                  >(
                    builder: (context, state) {
                      if (state.isInitialLoading) {
                        return const _AiCuratedCollectionDetailsLoadingView();
                      }

                      if (!state.hasCollection) {
                        return ErrorRetryWidget(
                          message:
                              state.errorMessage ??
                              l10n.shopUnableToLoadCollectionDetails,
                          onRetry: () {
                            final collectionId = state.collectionId;
                            if (collectionId == null) {
                              return;
                            }

                            context.read<AiCuratedCollectionDetailsBloc>().add(
                              LoadAiCuratedCollectionDetails(
                                collectionId,
                                page: state.currentPage,
                                searchQuery: state.searchQuery,
                              ),
                            );
                          },
                        );
                      }

                      return AiCuratedCollectionDetailsBrowser(
                        state: state,
                        searchController: _searchController,
                        onSearchChanged: _onSearchChanged,
                      );
                    },
                  ),
            ),
      ),
    );
  }
}
