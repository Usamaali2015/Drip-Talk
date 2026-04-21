import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_error_resolver.dart';
import 'package:drip_talk/core/services/api/api_exceptions.dart';
import 'package:drip_talk/core/services/api/dio_client.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_session_repository.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_repository.dart';
import 'package:drip_talk/features/auth/biometric/data/repository/biometric_auth_repository.dart';
import 'package:drip_talk/features/auth/two_factor/data/models/login_two_factor_challenge.dart';
import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:drip_talk/core/utils/routes/auth_guard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;
  final AuthSessionRepository _authSessionRepository;
  final DioClient _dioClient;
  final BiometricAuthRepository _biometricAuthRepository;

  LoginBloc(
    this._authRepository,
    this._authSessionRepository,
    this._dioClient,
    this._biometricAuthRepository,
  ) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
    on<DeleteAccountRequested>(_onDeleteAccountRequested);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final response = await _authRepository.login(
        email: event.email,
        password: event.password,
      );

      final resolvedEmail = response.user?.email?.trim().isNotEmpty == true
          ? response.user!.email!.trim()
          : event.email.trim();
      final emailVerifiedAt = response.user?.emailVerifiedAt;
      final requiresOtpVerification =
          response.user != null &&
          (emailVerifiedAt == null || emailVerifiedAt.isEmpty);

      if (requiresOtpVerification) {
        await _authSessionRepository.clearAuthenticatedSession();
        await _authSessionRepository.persistEmailVerificationStatus(
          email: resolvedEmail,
          emailVerifiedAt: emailVerifiedAt,
        );
        // Disable biometric login since verification is required
        await _biometricAuthRepository.disableBiometricLogin();
        _dioClient.clearAuthToken();
        AuthGuard.logout();

        emit(
          LoginVerificationRequired(
            email: resolvedEmail,
            message: response.message,
          ),
        );
        return;
      }

      if (response.requiresTwoFactor) {
        final twoFactorToken = response.twoFactorToken?.trim();
        if (twoFactorToken == null || twoFactorToken.isEmpty) {
          emit(
            LoginError(
              localizedString(
                fallback: 'Two-factor verification token not found.',
                select: (l10n) => l10n.twoFactorTokenNotFound,
              ),
            ),
          );
          return;
        }

        await _authSessionRepository.clearAuthenticatedSession();
        // Disable biometric login since 2FA is required
        await _biometricAuthRepository.disableBiometricLogin();
        _dioClient.clearAuthToken();
        AuthGuard.logout();

        emit(
          LoginTwoFactorRequired(
            challenge: LoginTwoFactorChallenge(
              email: resolvedEmail,
              password: event.password.trim(),
              twoFactorToken: twoFactorToken,
            ),
            message: response.message,
          ),
        );
        return;
      }

      final token = response.token;
      if (token != null && token.isNotEmpty) {
        await _biometricAuthRepository.cacheManualLoginCredentials(
          email: resolvedEmail,
          password: event.password.trim(),
        );
        await _authSessionRepository.saveAuthenticatedSession(
          token: token,
          refreshToken: response.refreshToken,
          user: response.user?.toJson(),
          emailVerifiedAt: emailVerifiedAt,
        );
        await _biometricAuthRepository.refreshBiometricSessionIfEnabled(
          token: token,
          refreshToken: response.refreshToken,
          user: response.user?.toJson(),
          emailVerifiedAt: emailVerifiedAt,
          email: resolvedEmail,
          password: event.password.trim(),
        );

        _dioClient.setAuthToken(token);
        AuthGuard.login();

        emit(LoginSuccess(message: response.message));
      } else {
        emit(
          LoginError(
            localizedString(
              fallback: 'Authentication token not found.',
              select: (l10n) => l10n.authTokenNotFound,
            ),
          ),
        );
      }
    } catch (e) {
      emit(LoginError(_resolveErrorMessage(e)));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(LoginLoading());

      final shouldPreserveBiometricSession =
          await _shouldPreserveBiometricSessionOnLogout();
      final token = await _authSessionRepository.getAuthToken();
      if (!shouldPreserveBiometricSession &&
          token != null &&
          token.isNotEmpty) {
        _dioClient.setAuthToken(token);
      }

      final response =
          shouldPreserveBiometricSession || token == null || token.isEmpty
          ? null
          : await _authRepository.logout();

      await _authSessionRepository.clearPendingVerification();
      await _authSessionRepository.clearAuthenticatedSession();
      if (!shouldPreserveBiometricSession) {
        await _biometricAuthRepository.disableBiometricLogin();
      }
      _dioClient.clearAuthToken();
      AuthGuard.logout();

      emit(
        LogoutSuccess(
          message:
              response?.message ??
              localizedString(
                fallback: 'Logged out successfully.',
                select: (l10n) => l10n.logoutSuccessMessage,
              ),
        ),
      );
    } catch (e) {
      emit(LoginError(_resolveErrorMessage(e)));
    }
  }

  Future<bool> _shouldPreserveBiometricSessionOnLogout() async {
    final biometricEnabled = await _biometricAuthRepository
        .isBiometricLoginEnabled();
    if (!biometricEnabled) {
      return false;
    }

    return _biometricAuthRepository.hasEnabledBiometricSession();
  }

  Future<void> _onDeleteAccountRequested(
    DeleteAccountRequested event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(DeleteAccountLoading());

      final token = await _authSessionRepository.getAuthToken();
      if (token != null && token.isNotEmpty) {
        _dioClient.setAuthToken(token);
      }

      final response = await _authRepository.deleteAccountWithCredentials(
        email: event.email.trim(),
        password: event.password,
      );

      await _authSessionRepository.clearPendingVerification();
      await _authSessionRepository.clearAuthenticatedSession();
      await _biometricAuthRepository.disableBiometricLogin();
      _dioClient.clearAuthToken();
      AuthGuard.logout();

      emit(
        DeleteAccountSuccess(
          message:
              response.message ??
              localizedString(
                fallback: 'Account deleted successfully.',
                select: (l10n) => l10n.deleteAccountSuccessMessage,
              ),
        ),
      );
    } catch (e) {
      emit(DeleteAccountError(_resolveErrorMessage(e)));
    }
  }

  String _resolveErrorMessage(Object error) {
    if (error is DioException) {
      if (error.error is ApiException) {
        return (error.error as ApiException).message;
      }
    }
    return resolveApiErrorMessage(
      error,
      fallback: localizedString(
        fallback: 'An unexpected error occurred',
        select: (l10n) => l10n.unexpectedErrorOccurred,
      ),
    );
  }
}
