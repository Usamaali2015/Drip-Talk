import 'package:dio/dio.dart';
import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drip_talk/features/shop/data/repository/shop_repository.dart';
import 'package:drip_talk/features/shop/domain/ai_curated_collection_details_event.dart';
import 'package:drip_talk/features/shop/domain/ai_curated_collection_details_state.dart';

class AiCuratedCollectionDetailsBloc
    extends
        Bloc<AiCuratedCollectionDetailsEvent, AiCuratedCollectionDetailsState> {
  AiCuratedCollectionDetailsBloc(this._repository)
    : super(const AiCuratedCollectionDetailsState()) {
    on<LoadAiCuratedCollectionDetails>(_onLoadAiCuratedCollectionDetails);
    on<SearchAiCuratedCollectionProducts>(_onSearchAiCuratedCollectionProducts);
    on<ChangeAiCuratedCollectionProductsPage>(
      _onChangeAiCuratedCollectionProductsPage,
    );
  }

  final ShopRepository _repository;
  CancelToken? _activeRequestToken;
  int _requestSequence = 0;

  Future<void> _onLoadAiCuratedCollectionDetails(
    LoadAiCuratedCollectionDetails event,
    Emitter<AiCuratedCollectionDetailsState> emit,
  ) async {
    await _fetchCollectionDetails(
      emit,
      collectionId: event.collectionId,
      page: event.page,
      perPage: event.perPage,
      searchQuery: event.searchQuery,
      showLoader: event.showLoader,
    );
  }

  Future<void> _onSearchAiCuratedCollectionProducts(
    SearchAiCuratedCollectionProducts event,
    Emitter<AiCuratedCollectionDetailsState> emit,
  ) async {
    final nextQuery = event.query.trim();
    if (nextQuery == state.searchQuery) {
      return;
    }

    final collectionId = state.collectionId;
    if (collectionId == null) {
      emit(state.copyWith(searchQuery: nextQuery));
      return;
    }

    await _fetchCollectionDetails(
      emit,
      collectionId: collectionId,
      page: 1,
      searchQuery: nextQuery,
      showLoader: false,
    );
  }

  Future<void> _onChangeAiCuratedCollectionProductsPage(
    ChangeAiCuratedCollectionProductsPage event,
    Emitter<AiCuratedCollectionDetailsState> emit,
  ) async {
    final collectionId = state.collectionId;
    if (collectionId == null ||
        event.page == state.currentPage ||
        event.page < 1 ||
        event.page > state.totalPages) {
      return;
    }

    await _fetchCollectionDetails(
      emit,
      collectionId: collectionId,
      page: event.page,
      searchQuery: state.searchQuery,
      showLoader: false,
    );
  }

  Future<void> _fetchCollectionDetails(
    Emitter<AiCuratedCollectionDetailsState> emit, {
    required int collectionId,
    required int page,
    int? perPage,
    String? searchQuery,
    required bool showLoader,
  }) async {
    final nextPage = page < 1 ? 1 : page;
    final resolvedSearchQuery = (searchQuery ?? state.searchQuery).trim();
    final requestId = ++_requestSequence;
    _activeRequestToken?.cancel();
    final cancelToken = CancelToken();
    _activeRequestToken = cancelToken;
    final hasVisibleCollection = state.collection != null;

    emit(
      state.copyWith(
        status: showLoader || !hasVisibleCollection
            ? AiCuratedCollectionDetailsStatus.loading
            : AiCuratedCollectionDetailsStatus.success,
        collectionId: collectionId,
        currentPage: nextPage,
        clearCollection: showLoader || !hasVisibleCollection,
        searchQuery: resolvedSearchQuery,
        isRefreshing: hasVisibleCollection && !showLoader,
        clearErrorMessage: true,
      ),
    );

    try {
      final response = await _repository.getAiCuratedCollectionDetails(
        collectionId: collectionId,
        page: nextPage,
        perPage: perPage,
        searchQuery: resolvedSearchQuery,
        cancelToken: cancelToken,
      );

      if (requestId != _requestSequence) {
        return;
      }

      final collection = response.data;
      if (collection?.outfit?.id == null) {
        emit(
          state.copyWith(
            status: AiCuratedCollectionDetailsStatus.failure,
            errorMessage:
                response.message ??
                localizedString(
                  fallback: 'Unable to load curated collection details',
                  select: (l10n) => l10n.shopUnableToLoadCollectionDetails,
                ),
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: AiCuratedCollectionDetailsStatus.success,
          collectionId: collectionId,
          collection: collection,
          currentPage:
              collection?.products?.pagination?.currentPage ?? nextPage,
          totalPages: collection?.products?.pagination?.lastPage ?? 1,
          totalItems:
              collection?.products?.pagination?.total ??
              collection?.items.length ??
              0,
          isRefreshing: false,
          clearErrorMessage: true,
        ),
      );
    } on DioException catch (error) {
      if (error.type == DioExceptionType.cancel ||
          requestId != _requestSequence) {
        return;
      }

      emit(
        state.copyWith(
          status: state.collection == null
              ? AiCuratedCollectionDetailsStatus.failure
              : AiCuratedCollectionDetailsStatus.success,
          currentPage: nextPage,
          isRefreshing: false,
          errorMessage: _resolveErrorMessage(error),
        ),
      );
    } catch (_) {
      if (requestId != _requestSequence) {
        return;
      }

      emit(
        state.copyWith(
          status: state.collection == null
              ? AiCuratedCollectionDetailsStatus.failure
              : AiCuratedCollectionDetailsStatus.success,
          currentPage: nextPage,
          isRefreshing: false,
          errorMessage: localizedString(
            fallback: 'Unable to load curated collection details',
            select: (l10n) => l10n.shopUnableToLoadCollectionDetails,
          ),
        ),
      );
    }
  }

  String _resolveErrorMessage(DioException error) {
    final responseData = error.response?.data;
    if (responseData is Map<String, dynamic>) {
      final message = responseData['message']?.toString().trim();
      if (message != null && message.isNotEmpty) {
        return message;
      }
    }

    return error.message?.trim().isNotEmpty == true
        ? error.message!.trim()
        : localizedString(
            fallback: 'Unable to load curated collection details',
            select: (l10n) => l10n.shopUnableToLoadCollectionDetails,
          );
  }

  @override
  Future<void> close() {
    _activeRequestToken?.cancel();
    return super.close();
  }
}
