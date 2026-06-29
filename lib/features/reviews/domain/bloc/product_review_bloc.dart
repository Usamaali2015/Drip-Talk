import 'package:drip_talk/core/services/api/api_error_resolver.dart';
import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:drip_talk/features/reviews/data/repository/review_repository.dart';
import 'package:drip_talk/features/reviews/domain/bloc/product_review_event.dart';
import 'package:drip_talk/features/reviews/domain/bloc/product_review_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductReviewBloc extends Bloc<ProductReviewEvent, ProductReviewState> {
  ProductReviewBloc(this._reviewRepository)
    : super(const ProductReviewState()) {
    on<SubmitProductReviewRequested>(_onSubmitRequested);
    on<ResetProductReviewStatusRequested>(_onResetRequested);
  }

  final ReviewRepository _reviewRepository;

  Future<void> _onSubmitRequested(
    SubmitProductReviewRequested event,
    Emitter<ProductReviewState> emit,
  ) async {
    if (state.isLoading) {
      return;
    }

    emit(
      state.copyWith(
        submissionStatus: ProductReviewSubmissionStatus.loading,
        clearFeedbackMessage: true,
      ),
    );

    try {
      final response = await _reviewRepository.addReview(event.request);
      emit(
        state.copyWith(
          submissionStatus: ProductReviewSubmissionStatus.success,
          feedbackMessage:
              response.message ??
              localizedString(
                fallback: 'Review submitted successfully.',
                select: (l10n) => l10n.reviewSubmittedSuccess,
              ),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          submissionStatus: ProductReviewSubmissionStatus.failure,
          feedbackMessage: resolveApiErrorMessage(
            error,
            fallback: localizedString(
              fallback: 'Unable to submit review.',
              select: (l10n) => l10n.reviewSubmitFailed,
            ),
          ),
        ),
      );
    }
  }

  void _onResetRequested(
    ResetProductReviewStatusRequested event,
    Emitter<ProductReviewState> emit,
  ) {
    emit(const ProductReviewState());
  }
}
