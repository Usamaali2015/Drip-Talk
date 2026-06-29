import 'package:equatable/equatable.dart';
import 'package:drip_talk/features/address/data/models/address_list_model.dart';

abstract class MyAddressesEvent extends Equatable {
  const MyAddressesEvent();

  @override
  List<Object?> get props => const [];
}

class LoadMyAddressesRequested extends MyAddressesEvent {
  const LoadMyAddressesRequested({this.showLoader = true});

  final bool showLoader;

  @override
  List<Object?> get props => [showLoader];
}

class DeleteAddressRequested extends MyAddressesEvent {
  const DeleteAddressRequested(this.address);

  final AddressListItem address;

  @override
  List<Object?> get props => [address];
}
