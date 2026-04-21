import 'package:dio/dio.dart';
import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drip_talk/features/wishlist/data/models/wishlist_model.dart';
import 'package:drip_talk/features/wishlist/data/repository/wishlist_repository.dart';

import 'wishlist_event.dart';
import 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc(this._repository) : super(const WishlistState()) {
    on<LoadWishlist>(_onLoadWishlist);
    on<ChangeWishlistPage>(_onChangeWishlistPage);
    on<ChangeWishlistSort>(_onChangeWishlistSort);
    on<ToggleWishlistProduct>(_onToggleWishlistProduct);
    on<ClearWishlistFeedback>(_onClearWishlistFeedback);
    on<ClearWishlistSession>(_onClearWishlistSession);
  }

  final WishlistRepository _repository;
  CancelToken? _activeLoadToken;
  int _loadRequestSequence = 0;

  Future<void> _onLoadWishlist(
    LoadWishlist event,
    Emitter<WishlistState> emit,
  ) async {
    final requestId = ++_loadRequestSequence;
    final targetPage = event.page < 1 ? 1 : event.page;
    final targetPerPage = event.perPage < 1 ? state.perPage : event.perPage;
    final targetSort = event.sort;

    _activeLoadToken?.cancel();
    final cancelToken = CancelToken();
    _activeLoadToken = cancelToken;

    final shouldRefreshInPlace =
        state.hasLoaded && state.items.isNotEmpty && !event.showLoader;

    emit(
      state.copyWith(
        status: event.showLoader ? WishlistStatus.loading : state.status,
        currentPage: targetPage,
        perPage: targetPerPage,
        sort: targetSort,
        setSortToNull: targetSort == null,
        isRefreshing: shouldRefreshInPlace,
        clearErrorMessage: true,
        clearFeedback: true,
      ),
    );

    try {
      final response = await _repository.getWishlist(
        page: targetPage,
        perPage: targetPerPage,
        sort: targetSort,
        cancelToken: cancelToken,
      );

      if (requestId != _loadRequestSequence) {
        return;
      }

      final data = response.data ?? const WishListData();
      final pagination = data.pagination ?? const WishListPagination();
      final items = data.items;

      emit(
        state.copyWith(
          status: WishlistStatus.success,
          items: items,
          knownSavedProductIds: _mergeKnownSavedIds(
            state.knownSavedProductIds,
            items.map((item) => item.id).whereType<int>(),
          ),
          currentPage: pagination.currentPage ?? targetPage,
          totalPages: pagination.lastPage ?? 1,
          perPage: pagination.perPage ?? targetPerPage,
          totalItems: pagination.total ?? items.length,
          sort: targetSort,
          setSortToNull: targetSort == null,
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
            status: state.hasLoaded ? state.status : WishlistStatus.initial,
            isRefreshing: false,
          ),
        );
        return;
      }

      final message = _resolveErrorMessage(error);
      emit(
        state.copyWith(
          status: state.items.isEmpty
              ? WishlistStatus.failure
              : WishlistStatus.success,
          hasLoaded: true,
          isRefreshing: false,
          errorMessage: message,
          feedbackMessage: state.items.isEmpty ? null : message,
          feedbackType: WishlistFeedbackType.error,
        ),
      );
    } catch (error) {
      if (requestId != _loadRequestSequence) {
        return;
      }

      final message = _resolveErrorMessage(error);
      if (event.silent) {
        emit(
          state.copyWith(
            status: state.hasLoaded ? state.status : WishlistStatus.initial,
            isRefreshing: false,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: state.items.isEmpty
              ? WishlistStatus.failure
              : WishlistStatus.success,
          hasLoaded: true,
          isRefreshing: false,
          errorMessage: message,
          feedbackMessage: state.items.isEmpty ? null : message,
          feedbackType: WishlistFeedbackType.error,
        ),
      );
    }
  }

  void _onChangeWishlistPage(
    ChangeWishlistPage event,
    Emitter<WishlistState> emit,
  ) {
    if (event.page == state.currentPage || event.page < 1) {
      return;
    }

    add(
      LoadWishlist(
        page: event.page,
        perPage: state.perPage,
        sort: state.sort,
        showLoader: false,
      ),
    );
  }

  void _onChangeWishlistSort(
    ChangeWishlistSort event,
    Emitter<WishlistState> emit,
  ) {
    if (event.sort == state.sort && state.hasLoaded) {
      return;
    }

    add(
      LoadWishlist(
        page: 1,
        perPage: state.perPage,
        sort: event.sort,
        showLoader: !state.hasLoaded,
      ),
    );
  }

  Future<void> _onToggleWishlistProduct(
    ToggleWishlistProduct event,
    Emitter<WishlistState> emit,
  ) async {
    if (event.productId <= 0 || state.isProductPending(event.productId)) {
      return;
    }

    final previousState = state;
    final isCurrentlySaved = state.isProductSaved(event.productId);
    final nextKnownSavedIds = isCurrentlySaved
        ? _removePending(state.knownSavedProductIds, event.productId)
        : _appendPending(state.knownSavedProductIds, event.productId);
    final nextItems = isCurrentlySaved
        ? state.items.where((item) => item.id != event.productId).toList()
        : state.items;
    final removedVisibleItem = nextItems.length != state.items.length;
    final optimisticTotalItems = isCurrentlySaved
        ? (state.totalItems > 0 ? state.totalItems - 1 : 0)
        : state.hasLoaded
        ? state.totalItems + 1
        : state.totalItems;

    final optimisticState = state.copyWith(
      status: state.hasLoaded ? WishlistStatus.success : state.status,
      items: nextItems,
      knownSavedProductIds: nextKnownSavedIds,
      pendingProductIds: _appendPending(
        state.pendingProductIds,
        event.productId,
      ),
      totalItems: optimisticTotalItems,
      hasLoaded: state.hasLoaded || nextItems.isNotEmpty,
      clearErrorMessage: true,
      clearFeedback: true,
    );

    emit(optimisticState);

    try {
      final response = await _repository.toggleWishlist(
        productId: event.productId,
      );
      final settledState = optimisticState.copyWith(
        pendingProductIds: _removePending(
          optimisticState.pendingProductIds,
          event.productId,
        ),
        feedbackMessage: response.message,
        feedbackType: WishlistFeedbackType.success,
        clearErrorMessage: true,
      );

      emit(settledState);

      if (settledState.hasLoaded) {
        add(
          LoadWishlist(
            page: _resolveReloadPage(
              state: settledState,
              removedVisibleItem: removedVisibleItem,
            ),
            perPage: settledState.perPage,
            sort: settledState.sort,
            showLoader: false,
            silent: true,
          ),
        );
      }
    } catch (error) {
      emit(
        previousState.copyWith(
          feedbackMessage: _resolveErrorMessage(error),
          feedbackType: WishlistFeedbackType.error,
          hasLoaded: previousState.hasLoaded || previousState.items.isNotEmpty,
        ),
      );
    }
  }

  void _onClearWishlistFeedback(
    ClearWishlistFeedback event,
    Emitter<WishlistState> emit,
  ) {
    emit(state.copyWith(clearFeedback: true));
  }

  void _onClearWishlistSession(
    ClearWishlistSession event,
    Emitter<WishlistState> emit,
  ) {
    _activeLoadToken?.cancel();
    emit(const WishlistState());
  }

  List<int> _appendPending(List<int> ids, int id) {
    if (ids.contains(id)) {
      return ids;
    }

    return List<int>.from(ids)..add(id);
  }

  List<int> _removePending(List<int> ids, int id) {
    return ids.where((value) => value != id).toList();
  }

  List<int> _mergeKnownSavedIds(List<int> currentIds, Iterable<int> newIds) {
    final mergedIds = <int>{...currentIds, ...newIds};
    return mergedIds.toList()..sort();
  }

  int _resolveReloadPage({
    required WishlistState state,
    required bool removedVisibleItem,
  }) {
    if (removedVisibleItem && state.items.isEmpty && state.currentPage > 1) {
      return state.currentPage - 1;
    }

    return state.currentPage;
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

      return error.message ??
          localizedString(
            fallback: 'Unable to update saved items',
            select: (l10n) => l10n.wishlistUpdateFailed,
          );
    }

    final message = error.toString().trim();
    return message.isEmpty
        ? localizedString(
            fallback: 'Unable to update saved items',
            select: (l10n) => l10n.wishlistUpdateFailed,
          )
        : message;
  }

  @override
  Future<void> close() {
    _activeLoadToken?.cancel();
    return super.close();
  }
}
