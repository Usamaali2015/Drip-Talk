class ContactSupportResponseModel {
  const ContactSupportResponseModel({this.status, this.message, this.errors});

  factory ContactSupportResponseModel.fromJson(Map<String, dynamic>? json) {
    final safeJson = json ?? const <String, dynamic>{};
    return ContactSupportResponseModel(
      status: _asString(safeJson['status']),
      message: _asString(safeJson['message']),
      errors: safeJson['errors'],
    );
  }

  final String? status;
  final String? message;
  final dynamic errors;

  bool get isSuccessful {
    final normalizedStatus = status?.trim().toLowerCase();
    return normalizedStatus == null ||
        normalizedStatus == 'success' ||
        normalizedStatus == 'ok' ||
        normalizedStatus == 'created';
  }
}

String? _asString(dynamic value) {
  if (value == null) {
    return null;
  }

  final normalized = value.toString().trim();
  if (normalized.isEmpty || normalized.toLowerCase() == 'null') {
    return null;
  }

  return normalized;
}
