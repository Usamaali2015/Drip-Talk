import 'package:dio/dio.dart';
import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:drip_talk/features/wardrobe/data/repository/wardrobe_repository.dart';
import 'package:drip_talk/features/wardrobe/domain/bloc/wardrobe_list_event.dart';
import 'package:drip_talk/features/wardrobe/domain/bloc/wardrobe_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WardrobeListBloc extends Bloc<WardrobeListEvent, WardrobeListState> {
  WardrobeListBloc(this._repository) : super(const WardrobeListState()) {
    on<LoadWardrobesRequested>(_onLoadWardrobesRequested);
    on<DeleteWardrobeFromListRequested>(_onDeleteWardrobeRequested);
  }

  final WardrobeRepository _repository;

  Future<void> _onLoadWardrobesRequested(
    LoadWardrobesRequested event,
    Emitter<WardrobeListState> emit,
  ) async {
    final shouldRefreshInPlace =
        state.wardrobes.isNotEmpty && !event.showLoader;

    emit(
      state.copyWith(
        status: event.showLoader || state.wardrobes.isEmpty
            ? WardrobeListStatus.loading
            : state.status,
        isRefreshing: shouldRefreshInPlace,
        clearErrorMessage: true,
        clearFeedback: true,
      ),
    );

    try {
      final response = await _repository.getWardrobes();
      if (!response.isSuccessful && response.wardrobes.isEmpty) {
        final message = localizedString(
          fallback: 'Unable to load wardrobes right now.',
          select: (l10n) => l10n.wardrobeListLoadFailed,
        );
        emit(
          state.copyWith(
            status: state.wardrobes.isEmpty
                ? WardrobeListStatus.failure
                : WardrobeListStatus.success,
            isRefreshing: false,
            errorMessage: state.wardrobes.isEmpty
                ? response.message?.trim().isNotEmpty == true
                      ? response.message!.trim()
                      : message
                : null,
            feedbackMessage: state.wardrobes.isEmpty
                ? null
                : response.message?.trim().isNotEmpty == true
                ? response.message!.trim()
                : message,
            feedbackType: WardrobeListFeedbackType.error,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: WardrobeListStatus.success,
          wardrobes: response.wardrobes,
          isRefreshing: false,
          clearErrorMessage: true,
          clearFeedback: true,
        ),
      );
    } catch (error) {
      final resolvedMessage = _resolveErrorMessage(
        error,
        fallback: localizedString(
          fallback: 'Unable to load wardrobes right now.',
          select: (l10n) => l10n.wardrobeListLoadFailed,
        ),
      );
      emit(
        state.copyWith(
          status: state.wardrobes.isEmpty
              ? WardrobeListStatus.failure
              : WardrobeListStatus.success,
          isRefreshing: false,
          errorMessage: state.wardrobes.isEmpty ? resolvedMessage : null,
          feedbackMessage: state.wardrobes.isEmpty ? null : resolvedMessage,
          feedbackType: WardrobeListFeedbackType.error,
        ),
      );
    }
  }

  Future<void> _onDeleteWardrobeRequested(
    DeleteWardrobeFromListRequested event,
    Emitter<WardrobeListState> emit,
  ) async {
    final wardrobeId = event.wardrobe.id;
    if (wardrobeId == null || state.isDeletingWardrobe(wardrobeId)) {
      return;
    }

    emit(
      state.copyWith(
        pendingDeleteIds: [...state.pendingDeleteIds, wardrobeId],
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
          status: WardrobeListStatus.success,
          wardrobes: state.wardrobes
              .where((wardrobe) => wardrobe.id != wardrobeId)
              .toList(),
          pendingDeleteIds: state.pendingDeleteIds
              .where((id) => id != wardrobeId)
              .toList(),
          feedbackMessage: message,
          feedbackType: WardrobeListFeedbackType.success,
          clearErrorMessage: true,
        ),
      );
    } catch (error) {
      final message = _resolveErrorMessage(
        error,
        fallback: localizedString(
          fallback: 'Unable to delete wardrobe',
          select: (l10n) => l10n.wardrobeDeleteFailed,
        ),
      );
      emit(
        state.copyWith(
          pendingDeleteIds: state.pendingDeleteIds
              .where((id) => id != wardrobeId)
              .toList(),
          feedbackMessage: message,
          feedbackType: WardrobeListFeedbackType.error,
        ),
      );
    }
  }
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
