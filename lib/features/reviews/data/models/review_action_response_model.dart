class ReviewActionResponseModel {
  const ReviewActionResponseModel({this.status, this.message, this.errors});

  factory ReviewActionResponseModel.fromJson(Map<String, dynamic>? json) {
    final safeJson = json ?? const <String, dynamic>{};
    return ReviewActionResponseModel(
      status: _asString(safeJson['status']),
      message: _asString(safeJson['message']),
      errors: safeJson['errors'],
    );
  }

  final String? status;
  final String? message;
  final dynamic errors;

  bool get isSuccessful => (status?.toLowerCase() ?? 'success') == 'success';
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
