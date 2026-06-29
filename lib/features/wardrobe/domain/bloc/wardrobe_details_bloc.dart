import 'package:dio/dio.dart';
import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:drip_talk/features/wardrobe/data/models/wardrobe_model.dart';
import 'package:drip_talk/features/wardrobe/data/models/wardrobe_request_models.dart';
import 'package:drip_talk/features/wardrobe/data/repository/wardrobe_repository.dart';
import 'package:drip_talk/features/wardrobe/domain/bloc/wardrobe_details_event.dart';
import 'package:drip_talk/features/wardrobe/domain/bloc/wardrobe_details_state.dart';
import 'package:drip_talk/features/wardrobe/domain/wardrobe_sync_notifier.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WardrobeDetailsBloc
    extends Bloc<WardrobeDetailsEvent, WardrobeDetailsState> {
  WardrobeDetailsBloc(this._repository, this._syncNotifier)
    : super(const WardrobeDetailsState()) {
    on<LoadWardrobeDetailsRequested>(_onLoadWardrobeDetailsRequested);
    on<WardrobeFilterChanged>(_onFilterChanged);
    on<WardrobeItemSelectionToggled>(_onItemSelectionToggled);
    on<WardrobeVisibleSelectionToggled>(_onVisibleSelectionToggled);
    on<WardrobeSelectionCleared>(_onSelectionCleared);
    on<WardrobeSelectedItemsStatusUpdateRequested>(
      _onSelectedItemsStatusUpdateRequested,
    );
    on<DeleteSelectedWardrobeItemsRequested>(
      _onDeleteSelectedWardrobeItemsRequested,
    );
    on<RenameWardrobeRequested>(_onRenameWardrobeRequested);
    on<AddWardrobeImagesRequested>(_onAddWardrobeImagesRequested);
    on<SetWardrobeCoverRequested>(_onSetWardrobeCoverRequested);
    on<DeleteWardrobeRequested>(_onDeleteWardrobeRequested);
  }

  final WardrobeRepository _repository;
  final WardrobeSyncNotifier _syncNotifier;

  Future<void> _onLoadWardrobeDetailsRequested(
    LoadWardrobeDetailsRequested event,
    Emitter<WardrobeDetailsState> emit,
  ) async {
    final currentWardrobe = state.wardrobe;
    final shouldRefreshInPlace = currentWardrobe != null && !event.showLoader;

    final initialWardrobe =
        event.initialWardrobe ??
        (currentWardrobe?.id == event.wardrobeId ? currentWardrobe : null);

    emit(
      state.copyWith(
        status: event.showLoader || currentWardrobe == null
            ? WardrobeDetailsStatus.loading
            : state.status,
        wardrobe: initialWardrobe,
        isRefreshing: shouldRefreshInPlace,
        clearErrorMessage: true,
        clearFeedback: true,
      ),
    );

    try {
      final wardrobe = await _fetchWardrobe(event.wardrobeId);
      if (wardrobe == null) {
        final message = localizedString(
          fallback: 'Wardrobe not found',
          select: (l10n) => l10n.wardrobeNotFound,
        );
        emit(
          state.copyWith(
            status: WardrobeDetailsStatus.failure,
            isRefreshing: false,
            errorMessage: message,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: WardrobeDetailsStatus.success,
          wardrobe: wardrobe,
          selectedItemIds: _sanitizeSelection(
            state.selectedItemIds,
            wardrobe.items,
          ),
          isRefreshing: false,
          clearErrorMessage: true,
          clearFeedback: true,
        ),
      );
    } catch (error) {
      final resolvedMessage = _resolveErrorMessage(
        error,
        fallback: localizedString(
          fallback: 'Unable to load wardrobe',
          select: (l10n) => l10n.wardrobeDetailsLoadFailed,
        ),
      );
      emit(
        state.copyWith(
          status: initialWardrobe == null
              ? WardrobeDetailsStatus.failure
              : WardrobeDetailsStatus.success,
          isRefreshing: false,
          errorMessage: initialWardrobe == null ? resolvedMessage : null,
          feedbackMessage: initialWardrobe == null ? null : resolvedMessage,
          feedbackType: WardrobeDetailsFeedbackType.error,
        ),
      );
    }
  }

  void _onFilterChanged(
    WardrobeFilterChanged event,
    Emitter<WardrobeDetailsState> emit,
  ) {
    emit(
      state.copyWith(
        filter: event.filter,
        selectedItemIds: const <int>[],
        clearFeedback: true,
      ),
    );
  }

  void _onItemSelectionToggled(
    WardrobeItemSelectionToggled event,
    Emitter<WardrobeDetailsState> emit,
  ) {
    final selectedIds = [...state.selectedItemIds];
    if (selectedIds.contains(event.itemId)) {
      selectedIds.remove(event.itemId);
    } else {
      selectedIds.add(event.itemId);
    }

    emit(state.copyWith(selectedItemIds: selectedIds, clearFeedback: true));
  }

  void _onVisibleSelectionToggled(
    WardrobeVisibleSelectionToggled event,
    Emitter<WardrobeDetailsState> emit,
  ) {
    final visibleIds = state.filteredItems
        .map((item) => item.id)
        .whereType<int>()
        .toList();
    if (visibleIds.isEmpty) {
      return;
    }

    final selectedIds = state.selectedItemIds.toSet();
    if (state.allVisibleItemsSelected) {
      selectedIds.removeAll(visibleIds);
    } else {
      selectedIds.addAll(visibleIds);
    }

    emit(
      state.copyWith(
        selectedItemIds: selectedIds.toList(),
        clearFeedback: true,
      ),
    );
  }

  void _onSelectionCleared(
    WardrobeSelectionCleared event,
    Emitter<WardrobeDetailsState> emit,
  ) {
    emit(state.copyWith(selectedItemIds: const <int>[], clearFeedback: true));
  }

  Future<void> _onSelectedItemsStatusUpdateRequested(
    WardrobeSelectedItemsStatusUpdateRequested event,
    Emitter<WardrobeDetailsState> emit,
  ) async {
    final wardrobeId = state.wardrobe?.id;
    final itemIds = state.selectedItemIds;
    if (wardrobeId == null || itemIds.isEmpty || state.isUpdatingItems) {
      return;
    }

    emit(
      state.copyWith(
        isUpdatingItems: true,
        selectedItemsAction: event.action,
        clearErrorMessage: true,
        clearFeedback: true,
      ),
    );

    try {
      final response = await _repository.updateWardrobeItems(
        UpdateWardrobeItemsRequestModel(
          itemIds: itemIds,
          status: event.status,
          targetWardrobeId: event.targetWardrobeId,
        ),
      );
      final refreshedWardrobe = _applySelectedItemsUpdate(
        wardrobe: state.wardrobe,
        selectedItemIds: itemIds,
        status: event.status,
        targetWardrobeId: event.targetWardrobeId,
      );
      final message = response.message?.trim().isNotEmpty == true
          ? response.message!.trim()
          : localizedString(
              fallback: 'Wardrobe items updated successfully',
              select: (l10n) => l10n.wardrobeItemsUpdatedSuccess,
            );

      emit(
        state.copyWith(
          status: WardrobeDetailsStatus.success,
          wardrobe: refreshedWardrobe,
          selectedItemIds: const <int>[],
          isUpdatingItems: false,
          selectedItemsAction: event.action,
          feedbackMessage: message,
          feedbackType: WardrobeDetailsFeedbackType.success,
          clearErrorMessage: true,
        ),
      );
      _syncNotifier.notifyChanged();
    } catch (error) {
      emit(
        state.copyWith(
          isUpdatingItems: false,
          selectedItemsAction: event.action,
          feedbackMessage: _resolveErrorMessage(
            error,
            fallback: localizedString(
              fallback: 'Unable to update wardrobe items',
              select: (l10n) => l10n.wardrobeItemsUpdateFailed,
            ),
          ),
          feedbackType: WardrobeDetailsFeedbackType.error,
        ),
      );
    }
  }

  Future<void> _onDeleteSelectedWardrobeItemsRequested(
    DeleteSelectedWardrobeItemsRequested event,
    Emitter<WardrobeDetailsState> emit,
  ) async {
    final wardrobeId = state.wardrobe?.id;
    final itemIds = state.selectedItemIds;
    if (wardrobeId == null || itemIds.isEmpty || state.isDeletingItems) {
      return;
    }

    emit(
      state.copyWith(
        isDeletingItems: true,
        clearErrorMessage: true,
        clearFeedback: true,
      ),
    );

    try {
      final response = await _repository.deleteWardrobeItems(itemIds: itemIds);
      final refreshedWardrobe =
          await _refreshWardrobeAfterMutation(wardrobeId) ?? state.wardrobe;
      final message = response.message?.trim().isNotEmpty == true
          ? response.message!.trim()
          : localizedString(
              fallback: 'Wardrobe items deleted successfully',
              select: (l10n) => l10n.wardrobeItemsDeletedSuccess,
            );

      emit(
        state.copyWith(
          status: WardrobeDetailsStatus.success,
          wardrobe: refreshedWardrobe,
          selectedItemIds: const <int>[],
          isDeletingItems: false,
          feedbackMessage: message,
          feedbackType: WardrobeDetailsFeedbackType.success,
          clearErrorMessage: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isDeletingItems: false,
          feedbackMessage: _resolveErrorMessage(
            error,
            fallback: localizedString(
              fallback: 'Unable to delete wardrobe items',
              select: (l10n) => l10n.wardrobeItemsDeleteFailed,
            ),
          ),
          feedbackType: WardrobeDetailsFeedbackType.error,
        ),
      );
    }
  }

  Future<void> _onRenameWardrobeRequested(
    RenameWardrobeRequested event,
    Emitter<WardrobeDetailsState> emit,
  ) async {
    final wardrobeId = state.wardrobe?.id;
    final normalizedTitle = event.title.trim();
    if (wardrobeId == null || normalizedTitle.isEmpty || state.isRenaming) {
      return;
    }

    emit(
      state.copyWith(
        isRenaming: true,
        clearErrorMessage: true,
        clearFeedback: true,
      ),
    );

    try {
      final response = await _repository.updateWardrobe(
        wardrobeId: wardrobeId,
        request: UpdateWardrobeRequestModel(title: normalizedTitle),
      );
      final refreshedWardrobe =
          await _refreshWardrobeAfterMutation(wardrobeId) ??
          state.wardrobe?.copyWith(title: normalizedTitle);
      final message = response.message?.trim().isNotEmpty == true
          ? response.message!.trim()
          : localizedString(
              fallback: 'Wardrobe renamed successfully',
              select: (l10n) => l10n.wardrobeRenamedSuccess,
            );

      emit(
        state.copyWith(
          status: WardrobeDetailsStatus.success,
          wardrobe: refreshedWardrobe,
          isRenaming: false,
          feedbackMessage: message,
          feedbackType: WardrobeDetailsFeedbackType.success,
          clearErrorMessage: true,
        ),
      );
      _syncNotifier.notifyChanged();
    } catch (error) {
      emit(
        state.copyWith(
          isRenaming: false,
          feedbackMessage: _resolveErrorMessage(
            error,
            fallback: localizedString(
              fallback: 'Unable to rename wardrobe',
              select: (l10n) => l10n.wardrobeRenameFailed,
            ),
          ),
          feedbackType: WardrobeDetailsFeedbackType.error,
        ),
      );
    }
  }

  Future<void> _onAddWardrobeImagesRequested(
    AddWardrobeImagesRequested event,
    Emitter<WardrobeDetailsState> emit,
  ) async {
    final wardrobeId = state.wardrobe?.id;
    if (wardrobeId == null || event.images.isEmpty || state.isAddingImages) {
      return;
    }

    emit(
      state.copyWith(
        isAddingImages: true,
        clearErrorMessage: true,
        clearFeedback: true,
      ),
    );

    try {
      final response = await _repository.updateWardrobe(
        wardrobeId: wardrobeId,
        request: UpdateWardrobeRequestModel(images: event.images),
      );
      final refreshedWardrobe =
          await _refreshWardrobeAfterMutation(wardrobeId) ?? state.wardrobe;
      final message = response.message?.trim().isNotEmpty == true
          ? response.message!.trim()
          : localizedString(
              fallback: 'Dresses added to wardrobe successfully',
              select: (l10n) => l10n.wardrobeAddedSuccess,
            );

      emit(
        state.copyWith(
          status: WardrobeDetailsStatus.success,
          wardrobe: refreshedWardrobe,
          isAddingImages: false,
          feedbackMessage: message,
          feedbackType: WardrobeDetailsFeedbackType.success,
          clearErrorMessage: true,
        ),
      );
      _syncNotifier.notifyChanged();
    } catch (error) {
      emit(
        state.copyWith(
          isAddingImages: false,
          feedbackMessage: _resolveErrorMessage(
            error,
            fallback: localizedString(
              fallback: 'Unable to add dresses',
              select: (l10n) => l10n.wardrobeAddFailed,
            ),
          ),
          feedbackType: WardrobeDetailsFeedbackType.error,
        ),
      );
    }
  }

  Future<void> _onSetWardrobeCoverRequested(
    SetWardrobeCoverRequested event,
    Emitter<WardrobeDetailsState> emit,
  ) async {
    final wardrobeId = state.wardrobe?.id;
    if (wardrobeId == null || state.isSettingCover) {
      return;
    }

    emit(
      state.copyWith(
        isSettingCover: true,
        clearErrorMessage: true,
        clearFeedback: true,
      ),
    );

    try {
      final response = await _repository.updateWardrobe(
        wardrobeId: wardrobeId,
        request: UpdateWardrobeRequestModel(coverItemId: event.itemId),
      );
      final refreshedWardrobe =
          await _refreshWardrobeAfterMutation(wardrobeId) ?? state.wardrobe;
      final message = response.message?.trim().isNotEmpty == true
          ? response.message!.trim()
          : localizedString(
              fallback: 'Wardrobe cover updated successfully',
              select: (l10n) => l10n.wardrobeCoverUpdatedSuccess,
            );

      emit(
        state.copyWith(
          status: WardrobeDetailsStatus.success,
          wardrobe: refreshedWardrobe,
          isSettingCover: false,
          feedbackMessage: message,
          feedbackType: WardrobeDetailsFeedbackType.success,
          clearErrorMessage: true,
        ),
      );
      _syncNotifier.notifyChanged();
    } catch (error) {
      emit(
        state.copyWith(
          isSettingCover: false,
          feedbackMessage: _resolveErrorMessage(
            error,
            fallback: localizedString(
              fallback: 'Unable to update wardrobe cover',
              select: (l10n) => l10n.wardrobeCoverUpdateFailed,
            ),
          ),
          feedbackType: WardrobeDetailsFeedbackType.error,
        ),
      );
    }
  }

  Future<void> _onDeleteWardrobeRequested(
    DeleteWardrobeRequested event,
    Emitter<WardrobeDetailsState> emit,
  ) async {
    final wardrobeId = state.wardrobe?.id;
    if (wardrobeId == null || state.isDeletingWardrobe) {
      return;
    }

    emit(
      state.copyWith(
        isDeletingWardrobe: true,
        clearErrorMessage: true,
        clearFeedback: true,
      ),
    );

    try {
      final response = await _repository.deleteWardrobe(wardrobeId: wardrobeId);
      final message = response.message?.trim().isNotEmpty == true
          ? response.message!.trim()
          : localizedString(
              fallback: 'Wardrobe deleted successfully',
              select: (l10n) => l10n.wardrobeDeleteSuccess,
            );
      emit(
        state.copyWith(
          status: WardrobeDetailsStatus.deleted,
          isDeletingWardrobe: false,
          feedbackMessage: message,
          feedbackType: WardrobeDetailsFeedbackType.success,
          selectedItemIds: const <int>[],
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isDeletingWardrobe: false,
          feedbackMessage: _resolveErrorMessage(
            error,
            fallback: localizedString(
              fallback: 'Unable to delete wardrobe',
              select: (l10n) => l10n.wardrobeDeleteFailed,
            ),
          ),
          feedbackType: WardrobeDetailsFeedbackType.error,
        ),
      );
    }
  }

  Future<WardrobeModel?> _fetchWardrobe(int wardrobeId) async {
    final response = await _repository.getWardrobes();
    return response.wardrobeById(wardrobeId);
  }

  Future<WardrobeModel?> _refreshWardrobeAfterMutation(int wardrobeId) async {
    try {
      return await _fetchWardrobe(wardrobeId);
    } catch (_) {
      return null;
    }
  }
}

WardrobeModel? _applySelectedItemsUpdate({
  required WardrobeModel? wardrobe,
  required List<int> selectedItemIds,
  required String status,
  required int? targetWardrobeId,
}) {
  if (wardrobe == null || selectedItemIds.isEmpty) {
    return wardrobe;
  }

  final selectedIds = selectedItemIds.toSet();
  final movesToDifferentWardrobe =
      targetWardrobeId != null && targetWardrobeId != wardrobe.id;

  final updatedItems = movesToDifferentWardrobe
      ? wardrobe.items
            .where(
              (item) => item.id == null || !selectedIds.contains(item.id),
            )
            .toList(growable: false)
      : wardrobe.items
            .map((item) {
              if (item.id == null || !selectedIds.contains(item.id)) {
                return item;
              }

              return item.copyWith(
                status: status,
                wardrobeId: targetWardrobeId ?? wardrobe.id,
              );
            })
            .toList(growable: false);

  return wardrobe.copyWith(
    items: updatedItems,
    totalItems: updatedItems.length,
    inWardrobeCount: updatedItems.where((item) => item.isInWardrobeLike).length,
    inLaundryCount: updatedItems.where((item) => item.isInLaundry).length,
  );
}

List<int> _sanitizeSelection(
  List<int> selectedItemIds,
  List<WardrobeItemModel> items,
) {
  final validIds = items.map((item) => item.id).whereType<int>().toSet();
  return selectedItemIds.where(validIds.contains).toList();
}

String _resolveErrorMessage(Object error, {required String fallback}) {
  if (error is DioException) {
    final responseMap = _asMap(error.response?.data);
    final message = responseMap?['message']?.toString().trim();
    if (message != null && message.isNotEmpty) {
      return message;
    }

    final dioMessage = error.message?.trim();
    if (dioMessage != null && dioMessage.isNotEmpty) {
      return dioMessage;
    }
  }

  return fallback;
}

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
  }

  return null;
}
