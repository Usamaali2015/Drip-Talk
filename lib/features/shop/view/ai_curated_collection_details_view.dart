import 'dart:async';
import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/widgets/app_error_retry.dart';
import 'package:drip_talk/core/common/widgets/app_gradient_background.dart';
import 'package:drip_talk/features/shop/domain/ai_curated_collection_details_bloc.dart';
import 'package:drip_talk/features/shop/domain/ai_curated_collection_details_event.dart';
import 'package:drip_talk/features/shop/domain/ai_curated_collection_details_state.dart';
import 'package:drip_talk/features/shop/view/widgets/ai_curated_collection_details_browser.dart';
import 'package:drip_talk/features/shop/view/widgets/shop_pagination_controls.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

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
    _searchController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CustomScaffold(
      showBottomNav: true,
      bottomNav: BlocBuilder<
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
                top: BorderSide(color: Colors.white12, width: 0.5),
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
      child: SafeArea(
        bottom: false,
        child:
            BlocBuilder<
              AiCuratedCollectionDetailsBloc,
              AiCuratedCollectionDetailsState
            >(
              builder: (context, state) {
                if (_searchController.text != state.searchQuery) {
                  _searchController.value = _searchController.value.copyWith(
                    text: state.searchQuery,
                    selection: TextSelection.collapsed(
                      offset: state.searchQuery.length,
                    ),
                    composing: TextRange.empty,
                  );
                }

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
    );
  }
}

class _AiCuratedCollectionDetailsLoadingView extends StatelessWidget {
  const _AiCuratedCollectionDetailsLoadingView();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primary.withValues(alpha: 0.12),
      highlightColor: AppColors.secondary.withValues(alpha: 0.18),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.s16,
          AppSizes.s20,
          AppSizes.s16,
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
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(AppSizes.s14),
                  ),
                ),
                const SizedBox(width: AppSizes.s12),
                Container(
                  width: AppSizes.s160,
                  height: AppSizes.s18,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(AppSizes.s12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.s20),
            Container(
              height: AppSizes.s55,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(AppSizes.s24),
              ),
            ),
            const SizedBox(height: AppSizes.s20),
            Container(
              height: AppSizes.s200,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(AppSizes.s28),
              ),
            ),
            const SizedBox(height: AppSizes.s20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSizes.s14,
                mainAxisSpacing: AppSizes.s16,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) => Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(AppSizes.s24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
