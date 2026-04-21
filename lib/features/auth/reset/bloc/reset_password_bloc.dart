import 'package:drip_talk/core/services/api/api_error_resolver.dart';
import 'package:drip_talk/core/services/api/dio_client.dart';
import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:drip_talk/core/utils/routes/auth_guard.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_response_model.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_repository.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_session_repository.dart';
import 'package:drip_talk/features/auth/auth_repository/password_reset_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'reset_password_event.dart';
import 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final AuthRepository _authRepository;
  final AuthSessionRepository _authSessionRepository;
  final DioClient _dioClient;

  ResetPasswordBloc(
    this._authRepository,
    this._authSessionRepository,
    this._dioClient,
  ) : super(const ResetPasswordState()) {
    on<ResetPasswordPasswordChanged>(_onPasswordChanged);
    on<ResetPasswordConfirmationChanged>(_onConfirmationChanged);
    on<ResetPasswordSubmitted>(_onSubmitted);
  }

  void _onPasswordChanged(
    ResetPasswordPasswordChanged event,
    Emitter<ResetPasswordState> emit,
  ) {
    emit(
      state.copyWith(
        password: event.value,
        submissionStatus: ResetPasswordSubmissionStatus.initial,
        failureReason: ResetPasswordFailureReason.none,
        clearFeedbackMessage: true,
      ),
    );
  }

  void _onConfirmationChanged(
    ResetPasswordConfirmationChanged event,
    Emitter<ResetPasswordState> emit,
  ) {
    emit(
      state.copyWith(
        passwordConfirmation: event.value,
        submissionStatus: ResetPasswordSubmissionStatus.initial,
        failureReason: ResetPasswordFailureReason.none,
        clearFeedbackMessage: true,
      ),
    );
  }

  Future<void> _onSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    final email = event.email.trim();
    final resetToken = event.resetToken.trim();

    if (email.isEmpty || resetToken.isEmpty) {
      emit(
        state.copyWith(
          hasAttemptedSubmit: true,
          submissionStatus: ResetPasswordSubmissionStatus.failure,
          failureReason: ResetPasswordFailureReason.missingSession,
          clearFeedbackMessage: true,
        ),
      );
      return;
    }

    final nextState = state.copyWith(
      hasAttemptedSubmit: true,
      submissionStatus: ResetPasswordSubmissionStatus.initial,
      failureReason: ResetPasswordFailureReason.none,
      clearFeedbackMessage: true,
    );

    if (!nextState.isPasswordValid || !nextState.passwordsMatch) {
      emit(nextState);
      return;
    }

    emit(
      nextState.copyWith(
        submissionStatus: ResetPasswordSubmissionStatus.loading,
        failureReason: ResetPasswordFailureReason.none,
      ),
    );

    try {
      final response = await _authRepository.resetPassword(
        email: email,
        resetToken: resetToken,
        password: state.password,
        passwordConfirmation: state.passwordConfirmation,
      );
      final authResponse = AuthResponseModel.fromResponse(response.data);

      if (event.source == PasswordResetSource.profile) {
        await _syncProfileSession(authResponse);
      }

      emit(
        state.copyWith(
          submissionStatus: ResetPasswordSubmissionStatus.success,
          failureReason: ResetPasswordFailureReason.none,
          clearFeedbackMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          submissionStatus: ResetPasswordSubmissionStatus.failure,
          failureReason: ResetPasswordFailureReason.api,
          feedbackMessage: resolveApiErrorMessage(
            e,
            fallback: localizedString(
              fallback: 'Unable to reset password',
              select: (l10n) => l10n.resetPasswordFailed,
            ),
          ),
        ),
      );
    }
  }

  Future<void> _syncProfileSession(AuthResponseModel authResponse) async {
    final currentToken = await _authSessionRepository.getAuthToken();
    final currentRefreshToken = await _authSessionRepository.getRefreshToken();
    final nextToken = authResponse.token?.trim() ?? currentToken?.trim();
    final nextRefreshToken =
        authResponse.refreshToken?.trim() ?? currentRefreshToken?.trim();
    if (nextToken == null || nextToken.isEmpty) {
      return;
    }

    final currentUser = await _authSessionRepository.getAuthenticatedUser();
    final nextUser = authResponse.user?.toJson() ?? currentUser;
    final emailVerifiedAt =
        authResponse.user?.emailVerifiedAt ??
        await _authSessionRepository.getEmailVerifiedAt();

    await _authSessionRepository.saveAuthenticatedSession(
      token: nextToken,
      refreshToken: nextRefreshToken,
      user: nextUser,
      emailVerifiedAt: emailVerifiedAt,
    );
    _dioClient.setAuthToken(nextToken);
    AuthGuard.login();
  }
}
