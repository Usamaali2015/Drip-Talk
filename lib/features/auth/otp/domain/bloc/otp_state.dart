import 'package:equatable/equatable.dart';

class OtpState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final bool isResendSuccess;
  final bool hasAuthenticatedSession;
  final bool shouldCollectProfile;
  final String? errorMessage;
  final String? resetToken;
  final int timerCount;
  final bool canResend;

  const OtpState({
    this.isLoading = false,
    this.isSuccess = false,
    this.isResendSuccess = false,
    this.hasAuthenticatedSession = false,
    this.shouldCollectProfile = false,
    this.errorMessage,
    this.resetToken,
    this.timerCount = 60,
    this.canResend = false,
  });

  OtpState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isResendSuccess,
    bool? hasAuthenticatedSession,
    bool? shouldCollectProfile,
    String? errorMessage,
    String? resetToken,
    int? timerCount,
    bool? canResend,
  }) {
    return OtpState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isResendSuccess: isResendSuccess ?? this.isResendSuccess,
      hasAuthenticatedSession:
          hasAuthenticatedSession ?? this.hasAuthenticatedSession,
      shouldCollectProfile: shouldCollectProfile ?? this.shouldCollectProfile,
      errorMessage: errorMessage,
      resetToken: resetToken ?? this.resetToken,
      timerCount: timerCount ?? this.timerCount,
      canResend: canResend ?? this.canResend,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSuccess,
    isResendSuccess,
    hasAuthenticatedSession,
    shouldCollectProfile,
    errorMessage,
    resetToken,
    timerCount,
    canResend,
  ];
}
