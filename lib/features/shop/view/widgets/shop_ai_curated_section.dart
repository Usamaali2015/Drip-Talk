import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/shop/data/models/ai_curated_model.dart';
import 'package:drip_talk/features/shop/domain/shop_bloc.dart';
import 'package:drip_talk/features/shop/domain/shop_state.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import 'ai_curated_collection_loading_widgets.dart';
import 'ai_promo_banner.dart';
import 'collection_card.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class ShopAiCuratedSection extends StatelessWidget {
  const ShopAiCuratedSection({
    super.key,
    required this.horizontalPadding,
  });

  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: l10n.shopAiCuratedCollections,
                style: AppTextStyles.ts18(
                  context,
                  color: AppColors.pureWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Material(
                color: AppColors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppSizes.s24),
                  onTap: () {
                    context.pushNamed(AppRoutes.aiCuratedCollections);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.s4,
                      vertical: AppSizes.s2,
                    ),
                    child: AppText(
                      text: l10n.shopSeeAll,
                      style: AppTextStyles.ts12(
                        context,
                        color: AppColors.materialPinkAccent,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const AppGap(AppSizes.s16, axis: Axis.vertical),
        BlocBuilder<ShopBloc, ShopState>(
          buildWhen: (previous, current) =>
              previous.collectionsStatus != current.collectionsStatus ||
              previous.curatedCollections != current.curatedCollections,
          builder: (context, state) {
            final featuredCollections = state.curatedCollections
                .where((collection) => collection.isFeatured ?? false)
                .toList();

            if (featuredCollections.isNotEmpty) {
              return _CollectionsList(
                collections: featuredCollections,
                horizontalPadding: horizontalPadding,
              );
            }

            if (state.collectionsStatus == ShopCollectionsStatus.failure) {
              return _SectionMessage(message: l10n.shopUnableToLoadCollections);
            }

            if (state.collectionsStatus == ShopCollectionsStatus.success) {
              return _SectionMessage(message: l10n.shopNoFeaturedCollections);
            }

            return _CollectionsShimmer(horizontalPadding: horizontalPadding);
          },
        ),
        const AppGap(AppSizes.s24, axis: Axis.vertical),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: AiPromoBanner(
            onTap: () {
              context.pushNamed(AppRoutes.chat);
            },
          ),
        ),
        const AppGap(AppSizes.s24, axis: Axis.vertical),
      ],
    );
  }
}

class _CollectionsList extends StatelessWidget {
  const _CollectionsList({
    required this.collections,
    required this.horizontalPadding,
  });

  final List<AiCuratedItem> collections;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      height: AppSizes.s200,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        scrollDirection: Axis.horizontal,
        itemCount: collections.length,
        itemBuilder: (context, index) {
          final collection = collections[index];
          return CollectionCard(
            title: _resolveCollectionTitle(collection, l10n),
            itemsText: l10n.shopCollectionItems(collection.productsCount ?? 0),
            imageUrl: collection.image,
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
      ),
    );
  }
}

class _SectionMessage extends StatelessWidget {
  const _SectionMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.s200,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.s24),
          child: AppText(
            text: message,
            textAlign: TextAlign.center,
            style: AppTextStyles.ts14(
              context,
              color: AppColors.pureWhite.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }
}

class _CollectionsShimmer extends StatelessWidget {
  const _CollectionsShimmer({required this.horizontalPadding});

  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.s200,
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) {
            return const AiCuratedCollectionListSkeletonCard();
          },
        ),
      ),
    );
  }
}

String _resolveCollectionTitle(
  AiCuratedItem collection,
  AppLocalizations l10n,
) {
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

  return l10n.shopAiCuratedCollections;
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
