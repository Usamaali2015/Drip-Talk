import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/cart/view/widgets/cart_action_button.dart';
import 'package:drip_talk/features/shop/data/models/ai_curated_model.dart';
import 'package:drip_talk/features/shop/domain/shop_bloc.dart';
import 'package:drip_talk/features/shop/domain/shop_event.dart';
import 'package:drip_talk/features/shop/domain/shop_state.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'ai_curated_collection_tile.dart';

class AiCuratedCollectionsBrowser extends StatelessWidget {
  const AiCuratedCollectionsBrowser({
    super.key,
    required this.searchController,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.searchHintText,
  });

  final TextEditingController searchController;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final String searchHintText;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      buildWhen: (previous, current) =>
          previous.collectionsStatus != current.collectionsStatus ||
          previous.curatedCollections != current.curatedCollections ||
          previous.collectionsCurrentPage != current.collectionsCurrentPage ||
          previous.collectionsTotalPages != current.collectionsTotalPages ||
          previous.collectionsTotalItems != current.collectionsTotalItems ||
          previous.isCollectionsRefreshing != current.isCollectionsRefreshing,
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(
            AppSizes.s16,
            AppSizes.s16,
            AppSizes.s16,
            AppSizes.s120,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _CuratedCollectionsSearchField(
                      controller: searchController,
                      hintText: searchHintText,
                      onChanged: onSearchChanged,
                    ),
                  ),
                  const AppGap(AppSizes.s12, axis: Axis.horizontal),
                  CartActionButton(
                    onTap: () => context.pushNamed(AppRoutes.cart),
                  ),
                ],
              ),
              const AppGap(AppSizes.s20, axis: Axis.vertical),

              AppText(
                text: l10n.shopAiCuratedCollections,
                style: AppTextStyles.ts18(
                  context,
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const AppGap(AppSizes.s20, axis: Axis.vertical),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: _buildCollectionsContent(
                  context,
                  state,
                  l10n,
                  searchQuery,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCollectionsContent(
    BuildContext context,
    ShopState state,
    AppLocalizations l10n,
    String searchQuery,
  ) {
    if (state.isCollectionsInitialLoading || state.isCollectionsRefreshing) {
      return const _CollectionsGridShimmer(
        key: ValueKey('collections-shimmer'),
      );
    }

    final visibleCollections = _filterCollections(
      state.curatedCollections,
      searchQuery,
    );

    if (state.curatedCollections.isEmpty &&
        state.collectionsStatus == ShopCollectionsStatus.failure) {
      return _CollectionsMessageState(
        key: const ValueKey('collections-error'),
        icon: Icons.cloud_off_rounded,
        message: l10n.shopUnableToLoadCollections,
        actionLabel: l10n.retry,
        onAction: () {
          context.read<ShopBloc>().add(
            LoadAiCuratedCollections(
              page: state.collectionsCurrentPage,
              searchQuery: searchQuery.isEmpty ? null : searchQuery,
            ),
          );
        },
      );
    }

    if (visibleCollections.isEmpty) {
      return _CollectionsMessageState(
        key: ValueKey(
          searchQuery.isEmpty ? 'collections-empty' : 'collections-no-results',
        ),
        icon: Icons.grid_view_rounded,
        message: searchQuery.isEmpty
            ? l10n.shopNoCuratedCollections
            : l10n.shopNoCollectionResults,
      );
    }

    return _CollectionsGrid(
      key: const ValueKey('collections-grid'),
      collections: visibleCollections,
      itemsLabelBuilder: l10n.shopCollectionItems,
      fallbackTitle: l10n.shopAiCuratedCollections,
    );
  }
}

class _CuratedCollectionsSearchField extends StatelessWidget {
  const _CuratedCollectionsSearchField({
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.s56,
      decoration: BoxDecoration(
        color: AppColors.darkBg.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppRadius.circular),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.38)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyles.ts14(
          context,
          color: AppColors.white,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: AppColors.cyan,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.ts12(
            context,
            color: AppColors.white.withValues(alpha: 0.56),
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.white),
          suffixIcon: controller.text.trim().isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                  icon: Icon(
                    Icons.close_rounded,
                    color: AppColors.white.withValues(alpha: 0.72),
                  ),
                ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s16,
            vertical: AppSizes.s16,
          ),
        ),
      ),
    );
  }
}

