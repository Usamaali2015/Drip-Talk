import 'package:equatable/equatable.dart';

class AddressListResponseModel {
  const AddressListResponseModel({
    this.status,
    this.message,
    this.data = const <AddressListItem>[],
    this.errors,
  });

  factory AddressListResponseModel.fromJson(Map<String, dynamic>? json) {
    final source = _mapValue(json);

    return AddressListResponseModel(
      status: _stringValue(source?['status']),
      message: _stringValue(source?['message']),
      data: _listValue(source?['data'], AddressListItem.fromJson),
      errors: source?['errors'],
    );
  }

  final String? status;
  final String? message;
  final List<AddressListItem> data;
  final dynamic errors;

  bool get isSuccessful {
    final normalizedStatus = status?.trim().toLowerCase();
    return normalizedStatus == null ||
        normalizedStatus == 'success' ||
        normalizedStatus == 'ok';
  }
}

class AddressListItem extends Equatable {
  const AddressListItem({
    this.id,
    this.userId,
    this.label,
    this.fullName,
    this.phone,
    this.addressLine,
    this.city,
    this.stateProvince,
    this.postalCode,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  factory AddressListItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const AddressListItem();
    }

    return AddressListItem(
      id: _intValue(json['id']),
      userId: _intValue(json['user_id']),
      label: _stringValue(json['label']),
      fullName: _stringValue(json['full_name']),
      phone: _stringValue(json['phone']),
      addressLine: _stringValue(json['address_line']),
      city: _stringValue(json['city']),
      stateProvince: _stringValue(json['state_province']),
      postalCode: _stringValue(json['postal_code']),
      isDefault: _boolValue(json['is_default']),
      createdAt: _dateTimeValue(json['created_at']),
      updatedAt: _dateTimeValue(json['updated_at']),
    );
  }

  final int? id;
  final int? userId;
  final String? label;
  final String? fullName;
  final String? phone;
  final String? addressLine;
  final String? city;
  final String? stateProvince;
  final String? postalCode;
  final bool? isDefault;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isDefaultAddress => isDefault ?? false;

  String? get displayLabel {
    final value = label?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }

    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  String? get cityPostalLine {
    final cityValue = city?.trim();
    final postalValue = postalCode?.trim();

    if ((cityValue == null || cityValue.isEmpty) &&
        (postalValue == null || postalValue.isEmpty)) {
      return null;
    }

    if (cityValue == null || cityValue.isEmpty) {
      return postalValue;
    }

    if (postalValue == null || postalValue.isEmpty) {
      return cityValue;
    }

    return '$cityValue, $postalValue';
  }

  List<String> get detailLines {
    return [fullName, addressLine, cityPostalLine, stateProvince]
        .whereType<String>()
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    label,
    fullName,
    phone,
    addressLine,
    city,
    stateProvince,
    postalCode,
    isDefault,
    createdAt,
    updatedAt,
  ];
}

Map<String, dynamic>? _mapValue(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
  }

  return null;
}

List<T> _listValue<T>(
  dynamic value,
  T Function(Map<String, dynamic>? json) fromJson,
) {
  if (value is! List) {
    return <T>[];
  }

  return value.map((item) => fromJson(_mapValue(item))).toList();
}

String? _stringValue(dynamic value) {
  if (value == null) {
    return null;
  }

  final normalized = value.toString().trim();
  return normalized.isEmpty || normalized.toLowerCase() == 'null'
      ? null
      : normalized;
}

int? _intValue(dynamic value) {
  if (value is int) {
    return value;
  }

  return int.tryParse(value?.toString() ?? '');
}

bool? _boolValue(dynamic value) {
  if (value is bool) {
    return value;
  }

  if (value is num) {
    return value != 0;
  }

  final normalized = value?.toString().trim().toLowerCase();
  if (normalized == null || normalized.isEmpty) {
    return null;
  }

  if (normalized == 'true' || normalized == '1' || normalized == 'yes') {
    return true;
  }

  if (normalized == 'false' || normalized == '0' || normalized == 'no') {
    return false;
  }

  return null;
}

DateTime? _dateTimeValue(dynamic value) {
  if (value is DateTime) {
    return value;
  }

  final raw = value?.toString();
  if (raw == null || raw.trim().isEmpty) {
    return null;
  }

  return DateTime.tryParse(raw);
}
