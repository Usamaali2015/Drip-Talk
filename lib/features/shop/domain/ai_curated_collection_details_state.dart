import 'package:drip_talk/features/shop/data/models/ai_collection_details_model.dart';
import 'package:equatable/equatable.dart';

enum AiCuratedCollectionDetailsStatus { initial, loading, success, failure }

class AiCuratedCollectionDetailsState extends Equatable {
  const AiCuratedCollectionDetailsState({
    this.status = AiCuratedCollectionDetailsStatus.initial,
    this.collectionId,
    this.collection,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.searchQuery = '',
    this.isRefreshing = false,
    this.errorMessage,
  });

  final AiCuratedCollectionDetailsStatus status;
  final int? collectionId;
  final AiCollectionDetailsData? collection;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final String searchQuery;
  final bool isRefreshing;
  final String? errorMessage;

  bool get isInitialLoading =>
      collection == null &&
      (status == AiCuratedCollectionDetailsStatus.initial ||
          status == AiCuratedCollectionDetailsStatus.loading);

  bool get hasCollection => collection?.outfit != null;

  AiCollectionOutfit? get outfit => collection?.outfit;

  List<AiCollectionProductItem> get visibleProducts {
    final products = collection?.items ?? const <AiCollectionProductItem>[];
    final normalizedQuery = searchQuery.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return products;
    }

    return products.where((product) {
      final haystacks = <String?>[
        product.title,
        product.slug,
        product.category?.name,
      ];

      return haystacks.any(
        (value) => value?.toLowerCase().contains(normalizedQuery) ?? false,
      );
    }).toList();
  }

  AiCuratedCollectionDetailsState copyWith({
    AiCuratedCollectionDetailsStatus? status,
    int? collectionId,
    AiCollectionDetailsData? collection,
    bool clearCollection = false,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    String? searchQuery,
    bool? isRefreshing,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return AiCuratedCollectionDetailsState(
      status: status ?? this.status,
      collectionId: collectionId ?? this.collectionId,
      collection: clearCollection ? null : (collection ?? this.collection),
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      searchQuery: searchQuery ?? this.searchQuery,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    collectionId,
    collection,
    currentPage,
    totalPages,
    totalItems,
    searchQuery,
    isRefreshing,
    errorMessage,
  ];
}
