import 'package:dio/dio.dart';
import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:drip_talk/features/product/data/models/product_details_model.dart';
import 'package:drip_talk/features/product/data/repository/product_preferences_repository.dart';
import 'package:drip_talk/features/product/data/repository/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(this._repository, this._preferencesRepository)
    : super(const ProductState()) {
    on<LoadProductDetails>(_onLoadProductDetails);
    on<ProductPageChanged>(_onProductPageChanged);
    on<SelectProductSize>(_onSelectProductSize);
    on<SelectProductColor>(_onSelectProductColor);
  }

  final ProductRepository _repository;
  final ProductPreferencesRepository _preferencesRepository;
  CancelToken? _activeRequestToken;
  int _requestSequence = 0;

  Future<void> _onLoadProductDetails(
    LoadProductDetails event,
    Emitter<ProductState> emit,
  ) async {
    final requestId = ++_requestSequence;
    _activeRequestToken?.cancel();
    final cancelToken = CancelToken();
    _activeRequestToken = cancelToken;

    emit(
      state.copyWith(
        status: event.showLoader || state.product == null
            ? ProductStatus.loading
            : state.status,
        productId: event.productId,
        currentIndex: event.showLoader ? 0 : state.currentIndex,
        clearProduct: event.showLoader,
        clearSelectedSize: event.showLoader,
        clearSelectedColor: event.showLoader,
        clearErrorMessage: true,
      ),
    );

    try {
      final response = await _repository.getProductDetails(
        productId: event.productId,
        cancelToken: cancelToken,
      );

      if (requestId != _requestSequence) {
        return;
      }

      final product = response.data;
      if (product == null || product.id == null) {
        emit(
          state.copyWith(
            status: event.showLoader || state.product == null
                ? ProductStatus.failure
                : ProductStatus.success,
            errorMessage:
                response.message ??
                localizedString(
                  fallback: 'Unable to load product details',
                  select: (l10n) => l10n.productUnableToLoad,
                ),
          ),
        );
        return;
      }

      final savedSizeId = await _preferencesRepository.getSelectedSizeId(
        product.id!,
      );
      if (requestId != _requestSequence) {
        return;
      }

      final resolvedSizeId = _resolveSelectedSizeId(product, savedSizeId);
      final resolvedColorId = _resolveSelectedColorId(
        product,
        preferredSizeId: resolvedSizeId,
      );

      emit(
        state.copyWith(
          status: ProductStatus.success,
          product: product,
          currentIndex: 0,
          selectedSizeId: resolvedSizeId,
          selectedColorId: resolvedColorId,
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
          status: event.showLoader || state.product == null
              ? ProductStatus.failure
              : ProductStatus.success,
          errorMessage: _resolveErrorMessage(error),
        ),
      );
    } catch (_) {
      if (requestId != _requestSequence) {
        return;
      }

      emit(
        state.copyWith(
          status: event.showLoader || state.product == null
              ? ProductStatus.failure
              : ProductStatus.success,
          errorMessage: localizedString(
            fallback: 'Unable to load product details',
            select: (l10n) => l10n.productUnableToLoad,
          ),
        ),
      );
    }
  }

  void _onProductPageChanged(
    ProductPageChanged event,
    Emitter<ProductState> emit,
  ) {
    emit(state.copyWith(currentIndex: event.index));
  }

  Future<void> _onSelectProductSize(
    SelectProductSize event,
    Emitter<ProductState> emit,
  ) async {
    final product = state.product;
    if (product == null) {
      return;
    }

    final availableSizes = product.availableSizes;
    final isValidSelection = availableSizes.any(
      (size) => size.id == event.sizeId,
    );
    if (!isValidSelection) {
      return;
    }

    final matchedVariant = _findMatchingVariant(
      product,
      sizeId: event.sizeId,
      colorId: state.selectedColorId,
    );

    emit(
      state.copyWith(
        selectedSizeId: event.sizeId,
        selectedColorId: matchedVariant?.colorId ?? state.selectedColorId,
        currentIndex: 0,
      ),
    );

    final productId = product.id;
    if (productId != null) {
      await _preferencesRepository.saveSelectedSizeId(
        productId: productId,
        sizeId: event.sizeId,
      );
    }
  }

  void _onSelectProductColor(
    SelectProductColor event,
    Emitter<ProductState> emit,
  ) {
    final product = state.product;
    if (product == null) {
      return;
    }

    final availableColors = product.availableColors;
    final isValidSelection = availableColors.any(
      (color) => color.id == event.colorId,
    );
    if (!isValidSelection) {
      return;
    }

    final matchedVariant = _findMatchingVariant(
      product,
      sizeId: state.selectedSizeId,
      colorId: event.colorId,
    );

    emit(
      state.copyWith(
        selectedSizeId: matchedVariant?.sizeId ?? state.selectedSizeId,
        selectedColorId: event.colorId,
        currentIndex: 0,
      ),
    );
  }

  int? _resolveSelectedSizeId(ProductDetailsData? product, int? savedSizeId) {
    final availableSizes =
        product?.availableSizes ?? const <ProductAvailableSize>[];
    final hasSavedSize =
        savedSizeId != null &&
        availableSizes.any((size) => size.id == savedSizeId);
    if (hasSavedSize) {
      return savedSizeId;
    }

    final preferredSizeId =
        product?.selectedVariant?.sizeId ?? _firstVariant(product)?.sizeId;
    if (preferredSizeId != null) {
      return preferredSizeId;
    }

    if (availableSizes.isEmpty) {
      return null;
    }
    return availableSizes.first.id;
  }

  int? _resolveSelectedColorId(
    ProductDetailsData? product, {
    int? preferredSizeId,
  }) {
    final matchedVariant = _findMatchingVariant(
      product,
      sizeId: preferredSizeId,
    );
    if (matchedVariant?.colorId != null) {
      return matchedVariant?.colorId;
    }

    final preferredColorId =
        product?.selectedVariant?.colorId ?? _firstVariant(product)?.colorId;
    if (preferredColorId != null) {
      return preferredColorId;
    }

    final colors = product?.availableColors ?? const <ProductAvailableColor>[];
    if (colors.isEmpty) {
      return null;
    }
    return colors.first.id;
  }

  ProductVariant? _findMatchingVariant(
    ProductDetailsData? product, {
    int? sizeId,
    int? colorId,
  }) {
    final variants = product?.variants ?? const <ProductVariant>[];
    if (variants.isEmpty) {
      return null;
    }

    ProductVariant? sizeMatch;
    ProductVariant? colorMatch;

    for (final variant in variants) {
      final matchesSize = sizeId == null || variant.sizeId == sizeId;
      final matchesColor = colorId == null || variant.colorId == colorId;

      if (matchesSize && matchesColor) {
        return variant;
      }

      if (sizeMatch == null && sizeId != null && variant.sizeId == sizeId) {
        sizeMatch = variant;
      }

      if (colorMatch == null && colorId != null && variant.colorId == colorId) {
        colorMatch = variant;
      }
    }

    return sizeMatch ?? colorMatch ?? variants.first;
  }

  ProductVariant? _firstVariant(ProductDetailsData? product) {
    final variants = product?.variants ?? const <ProductVariant>[];
    if (variants.isEmpty) {
      return null;
    }
    return variants.first;
  }

  String _resolveErrorMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message']?.toString();
      if (message != null && message.trim().isNotEmpty) {
        return message;
      }
    }
    return localizedString(
      fallback: 'Unable to load product details',
      select: (l10n) => l10n.productUnableToLoad,
    );
  }

  @override
  Future<void> close() {
    _activeRequestToken?.cancel();
    return super.close();
  }
}
