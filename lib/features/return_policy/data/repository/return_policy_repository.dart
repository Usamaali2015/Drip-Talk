import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_ends_point.dart';
import 'package:drip_talk/core/services/api/api_service.dart';
import 'package:drip_talk/features/return_policy/data/models/return_policy_model.dart';

class ReturnPolicyRepository {
  ReturnPolicyRepository(this._apiService);

  final ApiService _apiService;

  Future<ReturnPolicyModel> getReturnPolicy({CancelToken? cancelToken}) async {
    final response = await _apiService.get(
      ApiEndpoints.returnPolicyPage,
      cancelToken: cancelToken,
    );

    return ReturnPolicyModel.fromJson(_asMap(response.data));
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
