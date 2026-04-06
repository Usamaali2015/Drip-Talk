import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_ends_point.dart';
import 'package:drip_talk/core/services/api/api_service.dart';
import 'package:drip_talk/features/cart/data/models/cart_model.dart';

class CartRepository {
  CartRepository(this._apiService);

  final ApiService _apiService;

  Future<CartResponseModel> getCart({CancelToken? cancelToken}) async {
    final response = await _apiService.get(
      ApiEndpoints.cart,
      cancelToken: cancelToken,
    );
    return CartResponseModel.fromJson(_asJsonMap(response.data));
  }

  Future<CartResponseModel> addToCart({
    required int productVariantId,
    required int quantity,
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.cartAdd,
      data: {'product_variant_id': productVariantId, 'quantity': quantity},
      cancelToken: cancelToken,
    );
    return CartResponseModel.fromJson(_asJsonMap(response.data));
  }

  Future<CartResponseModel> updateCartItem({
    required int cartItemId,
    required int quantity,
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.cartUpdate,
      data: {'cart_item_id': cartItemId, 'quantity': quantity},
      cancelToken: cancelToken,
    );
    return CartResponseModel.fromJson(_asJsonMap(response.data));
  }

  Future<CartResponseModel> removeCartItem({
    required int cartItemId,
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.cartRemove,
      data: {'cart_item_id': cartItemId},
      cancelToken: cancelToken,
    );
    return CartResponseModel.fromJson(_asJsonMap(response.data));
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
