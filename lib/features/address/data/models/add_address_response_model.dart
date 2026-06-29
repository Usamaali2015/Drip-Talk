class AddAddressResponseModel {
  const AddAddressResponseModel({
    this.status,
    this.message,
    this.success,
    this.data,
    this.errors,
  });

  factory AddAddressResponseModel.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return AddAddressResponseModel(
      status: _asString(source?['status']),
      message: _asString(source?['message']),
      success: _asBool(source?['success']),
      data: AddressData.fromJson(_asMap(source?['data'])),
      errors: source?['errors'],
    );
  }

  final String? status;
  final String? message;
  final bool? success;
  final AddressData? data;
  final dynamic errors;

  bool get isSuccessful {
    if (success != null) {
      return success!;
    }

    final normalizedStatus = status?.trim().toLowerCase();
    return normalizedStatus == null ||
        normalizedStatus == 'success' ||
        normalizedStatus == 'ok' ||
        normalizedStatus == 'created';
  }
}

class AddressData {
  const AddressData({
    this.id,
    this.label,
    this.fullName,
    this.phone,
    this.addressLine,
    this.city,
    this.stateProvince,
    this.postalCode,
    this.isDefault,
  });

  factory AddressData.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    if (source == null) {
      return nullAddress;
    }

    return AddressData(
      id: _asInt(source['id']),
      label: _asString(source['label']),
      fullName: _asString(source['full_name']),
      phone: _asString(source['phone']),
      addressLine: _asString(source['address_line']),
      city: _asString(source['city']),
      stateProvince: _asString(source['state_province']),
      postalCode: _asString(source['postal_code']),
      isDefault: _asBool(source['is_default']),
    );
  }

  static const AddressData nullAddress = AddressData();

  final int? id;
  final String? label;
  final String? fullName;
  final String? phone;
  final String? addressLine;
  final String? city;
  final String? stateProvince;
  final String? postalCode;
  final bool? isDefault;
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

String? _asString(dynamic value) {
  if (value == null) {
    return null;
  }

  final normalized = value.toString().trim();
  return normalized.isEmpty || normalized.toLowerCase() == 'null'
      ? null
      : normalized;
}

int? _asInt(dynamic value) {
  if (value is int) {
    return value;
  }

  return int.tryParse(value?.toString() ?? '');
}

bool? _asBool(dynamic value) {
  if (value is bool) {
    return value;
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
