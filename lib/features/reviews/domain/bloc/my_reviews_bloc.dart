import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_error_resolver.dart';
import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:drip_talk/features/reviews/data/models/my_review_model.dart';
import 'package:drip_talk/features/reviews/data/repository/review_repository.dart';
import 'package:drip_talk/features/reviews/domain/bloc/my_reviews_event.dart';
import 'package:drip_talk/features/reviews/domain/bloc/my_reviews_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyReviewsBloc extends Bloc<MyReviewsEvent, MyReviewsState> {
  MyReviewsBloc(this._reviewRepository) : super(const MyReviewsState()) {
    on<LoadMyReviewsRequested>(_onLoadRequested);
    on<ChangeMyReviewsPageRequested>(_onPageChanged);
    on<MyReviewsFilterChanged>(_onFilterChanged);
    on<UpdateMyReviewRequested>(_onUpdateRequested);
    on<DeleteMyReviewRequested>(_onDeleteRequested);
  }

  final ReviewRepository _reviewRepository;
  CancelToken? _activeLoadToken;
  int _loadRequestSequence = 0;

  Future<void> _onLoadRequested(
    LoadMyReviewsRequested event,
    Emitter<MyReviewsState> emit,
  ) async {
    final requestId = ++_loadRequestSequence;
    final targetPage = event.page < 1 ? 1 : event.page;
    final targetPerPage = event.perPage < 1 ? state.perPage : event.perPage;
    final previousPage = state.currentPage;
    final previousPerPage = state.perPage;

    _activeLoadToken?.cancel();
    final cancelToken = CancelToken();
    _activeLoadToken = cancelToken;

    final shouldRefreshInPlace = state.reviews.isNotEmpty && !event.showLoader;

    emit(
      state.copyWith(
        loadStatus: event.showLoader || state.reviews.isEmpty
            ? MyReviewsLoadStatus.loading
            : state.loadStatus,
        currentPage: targetPage,
        perPage: targetPerPage,
        isRefreshing: shouldRefreshInPlace,
        clearErrorMessage: true,
        clearFeedbackMessage: true,
      ),
    );

    try {
      final response = await _reviewRepository.getReviews(
        page: targetPage,
        perPage: targetPerPage,
        cancelToken: cancelToken,
      );

      if (requestId != _loadRequestSequence) {
        return;
      }

      emit(
        state.copyWith(
          loadStatus: MyReviewsLoadStatus.success,
          reviews: response.reviews,
          summary: response.summary,
          currentPage: response.pagination.currentPage,
          totalPages: response.pagination.lastPage,
          perPage: response.pagination.perPage,
          totalItems: response.pagination.total,
          isRefreshing: false,
          clearErrorMessage: true,
        ),
      );
    } on DioException catch (error) {
      if (error.type == DioExceptionType.cancel ||
          requestId != _loadRequestSequence) {
        return;
      }

      final message = resolveApiErrorMessage(
        error,
        fallback: localizedString(
          fallback: 'Unable to load reviews.',
          select: (l10n) => l10n.reviewsLoadFailed,
        ),
      );
      emit(
        state.copyWith(
          loadStatus: state.reviews.isEmpty
              ? MyReviewsLoadStatus.failure
              : MyReviewsLoadStatus.success,
          currentPage: state.reviews.isEmpty ? targetPage : previousPage,
          perPage: state.reviews.isEmpty ? targetPerPage : previousPerPage,
          isRefreshing: false,
          errorMessage: state.reviews.isEmpty ? message : null,
          feedbackMessage: state.reviews.isEmpty ? null : message,
          feedbackType: MyReviewsFeedbackType.error,
        ),
      );
    } catch (error) {
      if (requestId != _loadRequestSequence) {
        return;
      }

      final message = resolveApiErrorMessage(
        error,
        fallback: localizedString(
          fallback: 'Unable to load reviews.',
          select: (l10n) => l10n.reviewsLoadFailed,
        ),
      );
      emit(
        state.copyWith(
          loadStatus: state.reviews.isEmpty
              ? MyReviewsLoadStatus.failure
              : MyReviewsLoadStatus.success,
          currentPage: state.reviews.isEmpty ? targetPage : previousPage,
          perPage: state.reviews.isEmpty ? targetPerPage : previousPerPage,
          isRefreshing: false,
          errorMessage: state.reviews.isEmpty ? message : null,
          feedbackMessage: state.reviews.isEmpty ? null : message,
          feedbackType: MyReviewsFeedbackType.error,
        ),
      );
    }
  }

  void _onPageChanged(
    ChangeMyReviewsPageRequested event,
    Emitter<MyReviewsState> emit,
  ) {
    if (event.page < 1 ||
        event.page == state.currentPage ||
        event.page > state.totalPages ||
        state.isBusy) {
      return;
    }

    add(
      LoadMyReviewsRequested(
        page: event.page,
        perPage: state.perPage,
        showLoader: false,
      ),
    );
  }

  void _onFilterChanged(
    MyReviewsFilterChanged event,
    Emitter<MyReviewsState> emit,
  ) {
    emit(
      state.copyWith(activeFilter: event.filter, clearFeedbackMessage: true),
    );
  }

  Future<void> _onUpdateRequested(
    UpdateMyReviewRequested event,
    Emitter<MyReviewsState> emit,
  ) async {
    if (state.isBusy) {
      return;
    }

    emit(
      state.copyWith(
        updatingReviewId: event.reviewId,
        clearErrorMessage: true,
        clearFeedbackMessage: true,
      ),
    );

    try {
      final action = await _reviewRepository.updateReview(
        reviewId: event.reviewId,
        request: event.request,
      );
      final latest = await _safeReloadReviews();
      emit(
        state.copyWith(
          reviews: latest?.reviews ?? state.reviews,
          summary:
              latest?.summary ??
              ReviewSummaryData.fromReviews(
                state.reviews,
                totalCountOverride: state.totalItems,
              ),
          currentPage: latest?.pagination.currentPage ?? state.currentPage,
          totalPages: latest?.pagination.lastPage ?? state.totalPages,
          perPage: latest?.pagination.perPage ?? state.perPage,
          totalItems: latest?.pagination.total ?? state.totalItems,
          loadStatus: MyReviewsLoadStatus.success,
          updatingReviewId: null,
          feedbackMessage:
              action.message ??
              localizedString(
                fallback: 'Review updated successfully.',
                select: (l10n) => l10n.reviewsUpdateSuccess,
              ),
          feedbackType: MyReviewsFeedbackType.success,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          updatingReviewId: null,
          feedbackMessage: resolveApiErrorMessage(
            error,
            fallback: localizedString(
              fallback: 'Unable to update review.',
              select: (l10n) => l10n.reviewsUpdateFailed,
            ),
          ),
          feedbackType: MyReviewsFeedbackType.error,
        ),
      );
    }
  }

  Future<void> _onDeleteRequested(
    DeleteMyReviewRequested event,
    Emitter<MyReviewsState> emit,
  ) async {
    if (state.isBusy) {
      return;
    }

    emit(
      state.copyWith(
        deletingReviewId: event.reviewId,
        clearErrorMessage: true,
        clearFeedbackMessage: true,
      ),
    );

    try {
      final action = await _reviewRepository.deleteReview(event.reviewId);
      final latest = await _safeReloadReviews();
      emit(
        state.copyWith(
          reviews: latest?.reviews ?? state.reviews,
          summary:
              latest?.summary ??
              ReviewSummaryData.fromReviews(
                state.reviews,
                totalCountOverride: state.totalItems,
              ),
          currentPage: latest?.pagination.currentPage ?? state.currentPage,
          totalPages: latest?.pagination.lastPage ?? state.totalPages,
          perPage: latest?.pagination.perPage ?? state.perPage,
          totalItems: latest?.pagination.total ?? state.totalItems,
          loadStatus: MyReviewsLoadStatus.success,
          deletingReviewId: null,
          feedbackMessage:
              action.message ??
              localizedString(
                fallback: 'Review deleted successfully.',
                select: (l10n) => l10n.reviewsDeleteSuccess,
              ),
          feedbackType: MyReviewsFeedbackType.success,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          deletingReviewId: null,
          feedbackMessage: resolveApiErrorMessage(
            error,
            fallback: localizedString(
              fallback: 'Unable to delete review.',
              select: (l10n) => l10n.reviewsDeleteFailed,
            ),
          ),
          feedbackType: MyReviewsFeedbackType.error,
        ),
      );
    }
  }

  Future<MyReviewsResponseModel?> _safeReloadReviews() async {
    try {
      return await _reviewRepository.getReviews(
        page: state.currentPage,
        perPage: state.perPage,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> close() {
    _activeLoadToken?.cancel();
    return super.close();
  }
}
