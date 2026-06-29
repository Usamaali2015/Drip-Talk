import 'package:drip_talk/core/services/storage/secure_storage.dart';
import 'package:drip_talk/core/services/storage/storage_keys.dart';
import 'package:drip_talk/features/auth/biometric/data/models/biometric_auth_models.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

class BiometricAuthRepository {
  BiometricAuthRepository(
    this._storage, {
    LocalAuthentication? localAuthentication,
  }) : _localAuthentication = localAuthentication ?? LocalAuthentication();

  final SecureStorage _storage;
  final LocalAuthentication _localAuthentication;

  Future<BiometricAvailability> getAvailability() async {
    try {
      final isDeviceSupported = await _localAuthentication.isDeviceSupported();
      final canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
      final availableBiometrics = canCheckBiometrics
          ? await _localAuthentication.getAvailableBiometrics()
          : const <BiometricType>[];

      return BiometricAvailability(
        isDeviceSupported: isDeviceSupported || canCheckBiometrics,
        availableBiometrics: availableBiometrics,
      );
    } on PlatformException {
      return const BiometricAvailability();
    }
  }

  Future<bool> isBiometricLoginEnabled() async {
    return _storage.readBool(StorageKeys.biometricLoginEnabled);
  }

  Future<BiometricSessionSnapshot?> getBiometricSessionSnapshot() async {
    final token = await _storage.readString(StorageKeys.biometricAuthToken);
    final normalizedToken = _normalize(token);
    if (normalizedToken == null) {
      return null;
    }

    return BiometricSessionSnapshot(
      token: normalizedToken,
      refreshToken: _normalize(
        await _storage.readString(StorageKeys.biometricRefreshToken),
      ),
      user: await _storage.readJson(StorageKeys.biometricUser),
      emailVerifiedAt: _normalize(
        await _storage.readString(StorageKeys.biometricEmailVerifiedAt),
      ),
    );
  }

  Future<BiometricLoginCredentials?> getBiometricLoginCredentials() async {
    final email = _normalize(
      await _storage.readString(StorageKeys.biometricLoginEmail),
    );
    final password = _normalize(
      await _storage.readString(StorageKeys.biometricLoginPassword),
    );
    if (email == null || password == null) {
      return null;
    }

    return BiometricLoginCredentials(email: email, password: password);
  }

  Future<bool> hasEnabledBiometricSession() async {
    if (!await isBiometricLoginEnabled()) {
      return false;
    }

    final credentials = await getBiometricLoginCredentials();
    if (credentials?.isValid == true) {
      return true;
    }

    final snapshot = await getBiometricSessionSnapshot();
    return snapshot?.isValid == true;
  }

  Future<void> authenticateOrThrow({required String reason}) async {
    final availability = await getAvailability();
    if (!availability.isAvailable) {
      throw const BiometricAuthException(
        'Biometric login is not available on this device.',
      );
    }

    try {
      final didAuthenticate = await _localAuthentication.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          sensitiveTransaction: true,
          useErrorDialogs: false,
        ),
      );

      if (!didAuthenticate) {
        throw const BiometricAuthException(
          'Biometric verification was cancelled.',
        );
      }
    } on PlatformException catch (error) {
      throw BiometricAuthException(_mapPlatformError(error.code));
    }
  }

  Future<void> enableBiometricLogin({
    required String token,
    String? refreshToken,
    Map<String, dynamic>? user,
    String? emailVerifiedAt,
  }) async {
    final normalizedToken = _normalize(token);
    if (normalizedToken == null) {
      throw const BiometricAuthException(
        'No authenticated session found for biometric login.',
      );
    }

    await _storage.writeBool(StorageKeys.biometricLoginEnabled, true);
    await _storage.writeString(StorageKeys.biometricAuthToken, normalizedToken);
    final normalizedRefreshToken = _normalize(refreshToken);
    if (normalizedRefreshToken == null) {
      await _storage.delete(StorageKeys.biometricRefreshToken);
    } else {
      await _storage.writeString(
        StorageKeys.biometricRefreshToken,
        normalizedRefreshToken,
      );
    }

    if (user == null) {
      await _storage.delete(StorageKeys.biometricUser);
    } else {
      await _storage.writeJson(StorageKeys.biometricUser, user);
    }

    final normalizedEmailVerifiedAt = _normalize(emailVerifiedAt);
    if (normalizedEmailVerifiedAt == null) {
      await _storage.delete(StorageKeys.biometricEmailVerifiedAt);
    } else {
      await _storage.writeString(
        StorageKeys.biometricEmailVerifiedAt,
        normalizedEmailVerifiedAt,
      );
    }
  }

  Future<void> cacheManualLoginCredentials({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = _normalize(email);
    final normalizedPassword = _normalize(password);
    if (normalizedEmail == null || normalizedPassword == null) {
      return;
    }

    await _storage.writeString(
      StorageKeys.biometricLoginEmail,
      normalizedEmail,
    );
    await _storage.writeString(
      StorageKeys.biometricLoginPassword,
      normalizedPassword,
    );
  }

  Future<void> clearCachedLoginCredentials() async {
    await _storage.delete(StorageKeys.biometricLoginEmail);
    await _storage.delete(StorageKeys.biometricLoginPassword);
  }

  Future<void> refreshBiometricSessionIfEnabled({
    required String token,
    String? refreshToken,
    Map<String, dynamic>? user,
    String? emailVerifiedAt,
    String? email,
    String? password,
  }) async {
    if (!await isBiometricLoginEnabled()) {
      return;
    }

    await enableBiometricLogin(
      token: token,
      refreshToken: refreshToken,
      user: user,
      emailVerifiedAt: emailVerifiedAt,
    );

    final normalizedEmail = _normalize(email);
    final normalizedPassword = _normalize(password);
    if (normalizedEmail != null && normalizedPassword != null) {
      await cacheManualLoginCredentials(
        email: normalizedEmail,
        password: normalizedPassword,
      );
    }
  }

  Future<void> disableBiometricLogin({bool clearCredentials = true}) async {
    await _storage.delete(StorageKeys.biometricLoginEnabled);
    await _storage.delete(StorageKeys.biometricAuthToken);
    await _storage.delete(StorageKeys.biometricRefreshToken);
    await _storage.delete(StorageKeys.biometricUser);
    await _storage.delete(StorageKeys.biometricEmailVerifiedAt);
    if (clearCredentials) {
      await clearCachedLoginCredentials();
    }
  }

  String _mapPlatformError(String code) {
    switch (code) {
      case auth_error.notAvailable:
        return 'Biometric login is not available on this device.';
      case auth_error.notEnrolled:
        return 'No biometrics are enrolled on this device.';
      case auth_error.lockedOut:
        return 'Biometric authentication is temporarily locked.';
      case auth_error.permanentlyLockedOut:
        return 'Biometric authentication is permanently locked.';
      case auth_error.passcodeNotSet:
        return 'Set a device passcode to use biometric login.';
      default:
        return 'Biometric authentication failed. Please try again.';
    }
  }

  String? _normalize(String? value) {
    if (value == null) {
      return null;
    }

    final normalized = value.trim();
    return normalized.isEmpty ? null : normalized;
  }
}
