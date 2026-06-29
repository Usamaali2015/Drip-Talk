import 'package:drip_talk/features/reviews/data/models/review_upsert_request_model.dart';
import 'package:equatable/equatable.dart';

abstract class MyReviewsEvent extends Equatable {
  const MyReviewsEvent();

  @override
  List<Object?> get props => const [];
}

class LoadMyReviewsRequested extends MyReviewsEvent {
  const LoadMyReviewsRequested({
    this.page = 1,
    this.perPage = 8,
    this.showLoader = true,
  });

  final int page;
  final int perPage;
  final bool showLoader;

  @override
  List<Object?> get props => [page, perPage, showLoader];
}

enum ReviewFilter { all, fiveStars, fourStars, pending }

class ChangeMyReviewsPageRequested extends MyReviewsEvent {
  const ChangeMyReviewsPageRequested(this.page);

  final int page;

  @override
  List<Object?> get props => [page];
}

class MyReviewsFilterChanged extends MyReviewsEvent {
  const MyReviewsFilterChanged(this.filter);

  final ReviewFilter filter;

  @override
  List<Object?> get props => [filter];
}

class UpdateMyReviewRequested extends MyReviewsEvent {
  const UpdateMyReviewRequested({
    required this.reviewId,
    required this.request,
  });

  final int reviewId;
  final ReviewUpsertRequestModel request;

  @override
  List<Object?> get props => [
    reviewId,
    request.productId,
    request.rating,
    request.review,
  ];
}

class DeleteMyReviewRequested extends MyReviewsEvent {
  const DeleteMyReviewRequested(this.reviewId);

  final int reviewId;

  @override
  List<Object?> get props => [reviewId];
}
