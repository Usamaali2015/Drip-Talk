import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_ends_point.dart';
import 'package:drip_talk/core/services/api/api_service.dart';
import 'package:drip_talk/features/legal_pages/data/models/legal_page_model.dart';
import 'package:drip_talk/features/legal_pages/legal_page_type.dart';

class LegalPagesRepository {
  LegalPagesRepository(this._apiService);

  final ApiService _apiService;

  Future<LegalPageModel> getPage(
    LegalPageType pageType, {
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.get(
      _resolveEndpoint(pageType),
      cancelToken: cancelToken,
    );

    return LegalPageModel.fromJson(_asMap(response.data));
  }

  String _resolveEndpoint(LegalPageType pageType) {
    switch (pageType) {
      case LegalPageType.privacyPolicy:
        return ApiEndpoints.privacyPolicyPage;
      case LegalPageType.termsAndConditions:
        return ApiEndpoints.termsAndConditionsPage;
    }
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
