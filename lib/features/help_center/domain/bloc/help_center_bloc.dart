import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drip_talk/core/services/api/api_error_resolver.dart';
import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:drip_talk/features/help_center/data/models/help_center_model.dart';
import 'package:drip_talk/features/help_center/data/repository/help_center_repository.dart';
import 'package:drip_talk/features/help_center/domain/bloc/help_center_event.dart';
import 'package:drip_talk/features/help_center/domain/bloc/help_center_state.dart';

class HelpCenterBloc extends Bloc<HelpCenterEvent, HelpCenterState> {
  HelpCenterBloc(this._repository) : super(const HelpCenterState()) {
    on<LoadHelpCenterRequested>(_onLoadRequested);
    on<HelpCenterCategorySelected>(_onCategorySelected);
  }

  final HelpCenterRepository _repository;

  Future<void> _onLoadRequested(
    LoadHelpCenterRequested event,
    Emitter<HelpCenterState> emit,
  ) async {
    final shouldRefreshInPlace =
        state.categories.isNotEmpty && !event.showLoader;

    emit(
      state.copyWith(
        status: event.showLoader || state.categories.isEmpty
            ? HelpCenterStatus.loading
            : state.status,
        isRefreshing: shouldRefreshInPlace,
        clearErrorMessage: true,
      ),
    );

    try {
      final response = await _repository.getPages();
      final categories = response.data?.items ?? const [];
      final selectedCategoryId = _resolveSelectedCategoryId(categories);

      if (!response.isSuccessful && categories.isEmpty) {
        emit(
          state.copyWith(
            status: HelpCenterStatus.failure,
            categories: categories,
            selectedCategoryId: selectedCategoryId,
            isRefreshing: false,
            errorMessage:
                response.message ??
                localizedString(
                  fallback: 'Unable to load help center.',
                  select: (l10n) => l10n.helpCenterLoadFailed,
                ),
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: HelpCenterStatus.success,
          categories: categories,
          selectedCategoryId: selectedCategoryId,
          isRefreshing: false,
          clearErrorMessage: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: state.categories.isEmpty
              ? HelpCenterStatus.failure
              : HelpCenterStatus.success,
          isRefreshing: false,
          errorMessage: state.categories.isEmpty
              ? resolveApiErrorMessage(
                  error,
                  fallback: localizedString(
                    fallback: 'Unable to load help center.',
                    select: (l10n) => l10n.helpCenterLoadFailed,
                  ),
                )
              : null,
        ),
      );
    }
  }

  void _onCategorySelected(
    HelpCenterCategorySelected event,
    Emitter<HelpCenterState> emit,
  ) {
    final hasCategory = state.categories.any(
      (item) => item.id == event.categoryId,
    );
    if (!hasCategory || state.selectedCategoryId == event.categoryId) {
      return;
    }

    emit(
      state.copyWith(
        status: HelpCenterStatus.success,
        selectedCategoryId: event.categoryId,
        clearErrorMessage: true,
      ),
    );
  }

  int? _resolveSelectedCategoryId(List<HelpCenterItem> categories) {
    if (categories.isEmpty) {
      return null;
    }

    final currentSelection = state.selectedCategoryId;
    for (final category in categories) {
      if (category.id == currentSelection) {
        return currentSelection;
      }
    }

    return categories.first.id;
  }
}
