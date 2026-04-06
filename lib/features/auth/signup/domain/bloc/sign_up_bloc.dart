import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_exceptions.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_session_repository.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_repository.dart';
import 'package:drip_talk/features/auth/signup/domain/bloc/sign_up_state.dart';
import 'package:drip_talk/features/auth/signup/domain/bloc/signup_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository _authRepository;
  final AuthSessionRepository _authSessionRepository;

  SignUpBloc(this._authRepository, this._authSessionRepository)
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

      final resolvedEmail =
          response.user?.email?.trim().isNotEmpty == true
              ? response.user!.email!.trim()
              : event.email.trim();
      final emailVerifiedAt = response.user?.emailVerifiedAt;
      final requiresOtpVerification =
          emailVerifiedAt == null || emailVerifiedAt.isEmpty;

      await _authSessionRepository.persistEmailVerificationStatus(
        email: resolvedEmail,
        emailVerifiedAt: emailVerifiedAt,
      );

      emit(
        SignUpSuccess(
          email: resolvedEmail,
          requiresOtpVerification: requiresOtpVerification,
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
      return error.message ?? 'Network Error';
    }

    return error.toString();
  }
}
