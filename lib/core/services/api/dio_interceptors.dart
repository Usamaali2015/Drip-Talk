import 'package:dio/dio.dart';
import 'package:drip_talk/core/common/constants/app_keys.dart';
import 'package:drip_talk/core/services/api/api_constants.dart';
import 'package:drip_talk/core/services/api/api_ends_point.dart';
import 'package:drip_talk/core/services/security/app_attestation_service.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/core/utils/routes/auth_guard.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_response_model.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_session_repository.dart';
import 'package:drip_talk/features/auth/biometric/data/repository/biometric_auth_repository.dart';
import 'package:drip_talk/features/cart/domain/bloc/cart_bloc.dart';
import 'package:drip_talk/features/cart/domain/bloc/cart_event.dart';
import 'package:drip_talk/features/wishlist/domain/bloc/wishlist_bloc.dart';
import 'package:drip_talk/features/wishlist/domain/bloc/wishlist_event.dart';
import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'api_error_resolver.dart';
import 'api_exceptions.dart';

class DioInterceptors extends Interceptor {
  DioInterceptors({
    required AuthSessionRepository authSessionRepository,
    required BiometricAuthRepository biometricAuthRepository,
    required AppAttestationService appAttestationService,
    required Dio refreshDio,
    required void Function(String token) setAuthToken,
    required VoidCallback clearAuthToken,
  }) : _authSessionRepository = authSessionRepository,
       _biometricAuthRepository = biometricAuthRepository,
       _appAttestationService = appAttestationService,
       _refreshDio = refreshDio,
       _setAuthToken = setAuthToken,
       _clearAuthToken = clearAuthToken;

  final AuthSessionRepository _authSessionRepository;
  final BiometricAuthRepository _biometricAuthRepository;
  final AppAttestationService _appAttestationService;
  final Dio _refreshDio;
  final void Function(String token) _setAuthToken;
  final VoidCallback _clearAuthToken;

