import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drip_talk/features/cart/data/models/cart_model.dart';
import 'package:drip_talk/features/cart/data/repository/cart_repository.dart';

import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(this._repository) : super(const CartState()) {
    on<LoadCart>(_onLoadCart);
    on<AddCartItem>(_onAddCartItem);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<RemoveCartItem>(_onRemoveCartItem);
    on<ClearCartFeedback>(_onClearCartFeedback);
    on<ClearCartSession>(_onClearCartSession);
  }

  final CartRepository _repository;
  CancelToken? _activeLoadToken;
  int _loadRequestSequence = 0;

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    final requestId = ++_loadRequestSequence;
    _activeLoadToken?.cancel();
    final cancelToken = CancelToken();
    _activeLoadToken = cancelToken;

    final shouldRefreshInPlace = state.hasLoaded && state.items.isNotEmpty;
    emit(
      state.copyWith(
        status: event.showLoader ? CartStatus.loading : state.status,
        isRefreshing: shouldRefreshInPlace && !event.showLoader,
        clearErrorMessage: true,
        clearFeedback: true,
      ),
    );

    try {
      final response = await _repository.getCart(cancelToken: cancelToken);
      if (requestId != _loadRequestSequence) {
        return;
      }

      final resolvedData = _resolveCartData(response.data);
      emit(
        state.copyWith(
          status: CartStatus.success,
          items: resolvedData.items,
          summary: resolvedData.summary,
          hasLoaded: true,
          isRefreshing: false,
          clearErrorMessage: true,
        ),
      );
    } on DioException catch (error) {
      if (error.type == DioExceptionType.cancel ||
          requestId != _loadRequestSequence) {
        return;
      }

      if (event.silent) {
        emit(
          state.copyWith(
            status: state.hasLoaded ? state.status : CartStatus.initial,
            isRefreshing: false,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: state.items.isEmpty ? CartStatus.failure : CartStatus.success,
          hasLoaded: true,
          isRefreshing: false,
          errorMessage: _resolveErrorMessage(error),
          feedbackMessage: state.items.isEmpty
              ? null
              : _resolveErrorMessage(error),
          feedbackType: CartFeedbackType.error,
        ),
      );
    } catch (_) {
      if (requestId != _loadRequestSequence) {
        return;
      }

      const fallbackMessage = 'Unable to load cart';
      if (event.silent) {
        emit(
          state.copyWith(
            status: state.hasLoaded ? state.status : CartStatus.initial,
            isRefreshing: false,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: state.items.isEmpty ? CartStatus.failure : CartStatus.success,
          hasLoaded: true,
          isRefreshing: false,
          errorMessage: fallbackMessage,
          feedbackMessage: state.items.isEmpty ? null : fallbackMessage,
          feedbackType: CartFeedbackType.error,
        ),
      );
    }
  }

  Future<void> _onAddCartItem(
    AddCartItem event,
    Emitter<CartState> emit,
  ) async {
    if (event.productVariantId <= 0 || event.quantity <= 0) {
      return;
    }

    final previousState = state;
    final currentItems = List<CartItem>.from(state.items);
    final existingIndex = currentItems.indexWhere(
      (item) => item.productVariantId == event.productVariantId,
    );

    if (existingIndex >= 0) {
      final existingItem = currentItems[existingIndex];
      currentItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + event.quantity,
        lineTotal: existingItem.lineTotal == null
            ? null
            : existingItem.resolvedLineTotal +
                  (existingItem.resolvedUnitPrice * event.quantity),
      );
    } else if (event.optimisticItem != null) {
      currentItems.insert(
        0,
        event.optimisticItem!.copyWith(
          productVariantId: event.productVariantId,
          quantity: event.quantity,
          lineTotal: event.optimisticItem!.unitPrice == null
              ? null
              : event.optimisticItem!.resolvedUnitPrice * event.quantity,
        ),
      );
    }

    final optimisticState = state.copyWith(
      status: CartStatus.success,
      items: currentItems,
      hasLoaded: true,
      pendingVariantIds: _appendPending(
        state.pendingVariantIds,
        event.productVariantId,
      ),
      clearErrorMessage: true,
      clearFeedback: true,
    );

    emit(optimisticState);

    try {
      final response = await _repository.addToCart(
        productVariantId: event.productVariantId,
        quantity: event.quantity,
      );

      emit(
        _successfulMutationState(
          baseState: optimisticState,
          response: response,
          productVariantId: event.productVariantId,
        ),
      );
      add(const LoadCart(showLoader: false, silent: true));
    } catch (error) {
      emit(
        previousState.copyWith(
          feedbackMessage: _resolveErrorMessage(error),
          feedbackType: CartFeedbackType.error,
          hasLoaded: previousState.hasLoaded || previousState.items.isNotEmpty,
        ),
      );
    }
  }

  Future<void> _onUpdateCartItemQuantity(
    UpdateCartItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    if (event.quantity <= 0) {
      add(RemoveCartItem(cartItemId: event.cartItemId));
      return;
    }

    final existingItem = state.itemForCartItemId(event.cartItemId);
    if (existingItem == null) {
      return;
    }

    final previousState = state;
    final nextItems = state.items.map((item) {
      if (item.id != event.cartItemId) {
        return item;
      }

      return item.copyWith(
        quantity: event.quantity,
        lineTotal: item.unitPrice == null
            ? null
            : item.resolvedUnitPrice * event.quantity,
      );
    }).toList();

    final optimisticState = state.copyWith(
      status: CartStatus.success,
      items: nextItems,
      pendingCartItemIds: _appendPending(
        state.pendingCartItemIds,
        event.cartItemId,
      ),
      clearErrorMessage: true,
      clearFeedback: true,
    );

    emit(optimisticState);

    try {
      final response = await _repository.updateCartItem(
        cartItemId: event.cartItemId,
        quantity: event.quantity,
      );

      emit(
        _successfulMutationState(
          baseState: optimisticState,
          response: response,
          cartItemId: event.cartItemId,
        ),
      );
      add(const LoadCart(showLoader: false, silent: true));
    } catch (error) {
      emit(
        previousState.copyWith(
          feedbackMessage: _resolveErrorMessage(error),
          feedbackType: CartFeedbackType.error,
        ),
      );
    }
  }

  Future<void> _onRemoveCartItem(
    RemoveCartItem event,
    Emitter<CartState> emit,
  ) async {
    final existingItem = state.itemForCartItemId(event.cartItemId);
    if (existingItem == null) {
      return;
    }

    final previousState = state;
    final nextItems = state.items
        .where((item) => item.id != event.cartItemId)
        .toList();

    final optimisticState = state.copyWith(
      status: CartStatus.success,
      items: nextItems,
      pendingCartItemIds: _appendPending(
        state.pendingCartItemIds,
        event.cartItemId,
      ),
      clearErrorMessage: true,
      clearFeedback: true,
    );

    emit(optimisticState);

    try {
      final response = await _repository.removeCartItem(
        cartItemId: event.cartItemId,
      );

      emit(
        _successfulMutationState(
          baseState: optimisticState,
          response: response,
          cartItemId: event.cartItemId,
        ),
      );
      add(const LoadCart(showLoader: false, silent: true));
    } catch (error) {
      emit(
        previousState.copyWith(
          feedbackMessage: _resolveErrorMessage(error),
          feedbackType: CartFeedbackType.error,
        ),
      );
    }
  }

  void _onClearCartFeedback(ClearCartFeedback event, Emitter<CartState> emit) {
    emit(state.copyWith(clearFeedback: true));
  }

  void _onClearCartSession(ClearCartSession event, Emitter<CartState> emit) {
    _activeLoadToken?.cancel();
    emit(const CartState());
  }

  CartState _successfulMutationState({
    required CartState baseState,
    required CartResponseModel response,
    int? productVariantId,
    int? cartItemId,
  }) {
    return baseState.copyWith(
      status: CartStatus.success,
      hasLoaded: true,
      isRefreshing: false,
      pendingVariantIds: productVariantId == null
          ? baseState.pendingVariantIds
          : _removePending(baseState.pendingVariantIds, productVariantId),
      pendingCartItemIds: cartItemId == null
          ? baseState.pendingCartItemIds
          : _removePending(baseState.pendingCartItemIds, cartItemId),
      feedbackMessage: response.message,
      feedbackType: CartFeedbackType.success,
      clearErrorMessage: true,
    );
  }

  CartData _resolveCartData(CartData? serverData) {
    if (serverData != null && serverData.hasMeaningfulData) {
      return serverData.copyWith(
        summary: serverData.summary.normalize(serverData.items),
      );
    }

    return const CartData();
  }

  List<int> _appendPending(List<int> pendingIds, int productVariantId) {
    if (pendingIds.contains(productVariantId)) {
      return pendingIds;
    }

    return List<int>.from(pendingIds)..add(productVariantId);
  }

  List<int> _removePending(List<int> pendingIds, int productVariantId) {
    return pendingIds.where((id) => id != productVariantId).toList();
  }

  String _resolveErrorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        final message = data['message']?.toString();
        if (message != null && message.trim().isNotEmpty) {
          return message;
        }
      } else if (data is Map) {
        final message = data['message']?.toString();
        if (message != null && message.trim().isNotEmpty) {
          return message;
        }
      }

      return error.message ?? 'Unable to update cart';
    }

    final message = error.toString().trim();
    return message.isEmpty ? 'Unable to update cart' : message;
  }

  @override
  Future<void> close() {
    _activeLoadToken?.cancel();
    return super.close();
  }
}