class _CollectionsGrid extends StatelessWidget {
  const _CollectionsGrid({
    super.key,
    required this.collections,
    required this.itemsLabelBuilder,
    required this.fallbackTitle,
  });

  final List<AiCuratedItem> collections;
  final String Function(int) itemsLabelBuilder;
  final String fallbackTitle;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: collections.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSizes.s14,
        crossAxisSpacing: AppSizes.s12,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final collection = collections[index];
        return AiCuratedCollectionTile(
          title: _resolveCollectionTitle(collection, fallbackTitle),
          subtitle: _resolveCollectionSubtitle(collection),
          itemsText: itemsLabelBuilder(collection.productsCount ?? 0),
          imageUrl: collection.image,
          isFeatured: collection.isFeatured ?? false,
          tags: _buildTags(collection),
          onTap: () {
            final collectionId = collection.id;
            if (collectionId == null) {
              return;
            }

            context.pushNamed(
              AppRoutes.aiCuratedCollectionDetails,
              pathParameters: {'id': collectionId.toString()},
            );
          },
        );
      },
    );
  }
}

class _CollectionsGridShimmer extends StatelessWidget {
  const _CollectionsGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primary.withValues(alpha: 0.12),
      highlightColor: AppColors.secondary.withValues(alpha: 0.18),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppSizes.s14,
          crossAxisSpacing: AppSizes.s12,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.lightBg,
              borderRadius: BorderRadius.circular(AppRadius.r24),
            ),
          );
        },
      ),
    );
  }
}

class _CollectionsMessageState extends StatelessWidget {
  const _CollectionsMessageState({
    super.key,
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.fitWidth,
      padding: const EdgeInsets.all(AppSizes.s24),
      decoration: BoxDecoration(
        color: AppColors.darkBg.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(AppRadius.r24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppSizes.s40,
            color: AppColors.white.withValues(alpha: 0.76),
          ),
          const AppGap(AppSizes.s12, axis: Axis.vertical),
          AppText(
            text: message,
            textAlign: TextAlign.center,
            style: AppTextStyles.ts14(
              context,
              color: AppColors.white.withValues(alpha: 0.78),
              fontWeight: FontWeight.w500,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const AppGap(AppSizes.s18, axis: Axis.vertical),
            FilledButton.icon(
              onPressed: onAction,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.s18,
                  vertical: AppSizes.s12,
                ),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

String _resolveCollectionTitle(AiCuratedItem collection, String fallbackTitle) {
  final candidates = <String?>[
    collection.title,
    collection.description,
    _humanize(collection.slug),
    _combineLabels(collection.occasion, collection.season),
  ];

  for (final candidate in candidates) {
    final normalized = candidate?.trim();
    if (normalized != null && normalized.isNotEmpty) {
      return normalized;
    }
  }

  return fallbackTitle;
}

String? _resolveCollectionSubtitle(AiCuratedItem collection) {
  final candidates = <String?>[
    collection.content,
    collection.description,
    _combineLabels(collection.occasion, collection.gender),
  ];

  for (final candidate in candidates) {
    final normalized = candidate?.trim();
    if (normalized != null && normalized.isNotEmpty) {
      return normalized;
    }
  }

  return null;
}

List<AiCuratedItem> _filterCollections(
  List<AiCuratedItem> collections,
  String searchQuery,
) {
  final normalizedQuery = searchQuery.trim().toLowerCase();
  if (normalizedQuery.isEmpty) {
    return collections;
  }

  return collections.where((collection) {
    final haystacks = <String?>[
      collection.title,
      collection.description,
      collection.content,
      collection.slug,
      collection.gender,
      collection.occasion,
      collection.season,
    ];

    return haystacks.any(
      (value) => value?.toLowerCase().contains(normalizedQuery) ?? false,
    );
  }).toList();
}

List<String> _buildTags(AiCuratedItem collection) {
  return [collection.gender, collection.occasion, collection.season]
      .map((value) => value?.trim())
      .whereType<String>()
      .where((value) => value.isNotEmpty)
      .toList();
}

String? _combineLabels(String? first, String? second) {
  final labels = [first, second]
      .map((value) => value?.trim())
      .whereType<String>()
      .where((value) => value.isNotEmpty)
      .toList();

  if (labels.isEmpty) {
    return null;
  }

  return labels.join(' • ');
}

String? _humanize(String? value) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) {
    return null;
  }

  return normalized
      .replaceAll(RegExp(r'[_-]+'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}
