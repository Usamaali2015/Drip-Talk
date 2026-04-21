import 'package:equatable/equatable.dart';

enum ResetPasswordSubmissionStatus { initial, loading, success, failure }

enum ResetPasswordFailureReason { none, missingSession, api }

class ResetPasswordState extends Equatable {
  final String password;
  final String passwordConfirmation;
  final bool hasAttemptedSubmit;
  final ResetPasswordSubmissionStatus submissionStatus;
  final ResetPasswordFailureReason failureReason;
  final String? feedbackMessage;

  const ResetPasswordState({
    this.password = '',
    this.passwordConfirmation = '',
    this.hasAttemptedSubmit = false,
    this.submissionStatus = ResetPasswordSubmissionStatus.initial,
    this.failureReason = ResetPasswordFailureReason.none,
    this.feedbackMessage,
  });

  bool get hasMinLength => password.length >= 8;

  bool get hasUppercase => RegExp(r'[A-Z]').hasMatch(password);

  bool get hasNumberOrSymbol => RegExp(r'[\d\W_]').hasMatch(password);

  bool get hasSpecialCharacter => RegExp(r'[^\w\s]').hasMatch(password);

  bool get isPasswordValid =>
      hasMinLength && hasUppercase && hasNumberOrSymbol && hasSpecialCharacter;

  bool get isConfirmationProvided => passwordConfirmation.trim().isNotEmpty;

  bool get passwordsMatch =>
      password.isNotEmpty &&
      passwordConfirmation.isNotEmpty &&
      password == passwordConfirmation;

  bool get isLoading =>
      submissionStatus == ResetPasswordSubmissionStatus.loading;

  bool get isSuccess =>
      submissionStatus == ResetPasswordSubmissionStatus.success;

  bool get isFailure =>
      submissionStatus == ResetPasswordSubmissionStatus.failure;

  ResetPasswordState copyWith({
    String? password,
    String? passwordConfirmation,
    bool? hasAttemptedSubmit,
    ResetPasswordSubmissionStatus? submissionStatus,
    ResetPasswordFailureReason? failureReason,
    String? feedbackMessage,
    bool clearFeedbackMessage = false,
  }) {
    return ResetPasswordState(
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      hasAttemptedSubmit: hasAttemptedSubmit ?? this.hasAttemptedSubmit,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      failureReason: failureReason ?? this.failureReason,
      feedbackMessage: clearFeedbackMessage
          ? null
          : (feedbackMessage ?? this.feedbackMessage),
    );
  }

  @override
  List<Object?> get props => [
    password,
    passwordConfirmation,
    hasAttemptedSubmit,
    submissionStatus,
    failureReason,
    feedbackMessage,
  ];
}
