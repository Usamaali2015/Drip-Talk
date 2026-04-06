import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_ends_point.dart';
import 'package:drip_talk/core/services/api/api_service.dart';
import 'package:drip_talk/features/wishlist/data/models/wishlist_model.dart';

class WishlistRepository {
  WishlistRepository(this._apiService);

  final ApiService _apiService;

  Future<WishListModel> getWishlist({
    int page = 1,
    int perPage = 20,
    String? sort,
    CancelToken? cancelToken,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      if (sort != null && sort.trim().isNotEmpty) 'sort': sort.trim(),
    };

    final response = await _apiService.get(
      ApiEndpoints.wishlist,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );

    return WishListModel.fromJson(_asJsonMap(response.data));
  }

  Future<WishlistActionResponse> toggleWishlist({
    required int productId,
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.wishlistToggle,
      data: {'product_id': productId},
      cancelToken: cancelToken,
    );

    return WishlistActionResponse.fromJson(_asJsonMap(response.data));
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
