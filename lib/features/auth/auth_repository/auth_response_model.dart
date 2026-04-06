class AuthResponseModel {
  const AuthResponseModel({
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  final String? status;
  final String? message;
  final AuthResponseData? data;
  final dynamic errors;

  String? get token => data?.token;
  AuthUserModel? get user => data?.user;
  bool get isEmailVerified => (user?.emailVerifiedAt?.isNotEmpty ?? false);

  factory AuthResponseModel.fromResponse(dynamic json) {
    return AuthResponseModel.fromJson(_asMap(json));
  }

  factory AuthResponseModel.fromJson(Map<String, dynamic>? json) {
    final safeJson = json ?? const <String, dynamic>{};
    final dataJson = _asMap(safeJson['data']);
    final userJson = _asMap(dataJson?['user']) ?? _asMap(safeJson['user']);

    return AuthResponseModel(
      status: _asString(safeJson['status']),
      message: _asString(safeJson['message']),
      data: AuthResponseData(
        token: _asString(
          dataJson?['token'] ?? safeJson['token'] ?? safeJson['access_token'],
        ),
        user: userJson == null ? null : AuthUserModel.fromJson(userJson),
        otpExpiresIn: _asInt(dataJson?['otp_expires_in']),
        resendCooldown: _asInt(dataJson?['resend_cooldown']),
      ),
      errors: safeJson['errors'],
    );
  }
}

class AuthResponseData {
  const AuthResponseData({
    this.token,
    this.user,
    this.otpExpiresIn,
    this.resendCooldown,
  });

  final String? token;
  final AuthUserModel? user;
  final int? otpExpiresIn;
  final int? resendCooldown;
}

class AuthUserModel {
  const AuthUserModel({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
  });

  final int? id;
  final String? name;
  final String? email;
  final String? emailVerifiedAt;
  final String? createdAt;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: _asInt(json['id']),
      name: _asString(json['name']),
      email: _asString(json['email']),
      emailVerifiedAt: _asString(json['email_verified_at']),
      createdAt: _asString(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
    };
  }
}

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map(
      (key, value) => MapEntry(key.toString(), value),
    );
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
