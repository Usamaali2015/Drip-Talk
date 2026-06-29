import 'package:dio/dio.dart';
import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drip_talk/features/address/data/repository/address_repository.dart';
import 'package:drip_talk/features/address/domain/bloc/add_address_event.dart';
import 'package:drip_talk/features/address/domain/bloc/add_address_state.dart';

class AddAddressBloc extends Bloc<AddAddressEvent, AddAddressState> {
  AddAddressBloc(this._repository) : super(const AddAddressState()) {
    on<AddAddressFormInitialized>(_onFormInitialized);
    on<AddAddressLabelChanged>(_onLabelChanged);
    on<AddAddressDefaultToggled>(_onDefaultToggled);
    on<AddAddressSubmitted>(_onSubmitted);
  }

  final AddressRepository _repository;

  void _onFormInitialized(
    AddAddressFormInitialized event,
    Emitter<AddAddressState> emit,
  ) {
    final address = event.address;
    if (address == null) {
      emit(
        const AddAddressState().copyWith(
          clearMessage: true,
          preserveEditingAddressId: false,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: AddAddressStatus.initial,
        selectedLabel: addressLabelFromValue(address.label),
        isDefault: address.isDefaultAddress,
        submissionMode: AddressSubmissionMode.update,
        editingAddressId: address.id,
        clearMessage: true,
      ),
    );
  }

  void _onLabelChanged(
    AddAddressLabelChanged event,
    Emitter<AddAddressState> emit,
  ) {
    emit(
      state.copyWith(
        selectedLabel: event.label,
        status: AddAddressStatus.initial,
        clearMessage: true,
      ),
    );
  }

  void _onDefaultToggled(
    AddAddressDefaultToggled event,
    Emitter<AddAddressState> emit,
  ) {
    emit(
      state.copyWith(
        isDefault: event.isDefault,
        status: AddAddressStatus.initial,
        clearMessage: true,
      ),
    );
  }

  Future<void> _onSubmitted(
    AddAddressSubmitted event,
    Emitter<AddAddressState> emit,
  ) async {
    if (state.isSubmitting) {
      return;
    }

    final request = event.request.copyWith(
      label: state.selectedLabel.value,
      isDefault: state.isDefault,
    );

    emit(
      state.copyWith(status: AddAddressStatus.submitting, clearMessage: true),
    );

    try {
      final response = state.isEditing
          ? await _repository.updateAddress(
              addressId: state.editingAddressId!,
              request: request,
            )
          : await _repository.addAddress(request);
      emit(
        state.copyWith(
          status: response.isSuccessful
              ? AddAddressStatus.success
              : AddAddressStatus.failure,
          message: response.message,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AddAddressStatus.failure,
          message: _resolveErrorMessage(error, isEditing: state.isEditing),
        ),
      );
    }
  }

  String _resolveErrorMessage(Object error, {required bool isEditing}) {
    if (error is DioException) {
      final data = error.response?.data;
      final responseMap = _asMap(data);
      final responseMessage = responseMap?['message']?.toString().trim();
      if (responseMessage != null && responseMessage.isNotEmpty) {
        return responseMessage;
      }

      final errors = responseMap?['errors'];
      if (errors is Map) {
        for (final value in errors.values) {
          if (value is List && value.isNotEmpty) {
            final firstMessage = value.first?.toString().trim();
            if (firstMessage != null && firstMessage.isNotEmpty) {
              return firstMessage;
            }
          }

          final directMessage = value?.toString().trim();
          if (directMessage != null && directMessage.isNotEmpty) {
            return directMessage;
          }
        }
      }

      final dioMessage = error.message?.trim();
      if (dioMessage != null && dioMessage.isNotEmpty) {
        return dioMessage;
      }
    }

    return localizedString(
      fallback: isEditing
          ? 'Unable to update address'
          : 'Unable to save address',
      select: (l10n) =>
          isEditing ? l10n.updateAddressSaveFailed : l10n.addAddressSaveFailed,
    );
  }
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
