import 'package:drip_talk/features/address/data/models/add_address_request_model.dart';
import 'package:drip_talk/features/address/data/models/address_list_model.dart';
import 'package:drip_talk/features/address/domain/bloc/add_address_state.dart';
import 'package:equatable/equatable.dart';

abstract class AddAddressEvent extends Equatable {
  const AddAddressEvent();

  @override
  List<Object?> get props => const [];
}

class AddAddressLabelChanged extends AddAddressEvent {
  const AddAddressLabelChanged(this.label);

  final AddressLabel label;

  @override
  List<Object?> get props => [label];
}

class AddAddressDefaultToggled extends AddAddressEvent {
  const AddAddressDefaultToggled(this.isDefault);

  final bool isDefault;

  @override
  List<Object?> get props => [isDefault];
}

class AddAddressFormInitialized extends AddAddressEvent {
  const AddAddressFormInitialized(this.address);

  final AddressListItem? address;

  @override
  List<Object?> get props => [address];
}

class AddAddressSubmitted extends AddAddressEvent {
  const AddAddressSubmitted(this.request);

  final AddAddressRequestModel request;

  @override
  List<Object?> get props => [request];
}
