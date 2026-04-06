import 'package:dio/dio.dart';
import 'package:drip_talk/features/shop/data/models/ai_curated_model.dart';
import 'package:drip_talk/features/shop/data/models/shop_model.dart';
import 'package:drip_talk/features/shop/domain/shop_filters.dart';
import 'package:drip_talk/features/shop/domain/shop_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drip_talk/features/shop/domain/shop_event.dart';
import 'package:drip_talk/features/shop/data/repository/shop_repository.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final ShopRepository _repository;
  CancelToken? _activeRequestToken;
  CancelToken? _collectionsRequestToken;
  int _requestSequence = 0;
  int _collectionsRequestSequence = 0;

  ShopBloc(this._repository) : super(const ShopState()) {
    on<LoadShopData>(_onLoadShopData);
    on<SelectCategory>(_onSelectCategory);
    on<ChangePage>(_onChangePage);
    on<SearchProducts>(_onSearchProducts);
    on<ApplyShopFilters>(_onApplyShopFilters);
    on<ResetShopFilters>(_onResetShopFilters);
    on<RefreshShopData>(_onRefreshShopData);
    on<LoadAiCuratedCollections>(_onLoadAiCuratedCollections);
    on<ChangeCuratedCollectionsPage>(_onChangeCuratedCollectionsPage);
  }

  Future<void> _fetchData(Emitter<ShopState> emit, ShopFilters filters) async {
    final nextFilters = filters.normalized();
    final hasVisibleProducts = state.products.isNotEmpty;
    final requestId = ++_requestSequence;

    _activeRequestToken?.cancel();
    final cancelToken = CancelToken();
    _activeRequestToken = cancelToken;

    emit(
      state.copyWith(
        status: hasVisibleProducts ? ShopStatus.success : ShopStatus.loading,
        filters: nextFilters,
        isRefreshing: hasVisibleProducts,
      ),
    );

    try {
      final response = await _repository.getProducts(
        filters: nextFilters,
        cancelToken: cancelToken,
      );

      if (requestId != _requestSequence) {
        return;
      }

      final items = response.data?.items ?? [];

      emit(
        state.copyWith(
          status: ShopStatus.success,
          products: items,
          categories: _mergeCategories(state.categories, items),
          filters: nextFilters.copyWith(
            page:
                response.data?.pagination?.currentPage?.toInt() ??
                nextFilters.page,
          ),
          totalPages: response.data?.pagination?.lastPage?.toInt() ?? 1,
          isRefreshing: false,
        ),
      );
    } on DioException catch (error) {
      if (error.type == DioExceptionType.cancel ||
          requestId != _requestSequence) {
        return;
      }

      emit(
        state.copyWith(
          status: ShopStatus.failure,
          filters: nextFilters,
          isRefreshing: false,
        ),
      );
    } catch (_) {
      if (requestId != _requestSequence) {
        return;
      }

      emit(
        state.copyWith(
          status: ShopStatus.failure,
          filters: nextFilters,
          isRefreshing: false,
        ),
      );
    }
  }

  Future<void> _onLoadShopData(
    LoadShopData event,
    Emitter<ShopState> emit,
  ) async {
    if (state.curatedCollections.isEmpty &&
        state.collectionsStatus != ShopCollectionsStatus.loading) {
      add(const LoadAiCuratedCollections());
    }

    final filters = (event.filters ?? state.filters).copyWith(page: 1);
    await _fetchData(emit, filters);
  }

  Future<void> _onSelectCategory(
    SelectCategory event,
    Emitter<ShopState> emit,
  ) async {
    if (event.categoryId == state.selectedCategoryId) {
      return;
    }

    final nextFilters = state.filters.copyWith(
      category: event.categoryId == ShopFilters.allCategoryValue
          ? null
          : event.categoryId,
      page: 1,
    );

    await _fetchData(emit, nextFilters);
  }

  Future<void> _onChangePage(ChangePage event, Emitter<ShopState> emit) async {
    if (event.page == state.currentPage) {
      return;
    }

    await _fetchData(emit, state.filters.copyWith(page: event.page));
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ShopState> emit,
  ) async {
    final normalizedQuery = event.query.trim();
    final nextQuery = normalizedQuery.isEmpty ? null : normalizedQuery;

    if (nextQuery == state.filters.search) {
      return;
    }

    await _fetchData(emit, state.filters.copyWith(search: nextQuery, page: 1));
  }

  Future<void> _onApplyShopFilters(
    ApplyShopFilters event,
    Emitter<ShopState> emit,
  ) async {
    final nextFilters = event.resetPage
        ? event.filters.copyWith(page: 1)
        : event.filters;

    if (nextFilters == state.filters) {
      return;
    }

    await _fetchData(emit, nextFilters);
  }

  Future<void> _onResetShopFilters(
    ResetShopFilters event,
    Emitter<ShopState> emit,
  ) async {
    const defaultFilters = ShopFilters();
    if (state.filters == defaultFilters) {
      return;
    }

    await _fetchData(emit, defaultFilters);
  }

  Future<void> _onRefreshShopData(
    RefreshShopData event,
    Emitter<ShopState> emit,
  ) async {
    await _fetchAiCuratedCollections(emit, page: state.collectionsCurrentPage);
    await _fetchData(emit, state.filters);
  }

  Future<void> _onLoadAiCuratedCollections(
    LoadAiCuratedCollections event,
    Emitter<ShopState> emit,
  ) async {
    await _fetchAiCuratedCollections(
      emit,
      page: event.page,
      perPage: event.perPage,
      searchQuery: event.searchQuery,
    );
  }

  Future<void> _onChangeCuratedCollectionsPage(
    ChangeCuratedCollectionsPage event,
    Emitter<ShopState> emit,
  ) async {
    if (event.page == state.collectionsCurrentPage ||
        event.page < 1 ||
        event.page > state.collectionsTotalPages) {
      return;
    }

    await _fetchAiCuratedCollections(
      emit,
      page: event.page,
      searchQuery: event.searchQuery,
    );
  }

  Future<void> _fetchAiCuratedCollections(
    Emitter<ShopState> emit, {
    required int page,
    int? perPage,
    String? searchQuery,
  }) async {
    final nextPage = page < 1 ? 1 : page;
    final hasVisibleCollections = state.curatedCollections.isNotEmpty;
    final requestId = ++_collectionsRequestSequence;
    _collectionsRequestToken?.cancel();
    final cancelToken = CancelToken();
    _collectionsRequestToken = cancelToken;

    emit(
      state.copyWith(
        collectionsStatus: hasVisibleCollections
            ? ShopCollectionsStatus.success
            : ShopCollectionsStatus.loading,
        collectionsCurrentPage: nextPage,
        isCollectionsRefreshing: hasVisibleCollections,
      ),
    );

    try {
      final response = await _repository.getAiCuratedCollections(
        page: nextPage,
        perPage: perPage,
        searchQuery: searchQuery,
        cancelToken: cancelToken,
      );

      if (requestId != _collectionsRequestSequence) {
        return;
      }

      final pagination = response.data?.pagination;

      emit(
        state.copyWith(
          curatedCollections: response.data?.items ?? const <AiCuratedItem>[],
          collectionsStatus: ShopCollectionsStatus.success,
          collectionsCurrentPage: pagination?.currentPage ?? nextPage,
          collectionsTotalPages: pagination?.lastPage ?? 1,
          collectionsTotalItems: pagination?.total ?? 0,
          isCollectionsRefreshing: false,
        ),
      );
    } on DioException catch (error) {
      if (error.type == DioExceptionType.cancel ||
          requestId != _collectionsRequestSequence) {
        return;
      }

      emit(
        state.copyWith(
          collectionsStatus: ShopCollectionsStatus.failure,
          collectionsCurrentPage: nextPage,
          isCollectionsRefreshing: false,
        ),
      );
    } catch (_) {
      if (requestId != _collectionsRequestSequence) {
        return;
      }

      emit(
        state.copyWith(
          collectionsStatus: ShopCollectionsStatus.failure,
          collectionsCurrentPage: nextPage,
          isCollectionsRefreshing: false,
        ),
      );
    }
  }

  List<Category> _mergeCategories(
    List<Category> currentCategories,
    List<Items> items,
  ) {
    final mergedCategories = <Category>[Category(id: -1)];
    final seenIds = <String>{'-1'};

    for (final category in currentCategories) {
      final id = category.id?.toString();
      if (id == null || !seenIds.add(id)) {
        continue;
      }
      mergedCategories.add(category);
    }

    for (final item in items) {
      final category = item.category;
      final id = category?.id?.toString();
      if (id == null || !seenIds.add(id)) {
        continue;
      }
      mergedCategories.add(category!);
    }

    return mergedCategories;
  }

  @override
  Future<void> close() {
    _activeRequestToken?.cancel();
    _collectionsRequestToken?.cancel();
    return super.close();
  }
}
