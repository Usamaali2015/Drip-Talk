import 'package:drip_talk/features/wardrobe/data/models/wardrobe_model.dart';
import 'package:equatable/equatable.dart';

enum WardrobeDetailsStatus { initial, loading, success, failure, deleted }

enum WardrobeDetailsFeedbackType { success, error, info }

enum WardrobeItemFilter { all, wardrobe, laundry }

enum WardrobeSelectedItemsAction {
  removeFromLaundry,
  sendToLaundry,
  moveToWardrobe,
}

class WardrobeDetailsState extends Equatable {
  const WardrobeDetailsState({
    this.status = WardrobeDetailsStatus.initial,
    this.wardrobe,
    this.filter = WardrobeItemFilter.all,
    this.selectedItemIds = const <int>[],
    this.selectedItemsAction,
    this.isRefreshing = false,
    this.isUpdatingItems = false,
    this.isDeletingItems = false,
    this.isRenaming = false,
    this.isAddingImages = false,
    this.isSettingCover = false,
    this.isDeletingWardrobe = false,
    this.errorMessage,
    this.feedbackMessage,
    this.feedbackType = WardrobeDetailsFeedbackType.info,
  });

  final WardrobeDetailsStatus status;
  final WardrobeModel? wardrobe;
  final WardrobeItemFilter filter;
  final List<int> selectedItemIds;
  final WardrobeSelectedItemsAction? selectedItemsAction;
  final bool isRefreshing;
  final bool isUpdatingItems;
  final bool isDeletingItems;
  final bool isRenaming;
  final bool isAddingImages;
  final bool isSettingCover;
  final bool isDeletingWardrobe;
  final String? errorMessage;
  final String? feedbackMessage;
  final WardrobeDetailsFeedbackType feedbackType;

  bool get isInitialLoading =>
      wardrobe == null &&
      (status == WardrobeDetailsStatus.initial ||
          status == WardrobeDetailsStatus.loading);

  bool get hasWardrobe => wardrobe != null;

  bool get hasSelection => selectedItemIds.isNotEmpty;

  bool get isSelectedItemsActionLoading =>
      isUpdatingItems && selectedItemsAction != null;

  bool get isMutating =>
      isUpdatingItems ||
      isDeletingItems ||
      isRenaming ||
      isAddingImages ||
      isSettingCover ||
      isDeletingWardrobe;

  List<WardrobeItemModel> get filteredItems {
    final items = wardrobe?.items ?? const <WardrobeItemModel>[];
    switch (filter) {
      case WardrobeItemFilter.all:
        return items;
      case WardrobeItemFilter.wardrobe:
        return items.where((item) => item.isInWardrobeLike).toList();
      case WardrobeItemFilter.laundry:
        return items.where((item) => item.isInLaundry).toList();
    }
  }

  List<WardrobeItemModel> get selectedItems {
    if (selectedItemIds.isEmpty) {
      return const <WardrobeItemModel>[];
    }

    final selectedIds = selectedItemIds.toSet();
    return (wardrobe?.items ?? const <WardrobeItemModel>[])
        .where((item) => item.id != null && selectedIds.contains(item.id))
        .toList();
  }

  bool get allVisibleItemsSelected {
    final visibleIds = filteredItems
        .map((item) => item.id)
        .whereType<int>()
        .toList();
    if (visibleIds.isEmpty) {
      return false;
    }

    final selectedIds = selectedItemIds.toSet();
    return visibleIds.every(selectedIds.contains);
  }

  bool get canSendToLaundry => selectedItems.any((item) => !item.isInLaundry);

  bool get canRemoveFromLaundry =>
      selectedItems.any((item) => item.isInLaundry);

  bool get canSetCover => selectedItems.length == 1;

  WardrobeDetailsState copyWith({
    WardrobeDetailsStatus? status,
    WardrobeModel? wardrobe,
    bool clearWardrobe = false,
    WardrobeItemFilter? filter,
    List<int>? selectedItemIds,
    WardrobeSelectedItemsAction? selectedItemsAction,
    bool? isRefreshing,
    bool? isUpdatingItems,
    bool? isDeletingItems,
    bool? isRenaming,
    bool? isAddingImages,
    bool? isSettingCover,
    bool? isDeletingWardrobe,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? feedbackMessage,
    WardrobeDetailsFeedbackType? feedbackType,
    bool clearFeedback = false,
  }) {
    return WardrobeDetailsState(
      status: status ?? this.status,
      wardrobe: clearWardrobe ? null : (wardrobe ?? this.wardrobe),
      filter: filter ?? this.filter,
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
      selectedItemsAction: selectedItemsAction ?? this.selectedItemsAction,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isUpdatingItems: isUpdatingItems ?? this.isUpdatingItems,
      isDeletingItems: isDeletingItems ?? this.isDeletingItems,
      isRenaming: isRenaming ?? this.isRenaming,
      isAddingImages: isAddingImages ?? this.isAddingImages,
      isSettingCover: isSettingCover ?? this.isSettingCover,
      isDeletingWardrobe: isDeletingWardrobe ?? this.isDeletingWardrobe,
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
    wardrobe,
    filter,
    selectedItemIds,
    selectedItemsAction,
    isRefreshing,
    isUpdatingItems,
    isDeletingItems,
    isRenaming,
    isAddingImages,
    isSettingCover,
    isDeletingWardrobe,
    errorMessage,
    feedbackMessage,
    feedbackType,
  ];
}
