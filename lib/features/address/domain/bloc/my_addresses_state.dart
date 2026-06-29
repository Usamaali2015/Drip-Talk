import 'package:drip_talk/features/address/data/models/address_list_model.dart';
import 'package:equatable/equatable.dart';

enum MyAddressesStatus { initial, loading, success, failure }

enum MyAddressesFeedbackType { success, error, info }

class MyAddressesState extends Equatable {
  const MyAddressesState({
    this.status = MyAddressesStatus.initial,
    this.addresses = const <AddressListItem>[],
    this.isRefreshing = false,
    this.pendingDeleteIds = const <int>[],
    this.errorMessage,
    this.feedbackMessage,
    this.feedbackType = MyAddressesFeedbackType.info,
  });

  final MyAddressesStatus status;
  final List<AddressListItem> addresses;
  final bool isRefreshing;
  final List<int> pendingDeleteIds;
  final String? errorMessage;
  final String? feedbackMessage;
  final MyAddressesFeedbackType feedbackType;

  bool get isInitialLoading =>
      addresses.isEmpty &&
      (status == MyAddressesStatus.initial ||
          status == MyAddressesStatus.loading);

  bool get isEmpty => status == MyAddressesStatus.success && addresses.isEmpty;

  bool isDeletingAddress(int? addressId) {
    if (addressId == null) {
      return false;
    }

    return pendingDeleteIds.contains(addressId);
  }

  MyAddressesState copyWith({
    MyAddressesStatus? status,
    List<AddressListItem>? addresses,
    bool? isRefreshing,
    List<int>? pendingDeleteIds,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? feedbackMessage,
    MyAddressesFeedbackType? feedbackType,
    bool clearFeedback = false,
  }) {
    return MyAddressesState(
      status: status ?? this.status,
      addresses: addresses ?? this.addresses,
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
    addresses,
    isRefreshing,
    pendingDeleteIds,
    errorMessage,
    feedbackMessage,
    feedbackType,
  ];
}
