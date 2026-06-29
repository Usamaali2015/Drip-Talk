import 'package:equatable/equatable.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAvailability extends Equatable {
  const BiometricAvailability({
    this.isDeviceSupported = false,
    this.availableBiometrics = const <BiometricType>[],
  });

  final bool isDeviceSupported;
  final List<BiometricType> availableBiometrics;

  bool get isAvailable => isDeviceSupported && availableBiometrics.isNotEmpty;

  bool get hasFace => availableBiometrics.contains(BiometricType.face);

  bool get hasFingerprint =>
      availableBiometrics.contains(BiometricType.fingerprint) ||
      availableBiometrics.contains(BiometricType.strong) ||
      availableBiometrics.contains(BiometricType.weak);

  @override
  List<Object?> get props => [isDeviceSupported, availableBiometrics];
}

class BiometricSessionSnapshot extends Equatable {
  const BiometricSessionSnapshot({
    required this.token,
    this.refreshToken,
    this.user,
    this.emailVerifiedAt,
  });

  final String token;
  final String? refreshToken;
  final Map<String, dynamic>? user;
  final String? emailVerifiedAt;

  bool get isValid => token.trim().isNotEmpty;

  @override
  List<Object?> get props => [token, refreshToken, user, emailVerifiedAt];
}

class BiometricLoginCredentials extends Equatable {
  const BiometricLoginCredentials({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  bool get isValid => email.trim().isNotEmpty && password.trim().isNotEmpty;

  @override
  List<Object?> get props => [email, password];
}

class BiometricAuthException implements Exception {
  const BiometricAuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
