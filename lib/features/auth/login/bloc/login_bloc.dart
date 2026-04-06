import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_exceptions.dart';
import 'package:drip_talk/core/services/api/dio_client.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_session_repository.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_repository.dart';
import 'package:drip_talk/core/utils/routes/auth_guard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;
  final AuthSessionRepository _authSessionRepository;
  final DioClient _dioClient;

  LoginBloc(this._authRepository, this._authSessionRepository, this._dioClient)
    : super(LoginInitial()) {
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

      final token = response.token;
      if (token != null && token.isNotEmpty) {
        await _authSessionRepository.saveAuthenticatedSession(
          token: token,
          user: response.user?.toJson(),
          emailVerifiedAt: emailVerifiedAt,
        );

        _dioClient.setAuthToken(token);
        AuthGuard.login();

        emit(LoginSuccess(message: response.message));
      } else {
        emit(LoginError('Authentication token not found.'));
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

      final token = await _authSessionRepository.getAuthToken();
      if (token != null && token.isNotEmpty) {
        _dioClient.setAuthToken(token);
      }

      final response = token == null || token.isEmpty
          ? null
          : await _authRepository.logout();

      await _authSessionRepository.clearPendingVerification();
      await _authSessionRepository.clearAuthenticatedSession();
      _dioClient.clearAuthToken();
      AuthGuard.logout();

      emit(
        LogoutSuccess(message: response?.message ?? 'Logged out successfully.'),
      );
    } catch (e) {
      emit(LoginError(_resolveErrorMessage(e)));
    }
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
      _dioClient.clearAuthToken();
      AuthGuard.logout();

      emit(
        DeleteAccountSuccess(
          message: response.message ?? 'Account deleted successfully.',
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

      return error.message ?? 'Network Error';
    }

    final message = error.toString().trim();
    return message.isEmpty ? 'An unexpected error occurred' : message;
  }
}
