import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_ends_point.dart';
import 'package:drip_talk/core/services/api/api_service.dart';
import 'package:drip_talk/features/help_center/data/models/help_center_model.dart';

class HelpCenterRepository {
  HelpCenterRepository(this._apiService);

  final ApiService _apiService;

  Future<HelpCenterModel> getPages({
    int page = 1,
    int? perPage,
    String? type,
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.pages,
      queryParameters: {
        'page': page,
        'per_page': ?perPage,
        if (type != null && type.trim().isNotEmpty) 'type': type.trim(),
      },
      cancelToken: cancelToken,
    );

    return HelpCenterModel.fromJson(_asMap(response.data));
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
