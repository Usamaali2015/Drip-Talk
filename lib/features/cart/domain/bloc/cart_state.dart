import 'package:drip_talk/features/cart/data/models/cart_model.dart';
import 'package:equatable/equatable.dart';

enum CartStatus { initial, loading, success, failure }

enum CartFeedbackType { success, error, info }

class CartState extends Equatable {
  const CartState({
    this.status = CartStatus.initial,
    this.items = const <CartItem>[],
    this.summary = const CartSummary(),
    this.pendingVariantIds = const <int>[],
    this.pendingCartItemIds = const <int>[],
    this.hasLoaded = false,
    this.isRefreshing = false,
    this.errorMessage,
    this.feedbackMessage,
    this.feedbackType = CartFeedbackType.info,
  });

  final CartStatus status;
  final List<CartItem> items;
  final CartSummary summary;
  final List<int> pendingVariantIds;
  final List<int> pendingCartItemIds;
  final bool hasLoaded;
  final bool isRefreshing;
  final String? errorMessage;
  final String? feedbackMessage;
  final CartFeedbackType feedbackType;

  bool get isInitialLoading =>
      status == CartStatus.loading && !hasLoaded && items.isEmpty;

  bool get isEmpty => hasLoaded && items.isEmpty;

  int get totalQuantity =>
      summary.itemCount ??
      items.fold<int>(0, (total, item) => total + item.quantity.clamp(0, 9999));

  int get uniqueItemCount => items.length;

  String? get currency => summary.currency;

  bool isVariantPending(int? productVariantId) {
    if (productVariantId == null) {
      return false;
    }

    return pendingVariantIds.contains(productVariantId);
  }

  bool isCartItemPending(int? cartItemId) {
    if (cartItemId == null) {
      return false;
    }

    return pendingCartItemIds.contains(cartItemId);
  }

  CartItem? itemForVariant(int productVariantId) {
    for (final item in items) {
      if (item.productVariantId == productVariantId) {
        return item;
      }
    }
    return null;
  }

  CartItem? itemForCartItemId(int cartItemId) {
    for (final item in items) {
      if (item.id == cartItemId) {
        return item;
      }
    }
    return null;
  }

  CartState copyWith({
    CartStatus? status,
    List<CartItem>? items,
    CartSummary? summary,
    List<int>? pendingVariantIds,
    List<int>? pendingCartItemIds,
    bool? hasLoaded,
    bool? isRefreshing,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? feedbackMessage,
    CartFeedbackType? feedbackType,
    bool clearFeedback = false,
  }) {
    final nextItems = items ?? this.items;
    final nextSummary = summary != null
        ? summary.normalize(nextItems)
        : (items != null
              ? this.summary.recalculate(nextItems)
              : this.summary.normalize(nextItems));

    return CartState(
      status: status ?? this.status,
      items: nextItems,
      summary: nextSummary,
      pendingVariantIds: pendingVariantIds ?? this.pendingVariantIds,
      pendingCartItemIds: pendingCartItemIds ?? this.pendingCartItemIds,
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
    summary,
    pendingVariantIds,
    pendingCartItemIds,
    hasLoaded,
    isRefreshing,
    errorMessage,
    feedbackMessage,
    feedbackType,
  ];
}
