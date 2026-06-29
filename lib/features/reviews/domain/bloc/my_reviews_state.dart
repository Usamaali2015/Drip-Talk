import 'package:drip_talk/features/reviews/data/models/my_review_model.dart';
import 'package:drip_talk/features/reviews/domain/bloc/my_reviews_event.dart';
import 'package:equatable/equatable.dart';

enum MyReviewsLoadStatus { initial, loading, success, failure }

enum MyReviewsFeedbackType { success, error }

class MyReviewsState extends Equatable {
  const MyReviewsState({
    this.loadStatus = MyReviewsLoadStatus.initial,
    this.reviews = const <MyReviewItemData>[],
    this.summary = const ReviewSummaryData(),
    this.currentPage = 1,
    this.totalPages = 1,
    this.perPage = 8,
    this.totalItems = 0,
    this.isRefreshing = false,
    this.activeFilter = ReviewFilter.all,
    this.errorMessage,
    this.feedbackMessage,
    this.feedbackType = MyReviewsFeedbackType.success,
    this.updatingReviewId,
    this.deletingReviewId,
  });

  final MyReviewsLoadStatus loadStatus;
  final List<MyReviewItemData> reviews;
  final ReviewSummaryData summary;
  final int currentPage;
  final int totalPages;
  final int perPage;
  final int totalItems;
  final bool isRefreshing;
  final ReviewFilter activeFilter;
  final String? errorMessage;
  final String? feedbackMessage;
  final MyReviewsFeedbackType feedbackType;
  final int? updatingReviewId;
  final int? deletingReviewId;

  bool get isInitialLoading =>
      reviews.isEmpty &&
      (loadStatus == MyReviewsLoadStatus.initial ||
          loadStatus == MyReviewsLoadStatus.loading);

  bool get hasPagination => totalPages > 1;

  bool get isBusy =>
      isRefreshing || updatingReviewId != null || deletingReviewId != null;

  List<MyReviewItemData> get filteredReviews {
    switch (activeFilter) {
      case ReviewFilter.all:
        return reviews;
      case ReviewFilter.fiveStars:
        return reviews.where((review) => review.rating == 5).toList();
      case ReviewFilter.fourStars:
        return reviews.where((review) => review.rating == 4).toList();
      case ReviewFilter.pending:
        return reviews.where((review) => review.isPending).toList();
    }
  }

  bool isUpdatingFor(MyReviewItemData review) =>
      updatingReviewId != null && updatingReviewId == review.reviewId;

  bool isDeletingFor(MyReviewItemData review) =>
      deletingReviewId != null && deletingReviewId == review.reviewId;

  MyReviewsState copyWith({
    MyReviewsLoadStatus? loadStatus,
    List<MyReviewItemData>? reviews,
    ReviewSummaryData? summary,
    int? currentPage,
    int? totalPages,
    int? perPage,
    int? totalItems,
    bool? isRefreshing,
    ReviewFilter? activeFilter,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? feedbackMessage,
    bool clearFeedbackMessage = false,
    MyReviewsFeedbackType? feedbackType,
    Object? updatingReviewId = _sentinel,
    Object? deletingReviewId = _sentinel,
  }) {
    return MyReviewsState(
      loadStatus: loadStatus ?? this.loadStatus,
      reviews: reviews ?? this.reviews,
      summary: summary ?? this.summary,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      perPage: perPage ?? this.perPage,
      totalItems: totalItems ?? this.totalItems,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      activeFilter: activeFilter ?? this.activeFilter,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      feedbackMessage: clearFeedbackMessage
          ? null
          : (feedbackMessage ?? this.feedbackMessage),
      feedbackType: feedbackType ?? this.feedbackType,
      updatingReviewId: updatingReviewId == _sentinel
          ? this.updatingReviewId
          : updatingReviewId as int?,
      deletingReviewId: deletingReviewId == _sentinel
          ? this.deletingReviewId
          : deletingReviewId as int?,
    );
  }

  @override
  List<Object?> get props => [
    loadStatus,
    reviews,
    summary,
    currentPage,
    totalPages,
    perPage,
    totalItems,
    isRefreshing,
    activeFilter,
    errorMessage,
    feedbackMessage,
    feedbackType,
    updatingReviewId,
    deletingReviewId,
  ];
}

const Object _sentinel = Object();
