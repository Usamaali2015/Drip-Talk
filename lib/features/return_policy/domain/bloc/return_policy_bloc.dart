import 'package:drip_talk/core/services/api/api_error_resolver.dart';
import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:drip_talk/features/return_policy/data/repository/return_policy_repository.dart';
import 'package:drip_talk/features/return_policy/domain/bloc/return_policy_event.dart';
import 'package:drip_talk/features/return_policy/domain/bloc/return_policy_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReturnPolicyBloc extends Bloc<ReturnPolicyEvent, ReturnPolicyState> {
  ReturnPolicyBloc(this._repository) : super(const ReturnPolicyState()) {
    on<LoadReturnPolicyRequested>(_onLoadRequested);
  }

  final ReturnPolicyRepository _repository;

  Future<void> _onLoadRequested(
    LoadReturnPolicyRequested event,
    Emitter<ReturnPolicyState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ReturnPolicyStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final response = await _repository.getReturnPolicy();
      final policy = response.data;

      if (!response.isSuccessful && policy == null) {
        emit(
          state.copyWith(
            status: ReturnPolicyStatus.failure,
            clearPolicy: true,
            errorMessage:
                response.message ??
                localizedString(
                  fallback: 'Unable to load return policy.',
                  select: (l10n) => l10n.returnPolicyLoadFailed,
                ),
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: ReturnPolicyStatus.success,
          policy: policy,
          clearErrorMessage: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ReturnPolicyStatus.failure,
          clearPolicy: true,
          errorMessage: resolveApiErrorMessage(
            error,
            fallback: localizedString(
              fallback: 'Unable to load return policy.',
              select: (l10n) => l10n.returnPolicyLoadFailed,
            ),
          ),
        ),
      );
    }
  }
}
