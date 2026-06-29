import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_error_resolver.dart';
import 'package:drip_talk/core/services/api/dio_client.dart';
import 'package:drip_talk/core/utils/routes/auth_guard.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_repository.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_session_repository.dart';
import 'package:drip_talk/features/auth/biometric/data/models/biometric_auth_models.dart';
import 'package:drip_talk/features/auth/biometric/data/repository/biometric_auth_repository.dart';
import 'package:drip_talk/features/dashboard/profile/data/models/profile_model.dart';
import 'package:drip_talk/features/dashboard/profile/data/repository/profile_repository.dart';
import 'package:drip_talk/features/auth/biometric/domain/bloc/biometric_auth_event.dart';
import 'package:drip_talk/features/auth/biometric/domain/bloc/biometric_auth_state.dart';
import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BiometricAuthBloc extends Bloc<BiometricAuthEvent, BiometricAuthState> {
  BiometricAuthBloc(
    this._biometricAuthRepository,
    this._authRepository,
    this._authSessionRepository,
    this._dioClient,
    this._profileRepository,
  ) : super(const BiometricAuthState()) {
    on<InitializeBiometricAuthRequested>(_onInitializeRequested);
    on<BiometricLoginRequested>(_onBiometricLoginRequested);
  }

  final BiometricAuthRepository _biometricAuthRepository;
  final AuthRepository _authRepository;
  final AuthSessionRepository _authSessionRepository;
  final DioClient _dioClient;
  final ProfileRepository _profileRepository;

  Future<void> _onInitializeRequested(
    InitializeBiometricAuthRequested event,
    Emitter<BiometricAuthState> emit,
  ) async {
    emit(
      state.copyWith(status: BiometricAuthStatus.loading, clearMessage: true),
    );

    try {
      final availability = await _biometricAuthRepository.getAvailability();
      final isEnabled = await _biometricAuthRepository
          .isBiometricLoginEnabled();
      final hasSavedSession = await _biometricAuthRepository
          .hasEnabledBiometricSession();

      emit(
        state.copyWith(
          status: availability.isAvailable
              ? BiometricAuthStatus.ready
              : BiometricAuthStatus.unavailable,
          availability: availability,
          isEnabled: isEnabled,
          hasSavedSession: hasSavedSession,
          clearMessage: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: BiometricAuthStatus.failure,
          message: resolveApiErrorMessage(
            error,
            fallback: localizedString(
              fallback: 'Unable to initialize biometric login.',
              select: (l10n) => l10n.biometricInitializeFailed,
            ),
          ),
        ),
      );
    }
  }

  Future<void> _onBiometricLoginRequested(
    BiometricLoginRequested event,
    Emitter<BiometricAuthState> emit,
  ) async {
    if (state.isBusy) {
      return;
    }

    if (!state.canLoginWithBiometrics) {
      emit(
        state.copyWith(
          status: BiometricAuthStatus.failure,
          message: localizedString(
            fallback: 'Biometric login is not available right now.',
            select: (l10n) => l10n.biometricUnavailable,
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: BiometricAuthStatus.authenticating,
        clearMessage: true,
      ),
    );

    try {
      await _biometricAuthRepository.authenticateOrThrow(
        reason: localizedString(
          fallback: 'Authenticate to sign in to Drip Talk',
          select: (l10n) => l10n.biometricAuthenticateReason,
        ),
      );
      await _restoreBiometricSession();

      emit(
        state.copyWith(
          status: BiometricAuthStatus.success,
          message: localizedString(
            fallback: 'Signed in with biometrics.',
            select: (l10n) => l10n.biometricSignedInSuccess,
          ),
        ),
      );
    } catch (error) {
      if (_shouldResetBiometricSession(error)) {
        await _biometricAuthRepository.disableBiometricLogin();
        await _authSessionRepository.clearAuthenticatedSession();
        _dioClient.clearAuthToken();
        AuthGuard.logout();
        emit(
          state.copyWith(
            status: BiometricAuthStatus.failure,
            message: localizedString(
              fallback:
                  'Your biometric session has expired. Please log in with email and password again.',
              select: (l10n) => l10n.biometricSessionExpired,
            ),
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: BiometricAuthStatus.failure,
          message: resolveApiErrorMessage(
            error,
            fallback: localizedString(
              fallback: 'Biometric authentication failed. Please try again.',
              select: (l10n) => l10n.biometricAuthFailed,
            ),
          ),
        ),
      );
    }
  }

  Future<void> _signInWithStoredCredentials({
    required String email,
    required String password,
  }) async {
    final response = await _authRepository.login(
      email: email,
      password: password,
    );
    final responseUser = response.user;
    final resolvedEmail = responseUser?.email?.trim().isNotEmpty == true
        ? responseUser!.email!.trim()
        : email.trim();
    final emailVerifiedAt = responseUser?.emailVerifiedAt;
    final requiresOtpVerification =
        responseUser != null &&
        (emailVerifiedAt == null || emailVerifiedAt.isEmpty);

    if (requiresOtpVerification) {
      await _authSessionRepository.clearAuthenticatedSession();
      _dioClient.clearAuthToken();
      AuthGuard.logout();
      throw BiometricAuthException(
        localizedString(
          fallback:
              'Verify your email with a manual login before using biometric login.',
          select: (l10n) => l10n.biometricVerifyEmailFirst,
        ),
      );
    }

    if (response.requiresTwoFactor) {
      await _authSessionRepository.clearAuthenticatedSession();
      // Disable biometric login since 2FA is required
      await _biometricAuthRepository.disableBiometricLogin();
      _dioClient.clearAuthToken();
      AuthGuard.logout();
      throw BiometricAuthException(
        localizedString(
          fallback:
              'Your biometric session needs to be refreshed. Log in once with email, password, and 2FA, then try biometric login again.',
          select: (l10n) => l10n.biometricRefreshSessionRequired,
        ),
      );
    }

    final token = response.token?.trim();
    if (token == null || token.isEmpty) {
      throw BiometricAuthException(
        localizedString(
          fallback: 'Authentication token not found. Please log in manually.',
          select: (l10n) => l10n.biometricTokenMissingManualLogin,
        ),
      );
    }

    _dioClient.setAuthToken(token);
    final syncedProfile = await _getValidatedProfile();
    final profileUser = syncedProfile == null || syncedProfile.isEmpty
        ? responseUser?.toJson()
        : syncedProfile.toSessionJson();
    final verifiedAt =
        syncedProfile?.emailVerifiedAt?.toIso8601String() ?? emailVerifiedAt;

    await _authSessionRepository.saveAuthenticatedSession(
      token: token,
      refreshToken: response.refreshToken,
      user: profileUser,
      emailVerifiedAt: verifiedAt,
    );
    await _biometricAuthRepository.refreshBiometricSessionIfEnabled(
      token: token,
      refreshToken: response.refreshToken,
      user: profileUser,
      emailVerifiedAt: verifiedAt,
      email: resolvedEmail,
      password: password,
    );
    AuthGuard.login();
  }

  Future<void> _restoreBiometricSession() async {
    final snapshot = await _biometricAuthRepository
        .getBiometricSessionSnapshot();
    if (snapshot != null && snapshot.isValid) {
      await _restoreFromStoredSessionSnapshot(snapshot: snapshot);
      return;
    }

    final credentials = await _biometricAuthRepository
        .getBiometricLoginCredentials();
    if (credentials?.isValid == true) {
      await _signInWithStoredCredentials(
        email: credentials!.email,
        password: credentials.password,
      );
      return;
    }

    throw BiometricAuthException(
      localizedString(
        fallback: 'No biometric session found. Please log in manually.',
        select: (l10n) => l10n.biometricNoSavedSession,
      ),
    );
  }

  Future<void> _restoreFromStoredSessionSnapshot({
    BiometricSessionSnapshot? snapshot,
  }) async {
    final resolvedSnapshot =
        snapshot ??
        await _biometricAuthRepository.getBiometricSessionSnapshot();
    if (resolvedSnapshot == null || !resolvedSnapshot.isValid) {
      throw BiometricAuthException(
        localizedString(
          fallback: 'No biometric session found. Please log in manually.',
          select: (l10n) => l10n.biometricNoSavedSession,
        ),
      );
    }

    _dioClient.setAuthToken(resolvedSnapshot.token);
    final syncedProfile = await _getValidatedProfile();
    if (syncedProfile == null || syncedProfile.isEmpty) {
      await _authSessionRepository.clearAuthenticatedSession();
      // Disable biometric login since the session has expired
      await _biometricAuthRepository.disableBiometricLogin();
      _dioClient.clearAuthToken();
      AuthGuard.logout();
      throw BiometricAuthException(
        localizedString(
          fallback:
              'Your biometric session has expired. Please log in with email and password again.',
          select: (l10n) => l10n.biometricSessionExpired,
        ),
      );
    }

    final profileUser = syncedProfile.toSessionJson();
    final verifiedAt =
        syncedProfile.emailVerifiedAt?.toIso8601String() ??
        resolvedSnapshot.emailVerifiedAt;

    await _authSessionRepository.saveAuthenticatedSession(
      token: resolvedSnapshot.token,
      refreshToken: resolvedSnapshot.refreshToken,
      user: profileUser,
      emailVerifiedAt: verifiedAt,
    );
    await _biometricAuthRepository.refreshBiometricSessionIfEnabled(
      token: resolvedSnapshot.token,
      refreshToken: resolvedSnapshot.refreshToken,
      user: profileUser,
      emailVerifiedAt: verifiedAt,
    );
    AuthGuard.login();
  }

  Future<ProfileData?> _getValidatedProfile() async {
    final profileResponse = await _profileRepository.getProfile();
    final profile = profileResponse.data;
    if (!profileResponse.isSuccessful || profile == null || profile.isEmpty) {
      return null;
    }
    return profile;
  }

  bool _shouldResetBiometricSession(Object error) {
    if (error is! DioException) {
      return false;
    }

    final statusCode = error.response?.statusCode;
    return statusCode == 401 || statusCode == 403 || statusCode == 422;
  }
}
