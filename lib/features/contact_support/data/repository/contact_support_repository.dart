import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_ends_point.dart';
import 'package:drip_talk/core/services/api/api_service.dart';
import 'package:drip_talk/features/contact_support/data/models/contact_support_request_model.dart';
import 'package:drip_talk/features/contact_support/data/models/contact_support_response_model.dart';

class ContactSupportRepository {
  ContactSupportRepository(this._apiService);

  final ApiService _apiService;

  Future<ContactSupportResponseModel> submitSupportRequest(
    ContactSupportRequestModel request, {
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.contactSupport,
      data: request.toJson(),
      cancelToken: cancelToken,
    );

    return ContactSupportResponseModel.fromJson(_asMap(response.data));
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
