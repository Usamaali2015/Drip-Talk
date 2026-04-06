import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_ends_point.dart';
import 'package:drip_talk/core/services/api/api_service.dart';
import 'package:drip_talk/features/product/data/models/product_details_model.dart';

class ProductRepository {
  ProductRepository(this._apiService);

  final ApiService _apiService;

  Future<ProductDetailsModel> getProductDetails({
    required int productId,
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.productDetails(productId),
      cancelToken: cancelToken,
    );

    return ProductDetailsModel.fromJson(response.data as Map<String, dynamic>?);
  }
}
