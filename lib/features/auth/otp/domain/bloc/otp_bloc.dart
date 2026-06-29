import 'dart:async';
import 'package:drip_talk/core/services/api/api_error_resolver.dart';
import 'package:drip_talk/core/services/api/dio_client.dart';
import 'package:drip_talk/core/utils/routes/auth_guard.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_otp_purpose.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_response_model.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_session_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_repository.dart';
import 'otp_event.dart';
import 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final AuthRepository _authRepository;
  final AuthSessionRepository _authSessionRepository;
  final DioClient _dioClient;
  StreamSubscription<int>? _timerSubscription;

  OtpBloc(this._authRepository, this._authSessionRepository, this._dioClient)
    : super(const OtpState()) {
    on<OtpTimerStarted>(_onTimerStarted);
    on<OtpTimerTicked>(_onTimerTicked);
    on<OtpSubmitted>(_onOtpSubmitted);
    on<OtpResent>(_onOtpResent);
  }

  void _onTimerStarted(OtpTimerStarted event, Emitter<OtpState> emit) {
    emit(
      state.copyWith(
        timerCount: 60,
        canResend: false,
        errorMessage: null,
        isResendSuccess: false,
        hasAuthenticatedSession: false,
        shouldCollectProfile: false,
      ),
    );
    _timerSubscription?.cancel();
    _timerSubscription = Stream.periodic(
      const Duration(seconds: 1),
      (x) => 59 - x,
    ).take(60).listen((duration) => add(OtpTimerTicked(duration)));
  }

  void _onTimerTicked(OtpTimerTicked event, Emitter<OtpState> emit) {
    emit(
      state.copyWith(
        timerCount: event.duration,
        canResend: event.duration == 0,
      ),
    );
  }

  Future<void> _onOtpSubmitted(
    OtpSubmitted event,
    Emitter<OtpState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      if (event.purpose == AuthOtpPurpose.forgotPassword) {
        final response = await _authRepository.forgotPasswordVerifyOtp(
          email: event.email,
          otp: event.otp,
        );
        final responseData = response.data;
        final token =
            responseData['reset_token'] ?? responseData['data']?['reset_token'];
        emit(
          state.copyWith(isSuccess: true, isLoading: false, resetToken: token),
        );
      } else {
        final response = await _authRepository.verifyOtp(
          email: event.email,
          otp: event.otp,
        );
        final authResponse = AuthResponseModel.fromResponse(response.data);
        final token = authResponse.token?.trim();
        final shouldCollectProfile =
            event.purpose == AuthOtpPurpose.signupVerification;
        var hasAuthenticatedSession = false;

        if (token != null && token.isNotEmpty) {
          await _authSessionRepository.saveAuthenticatedSession(
            token: token,
            refreshToken: authResponse.refreshToken,
            user: authResponse.user?.toJson(),
            emailVerifiedAt: authResponse.user?.emailVerifiedAt,
            profileSetupRequired: shouldCollectProfile,
            recommendationsFlowRequired: shouldCollectProfile,
          );
          _dioClient.setAuthToken(token);
          hasAuthenticatedSession = true;
        } else {
          hasAuthenticatedSession = await _authSessionRepository
              .promotePendingVerificationSession(
                emailVerifiedAt: authResponse.user?.emailVerifiedAt,
                user: authResponse.user?.toJson(),
                profileSetupRequired: shouldCollectProfile,
                recommendationsFlowRequired: shouldCollectProfile,
              );

          if (hasAuthenticatedSession) {
            final promotedToken = await _authSessionRepository.getAuthToken();
            if (promotedToken != null && promotedToken.isNotEmpty) {
              _dioClient.setAuthToken(promotedToken);
            }
          }
        }

        if (!hasAuthenticatedSession) {
          await _authSessionRepository.markEmailVerified(
            emailVerifiedAt: authResponse.user?.emailVerifiedAt,
          );
        }

        if (hasAuthenticatedSession) {
          AuthGuard.login(
            profileSetupRequired: shouldCollectProfile ? true : null,
            recommendationsFlowRequired: shouldCollectProfile ? true : null,
          );
        }

        emit(
          state.copyWith(
            isSuccess: true,
            isLoading: false,
            hasAuthenticatedSession: hasAuthenticatedSession,
            shouldCollectProfile:
                hasAuthenticatedSession && shouldCollectProfile,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: resolveApiErrorMessage(
            e,
            fallback: 'Unable to verify OTP',
          ),
          isLoading: false,
          hasAuthenticatedSession: false,
          shouldCollectProfile: false,
        ),
      );
    }
  }

  Future<void> _onOtpResent(OtpResent event, Emitter<OtpState> emit) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        isResendSuccess: false,
        hasAuthenticatedSession: false,
        shouldCollectProfile: false,
      ),
    );
    try {
      if (event.purpose.usesForgotPasswordEndpoints) {
        await _authRepository.sendForgotPasswordOtp(event.email);
      } else {
        await _authRepository.resendOtp(event.email);
      }
      add(OtpTimerStarted());
      emit(state.copyWith(isResendSuccess: true, isLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: resolveApiErrorMessage(
            e,
            fallback: 'Unable to resend OTP',
          ),
          isLoading: false,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _timerSubscription?.cancel();
    return super.close();
  }
}
