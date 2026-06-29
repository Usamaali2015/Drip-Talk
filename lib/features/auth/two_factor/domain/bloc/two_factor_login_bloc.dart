import 'package:drip_talk/core/services/api/api_error_resolver.dart';
import 'package:drip_talk/core/services/api/dio_client.dart';
import 'package:drip_talk/core/utils/routes/auth_guard.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_repository.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_session_repository.dart';
import 'package:drip_talk/features/auth/biometric/data/repository/biometric_auth_repository.dart';
import 'package:drip_talk/features/auth/two_factor/domain/bloc/two_factor_login_event.dart';
import 'package:drip_talk/features/auth/two_factor/domain/bloc/two_factor_login_state.dart';
import 'package:drip_talk/features/dashboard/profile/data/models/profile_model.dart';
import 'package:drip_talk/features/dashboard/profile/data/repository/profile_repository.dart';
import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TwoFactorLoginBloc
    extends Bloc<TwoFactorLoginEvent, TwoFactorLoginState> {
  TwoFactorLoginBloc(
    this._authRepository,
    this._authSessionRepository,
    this._dioClient,
    this._profileRepository,
    this._biometricAuthRepository,
  ) : super(const TwoFactorLoginState()) {
    on<TwoFactorLoginCodeChanged>(_onCodeChanged);
    on<TwoFactorLoginSubmitted>(_onSubmitted);
  }

  final AuthRepository _authRepository;
  final AuthSessionRepository _authSessionRepository;
  final DioClient _dioClient;
  final ProfileRepository _profileRepository;
  final BiometricAuthRepository _biometricAuthRepository;

  void _onCodeChanged(
    TwoFactorLoginCodeChanged event,
    Emitter<TwoFactorLoginState> emit,
  ) {
    emit(
      state.copyWith(
        code: event.code,
        submissionStatus: TwoFactorLoginSubmissionStatus.initial,
        clearFeedbackMessage: true,
      ),
    );
  }

  Future<void> _onSubmitted(
    TwoFactorLoginSubmitted event,
    Emitter<TwoFactorLoginState> emit,
  ) async {
    final code = state.code.trim();
    if (state.isLoading) {
      return;
    }

    if (code.length != 6) {
      emit(
        state.copyWith(
          hasAttemptedSubmit: true,
          submissionStatus: TwoFactorLoginSubmissionStatus.failure,
          feedbackMessage: localizedString(
            fallback: 'Enter the 6-digit code from your authenticator app.',
            select: (l10n) => l10n.twoFactorEnterAuthenticatorCode,
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        hasAttemptedSubmit: true,
        submissionStatus: TwoFactorLoginSubmissionStatus.loading,
        clearFeedbackMessage: true,
      ),
    );

    try {
      final response = await _authRepository.verifyTwoFactor(
        twoFactorToken: event.challenge.twoFactorToken,
        code: code,
      );

      final token = response.token?.trim();
      if (token == null || token.isEmpty) {
        emit(
          state.copyWith(
            submissionStatus: TwoFactorLoginSubmissionStatus.failure,
            feedbackMessage: localizedString(
              fallback: 'Authentication token not found.',
              select: (l10n) => l10n.authTokenNotFound,
            ),
          ),
        );
        return;
      }

      _dioClient.setAuthToken(token);
      final syncedProfile = await _getValidatedProfile();
      final profileUser = syncedProfile == null || syncedProfile.isEmpty
          ? response.user?.toJson()
          : syncedProfile.toSessionJson();
      final emailVerifiedAt =
          syncedProfile?.emailVerifiedAt?.toIso8601String() ??
          response.user?.emailVerifiedAt;

      await _biometricAuthRepository.cacheManualLoginCredentials(
        email: event.challenge.email,
        password: event.challenge.password,
      );
      await _authSessionRepository.saveAuthenticatedSession(
        token: token,
        refreshToken: response.refreshToken,
        user: profileUser,
        emailVerifiedAt: emailVerifiedAt,
      );
      await _biometricAuthRepository.refreshBiometricSessionIfEnabled(
        token: token,
        refreshToken: response.refreshToken,
        user: profileUser,
        emailVerifiedAt: emailVerifiedAt,
        email: event.challenge.email,
        password: event.challenge.password,
      );
      AuthGuard.login();

      emit(
        state.copyWith(
          submissionStatus: TwoFactorLoginSubmissionStatus.success,
          feedbackMessage:
              response.message ??
              localizedString(
                fallback: 'Two-factor authentication verified successfully.',
                select: (l10n) => l10n.twoFactorVerifiedSuccessMessage,
              ),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          submissionStatus: TwoFactorLoginSubmissionStatus.failure,
          feedbackMessage: resolveApiErrorMessage(
            error,
            fallback: localizedString(
              fallback: 'Unable to verify two-factor authentication.',
              select: (l10n) => l10n.twoFactorVerificationFailed,
            ),
          ),
        ),
      );
    }
  }

  Future<ProfileData?> _getValidatedProfile() async {
    final profileResponse = await _profileRepository.getProfile();
    final profile = profileResponse.data;
    if (!profileResponse.isSuccessful || profile == null || profile.isEmpty) {
      return null;
    }
    return profile;
  }
}
