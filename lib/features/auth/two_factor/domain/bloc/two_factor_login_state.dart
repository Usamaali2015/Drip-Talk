import 'package:equatable/equatable.dart';

enum TwoFactorLoginSubmissionStatus { initial, loading, success, failure }

class TwoFactorLoginState extends Equatable {
  const TwoFactorLoginState({
    this.code = '',
    this.submissionStatus = TwoFactorLoginSubmissionStatus.initial,
    this.feedbackMessage,
    this.hasAttemptedSubmit = false,
  });

  final String code;
  final TwoFactorLoginSubmissionStatus submissionStatus;
  final String? feedbackMessage;
  final bool hasAttemptedSubmit;

  bool get isLoading =>
      submissionStatus == TwoFactorLoginSubmissionStatus.loading;
  bool get isSuccess =>
      submissionStatus == TwoFactorLoginSubmissionStatus.success;
  bool get isFailure =>
      submissionStatus == TwoFactorLoginSubmissionStatus.failure;

  TwoFactorLoginState copyWith({
    String? code,
    TwoFactorLoginSubmissionStatus? submissionStatus,
    String? feedbackMessage,
    bool clearFeedbackMessage = false,
    bool? hasAttemptedSubmit,
  }) {
    return TwoFactorLoginState(
      code: code ?? this.code,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      feedbackMessage: clearFeedbackMessage
          ? null
          : (feedbackMessage ?? this.feedbackMessage),
      hasAttemptedSubmit: hasAttemptedSubmit ?? this.hasAttemptedSubmit,
    );
  }

  @override
  List<Object?> get props => [
    code,
    submissionStatus,
    feedbackMessage,
    hasAttemptedSubmit,
  ];
}
