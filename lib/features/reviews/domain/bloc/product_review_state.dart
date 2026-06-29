import 'package:equatable/equatable.dart';

enum ProductReviewSubmissionStatus { initial, loading, success, failure }

class ProductReviewState extends Equatable {
  const ProductReviewState({
    this.submissionStatus = ProductReviewSubmissionStatus.initial,
    this.feedbackMessage,
  });

  final ProductReviewSubmissionStatus submissionStatus;
  final String? feedbackMessage;

  bool get isLoading =>
      submissionStatus == ProductReviewSubmissionStatus.loading;
  bool get isSuccess =>
      submissionStatus == ProductReviewSubmissionStatus.success;
  bool get isFailure =>
      submissionStatus == ProductReviewSubmissionStatus.failure;

  ProductReviewState copyWith({
    ProductReviewSubmissionStatus? submissionStatus,
    String? feedbackMessage,
    bool clearFeedbackMessage = false,
  }) {
    return ProductReviewState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      feedbackMessage: clearFeedbackMessage
          ? null
          : (feedbackMessage ?? this.feedbackMessage),
    );
  }

  @override
  List<Object?> get props => [submissionStatus, feedbackMessage];
}
