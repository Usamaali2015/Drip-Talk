import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_constants.dart';
import 'package:drip_talk/core/services/api/api_ends_point.dart';
import 'package:drip_talk/core/services/api/api_service.dart';
import 'package:drip_talk/features/wardrobe/data/models/wardrobe_model.dart';
import 'package:drip_talk/features/wardrobe/data/models/wardrobe_request_models.dart';

class WardrobeRepository {
  WardrobeRepository(this._apiService);

  final ApiService _apiService;

  Future<WardrobeResponseModel> getWardrobes({CancelToken? cancelToken}) async {
    final response = await _apiService.get(
      ApiEndpoints.wardrobes,
      cancelToken: cancelToken,
    );

    return WardrobeResponseModel.fromJson(_asMap(response.data));
  }

  Future<WardrobeResponseModel> createWardrobe(
    CreateWardrobeRequestModel request, {
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.wardrobes,
      data: await request.toFormData(),
      options: Options(contentType: ApiConstants.multiPart),
      cancelToken: cancelToken,
    );

    return WardrobeResponseModel.fromJson(_asMap(response.data));
  }

  Future<WardrobeResponseModel> updateWardrobe({
    required int wardrobeId,
    required UpdateWardrobeRequestModel request,
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.wardrobe(wardrobeId),
      data: await request.toFormData(),
      options: Options(contentType: ApiConstants.multiPart),
      cancelToken: cancelToken,
    );

    return WardrobeResponseModel.fromJson(_asMap(response.data));
  }

  Future<WardrobeResponseModel> updateWardrobeItems(
    UpdateWardrobeItemsRequestModel request, {
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.wardrobeItems,
      data: request.toFormData(),
      options: Options(contentType: ApiConstants.multiPart),
      cancelToken: cancelToken,
    );

    return WardrobeResponseModel.fromJson(_asMap(response.data));
  }

  Future<WardrobeResponseModel> deleteWardrobeItems({
    required List<int> itemIds,
    CancelToken? cancelToken,
  }) async {
    final formData = FormData.fromMap({'_method': 'DELETE'});
    for (final itemId in itemIds) {
      formData.fields.add(MapEntry('item_ids[]', '$itemId'));
    }

    final response = await _apiService.post(
      ApiEndpoints.wardrobeItems,
      data: formData,
      options: Options(contentType: ApiConstants.multiPart),
      cancelToken: cancelToken,
    );

    return WardrobeResponseModel.fromJson(_asMap(response.data));
  }

  Future<WardrobeResponseModel> deleteWardrobe({
    required int wardrobeId,
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.wardrobe(wardrobeId),
      data: FormData.fromMap({'_method': 'DELETE'}),
      options: Options(contentType: ApiConstants.multiPart),
      cancelToken: cancelToken,
    );

    return WardrobeResponseModel.fromJson(_asMap(response.data));
  }
}

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
  }

  return null;
}
