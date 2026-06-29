import 'package:drip_talk/features/wardrobe/data/models/wardrobe_model.dart';
import 'package:equatable/equatable.dart';

enum WardrobeListStatus { initial, loading, success, failure }

enum WardrobeListFeedbackType { success, error, info }

class WardrobeListState extends Equatable {
  const WardrobeListState({
    this.status = WardrobeListStatus.initial,
    this.wardrobes = const <WardrobeModel>[],
    this.isRefreshing = false,
    this.pendingDeleteIds = const <int>[],
    this.errorMessage,
    this.feedbackMessage,
    this.feedbackType = WardrobeListFeedbackType.info,
  });

  final WardrobeListStatus status;
  final List<WardrobeModel> wardrobes;
  final bool isRefreshing;
  final List<int> pendingDeleteIds;
  final String? errorMessage;
  final String? feedbackMessage;
  final WardrobeListFeedbackType feedbackType;

  bool get isInitialLoading =>
      wardrobes.isEmpty &&
      (status == WardrobeListStatus.initial ||
          status == WardrobeListStatus.loading);

  bool get isEmpty => status == WardrobeListStatus.success && wardrobes.isEmpty;

  bool isDeletingWardrobe(int? wardrobeId) {
    if (wardrobeId == null) {
      return false;
    }

    return pendingDeleteIds.contains(wardrobeId);
  }

  WardrobeListState copyWith({
    WardrobeListStatus? status,
    List<WardrobeModel>? wardrobes,
    bool? isRefreshing,
    List<int>? pendingDeleteIds,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? feedbackMessage,
    WardrobeListFeedbackType? feedbackType,
    bool clearFeedback = false,
  }) {
    return WardrobeListState(
      status: status ?? this.status,
      wardrobes: wardrobes ?? this.wardrobes,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      pendingDeleteIds: pendingDeleteIds ?? this.pendingDeleteIds,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      feedbackMessage: clearFeedback
          ? null
          : (feedbackMessage ?? this.feedbackMessage),
      feedbackType: feedbackType ?? this.feedbackType,
    );
  }

  @override
  List<Object?> get props => [
    status,
    wardrobes,
    isRefreshing,
    pendingDeleteIds,
    errorMessage,
    feedbackMessage,
    feedbackType,
  ];
}
