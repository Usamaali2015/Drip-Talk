import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_ends_point.dart';
import 'package:drip_talk/core/services/api/api_service.dart';
import 'package:drip_talk/features/auth/profile_setup/data/models/brands_model.dart';

class ProfileSetupBrandsRepository {
  ProfileSetupBrandsRepository(this._apiService);

  final ApiService _apiService;

  Future<BrandsModel> getBrands({CancelToken? cancelToken}) async {
    final response = await _apiService.get(
      ApiEndpoints.brands,
      cancelToken: cancelToken,
    );

    return BrandsModel.fromJson(_asMap(response.data));
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
