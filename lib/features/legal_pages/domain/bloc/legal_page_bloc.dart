import 'package:drip_talk/core/services/api/api_error_resolver.dart';
import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:drip_talk/features/legal_pages/data/repository/legal_pages_repository.dart';
import 'package:drip_talk/features/legal_pages/domain/bloc/legal_page_event.dart';
import 'package:drip_talk/features/legal_pages/domain/bloc/legal_page_state.dart';
import 'package:drip_talk/features/legal_pages/legal_page_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LegalPageBloc extends Bloc<LegalPageEvent, LegalPageState> {
  LegalPageBloc(this._repository, this.pageType)
    : super(const LegalPageState()) {
    on<LoadLegalPageRequested>(_onLoadRequested);
  }

  final LegalPagesRepository _repository;
  final LegalPageType pageType;

  Future<void> _onLoadRequested(
    LoadLegalPageRequested event,
    Emitter<LegalPageState> emit,
  ) async {
    emit(
      state.copyWith(status: LegalPageStatus.loading, clearErrorMessage: true),
    );

    try {
      final response = await _repository.getPage(pageType);
      final page = response.data;

      if (!response.isSuccessful && page == null) {
        emit(
          state.copyWith(
            status: LegalPageStatus.failure,
            clearPage: true,
            errorMessage: response.message ?? _loadFailedFallback(),
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: LegalPageStatus.success,
          page: page,
          clearErrorMessage: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: LegalPageStatus.failure,
          clearPage: true,
          errorMessage: resolveApiErrorMessage(
            error,
            fallback: _loadFailedFallback(),
          ),
        ),
      );
    }
  }

  String _loadFailedFallback() {
    switch (pageType) {
      case LegalPageType.privacyPolicy:
        return localizedString(
          fallback: 'Unable to load privacy policy.',
          select: (l10n) => l10n.privacyPolicyLoadFailed,
        );
      case LegalPageType.termsAndConditions:
        return localizedString(
          fallback: 'Unable to load terms & conditions.',
          select: (l10n) => l10n.termsAndConditionsLoadFailed,
        );
    }
  }
}
