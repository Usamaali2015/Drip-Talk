import 'dart:async';
import 'package:drip_talk/features/auth/auth_repository/auth_response_model.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_session_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_repository.dart';
import 'otp_event.dart';
import 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final AuthRepository _authRepository;
  final AuthSessionRepository _authSessionRepository;
  StreamSubscription<int>? _timerSubscription;

  OtpBloc(this._authRepository, this._authSessionRepository)
    : super(const OtpState()) {
    on<OtpTimerStarted>(_onTimerStarted);
    on<OtpTimerTicked>(_onTimerTicked);
    on<OtpSubmitted>(_onOtpSubmitted);
    on<OtpResent>(_onOtpResent);
  }

  void _onTimerStarted(OtpTimerStarted event, Emitter<OtpState> emit) {
    emit(state.copyWith(timerCount: 60, canResend: false, errorMessage: null, isResendSuccess: false));
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
      if (event.type == 'forgot_password') {
        final response = await _authRepository.forgotPasswordVerifyOtp(
          email: event.email,
          otp: event.otp,
        );
        final responseData = response.data;
        final token = responseData['reset_token'] ?? responseData['data']?['reset_token'];
        emit(state.copyWith(isSuccess: true, isLoading: false, resetToken: token));
      } else {
        final response = await _authRepository.verifyOtp(
          email: event.email,
          otp: event.otp,
        );
        final authResponse = AuthResponseModel.fromResponse(response.data);
        await _authSessionRepository.markEmailVerified(
          emailVerifiedAt: authResponse.user?.emailVerifiedAt,
        );
        emit(state.copyWith(isSuccess: true, isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> _onOtpResent(OtpResent event, Emitter<OtpState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isResendSuccess: false));
    try {
      if (event.type == 'forgot_password') {
        await _authRepository.sendForgotPasswordOtp(event.email);
      } else {
        await _authRepository.resendOtp(event.email);
      }
      add(OtpTimerStarted());
      emit(state.copyWith(isResendSuccess: true, isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  @override
  Future<void> close() {
    _timerSubscription?.cancel();
    return super.close();
  }
}
