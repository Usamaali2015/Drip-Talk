import 'package:drip_talk/core/services/api/api_ends_point.dart';
import 'package:drip_talk/core/services/api/api_service.dart';
import 'package:drip_talk/features/shop/data/models/ai_collection_details_model.dart';
import 'package:drip_talk/features/shop/data/models/ai_curated_model.dart';
import 'package:drip_talk/features/shop/data/models/shop_model.dart';
import 'package:drip_talk/features/shop/domain/shop_filters.dart';
import 'package:dio/dio.dart';

class ShopRepository {
  final ApiService _apiService;

  ShopRepository(this._apiService);

  Future<ShopModel> getProducts({
    required ShopFilters filters,
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.products,
      queryParameters: filters.toQueryParameters(),
      cancelToken: cancelToken,
    );
    return ShopModel.fromJson(response.data);
  }

  Future<AiCuratedModel> getAiCuratedCollections({
    int page = 1,
    int? perPage,
    String? searchQuery,
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.collections,
      queryParameters: {
        'page': page,
        if (perPage != null) 'per_page': perPage,
        if (searchQuery != null && searchQuery.trim().isNotEmpty)
          'search': searchQuery.trim(),
      },
      cancelToken: cancelToken,
    );
    return AiCuratedModel.fromJson(_asJsonMap(response.data));
  }

  Future<AiCollectionDetailsModel> getAiCuratedCollectionDetails({
    required int collectionId,
    int page = 1,
    int? perPage,
    String? searchQuery,
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.collectionDetails(collectionId),
      queryParameters: {
        'page': page,
        if (perPage != null) 'per_page': perPage,
        if (searchQuery != null && searchQuery.trim().isNotEmpty)
          'search': searchQuery.trim(),
      },
      cancelToken: cancelToken,
    );

    return AiCollectionDetailsModel.fromJson(_asJsonMap(response.data));
  }

  Map<String, dynamic>? _asJsonMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
    }

    return null;
  }
}
