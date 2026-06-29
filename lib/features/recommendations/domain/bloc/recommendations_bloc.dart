import 'dart:async';

import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_error_resolver.dart';
import 'package:drip_talk/core/services/api/dio_client.dart';
import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_session_repository.dart';
import 'package:drip_talk/features/recommendations/data/models/recommendations_request_model.dart';
import 'package:drip_talk/features/recommendations/data/models/try_on_generate_request_model.dart';
import 'package:drip_talk/features/recommendations/data/models/try_on_result_model.dart';
import 'package:drip_talk/features/recommendations/data/repository/recommendations_repository.dart';
import 'package:drip_talk/features/recommendations/data/services/try_on_realtime_service.dart';
import 'package:drip_talk/features/recommendations/domain/bloc/recommendations_event.dart';
import 'package:drip_talk/features/recommendations/domain/bloc/recommendations_state.dart';
import 'package:drip_talk/features/recommendations/domain/services/recommendations_photo_validator.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecommendationsBloc
    extends Bloc<RecommendationsEvent, RecommendationsState> {
  RecommendationsBloc(
    this._repository,
    this._authSessionRepository,
    this._dioClient,
    this._tryOnRealtimeService,
    this._photoValidator,
  ) : super(const RecommendationsState()) {
    on<RecommendationsPhotoSelected>(_onPhotoSelected);
    on<RecommendationsFetchRequested>(_onFetchRequested);
    on<RecommendationsLiked>(_onLiked);
    on<RecommendationsDisliked>(_onDisliked);
    on<RecommendationsReviewSkipped>(_onReviewSkipped);
    on<RecommendationsRestartRequested>(_onRestartRequested);
    on<RecommendationsTryOnRequested>(_onTryOnRequested);
    on<_RecommendationsTryOnRealtimeUpdated>(_onTryOnRealtimeUpdated);
    on<_RecommendationsTryOnRealtimeFailed>(_onTryOnRealtimeFailed);
  }

  final RecommendationsRepository _repository;
  final AuthSessionRepository _authSessionRepository;
  final DioClient _dioClient;
  final TryOnRealtimeService _tryOnRealtimeService;
  final RecommendationsPhotoValidator _photoValidator;

  CancelToken? _recommendationsRequestToken;
  CancelToken? _tryOnRequestToken;
  StreamSubscription<TryOnResultModel>? _tryOnRealtimeSubscription;
  TryOnRealtimeSession? _tryOnRealtimeSession;
  int _photoValidationRequestId = 0;
  int _tryOnSessionId = 0;

  Future<void> _onPhotoSelected(
    RecommendationsPhotoSelected event,
    Emitter<RecommendationsState> emit,
  ) async {
    final validationRequestId = ++_photoValidationRequestId;
    _cancelTryOnFlow();

    emit(
      state.copyWith(
        step: RecommendationsStep.photo,
        selectedPhoto: null,
        recommendations: null,
        currentIndex: 0,
        likedIndices: const <int>[],
        dislikedIndices: const <int>[],
        skippedIndices: const <int>[],
        isValidatingPhoto: true,
        isFetchingRecommendations: false,
        isGeneratingTryOn: false,
        errorMessage: null,
        tryOnBatchId: null,
        tryOnProgress: 0,
        tryOnBatch: null,
        tryOnResults: const <TryOnGeneratedLook>[],
      ),
    );

    final validationResult = await _photoValidator.validate(event.photo);
    if (validationRequestId != _photoValidationRequestId || isClosed) {
      return;
    }

    if (!validationResult.isValid) {
      emit(
        state.copyWith(
          step: RecommendationsStep.photo,
          selectedPhoto: null,
          recommendations: null,
          currentIndex: 0,
          likedIndices: const <int>[],
          dislikedIndices: const <int>[],
          skippedIndices: const <int>[],
          isValidatingPhoto: false,
          errorMessage: validationResult.message ?? _photoRequiredMessage(),
          tryOnBatchId: null,
          tryOnProgress: 0,
          tryOnBatch: null,
          tryOnResults: const <TryOnGeneratedLook>[],
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        step: RecommendationsStep.photo,
        selectedPhoto: event.photo,
        recommendations: null,
        currentIndex: 0,
        likedIndices: const <int>[],
        dislikedIndices: const <int>[],
        skippedIndices: const <int>[],
        isValidatingPhoto: false,
        errorMessage: null,
        tryOnBatchId: null,
        tryOnProgress: 0,
        tryOnBatch: null,
        tryOnResults: const <TryOnGeneratedLook>[],
      ),
    );
  }

  Future<void> _onFetchRequested(
    RecommendationsFetchRequested event,
    Emitter<RecommendationsState> emit,
  ) async {
    final selectedPhoto = state.selectedPhoto;
    if (selectedPhoto == null) {
      emit(
        state.copyWith(
          step: RecommendationsStep.photo,
          errorMessage: _photoRequiredMessage(),
        ),
      );
      return;
    }

    _recommendationsRequestToken?.cancel();
    final cancelToken = CancelToken();
    _recommendationsRequestToken = cancelToken;
    _cancelTryOnFlow();

    emit(
      state.copyWith(
        step: RecommendationsStep.photo,
        recommendations: null,
        currentIndex: 0,
        likedIndices: const <int>[],
        dislikedIndices: const <int>[],
        skippedIndices: const <int>[],
        isValidatingPhoto: false,
        isFetchingRecommendations: true,
        isGeneratingTryOn: false,
        errorMessage: null,
        tryOnBatchId: null,
        tryOnProgress: 0,
        tryOnBatch: null,
        tryOnResults: const <TryOnGeneratedLook>[],
      ),
    );

    try {
      await _ensureAuthenticatedRequestContext();
      final response = await _repository.getRecommendations(
        RecommendationsRequestModel(profileImageFile: selectedPhoto),
        cancelToken: cancelToken,
      );

      if (_shouldAbort(cancelToken)) {
        return;
      }

      if (response.items.isEmpty) {
        emit(
          state.copyWith(
            step: RecommendationsStep.photo,
            recommendations: response,
            currentIndex: 0,
            isFetchingRecommendations: false,
            errorMessage: response.message ?? _noRecommendationsMessage(),
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          step: RecommendationsStep.review,
          recommendations: response,
          currentIndex: 0,
          likedIndices: const <int>[],
          dislikedIndices: const <int>[],
          skippedIndices: const <int>[],
          isFetchingRecommendations: false,
          errorMessage: null,
        ),
      );
    } on DioException catch (error) {
      if (error.type == DioExceptionType.cancel ||
          CancelToken.isCancel(error)) {
        return;
      }

      emit(
        state.copyWith(
          step: RecommendationsStep.photo,
          isFetchingRecommendations: false,
          errorMessage: resolveApiErrorMessage(
            error,
            fallback: _loadFailedMessage(),
          ),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          step: RecommendationsStep.photo,
          isFetchingRecommendations: false,
          errorMessage: resolveApiErrorMessage(
            error,
            fallback: _loadFailedMessage(),
          ),
        ),
      );
    }
  }

  void _onLiked(
    RecommendationsLiked event,
    Emitter<RecommendationsState> emit,
  ) {
    if (!state.isReviewing) {
      return;
    }

    _advanceReview(
      emit,
      likedIndices: [...state.likedIndices, state.currentIndex],
    );
  }

  void _onDisliked(
    RecommendationsDisliked event,
    Emitter<RecommendationsState> emit,
  ) {
    if (!state.isReviewing) {
      return;
    }

    _advanceReview(
      emit,
      dislikedIndices: [...state.dislikedIndices, state.currentIndex],
    );
  }

  void _onReviewSkipped(
    RecommendationsReviewSkipped event,
    Emitter<RecommendationsState> emit,
  ) {
    if (!state.isReviewing) {
      return;
    }

    _advanceReview(
      emit,
      skippedIndices: [...state.skippedIndices, state.currentIndex],
    );
  }

  void _advanceReview(
    Emitter<RecommendationsState> emit, {
    List<int>? likedIndices,
    List<int>? dislikedIndices,
    List<int>? skippedIndices,
  }) {
    final isLastItem = state.isCurrentItemLast;

    emit(
      state.copyWith(
        step: isLastItem
            ? RecommendationsStep.summary
            : RecommendationsStep.review,
        currentIndex: isLastItem ? state.currentIndex : state.currentIndex + 1,
        likedIndices: likedIndices ?? state.likedIndices,
        dislikedIndices: dislikedIndices ?? state.dislikedIndices,
        skippedIndices: skippedIndices ?? state.skippedIndices,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onTryOnRequested(
    RecommendationsTryOnRequested event,
    Emitter<RecommendationsState> emit,
  ) async {
    if (state.isGeneratingTryOn || state.hasTryOnResults) {
      return;
    }

    final selectedPhoto = state.selectedPhoto;
    if (selectedPhoto == null) {
      emit(
        state.copyWith(
          step: RecommendationsStep.photo,
          errorMessage: _photoRequiredMessage(),
        ),
      );
      return;
    }

    if (state.likedDressImageUrls.isEmpty) {
      emit(
        state.copyWith(
          step: RecommendationsStep.summary,
          errorMessage: _tryOnLooksRequiredMessage(),
        ),
      );
      return;
    }

    final tryOnSessionId = ++_tryOnSessionId;
    _tryOnRequestToken?.cancel();
    _releaseTryOnRealtimeSession();
    final cancelToken = CancelToken();
    _tryOnRequestToken = cancelToken;

    emit(
      state.copyWith(
        step: RecommendationsStep.tryOnProcessing,
        isGeneratingTryOn: true,
        errorMessage: null,
        tryOnBatchId: null,
        tryOnProgress: 0,
        tryOnBatch: null,
        tryOnResults: const <TryOnGeneratedLook>[],
      ),
    );

    try {
      await _ensureAuthenticatedRequestContext();
      final generateResponse = await _repository.generateTryOn(
        TryOnGenerateRequestModel(
          faceImageFile: selectedPhoto,
          dressImageUrls: state.likedDressImageUrls,
        ),
        cancelToken: cancelToken,
      );

      if (_shouldAbortTryOn(cancelToken, tryOnSessionId)) {
        return;
      }

      final batchId = generateResponse.batchId?.trim();
      if (batchId == null || batchId.isEmpty) {
        throw Exception(
          generateResponse.message?.trim().isNotEmpty == true
              ? generateResponse.message!.trim()
              : _tryOnFailedMessage(),
        );
      }

      emit(
        state.copyWith(
          step: RecommendationsStep.tryOnProcessing,
          isGeneratingTryOn: true,
          tryOnBatchId: batchId,
          tryOnProgress: _progressFrom(generateResponse.progress, fallback: 0),
          tryOnBatch: TryOnResultModel(
            status: generateResponse.status,
            message: generateResponse.message,
            batchId: batchId,
            progress: _progressFrom(generateResponse.progress, fallback: 0),
            totalImages: state.likedItemsWithThumbnails.length,
          ),
          errorMessage: null,
        ),
      );

      _logDebug(
        'RecommendationsBloc.tryOn generate batchId=$batchId progress=${generateResponse.progress} channel=${generateResponse.channelName}',
      );

      final realtimeSession = await _tryOnRealtimeService.connect(
        batchId: batchId,
        channelName: generateResponse.channelName?.trim(),
      );

      if (_shouldAbortTryOn(cancelToken, tryOnSessionId)) {
        await realtimeSession.close();
        return;
      }

      _releaseTryOnRealtimeSession();
      _tryOnRealtimeSession = realtimeSession;
      _tryOnRealtimeSubscription = realtimeSession.updates.listen(
        (TryOnResultModel result) {
          add(
            _RecommendationsTryOnRealtimeUpdated(
              sessionId: tryOnSessionId,
              batchId: batchId,
              result: result,
            ),
          );
        },
        onError: (Object error, StackTrace stackTrace) {
          add(
            _RecommendationsTryOnRealtimeFailed(
              sessionId: tryOnSessionId,
              message: resolveApiErrorMessage(
                error,
                fallback: _tryOnFailedMessage(),
              ),
            ),
          );
        },
      );
    } on DioException catch (error) {
      if (error.type == DioExceptionType.cancel ||
          CancelToken.isCancel(error)) {
        return;
      }

      _completeTryOnFlow();
      _emitTryOnFailure(
        emit,
        resolveApiErrorMessage(error, fallback: _tryOnFailedMessage()),
      );
    } catch (error) {
      _completeTryOnFlow();
      _emitTryOnFailure(
        emit,
        resolveApiErrorMessage(error, fallback: _tryOnFailedMessage()),
      );
    }
  }

  Future<void> _onTryOnRealtimeUpdated(
    _RecommendationsTryOnRealtimeUpdated event,
    Emitter<RecommendationsState> emit,
  ) async {
    if (event.sessionId != _tryOnSessionId) {
      return;
    }

    final result = event.result;
    final batchId = result.batchId?.trim().isNotEmpty == true
        ? result.batchId!.trim()
        : event.batchId;
    final mergedResults = _mergeTryOnResults(
      previous: state.tryOnResults,
      current: result.results,
    );
    final mergedBatch = _mergeTryOnBatch(
      current: result,
      batchId: batchId,
      previous: state.tryOnBatch,
      mergedResults: mergedResults,
      fallbackTotalImages: state.likedItemsWithThumbnails.length,
    );
    final progress = _progressFrom(
      mergedBatch.progress,
      fallback: state.tryOnProgress,
    );

    _logDebug(
      'RecommendationsBloc.tryOn realtime status=${mergedBatch.status} progress=${mergedBatch.progress} results=${mergedResults.length} batchId=$batchId',
    );

    if (mergedBatch.isFailed) {
      _completeTryOnFlow();
      _emitTryOnFailure(
        emit,
        mergedBatch.message ?? result.message ?? _tryOnFailedMessage(),
      );
      return;
    }

    if (mergedBatch.isCompleted) {
      final completedSessionId = event.sessionId;
      _completeTryOnFlow();
      final completedResolution = await _resolveCompletedTryOnResult(
        batchId: batchId,
        mergedBatch: mergedBatch,
        mergedResults: mergedResults,
      );
      if (isClosed || _tryOnSessionId != completedSessionId + 1) {
        return;
      }

      final expectedTotal =
          completedResolution.batch.totalImages ??
          state.likedItemsWithThumbnails.length;
      if (expectedTotal > 0 &&
          completedResolution.results.length < expectedTotal) {
        _emitTryOnFailure(
          emit,
          completedResolution.batch.message ?? _tryOnFailedMessage(),
        );
        return;
      }

      if (completedResolution.results.isEmpty) {
        _emitTryOnFailure(
          emit,
          completedResolution.batch.message ?? _tryOnEmptyResultMessage(),
        );
        return;
      }

      emit(
        state.copyWith(
          step: RecommendationsStep.tryOnResults,
          isGeneratingTryOn: false,
          tryOnBatchId: batchId,
          tryOnProgress: 100,
          tryOnBatch: completedResolution.batch,
          tryOnResults: completedResolution.results,
          errorMessage: null,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        step: RecommendationsStep.tryOnProcessing,
        isGeneratingTryOn: true,
        tryOnBatchId: batchId,
        tryOnProgress: progress,
        tryOnBatch: mergedBatch,
        tryOnResults: mergedResults,
        errorMessage: null,
      ),
    );
  }

  Future<_CompletedTryOnResolution> _resolveCompletedTryOnResult({
    required String batchId,
    required TryOnResultModel mergedBatch,
    required List<TryOnGeneratedLook> mergedResults,
  }) async {
    final expectedTotal = mergedBatch.totalImages ?? state.tryOnTotalItems;
    final shouldFetchFinalResult =
        batchId.trim().isNotEmpty &&
        expectedTotal > 0 &&
        mergedResults.length < expectedTotal;

    if (!shouldFetchFinalResult) {
      return _CompletedTryOnResolution(
        batch: mergedBatch,
        results: mergedResults,
      );
    }

    try {
      final finalResult = await _repository.getTryOnResult(batchId);
      final resolvedResults = _mergeTryOnResults(
        previous: mergedResults,
        current: finalResult.results,
      );
      final resolvedBatch = _mergeTryOnBatch(
        current: finalResult,
        batchId: batchId,
        previous: mergedBatch,
        mergedResults: resolvedResults,
        fallbackTotalImages: state.likedItemsWithThumbnails.length,
      );

      _logDebug(
        'RecommendationsBloc.tryOn completed reconciliation batchId=$batchId expected=$expectedTotal merged=${mergedResults.length} final=${resolvedResults.length}',
      );

      return _CompletedTryOnResolution(
        batch: resolvedBatch,
        results: resolvedResults,
      );
    } catch (error) {
      _logDebug(
        'RecommendationsBloc.tryOn completed reconciliation failed batchId=$batchId error=$error',
      );
      return _CompletedTryOnResolution(
        batch: mergedBatch,
        results: mergedResults,
      );
    }
  }

  void _onTryOnRealtimeFailed(
    _RecommendationsTryOnRealtimeFailed event,
    Emitter<RecommendationsState> emit,
  ) {
    if (event.sessionId != _tryOnSessionId) {
      return;
    }

    _completeTryOnFlow();
    _emitTryOnFailure(emit, event.message);
  }

  void _onRestartRequested(
    RecommendationsRestartRequested event,
    Emitter<RecommendationsState> emit,
  ) {
    _recommendationsRequestToken?.cancel();
    _recommendationsRequestToken = null;
    _cancelTryOnFlow();
    _photoValidationRequestId++;
    emit(const RecommendationsState());
  }

  Future<void> _ensureAuthenticatedRequestContext() async {
    final token = await _authSessionRepository.getAuthToken();
    if (token == null || token.trim().isEmpty) {
      return;
    }

    _dioClient.setAuthToken(token.trim());
  }

  bool _shouldAbort(CancelToken cancelToken) {
    return isClosed ||
        cancelToken.isCancelled ||
        identical(cancelToken, _recommendationsRequestToken) == false;
  }

  bool _shouldAbortTryOn(CancelToken cancelToken, int sessionId) {
    return isClosed ||
        cancelToken.isCancelled ||
        sessionId != _tryOnSessionId ||
        identical(cancelToken, _tryOnRequestToken) == false;
  }

  TryOnResultModel _mergeTryOnBatch({
    required TryOnResultModel current,
    required String batchId,
    required List<TryOnGeneratedLook> mergedResults,
    required int fallbackTotalImages,
    TryOnResultModel? previous,
  }) {
    final mergedItems = _mergeTryOnItems(previous?.items, current.items);
    final resolvedTotalImages =
        current.totalImages ??
        previous?.totalImages ??
        (mergedItems.isNotEmpty ? mergedItems.length : null) ??
        fallbackTotalImages;
    final resolvedProgress =
        current.progress ??
        _progressFromCompletedLooks(
          completedCount: mergedResults.length,
          totalCount: resolvedTotalImages,
        ) ??
        previous?.progress ??
        0;

    return TryOnResultModel(
      status: current.status ?? previous?.status,
      message: current.message ?? previous?.message,
      batchId: current.batchId ?? previous?.batchId ?? batchId,
      progress: resolvedProgress,
      progressText:
          current.progressText ??
          previous?.progressText ??
          _progressTextFromCounts(
            completedCount: mergedResults.length,
            totalCount: resolvedTotalImages,
          ),
      totalImages: resolvedTotalImages,
      avgTimePerImage: current.avgTimePerImage ?? previous?.avgTimePerImage,
      currentImage: _hasTryOnItemData(current.currentImage)
          ? current.currentImage
          : previous?.currentImage,
      generatedAt: current.generatedAt ?? previous?.generatedAt,
      items: mergedItems,
      results: mergedResults,
    );
  }

  List<TryOnBatchItem> _mergeTryOnItems(
    List<TryOnBatchItem>? previous,
    List<TryOnBatchItem> current,
  ) {
    final previousItems = previous ?? const <TryOnBatchItem>[];
    if (previousItems.isEmpty) {
      return current;
    }

    if (current.isEmpty) {
      return previousItems;
    }

    final sequenceCounts = <int, int>{};
    for (final item in [...previousItems, ...current]) {
      final sequence = item.sequence;
      if (sequence == null) {
        continue;
      }

      sequenceCounts.update(sequence, (count) => count + 1, ifAbsent: () => 1);
    }

    final merged = <String, TryOnBatchItem>{};
    var hasKeyedItem = false;

    void addItems(List<TryOnBatchItem> items) {
      for (final item in items) {
        final key = _tryOnItemKey(item, sequenceCounts);
        if (key == null) {
          continue;
        }

        hasKeyedItem = true;
        merged[key] = _preferMoreCompleteItem(merged[key], item);
      }
    }

    addItems(previousItems);
    addItems(current);

    if (!hasKeyedItem) {
      return current.length >= previousItems.length ? current : previousItems;
    }

    final sortedItems = merged.values.toList()
      ..sort((left, right) {
        return (left.sequence ?? left.id ?? 0).compareTo(
          right.sequence ?? right.id ?? 0,
        );
      });
    return sortedItems;
  }

  List<TryOnGeneratedLook> _mergeTryOnResults({
    required List<TryOnGeneratedLook> previous,
    required List<TryOnGeneratedLook> current,
  }) {
    if (previous.isEmpty) {
      return current;
    }

    if (current.isEmpty) {
      return previous;
    }

    final sequenceCounts = <int, int>{};
    for (final look in [...previous, ...current]) {
      final sequence = look.sequence;
      if (sequence == null) {
        continue;
      }

      sequenceCounts.update(sequence, (count) => count + 1, ifAbsent: () => 1);
    }

    final merged = <String, TryOnGeneratedLook>{};

    void addLooks(List<TryOnGeneratedLook> looks) {
      for (final look in looks) {
        final key = _tryOnLookKey(look, sequenceCounts);
        if (key == null) {
          continue;
        }

        merged[key] = _preferMoreCompleteLook(merged[key], look);
      }
    }

    addLooks(previous);
    addLooks(current);

    final sortedLooks = merged.values.toList()
      ..sort((left, right) {
        return (left.sequence ?? 1 << 20).compareTo(right.sequence ?? 1 << 20);
      });
    return sortedLooks;
  }

  String? _tryOnItemKey(TryOnBatchItem item, Map<int, int> sequenceCounts) {
    if (item.id != null) {
      return 'id:${item.id}';
    }

    final imageUrl = item.generatedImageUrl?.trim();
    final sequence = item.sequence;
    final hasUniqueSequence =
        sequence != null && (sequenceCounts[sequence] ?? 0) == 1;
    if (hasUniqueSequence) {
      return 'seq:$sequence';
    }

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return 'img:$imageUrl';
    }

    if (sequence != null) {
      return 'seq:$sequence';
    }

    return null;
  }

  String? _tryOnLookKey(TryOnGeneratedLook look, Map<int, int> sequenceCounts) {
    final imageUrl = look.imageUrl.trim();
    final sequence = look.sequence;
    final hasUniqueSequence =
        sequence != null && (sequenceCounts[sequence] ?? 0) == 1;
    if (hasUniqueSequence) {
      return 'seq:$sequence';
    }

    if (imageUrl.isNotEmpty) {
      return 'img:$imageUrl';
    }

    if (sequence != null) {
      return 'seq:$sequence';
    }

    return null;
  }

  bool _hasTryOnItemData(TryOnBatchItem? item) {
    return item != null &&
        (item.id != null ||
            item.sequence != null ||
            item.progress != null ||
            item.generatedImageUrl?.trim().isNotEmpty == true ||
            item.status?.trim().isNotEmpty == true ||
            item.errorMessage?.trim().isNotEmpty == true);
  }

  TryOnBatchItem _preferMoreCompleteItem(
    TryOnBatchItem? previous,
    TryOnBatchItem candidate,
  ) {
    if (previous == null) {
      return candidate;
    }

    final previousScore = _tryOnItemCompletenessScore(previous);
    final candidateScore = _tryOnItemCompletenessScore(candidate);
    if (candidateScore != previousScore) {
      return candidateScore >= previousScore ? candidate : previous;
    }

    return candidate;
  }

  int _tryOnItemCompletenessScore(TryOnBatchItem item) {
    return (item.hasGeneratedImage ? 4 : 0) +
        (item.progress ?? 0) +
        (item.status?.trim().isNotEmpty == true ? 1 : 0) +
        (item.errorMessage?.trim().isNotEmpty == true ? 1 : 0);
  }

  TryOnGeneratedLook _preferMoreCompleteLook(
    TryOnGeneratedLook? previous,
    TryOnGeneratedLook candidate,
  ) {
    if (previous == null) {
      return candidate;
    }

    final previousScore = _tryOnLookCompletenessScore(previous);
    final candidateScore = _tryOnLookCompletenessScore(candidate);
    if (candidateScore != previousScore) {
      return candidateScore >= previousScore ? candidate : previous;
    }

    return candidate.imageUrl.length >= previous.imageUrl.length
        ? candidate
        : previous;
  }

  int _tryOnLookCompletenessScore(TryOnGeneratedLook look) {
    return (look.sequence != null ? 2 : 0) +
        (look.title?.trim().isNotEmpty == true ? 1 : 0) +
        (look.referenceImageUrl?.trim().isNotEmpty == true ? 1 : 0);
  }

  int? _progressFromCompletedLooks({
    required int completedCount,
    required int totalCount,
  }) {
    if (totalCount <= 0 || completedCount <= 0) {
      return null;
    }

    if (completedCount >= totalCount) {
      return 100;
    }

    return ((completedCount / totalCount) * 100).floor().clamp(0, 99);
  }

  String? _progressTextFromCounts({
    required int completedCount,
    required int totalCount,
  }) {
    if (totalCount <= 0) {
      return null;
    }

    final safeCompleted = completedCount.clamp(0, totalCount);
    return '$safeCompleted/$totalCount';
  }

  void _emitTryOnFailure(Emitter<RecommendationsState> emit, String message) {
    emit(
      state.copyWith(
        step: RecommendationsStep.summary,
        isGeneratingTryOn: false,
        errorMessage: message,
        tryOnBatchId: null,
        tryOnProgress: 0,
        tryOnBatch: null,
        tryOnResults: const <TryOnGeneratedLook>[],
      ),
    );
  }

  void _cancelTryOnFlow() {
    _tryOnSessionId++;
    _tryOnRequestToken?.cancel();
    _tryOnRequestToken = null;
    _releaseTryOnRealtimeSession();
  }

  void _completeTryOnFlow() {
    _tryOnSessionId++;
    _tryOnRequestToken = null;
    _releaseTryOnRealtimeSession();
  }

  void _releaseTryOnRealtimeSession() {
    final tryOnSubscription = _tryOnRealtimeSubscription;
    final tryOnSession = _tryOnRealtimeSession;
    _tryOnRealtimeSubscription = null;
    _tryOnRealtimeSession = null;
    unawaited(_disposeTryOnRealtimeResources(tryOnSubscription, tryOnSession));
  }

  Future<void> _disposeTryOnRealtimeResources(
    StreamSubscription<TryOnResultModel>? subscription,
    TryOnRealtimeSession? session,
  ) async {
    await subscription?.cancel();
    await session?.close();
  }

  int _progressFrom(int? value, {required int fallback}) {
    final progress = value;
    if (progress == null) {
      return fallback;
    }

    return progress.clamp(0, 100);
  }

  String _photoRequiredMessage() =>
      _localized(select: (l10n) => l10n.recommendationsPhotoRequiredMessage);

  String _loadFailedMessage() =>
      _localized(select: (l10n) => l10n.recommendationsLoadFailedMessage);

  String _noRecommendationsMessage() =>
      _localized(select: (l10n) => l10n.recommendationsNoDataMessage);

  String _tryOnLooksRequiredMessage() => _localized(
    select: (l10n) => l10n.recommendationsTryOnLooksRequiredMessage,
  );

  String _tryOnFailedMessage() =>
      _localized(select: (l10n) => l10n.recommendationsTryOnFailedMessage);

  String _tryOnEmptyResultMessage() =>
      _localized(select: (l10n) => l10n.recommendationsTryOnEmptyResultMessage);

  @override
  Future<void> close() async {
    _recommendationsRequestToken?.cancel();
    _recommendationsRequestToken = null;
    _tryOnSessionId++;
    _tryOnRequestToken?.cancel();
    _tryOnRequestToken = null;
    final tryOnSubscription = _tryOnRealtimeSubscription;
    final tryOnSession = _tryOnRealtimeSession;
    _tryOnRealtimeSubscription = null;
    _tryOnRealtimeSession = null;
    await _disposeTryOnRealtimeResources(tryOnSubscription, tryOnSession);
    await _photoValidator.close();
    return super.close();
  }
}

class _RecommendationsTryOnRealtimeUpdated extends RecommendationsEvent {
  const _RecommendationsTryOnRealtimeUpdated({
    required this.sessionId,
    required this.batchId,
    required this.result,
  });

  final int sessionId;
  final String batchId;
  final TryOnResultModel result;

  @override
  List<Object?> get props => [sessionId, batchId, result];
}

class _RecommendationsTryOnRealtimeFailed extends RecommendationsEvent {
  const _RecommendationsTryOnRealtimeFailed({
    required this.sessionId,
    required this.message,
  });

  final int sessionId;
  final String message;

  @override
  List<Object?> get props => [sessionId, message];
}

class _CompletedTryOnResolution {
  const _CompletedTryOnResolution({required this.batch, required this.results});

  final TryOnResultModel batch;
  final List<TryOnGeneratedLook> results;
}

String _localized({
  String? fallback,
  required String Function(AppLocalizations l10n) select,
}) {
  return localizedString(fallback: fallback, select: select);
}

void _logDebug(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}
