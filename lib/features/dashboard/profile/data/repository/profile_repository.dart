import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_constants.dart';
import 'package:drip_talk/core/services/api/api_ends_point.dart';
import 'package:drip_talk/core/services/api/api_service.dart';
import 'package:drip_talk/core/utils/app_utils/logger.dart';
import 'package:drip_talk/features/dashboard/profile/data/models/profile_model.dart';
import 'package:drip_talk/features/dashboard/profile/data/models/profile_update_response_model.dart';
import 'package:drip_talk/features/dashboard/profile/data/models/update_profile_request_model.dart';
import 'package:flutter/foundation.dart';

class ProfileRepository {
  ProfileRepository(this._apiService);

  final ApiService _apiService;

  Future<ProfileResponseModel> getProfile({CancelToken? cancelToken}) async {
    final response = await _apiService.get(
      ApiEndpoints.profile,
      cancelToken: cancelToken,
    );

    return ProfileResponseModel.fromJson(_asMap(response.data));
  }

  Future<ProfileUpdateResponseModel> updateProfile(
    UpdateProfileRequestModel request, {
    CancelToken? cancelToken,
  }) async {
    try {
      final payload = const JsonEncoder.withIndent(
        '  ',
      ).convert(request.toDebugMap());
      debugPrint(
        'POST ${ApiEndpoints.accountUpdate}\nProfile update payload:\n$payload',
      );
      AppLogger.log(
        'POST ${ApiEndpoints.accountUpdate}\nProfile update payload:\n$payload',
        name: 'PROFILE_UPDATE',
      );

      final response = await _apiService.post(
        ApiEndpoints.accountUpdate,
        data: await request.toFormData(),
        options: Options(contentType: ApiConstants.multiPart),
        cancelToken: cancelToken,
      );

      return ProfileUpdateResponseModel.fromJson(_asMap(response.data));
    } on DioException catch (error) {
      final responseData = error.response?.data;
      debugPrint(
        'Profile update request failed:\n'
        'message: ${error.message}\n'
        'statusCode: ${error.response?.statusCode}\n'
        'response: ${responseData is String ? responseData : jsonEncode(responseData)}',
      );
      AppLogger.error('Profile update request failed', error);
      rethrow;
    } catch (error) {
      debugPrint('Profile update request failed: $error');
      AppLogger.error('Profile update request failed', error);
      rethrow;
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