  bool _isHandlingSessionExpiry = false;
  Future<String?>? _refreshingTokenFuture;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isSecureRequest(options)) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.badCertificate,
          message: 'Insecure network transport is not allowed.',
        ),
      );
      return;
    }

    if (_requiresAppAttestation(options)) {
      final proof = await _attachAppAttestationHeaders(options);
      if (proof == null && _enforcesAppAttestation(options)) {  
        handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.unknown,
            message:
                'App attestation is required for this request but no proof was generated.',
          ),
        );
        return;
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (CancelToken.isCancel(err)) {
      final requestCanceledMessage = localizedString(
        fallback: 'Request canceled',
        select: (l10n) => l10n.requestCanceled,
      );
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          type: DioExceptionType.cancel,
          message: requestCanceledMessage,
          error: ApiException(message: requestCanceledMessage),
          stackTrace: err.stackTrace,
        ),
      );
      return;
    }

    final statusCode = err.response?.statusCode;
    final message = resolveApiErrorMessage(
      err,
      fallback: localizedString(
        fallback: 'Something went wrong',
        select: (l10n) => l10n.somethingWentWrong,
      ),
    );

    if (_shouldAttemptTokenRefresh(err, statusCode: statusCode)) {
      try {
        final refreshedToken = await _refreshAccessToken();
        if (refreshedToken != null && refreshedToken.isNotEmpty) {
          final response = await _retryRequest(
            err.requestOptions,
            refreshedToken,
          );
          handler.resolve(response);
          return;
        }
      } catch (_) {
        // Refresh failed, fall back to clearing the expired session.
      }

      await _handleExpiredSession();
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        message: message,
        error: ApiException(message: message, statusCode: statusCode),
        stackTrace: err.stackTrace,
      ),
    );
  }

  bool _shouldAttemptTokenRefresh(
    DioException error, {
    required int? statusCode,
  }) {
    if (_isHandlingSessionExpiry || statusCode != 401) {
      return false;
    }

    if (error.requestOptions.extra['skipAuthRefresh'] == true ||
        error.requestOptions.extra['authRefreshRetried'] == true) {
      return false;
    }

    return _hasAuthHeader(error.requestOptions);
  }

  bool _hasAuthHeader(RequestOptions options) {
    for (final entry in options.headers.entries) {
      if (entry.key.toString().toLowerCase() !=
          ApiConstants.authorization.toLowerCase()) {
        continue;
      }

      final value = entry.value?.toString().trim();
      return value != null && value.isNotEmpty;
    }

    return false;
  }

  bool _isSecureRequest(RequestOptions options) {
    return options.uri.scheme.toLowerCase() == 'https';
  }

  bool _requiresAppAttestation(RequestOptions options) {
    return options.extra[ApiConstants.requiresAppAttestationExtra] == true;
  }

  bool _enforcesAppAttestation(RequestOptions options) {
    return options.extra[ApiConstants.enforceAppAttestationExtra] == true;
  }

  Future<AppAttestationProof?> _attachAppAttestationHeaders(
    RequestOptions options,
  ) async {
    final nonce = _appAttestationService.createNonce();
    final requestBinding = _appAttestationService.createRequestBinding(
      method: options.method,
      uri: options.uri,
      data: options.data,
    );
    final proof = await _appAttestationService.generateProof(
      nonce: nonce,
      requestBinding: requestBinding,
    );

    options.headers[ApiConstants.appAttestationNonceHeader] = nonce;
    options.headers[ApiConstants.appAttestationBindingHeader] = requestBinding;

    if (proof == null) {
      options.headers[ApiConstants.appAttestationStatusHeader] =
          ApiConstants.appAttestationStatusUnavailable;
      options.headers.remove(ApiConstants.appAttestationAssertionHeader);
      options.headers.remove(ApiConstants.appAttestationProviderHeader);
      options.headers.remove(ApiConstants.appAttestationKeyIdHeader);
      return null;
    }

    options.headers[ApiConstants.appAttestationStatusHeader] =
        ApiConstants.appAttestationStatusPresent;
    options.headers[ApiConstants.appAttestationAssertionHeader] =
        proof.assertion;
    options.headers[ApiConstants.appAttestationProviderHeader] =
        proof.provider;

    if (proof.keyId != null && proof.keyId!.isNotEmpty) {
      options.headers[ApiConstants.appAttestationKeyIdHeader] = proof.keyId;
    } else {
      options.headers.remove(ApiConstants.appAttestationKeyIdHeader);
    }

    return proof;
  }

  Future<String?> _refreshAccessToken() {
    final activeTask = _refreshingTokenFuture;
    if (activeTask != null) {
      return activeTask;
    }

    final task = _performTokenRefresh();
    _refreshingTokenFuture = task;
    task.whenComplete(() {
      if (identical(_refreshingTokenFuture, task)) {
        _refreshingTokenFuture = null;
      }
    });
    return task;
  }

  Future<String?> _performTokenRefresh() async {
    final refreshToken = await _authSessionRepository.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    final response = await _refreshDio.post(
      ApiEndpoints.refreshToken,
      data: {'refresh_token': refreshToken},
      options: Options(extra: {'skipAuthRefresh': true}),
    );
    final authResponse = AuthResponseModel.fromResponse(response.data);
    final nextToken = authResponse.token?.trim();
    if (nextToken == null || nextToken.isEmpty) {
      return null;
    }

    final currentUser = await _authSessionRepository.getAuthenticatedUser();
    final nextUser = authResponse.user?.toJson() ?? currentUser;
    final nextEmailVerifiedAt =
        authResponse.user?.emailVerifiedAt ??
        await _authSessionRepository.getEmailVerifiedAt();
    final nextRefreshToken = authResponse.refreshToken?.trim() ?? refreshToken;

    await _authSessionRepository.saveAuthenticatedSession(
      token: nextToken,
      refreshToken: nextRefreshToken,
      user: nextUser,
      emailVerifiedAt: nextEmailVerifiedAt,
    );
    await _biometricAuthRepository.refreshBiometricSessionIfEnabled(
      token: nextToken,
      refreshToken: nextRefreshToken,
      user: nextUser,
      emailVerifiedAt: nextEmailVerifiedAt,
    );
    _setAuthToken(nextToken);
    AuthGuard.login();
    return nextToken;
  }

  Future<Response<dynamic>> _retryRequest(
    RequestOptions requestOptions,
    String token,
  ) {
    final nextHeaders = Map<String, dynamic>.from(requestOptions.headers);
    nextHeaders[ApiConstants.authorization] = '${ApiConstants.bearer} $token';

    return _refreshDio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      cancelToken: requestOptions.cancelToken,
      onSendProgress: requestOptions.onSendProgress,
      onReceiveProgress: requestOptions.onReceiveProgress,
      options: Options(
        method: requestOptions.method,
        headers: nextHeaders,
        responseType: requestOptions.responseType,
        contentType: requestOptions.contentType,
        receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
        followRedirects: requestOptions.followRedirects,
        validateStatus: requestOptions.validateStatus,
        sendTimeout: requestOptions.sendTimeout,
        receiveTimeout: requestOptions.receiveTimeout,
        extra: <String, dynamic>{
          ...requestOptions.extra,
          'authRefreshRetried': true,
        },
        listFormat: requestOptions.listFormat,
      ),
    );
  }

  Future<void> _handleExpiredSession() async {
    _isHandlingSessionExpiry = true;
    try {
      await _authSessionRepository.clearPendingVerification();
      await _authSessionRepository.clearAuthenticatedSession();
      // Disable biometric login since the session has expired
      await _biometricAuthRepository.disableBiometricLogin();
      _clearAuthToken();

      final context = AppKeys.navigatorKey.currentContext;
      if (context != null && context.mounted) {
        context.read<CartBloc>().add(const ClearCartSession());
        context.read<WishlistBloc>().add(const ClearWishlistSession());
        ToastUtils.show(
          context,
          localizedString(
            fallback: 'Your session has expired. Please log in again.',
            select: (l10n) => l10n.sessionExpiredLoginAgain,
          ),
          type: ToastType.info,
        );
      }

      AuthGuard.logout();
    } finally {
      _isHandlingSessionExpiry = false;
    }
  }
}
