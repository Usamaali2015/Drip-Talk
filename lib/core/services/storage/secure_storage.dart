import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'storage_keys.dart';

class SecureStorage {
  SecureStorage._();

  /// Singleton instance
  static final SecureStorage instance = SecureStorage._();

  /// Secure storage configuration
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  ///* -------------------------------------------------------------------------- */
  ///*                                   WRITE                                    */
  ///* -------------------------------------------------------------------------- */

  Future<void> writeString(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<void> writeBool(String key, bool value) async {
    await _storage.write(key: key, value: value.toString());
  }

  Future<void> writeJson(String key, Map<String, dynamic> value) async {
    await _storage.write(key: key, value: jsonEncode(value));
  }

  ///* -------------------------------------------------------------------------- */
  ///*                                    READ                                    */
  ///* -------------------------------------------------------------------------- */

  Future<String?> readString(String key) async {
    return _storage.read(key: key);
  }

  Future<bool> readBool(String key) async {
    final value = await _storage.read(key: key);
    return value == 'true';
  }

  Future<Map<String, dynamic>?> readJson(String key) async {
    final value = await _storage.read(key: key);
    if (value == null) return null;
    return jsonDecode(value) as Map<String, dynamic>;
  }

  ///* -------------------------------------------------------------------------- */
  ///*                                   DELETE                                   */
  ///* -------------------------------------------------------------------------- */

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  ///* -------------------------------------------------------------------------- */
  ///*                             AUTH-SPECIFIC HELPERS                           */
  ///* -------------------------------------------------------------------------- */

  Future<void> saveAuthToken(String token) async {
    await writeString(StorageKeys.authToken, token);
    await writeBool(StorageKeys.isLoggedIn, true);
  }

  Future<String?> getAuthToken() async {
    return readString(StorageKeys.authToken);
  }

  Future<void> saveRefreshToken(String token) async {
    await writeString(StorageKeys.refreshToken, token);
  }

  Future<void> saveUser(Map<String, dynamic> userJson) async {
    await writeJson(StorageKeys.user, userJson);
  }

  Future<Map<String, dynamic>?> getUser() async {
    return readJson(StorageKeys.user);
  }

  Future<bool> isLoggedIn() async {
    return readBool(StorageKeys.isLoggedIn);
  }

  ///* -------------------------------------------------------------------------- */
  ///*                             THEME-SPECIFIC HELPERS                       */
  ///* -------------------------------------------------------------------------- */

  Future<void> saveThemeMode(ThemeMode themeMode) async {
    await writeString(StorageKeys.theme, themeMode.toString());
  }

  Future<ThemeMode> getThemeMode() async {
    final theme = await readString(StorageKeys.theme);
    if (theme == ThemeMode.dark.toString()) {
      return ThemeMode.dark;
    } else if (theme == ThemeMode.light.toString()) {
      return ThemeMode.light;
    }

    return ThemeMode.system;
  }

  ///* -------------------------------------------------------------------------- */
  ///*                             LOCALE-SPECIFIC HELPERS                         */
  ///* -------------------------------------------------------------------------- */

  Future<void> saveLocale(Locale locale) async {
    await writeString(StorageKeys.locale, locale.toLanguageTag());
  }

  Future<Locale> getLocale() async {
    final localeTag = await readString(StorageKeys.locale);
    if (localeTag != null) {
      return Locale.fromSubtags(languageCode: localeTag);
    }
    return const Locale('en');
  }

  ///* -------------------------------------------------------------------------- */
  ///*                                 LOGOUT                                    */
  ///* -------------------------------------------------------------------------- */

  Future<void> logout() async {
    await delete(StorageKeys.authToken);
    await delete(StorageKeys.refreshToken);
    await delete(StorageKeys.user);
    await delete(StorageKeys.isLoggedIn);
    await delete(StorageKeys.emailVerifiedAt);
    await delete(StorageKeys.pendingVerificationEmail);
    await delete(StorageKeys.theme);
    await delete(StorageKeys.locale);
  }
}
