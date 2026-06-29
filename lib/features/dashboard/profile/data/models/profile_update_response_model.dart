import 'dart:convert';
import 'dart:typed_data';

import 'package:drip_talk/features/dashboard/profile/data/models/profile_model.dart';
import 'package:equatable/equatable.dart';

class ProfileUpdateResponseModel extends Equatable {
  const ProfileUpdateResponseModel({
    this.status,
    this.message,
    this.user,
    this.emailVerificationSent,
    this.twoFactorSetup,
    this.biometricNote,
    this.errors,
  });

  factory ProfileUpdateResponseModel.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    final dataSource = _asMap(source?['data']);
    final setupSource =
        _asMap(dataSource?['two_factor_setup']) ??
        _asMap(source?['two_factor_setup']);

    return ProfileUpdateResponseModel(
      status: _asString(source?['status']),
      message: _asString(source?['message']),
      user: ProfileData.fromJson(dataSource),
      emailVerificationSent: _asBool(
        dataSource?['email_verification_sent'] ??
            source?['email_verification_sent'],
      ),
      twoFactorSetup: TwoFactorSetupData.fromJson(
        setupSource,
        fallbackToken: _asString(
          dataSource?['two_factor_token'] ??
              dataSource?['token'] ??
              source?['two_factor_token'] ??
              source?['token'],
        ),
      ),
      biometricNote: _asString(
        dataSource?['biometric_note'] ?? source?['biometric_note'],
      ),
      errors: source?['errors'],
    );
  }

  final String? status;
  final String? message;
  final ProfileData? user;
  final bool? emailVerificationSent;
  final TwoFactorSetupData? twoFactorSetup;
  final String? biometricNote;
  final dynamic errors;

  bool get isSuccessful {
    final normalized = status?.trim().toLowerCase();
    return normalized == null ||
        normalized == 'success' ||
        normalized == 'ok' ||
        normalized == 'created';
  }

  @override
  List<Object?> get props => [
    status,
    message,
    user,
    emailVerificationSent,
    twoFactorSetup,
    biometricNote,
    errors,
  ];
}

class TwoFactorSetupData extends Equatable {
  const TwoFactorSetupData({
    this.secret,
    this.otpauthUri,
    this.qrCode,
    this.twoFactorToken,
    this.requiresVerification = true,
  });

  factory TwoFactorSetupData.fromJson(
    Map<String, dynamic>? json, {
    String? fallbackToken,
  }) {
    if (json == null && fallbackToken == null) {
      return nullSetup;
    }

    final source = _asMap(json);
    return TwoFactorSetupData(
      secret: _asString(source?['secret']),
      otpauthUri: _asString(source?['otpauth_uri']),
      qrCode: _asString(source?['qr_code']),
      twoFactorToken: _asString(source?['two_factor_token']) ?? fallbackToken,
      requiresVerification: _asBool(source?['requires_verification']) ?? true,
    );
  }

  static const TwoFactorSetupData nullSetup = TwoFactorSetupData();

  final String? secret;
  final String? otpauthUri;
  final String? qrCode;
  final String? twoFactorToken;
  final bool requiresVerification;

  bool get isEmpty =>
      secret == null &&
      otpauthUri == null &&
      qrCode == null &&
      twoFactorToken == null;

  String get formattedSecret {
    final normalizedSecret =
        secret?.replaceAll(RegExp(r'\s+'), '').trim().toUpperCase() ?? '';
    if (normalizedSecret.isEmpty) {
      return '';
    }

    final buffer = StringBuffer();
    for (var index = 0; index < normalizedSecret.length; index++) {
      if (index > 0 && index % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(normalizedSecret[index]);
    }
    return buffer.toString();
  }

  Uint8List? get qrCodeBytes {
    final normalizedQr = qrCode?.trim();
    if (normalizedQr == null || normalizedQr.isEmpty) {
      return null;
    }

    final base64Part = normalizedQr.contains(',')
        ? normalizedQr.split(',').last
        : normalizedQr;

    try {
      return base64Decode(base64Part);
    } catch (_) {
      return null;
    }
  }

  @override
  List<Object?> get props => [
    secret,
    otpauthUri,
    qrCode,
    twoFactorToken,
    requiresVerification,
  ];
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
