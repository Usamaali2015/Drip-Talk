import 'package:equatable/equatable.dart';

class OtpState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final bool isResendSuccess;
  final String? errorMessage;
  final String? resetToken;
  final int timerCount;
  final bool canResend;

  const OtpState({
    this.isLoading = false,
    this.isSuccess = false,
    this.isResendSuccess = false,
    this.errorMessage,
    this.resetToken,
    this.timerCount = 60,
    this.canResend = false,
  });

  OtpState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isResendSuccess,
    String? errorMessage,
    String? resetToken,
    int? timerCount,
    bool? canResend,
  }) {
    return OtpState(
      isLoading: isLoading ?? false,
      isSuccess: isSuccess ?? false,
      isResendSuccess: isResendSuccess ?? false,
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
    errorMessage,
    resetToken,
    timerCount,
    canResend,
  ];
}