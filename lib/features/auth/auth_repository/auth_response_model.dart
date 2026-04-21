class AuthResponseModel {
  const AuthResponseModel({this.status, this.message, this.data, this.errors});

  final String? status;
  final String? message;
  final AuthResponseData? data;
  final dynamic errors;

  String? get token => data?.token;
  String? get refreshToken => data?.refreshToken;
  String? get twoFactorToken => data?.twoFactorToken;
  AuthUserModel? get user => data?.user;
  bool get isEmailVerified => (user?.emailVerifiedAt?.isNotEmpty ?? false);
  bool get requiresTwoFactor => data?.requiresTwoFactor ?? false;

  factory AuthResponseModel.fromResponse(dynamic json) {
    return AuthResponseModel.fromJson(_asMap(json));
  }

  factory AuthResponseModel.fromJson(Map<String, dynamic>? json) {
    final safeJson = json ?? const <String, dynamic>{};
    final dataJson = _asMap(safeJson['data']);
    final userJson = _asMap(dataJson?['user']) ?? _asMap(safeJson['user']);
    final twoFactorJson =
        _asMap(dataJson?['two_factor']) ?? _asMap(safeJson['two_factor']);
    final tokensJson =
        _asMap(dataJson?['tokens']) ?? _asMap(safeJson['tokens']);
    final userHasTwoFactor = _asBool(
      userJson?['google2fa_enabled'] ??
          userJson?['google_2fa_enabled'] ??
          dataJson?['google2fa_enabled'] ??
          dataJson?['google_2fa_enabled'] ??
          safeJson['google2fa_enabled'] ??
          safeJson['google_2fa_enabled'],
    );
    final accessToken = _asString(
      dataJson?['token'] ??
          dataJson?['access_token'] ??
          tokensJson?['token'] ??
          tokensJson?['access_token'] ??
          safeJson['token'] ??
          safeJson['access_token'],
    );
    final refreshToken = _asString(
      dataJson?['refresh_token'] ??
          dataJson?['refreshToken'] ??
          tokensJson?['refresh_token'] ??
          tokensJson?['refreshToken'] ??
          safeJson['refresh_token'] ??
          safeJson['refreshToken'],
    );
    final twoFactorToken = _asString(
      dataJson?['two_factor_token'] ??
          dataJson?['twoFactorToken'] ??
          dataJson?['challenge_token'] ??
          safeJson['two_factor_token'] ??
          safeJson['twoFactorToken'] ??
          safeJson['challenge_token'] ??
          twoFactorJson?['token'] ??
          twoFactorJson?['two_factor_token'],
    );
    final requiresTwoFactor =
        _asBool(
          dataJson?['requires_2fa'] ??
              dataJson?['two_factor_required'] ??
              dataJson?['requires_two_factor'] ??
              safeJson['requires_2fa'] ??
              safeJson['two_factor_required'] ??
              safeJson['requires_two_factor'] ??
              safeJson['mfa_required'] ??
              twoFactorJson?['required'],
        ) ??
        (twoFactorToken != null && twoFactorToken.isNotEmpty) ||
            ((userHasTwoFactor ?? false) &&
                (accessToken == null || accessToken.isEmpty));

    return AuthResponseModel(
      status: _asString(safeJson['status']),
      message: _asString(safeJson['message']),
      data: AuthResponseData(
        token: accessToken,
        refreshToken: refreshToken,
        twoFactorToken: twoFactorToken,
        requiresTwoFactor: requiresTwoFactor,
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
    this.refreshToken,
    this.twoFactorToken,
    this.requiresTwoFactor = false,
    this.user,
    this.otpExpiresIn,
    this.resendCooldown,
  });

  final String? token;
  final String? refreshToken;
  final String? twoFactorToken;
  final bool requiresTwoFactor;
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
    this.googleTwoFactorEnabled,
    this.createdAt,
  });

  final int? id;
  final String? name;
  final String? email;
  final String? emailVerifiedAt;
  final bool? googleTwoFactorEnabled;
  final String? createdAt;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: _asInt(json['id']),
      name: _asString(json['name']),
      email: _asString(json['email']),
      emailVerifiedAt: _asString(json['email_verified_at']),
      googleTwoFactorEnabled: _asBool(
        json['google2fa_enabled'] ?? json['google_2fa_enabled'],
      ),
      createdAt: _asString(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'google2fa_enabled': googleTwoFactorEnabled,
      'created_at': createdAt,
    };
  }
}

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
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

  if (value is num) {
    return value != 0;
  }

  final normalized = value?.toString().trim().toLowerCase();
  if (normalized == null || normalized.isEmpty || normalized == 'null') {
    return null;
  }

  if (normalized == '1' || normalized == 'true') {
    return true;
  }

  if (normalized == '0' || normalized == 'false') {
    return false;
  }

  return null;
}
