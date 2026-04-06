import 'package:drip_talk/features/wishlist/data/models/wishlist_model.dart';
import 'package:equatable/equatable.dart';

enum WishlistStatus { initial, loading, success, failure }

enum WishlistFeedbackType { success, error, info }

class WishlistState extends Equatable {
  const WishlistState({
    this.status = WishlistStatus.initial,
    this.items = const <WishListItem>[],
    this.knownSavedProductIds = const <int>[],
    this.pendingProductIds = const <int>[],
    this.currentPage = 1,
    this.totalPages = 1,
    this.perPage = 20,
    this.totalItems = 0,
    this.sort,
    this.hasLoaded = false,
    this.isRefreshing = false,
    this.errorMessage,
    this.feedbackMessage,
    this.feedbackType = WishlistFeedbackType.info,
  });

  final WishlistStatus status;
  final List<WishListItem> items;
  final List<int> knownSavedProductIds;
  final List<int> pendingProductIds;
  final int currentPage;
  final int totalPages;
  final int perPage;
  final int totalItems;
  final String? sort;
  final bool hasLoaded;
  final bool isRefreshing;
  final String? errorMessage;
  final String? feedbackMessage;
  final WishlistFeedbackType feedbackType;

  bool get isInitialLoading =>
      status == WishlistStatus.loading && !hasLoaded && items.isEmpty;

  bool isProductSaved(int? productId) {
    if (productId == null) {
      return false;
    }

    return knownSavedProductIds.contains(productId);
  }

  bool isProductPending(int? productId) {
    if (productId == null) {
      return false;
    }

    return pendingProductIds.contains(productId);
  }

  WishlistState copyWith({
    WishlistStatus? status,
    List<WishListItem>? items,
    List<int>? knownSavedProductIds,
    List<int>? pendingProductIds,
    int? currentPage,
    int? totalPages,
    int? perPage,
    int? totalItems,
    String? sort,
    bool setSortToNull = false,
    bool? hasLoaded,
    bool? isRefreshing,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? feedbackMessage,
    WishlistFeedbackType? feedbackType,
    bool clearFeedback = false,
  }) {
    return WishlistState(
      status: status ?? this.status,
      items: items ?? this.items,
      knownSavedProductIds: knownSavedProductIds ?? this.knownSavedProductIds,
      pendingProductIds: pendingProductIds ?? this.pendingProductIds,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      perPage: perPage ?? this.perPage,
      totalItems: totalItems ?? this.totalItems,
      sort: setSortToNull ? null : (sort ?? this.sort),
      hasLoaded: hasLoaded ?? this.hasLoaded,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      feedbackMessage: clearFeedback
          ? null
          : (feedbackMessage ?? this.feedbackMessage),
      feedbackType: feedbackType ?? this.feedbackType,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    knownSavedProductIds,
    pendingProductIds,
    currentPage,
    totalPages,
    perPage,
    totalItems,
    sort,
    hasLoaded,
    isRefreshing,
    errorMessage,
    feedbackMessage,
    feedbackType,
  ];
}
