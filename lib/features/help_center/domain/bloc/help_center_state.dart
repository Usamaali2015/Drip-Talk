import 'package:equatable/equatable.dart';
import 'package:drip_talk/features/help_center/data/models/help_center_model.dart';

enum HelpCenterStatus { initial, loading, success, failure }

class HelpCenterState extends Equatable {
  const HelpCenterState({
    this.status = HelpCenterStatus.initial,
    this.categories = const <HelpCenterItem>[],
    this.selectedCategoryId,
    this.errorMessage,
    this.isRefreshing = false,
  });

  final HelpCenterStatus status;
  final List<HelpCenterItem> categories;
  final int? selectedCategoryId;
  final String? errorMessage;
  final bool isRefreshing;

  bool get isInitialLoading =>
      status == HelpCenterStatus.loading && categories.isEmpty;

  bool get isFailure => status == HelpCenterStatus.failure;

  bool get hasCategories => categories.isNotEmpty;

  bool get isEmpty => status == HelpCenterStatus.success && categories.isEmpty;

  HelpCenterItem? get selectedCategory {
    if (categories.isEmpty) {
      return null;
    }

    for (final category in categories) {
      if (category.id == selectedCategoryId) {
        return category;
      }
    }

    return categories.first;
  }

  HelpCenterState copyWith({
    HelpCenterStatus? status,
    List<HelpCenterItem>? categories,
    int? selectedCategoryId,
    bool clearSelectedCategory = false,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? isRefreshing,
  }) {
    return HelpCenterState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      selectedCategoryId: clearSelectedCategory
          ? null
          : selectedCategoryId ?? this.selectedCategoryId,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
    status,
    categories,
    selectedCategoryId,
    errorMessage,
    isRefreshing,
  ];
}
