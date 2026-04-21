import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_error_resolver.dart';
import 'package:drip_talk/core/services/api/api_exceptions.dart';
import 'package:drip_talk/core/services/api/dio_client.dart';
import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:drip_talk/core/utils/routes/auth_guard.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_session_repository.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_repository.dart';
import 'package:drip_talk/features/auth/signup/domain/bloc/sign_up_state.dart';
import 'package:drip_talk/features/auth/signup/domain/bloc/signup_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository _authRepository;
  final AuthSessionRepository _authSessionRepository;
  final DioClient _dioClient;

  SignUpBloc(this._authRepository, this._authSessionRepository, this._dioClient)
    : super(SignUpInitial()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
  }

  Future<void> _onSignUpSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    emit(SignUpLoading());
    try {
      final response = await _authRepository.signUp(
        name: event.name,
        email: event.email,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
      );

      final resolvedEmail = response.user?.email?.trim().isNotEmpty == true
          ? response.user!.email!.trim()
          : event.email.trim();
      final emailVerifiedAt = response.user?.emailVerifiedAt;
      final requiresOtpVerification =
          emailVerifiedAt == null || emailVerifiedAt.isEmpty;
      final token = response.token?.trim();
      var hasAuthenticatedSession = false;

      if (requiresOtpVerification) {
        await _authSessionRepository.savePendingVerificationSession(
          email: resolvedEmail,
          emailVerifiedAt: emailVerifiedAt,
          token: token,
          refreshToken: response.refreshToken,
          user: response.user?.toJson(),
        );
      } else {
        await _authSessionRepository.persistEmailVerificationStatus(
          email: resolvedEmail,
          emailVerifiedAt: emailVerifiedAt,
        );
      }

      if (!requiresOtpVerification && token != null && token.isNotEmpty) {
        await _authSessionRepository.saveAuthenticatedSession(
          token: token,
          refreshToken: response.refreshToken,
          user: response.user?.toJson(),
          emailVerifiedAt: emailVerifiedAt,
        );
        _dioClient.setAuthToken(token);
        AuthGuard.login();
        hasAuthenticatedSession = true;
      }

      emit(
        SignUpSuccess(
          email: resolvedEmail,
          requiresOtpVerification: requiresOtpVerification,
          hasAuthenticatedSession: hasAuthenticatedSession,
          message: response.message,
        ),
      );
    } catch (e) {
      emit(SignUpError(_mapError(e)));
    }
  }

  String _mapError(Object error) {
    if (error is DioException) {
      if (error.error is ApiException) {
        return (error.error as ApiException).message;
      }
    }
    return resolveApiErrorMessage(
      error,
      fallback: localizedString(
        fallback: 'Network Error',
        select: (l10n) => l10n.signupNetworkError,
      ),
    );
  }
}
