import 'dart:io';

import 'package:drip_talk/features/recommendations/data/models/recommendations_model.dart';
import 'package:drip_talk/features/recommendations/data/models/try_on_result_model.dart';
import 'package:equatable/equatable.dart';

enum RecommendationsStep {
  photo,
  review,
  summary,
  tryOnProcessing,
  tryOnResults,
}

class RecommendationsState extends Equatable {
  const RecommendationsState({
    this.step = RecommendationsStep.photo,
    this.selectedPhoto,
    this.recommendations,
    this.currentIndex = 0,
    this.likedIndices = const <int>[],
    this.dislikedIndices = const <int>[],
    this.skippedIndices = const <int>[],
    this.isValidatingPhoto = false,
    this.isFetchingRecommendations = false,
    this.isGeneratingTryOn = false,
    this.errorMessage,
    this.tryOnBatchId,
    this.tryOnProgress = 0,
    this.tryOnBatch,
    this.tryOnResults = const <TryOnGeneratedLook>[],
  });

  final RecommendationsStep step;
  final File? selectedPhoto;
  final RecommendationsModel? recommendations;
  final int currentIndex;
  final List<int> likedIndices;
  final List<int> dislikedIndices;
  final List<int> skippedIndices;
  final bool isValidatingPhoto;
  final bool isFetchingRecommendations;
  final bool isGeneratingTryOn;
  final String? errorMessage;
  final String? tryOnBatchId;
  final int tryOnProgress;
  final TryOnResultModel? tryOnBatch;
  final List<TryOnGeneratedLook> tryOnResults;

  bool get hasSelectedPhoto => selectedPhoto != null;

  bool get isLoading => isFetchingRecommendations;

  bool get isBusy =>
      isFetchingRecommendations || isValidatingPhoto || isGeneratingTryOn;

  bool get canFetchRecommendations =>
      hasSelectedPhoto && !isValidatingPhoto && !isFetchingRecommendations;

  List<RecommendationItem> get items =>
      recommendations?.items ?? const <RecommendationItem>[];

  bool get hasRecommendations => items.isNotEmpty;

  bool get isReviewing =>
      step == RecommendationsStep.review && hasRecommendations;

  bool get isCompleted =>
      step == RecommendationsStep.summary && hasRecommendations;

  bool get isShowingTryOnProcessing =>
      step == RecommendationsStep.tryOnProcessing;

  bool get hasTryOnResults =>
      step == RecommendationsStep.tryOnResults && tryOnResults.isNotEmpty;

  bool get hasExpectedTryOnResults {
    final totalItems = tryOnTotalItems;
    return totalItems > 0 && tryOnResults.length >= totalItems;
  }

  bool get isTryOnComplete =>
      tryOnBatch?.isCompleted == true || hasExpectedTryOnResults;

  int get tryOnTotalItems => tryOnBatch?.totalImages ?? tryOnResults.length;

  String? get tryOnProgressText => tryOnBatch?.progressText;

  RecommendationItem? get currentItem {
    if (!hasRecommendations ||
        currentIndex < 0 ||
        currentIndex >= items.length) {
      return null;
    }

    return items[currentIndex];
  }

  int get totalItems => items.length;

  int get currentPosition => hasRecommendations ? currentIndex + 1 : 0;

  List<RecommendationItem> get likedItems => _itemsFor(likedIndices);

  List<RecommendationItem> get likedItemsWithThumbnails => likedItems
      .where((item) => item.thumbnail?.trim().isNotEmpty == true)
      .toList(growable: false);

  List<String> get likedDressImageUrls => likedItemsWithThumbnails
      .map((item) => item.thumbnail!.trim())
      .toList(growable: false);

  List<RecommendationItem> get dislikedItems => _itemsFor(dislikedIndices);

  List<RecommendationItem> get skippedItems => _itemsFor(skippedIndices);

  bool isItemLiked(int index) => likedIndices.contains(index);

  bool get isCurrentItemLast =>
      !hasRecommendations || currentIndex >= items.length - 1;

  bool get canGenerateTryOn =>
      likedDressImageUrls.isNotEmpty &&
      hasSelectedPhoto &&
      !isGeneratingTryOn &&
      !isFetchingRecommendations &&
      !hasTryOnResults;

  List<RecommendationItem> _itemsFor(List<int> indices) {
    if (!hasRecommendations || indices.isEmpty) {
      return const <RecommendationItem>[];
    }

    return indices
        .where((index) => index >= 0 && index < items.length)
        .map((index) => items[index])
        .toList(growable: false);
  }

  RecommendationsState copyWith({
    RecommendationsStep? step,
    Object? selectedPhoto = _sentinel,
    Object? recommendations = _sentinel,
    int? currentIndex,
    List<int>? likedIndices,
    List<int>? dislikedIndices,
    List<int>? skippedIndices,
    bool? isValidatingPhoto,
    bool? isFetchingRecommendations,
    bool? isGeneratingTryOn,
    Object? errorMessage = _sentinel,
    Object? tryOnBatchId = _sentinel,
    int? tryOnProgress,
    Object? tryOnBatch = _sentinel,
    List<TryOnGeneratedLook>? tryOnResults,
  }) {
    return RecommendationsState(
      step: step ?? this.step,
      selectedPhoto: selectedPhoto == _sentinel
          ? this.selectedPhoto
          : selectedPhoto as File?,
      recommendations: recommendations == _sentinel
          ? this.recommendations
          : recommendations as RecommendationsModel?,
      currentIndex: currentIndex ?? this.currentIndex,
      likedIndices: likedIndices ?? this.likedIndices,
      dislikedIndices: dislikedIndices ?? this.dislikedIndices,
      skippedIndices: skippedIndices ?? this.skippedIndices,
      isValidatingPhoto: isValidatingPhoto ?? this.isValidatingPhoto,
      isFetchingRecommendations:
          isFetchingRecommendations ?? this.isFetchingRecommendations,
      isGeneratingTryOn: isGeneratingTryOn ?? this.isGeneratingTryOn,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
      tryOnBatchId: tryOnBatchId == _sentinel
          ? this.tryOnBatchId
          : tryOnBatchId as String?,
      tryOnProgress: tryOnProgress ?? this.tryOnProgress,
      tryOnBatch: tryOnBatch == _sentinel
          ? this.tryOnBatch
          : tryOnBatch as TryOnResultModel?,
      tryOnResults: tryOnResults ?? this.tryOnResults,
    );
  }

  @override
  List<Object?> get props => [
    step,
    selectedPhoto?.path,
    recommendations,
    currentIndex,
    likedIndices,
    dislikedIndices,
    skippedIndices,
    isValidatingPhoto,
    isFetchingRecommendations,
    isGeneratingTryOn,
    errorMessage,
    tryOnBatchId,
    tryOnProgress,
    tryOnBatch,
    tryOnResults,
  ];
}

const Object _sentinel = Object();
