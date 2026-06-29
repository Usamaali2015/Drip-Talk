import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class AddAddressRequestModel extends Equatable {
  const AddAddressRequestModel({
    required this.label,
    required this.fullName,
    required this.phone,
    required this.addressLine,
    required this.city,
    required this.stateProvince,
    required this.postalCode,
    required this.isDefault,
  });

  final String label;
  final String fullName;
  final String phone;
  final String addressLine;
  final String city;
  final String stateProvince;
  final String postalCode;
  final bool isDefault;

  FormData toFormData() {
    return FormData.fromMap({
      'label': label,
      'full_name': fullName,
      'phone': phone,
      'address_line': addressLine,
      'city': city,
      'state_province': stateProvince,
      'postal_code': postalCode,
      'is_default': isDefault ? '1' : '0',
    });
  }

  AddAddressRequestModel copyWith({
    String? label,
    String? fullName,
    String? phone,
    String? addressLine,
    String? city,
    String? stateProvince,
    String? postalCode,
    bool? isDefault,
  }) {
    return AddAddressRequestModel(
      label: label ?? this.label,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      addressLine: addressLine ?? this.addressLine,
      city: city ?? this.city,
      stateProvince: stateProvince ?? this.stateProvince,
      postalCode: postalCode ?? this.postalCode,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  List<Object?> get props => [
    label,
    fullName,
    phone,
    addressLine,
    city,
    stateProvince,
    postalCode,
    isDefault,
  ];
}
