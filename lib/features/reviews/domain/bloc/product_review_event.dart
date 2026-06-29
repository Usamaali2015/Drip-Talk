import 'package:drip_talk/features/reviews/data/models/review_upsert_request_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProductReviewEvent extends Equatable {
  const ProductReviewEvent();

  @override
  List<Object?> get props => const [];
}

class SubmitProductReviewRequested extends ProductReviewEvent {
  const SubmitProductReviewRequested(this.request);

  final ReviewUpsertRequestModel request;

  @override
  List<Object?> get props => [
    request.productId,
    request.rating,
    request.review,
  ];
}

class ResetProductReviewStatusRequested extends ProductReviewEvent {
  const ResetProductReviewStatusRequested();
}
