import 'api_barrels.dart';
import 'package:drip_talk/core/services/security/app_attestation_service.dart';
import 'package:drip_talk/core/services/storage/secure_storage.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_session_repository.dart';
import 'package:drip_talk/features/auth/biometric/data/repository/biometric_auth_repository.dart';

class DioClient {
  final Dio dio;
  final Dio _refreshDio;
  final AuthSessionRepository _authSessionRepository;
  final SecureStorage _secureStorage = SecureStorage.instance;

  DioClient(
    this._authSessionRepository,
    BiometricAuthRepository biometricAuthRepository,
    AppAttestationService appAttestationService,
  ) : dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(
            milliseconds: ApiConstants.connectTimeout,
          ),
          receiveTimeout: const Duration(
            milliseconds: ApiConstants.receiveTimeout,
          ),
          headers: ApiConstants.defaultHeaders,
        ),
      ),
      _refreshDio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(
            milliseconds: ApiConstants.connectTimeout,
          ),
          receiveTimeout: const Duration(
            milliseconds: ApiConstants.receiveTimeout,
          ),
          headers: ApiConstants.defaultHeaders,
        ),
      ) {
    _refreshDio.interceptors.addAll([
      RetryInterceptor(dio: _refreshDio),
      NetworkInterceptor(),
    ]);

    dio.interceptors.addAll([
      DioInterceptors(
        authSessionRepository: _authSessionRepository,
        biometricAuthRepository: biometricAuthRepository,
        appAttestationService: appAttestationService,
        refreshDio: _refreshDio,
        setAuthToken: setAuthToken,
        clearAuthToken: clearAuthToken,
      ),
      RetryInterceptor(dio: dio),
      NetworkInterceptor(),
    ]);
  }

  void setAuthToken(String token) {
    dio.options.headers[ApiConstants.authorization] =
        '${ApiConstants.bearer} $token';
  }

  void clearAuthToken() {
    dio.options.headers.remove(ApiConstants.authorization);
  }

  Future<void> restoreLanguageCode() async {
    setLanguageCode(await _secureStorage.getLanguageCode());
  }

  void setLanguageCode(String languageCode) {
    final normalizedCode = languageCode.trim().toLowerCase();
    final resolvedCode = normalizedCode.isEmpty ? 'en' : normalizedCode;

    _applyLanguageCode(dio.options, resolvedCode);
    _applyLanguageCode(_refreshDio.options, resolvedCode);
  }

  void _applyLanguageCode(BaseOptions options, String languageCode) {
    final nextQueryParameters = Map<String, dynamic>.from(
      options.queryParameters,
    );
    nextQueryParameters['lang'] = languageCode;
    options.queryParameters = nextQueryParameters;
  }
}
