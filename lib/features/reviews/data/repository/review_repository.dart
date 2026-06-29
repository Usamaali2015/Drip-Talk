import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_ends_point.dart';
import 'package:drip_talk/core/services/api/api_service.dart';
import 'package:drip_talk/features/reviews/data/models/my_review_model.dart';
import 'package:drip_talk/features/reviews/data/models/review_action_response_model.dart';
import 'package:drip_talk/features/reviews/data/models/review_upsert_request_model.dart';

class ReviewRepository {
  ReviewRepository(this._apiService);

  final ApiService _apiService;

  Future<MyReviewsResponseModel> getReviews({
    int page = 1,
    int perPage = 8,
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.reviews,
      queryParameters: {'page': page, 'per_page': perPage},
      cancelToken: cancelToken,
    );

    return MyReviewsResponseModel.fromJson(_asJsonMap(response.data));
  }

  Future<ReviewActionResponseModel> addReview(
    ReviewUpsertRequestModel request, {
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.addProductReview(request.productId!),
      data: request.toJson(),
      cancelToken: cancelToken,
    );

    return ReviewActionResponseModel.fromJson(_asJsonMap(response.data));
  }

  Future<ReviewActionResponseModel> updateReview({
    required int reviewId,
    required ReviewUpsertRequestModel request,
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.updateReview(reviewId),
      data: request.toJson(),
      cancelToken: cancelToken,
    );

    return ReviewActionResponseModel.fromJson(_asJsonMap(response.data));
  }

  Future<ReviewActionResponseModel> deleteReview(
    int reviewId, {
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.delete(
      ApiEndpoints.deleteReview(reviewId),
      cancelToken: cancelToken,
    );

    return ReviewActionResponseModel.fromJson(_asJsonMap(response.data));
  }
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
