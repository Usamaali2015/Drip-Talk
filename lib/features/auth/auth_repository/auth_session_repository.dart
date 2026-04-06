import 'package:drip_talk/core/services/storage/secure_storage.dart';
import 'package:drip_talk/core/services/storage/storage_keys.dart';

class AuthSessionRepository {
  AuthSessionRepository(this._storage);

  final SecureStorage _storage;

  Future<void> persistEmailVerificationStatus({
    required String email,
    required String? emailVerifiedAt,
  }) async {
    final normalizedEmail = _normalize(email);
    if (normalizedEmail == null) {
      return;
    }

    await _saveEmailVerifiedAt(emailVerifiedAt);

    if (_isVerified(emailVerifiedAt)) {
      await _storage.delete(StorageKeys.pendingVerificationEmail);
      return;
    }

    await _storage.writeString(
      StorageKeys.pendingVerificationEmail,
      normalizedEmail,
    );
  }

  Future<void> saveAuthenticatedSession({
    required String token,
    Map<String, dynamic>? user,
    required String? emailVerifiedAt,
  }) async {
    await _storage.saveAuthToken(token);
    if (user != null) {
      await _storage.saveUser(user);
    }
    await _saveEmailVerifiedAt(emailVerifiedAt);
    await _storage.delete(StorageKeys.pendingVerificationEmail);
  }

  Future<void> clearAuthenticatedSession() async {
    await _storage.delete(StorageKeys.authToken);
    await _storage.delete(StorageKeys.refreshToken);
    await _storage.delete(StorageKeys.user);
    await _storage.delete(StorageKeys.isLoggedIn);
  }

  Future<String?> getAuthToken() async {
    return _normalize(await _storage.readString(StorageKeys.authToken));
  }

  Future<void> markEmailVerified({String? emailVerifiedAt}) async {
    await _saveEmailVerifiedAt(
      _normalize(emailVerifiedAt) ?? DateTime.now().toUtc().toIso8601String(),
    );
    await _storage.delete(StorageKeys.pendingVerificationEmail);
  }

  Future<String?> getPendingVerificationEmail() async {
    return _normalize(
      await _storage.readString(StorageKeys.pendingVerificationEmail),
    );
  }

  Future<String?> getEmailVerifiedAt() async {
    return _normalize(await _storage.readString(StorageKeys.emailVerifiedAt));
  }

  Future<bool> hasPendingEmailVerification() async {
    final pendingEmail = await getPendingVerificationEmail();
    return pendingEmail != null && await getEmailVerifiedAt() == null;
  }

  Future<void> clearPendingVerification() async {
    await _storage.delete(StorageKeys.pendingVerificationEmail);
    await _storage.delete(StorageKeys.emailVerifiedAt);
  }

  bool _isVerified(String? emailVerifiedAt) {
    return _normalize(emailVerifiedAt) != null;
  }

  Future<void> _saveEmailVerifiedAt(String? emailVerifiedAt) async {
    final normalizedValue = _normalize(emailVerifiedAt);
    if (normalizedValue == null) {
      await _storage.delete(StorageKeys.emailVerifiedAt);
      return;
    }

    await _storage.writeString(StorageKeys.emailVerifiedAt, normalizedValue);
  }

  String? _normalize(String? value) {
    if (value == null) {
      return null;
    }

    final normalized = value.trim();
    return normalized.isEmpty ? null : normalized;
  }
}
