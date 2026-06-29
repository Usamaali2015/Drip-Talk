import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drip_talk/features/address/data/repository/address_repository.dart';
import 'package:drip_talk/features/address/domain/bloc/my_addresses_event.dart';
import 'package:drip_talk/features/address/domain/bloc/my_addresses_state.dart';

class MyAddressesBloc extends Bloc<MyAddressesEvent, MyAddressesState> {
  MyAddressesBloc(this._repository) : super(const MyAddressesState()) {
    on<LoadMyAddressesRequested>(_onLoadAddressesRequested);
    on<DeleteAddressRequested>(_onDeleteAddressRequested);
  }

  final AddressRepository _repository;

  Future<void> _onLoadAddressesRequested(
    LoadMyAddressesRequested event,
    Emitter<MyAddressesState> emit,
  ) async {
    final shouldRefreshInPlace =
        state.addresses.isNotEmpty && !event.showLoader;

    emit(
      state.copyWith(
        status: event.showLoader || state.addresses.isEmpty
            ? MyAddressesStatus.loading
            : state.status,
        isRefreshing: shouldRefreshInPlace,
        clearErrorMessage: true,
        clearFeedback: true,
      ),
    );

    try {
      final response = await _repository.getAddresses();
      if (!response.isSuccessful && response.data.isEmpty) {
        emit(
          state.copyWith(
            status: state.addresses.isEmpty
                ? MyAddressesStatus.failure
                : MyAddressesStatus.success,
            isRefreshing: false,
            errorMessage: state.addresses.isEmpty
                ? response.message ?? 'Unable to load addresses'
                : null,
            feedbackMessage: state.addresses.isEmpty
                ? null
                : response.message ?? 'Unable to load addresses',
            feedbackType: MyAddressesFeedbackType.error,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: MyAddressesStatus.success,
          addresses: response.data,
          isRefreshing: false,
          clearErrorMessage: true,
          clearFeedback: true,
        ),
      );
    } catch (error) {
      final resolvedMessage = _resolveErrorMessage(error);
      emit(
        state.copyWith(
          status: state.addresses.isEmpty
              ? MyAddressesStatus.failure
              : MyAddressesStatus.success,
          isRefreshing: false,
          errorMessage: state.addresses.isEmpty ? resolvedMessage : null,
          feedbackMessage: state.addresses.isEmpty ? null : resolvedMessage,
          feedbackType: MyAddressesFeedbackType.error,
        ),
      );
    }
  }

  Future<void> _onDeleteAddressRequested(
    DeleteAddressRequested event,
    Emitter<MyAddressesState> emit,
  ) async {
    final addressId = event.address.id;
    if (addressId == null || state.isDeletingAddress(addressId)) {
      return;
    }

    emit(
      state.copyWith(
        pendingDeleteIds: [...state.pendingDeleteIds, addressId],
        clearFeedback: true,
      ),
    );

    try {
      final response = await _repository.deleteAddress(addressId: addressId);
      emit(
        state.copyWith(
          status: MyAddressesStatus.success,
          addresses: state.addresses
              .where((address) => address.id != addressId)
              .toList(),
          pendingDeleteIds: state.pendingDeleteIds
              .where((id) => id != addressId)
              .toList(),
          feedbackMessage: response.message ?? 'Address deleted successfully',
          feedbackType: MyAddressesFeedbackType.success,
          clearErrorMessage: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          pendingDeleteIds: state.pendingDeleteIds
              .where((id) => id != addressId)
              .toList(),
          feedbackMessage: _resolveDeleteErrorMessage(error),
          feedbackType: MyAddressesFeedbackType.error,
        ),
      );
    }
  }

  String _resolveErrorMessage(Object error) {
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

    return 'Unable to load addresses';
  }

  String _resolveDeleteErrorMessage(Object error) {
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

    return 'Unable to delete address';
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
