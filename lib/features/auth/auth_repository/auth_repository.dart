import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_ends_point.dart';
import 'package:drip_talk/core/services/api/api_service.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_response_model.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<AuthResponseModel> signUp({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.signup,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
      requiresAppAttestation: true,
    );

    return AuthResponseModel.fromResponse(response.data);
  }

  Future<Response> verifyOtp({
    required String email,
    required String otp,
  }) async {
    return await _apiService.post(
      ApiEndpoints.verifyOtp,
      data: {'email': email, 'otp': otp},
      requiresAppAttestation: true,
    );
  }

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
      requiresAppAttestation: true,
    );

    return AuthResponseModel.fromResponse(response.data);
  }

  Future<AuthResponseModel> verifyTwoFactor({
    required String twoFactorToken,
    required String code,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.verifyTwoFactor,
      data: {'two_factor_token': twoFactorToken, 'code': code},
      requiresAppAttestation: true,
    );

    return AuthResponseModel.fromResponse(response.data);
  }

  Future<AuthResponseModel> logout() async {
    final response = await _apiService.post(ApiEndpoints.logout);

    return AuthResponseModel.fromResponse(response.data);
  }

  Future<AuthResponseModel> refreshAccessToken({
    required String refreshToken,
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.refreshToken,
      data: {'refresh_token': refreshToken},
      options: Options(extra: {'skipAuthRefresh': true}),
      cancelToken: cancelToken,
    );

    return AuthResponseModel.fromResponse(response.data);
  }

  Future<AuthResponseModel> deleteAccountWithCredentials({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.delete(
      ApiEndpoints.deleteAccountWithCredentials,
      data: {'email': email, 'password': password},
      requiresAppAttestation: true,
    );

    return AuthResponseModel.fromResponse(response.data);
  }

  Future<Response> sendForgotPasswordOtp(String email) async {
    return await _apiService.post(
      ApiEndpoints.sendForgotPasswordOtp,
      data: {'email': email},
      requiresAppAttestation: true,
    );
  }

  Future<Response> forgotPasswordVerifyOtp({
    required String email,
    required String otp,
  }) async {
    return await _apiService.post(
      ApiEndpoints.forgotPasswordVerifyOtp,
      data: {'email': email, 'otp': otp},
      requiresAppAttestation: true,
    );
  }

  Future<Response> resendOtp(String email) async {
    return await _apiService.post(
      ApiEndpoints.resendOtp,
      data: {'email': email},
      requiresAppAttestation: true,
    );
  }

  Future<Response> resetPassword({
    required String email,
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) async {
    return await _apiService.post(
      ApiEndpoints.resetPassword,
      data: {
        'email': email,
        'reset_token': resetToken,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
      requiresAppAttestation: true,
    );
  }
}
