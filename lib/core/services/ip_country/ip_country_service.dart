import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Resolves the user's country dial code (e.g. "+92") from their IP address.
///
/// Resolution order:
///   1. ip-api.com  (primary — no key, highly reliable)
///   2. ipinfo.io   (secondary fallback)
///   3. Device locale country code
///   4. Hard-coded fallback (+1)
///
/// The resolved value is cached after the first successful call so the
/// network is never hit more than once per app session.
class IpCountryService {
  IpCountryService._();

  static final instance = IpCountryService._();

  static const _fallbackDialCode = '+1';

  // freeipapi.com: HTTPS, no key, returns {"countryCode":"PK",...}
  static const _primaryUrl = 'https://freeipapi.com/api/json';

  // ipinfo.io: HTTPS, free tier, returns {"country":"PK",...}
  static const _secondaryUrl = 'https://ipinfo.io/json';

  String? _cached;
  Future<String>? _inflight;

  /// Returns the best-guess dial code for the current user.
  /// Safe to call multiple times — the network request fires only once.
  Future<String> resolveDialCode() {
    if (_cached != null) return Future.value(_cached!);
    return _inflight ??= _resolve();
  }

  Future<String> _resolve() async {
    final localeCode = _fromLocale();

    final dialCode = await _tryPrimary() ?? await _trySecondary();
    if (dialCode != null) {
      _cached = dialCode;
      return dialCode;
    }

    final resolved = localeCode ?? _fallbackDialCode;
    _cached = resolved;
    return resolved;
  }

  Future<String?> _tryPrimary() async {
    try {
      final response = await _dio().get<Map<String, dynamic>>(_primaryUrl);
      return _fromCountryCode(_asString(response.data?['countryCode']));
    } catch (e) {
      if (kDebugMode) debugPrint('IpCountryService[primary]: $e');
      return null;
    }
  }

  Future<String?> _trySecondary() async {
    try {
      final response = await _dio().get<Map<String, dynamic>>(_secondaryUrl);
      return _fromCountryCode(_asString(response.data?['country']));
    } catch (e) {
      if (kDebugMode) debugPrint('IpCountryService[secondary]: $e');
      return null;
    }
  }

  Dio _dio() => Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: const {
        'Accept': 'application/json',
        'User-Agent': 'DripTalkApp/1.0',
      },
    ),
  );

  String? _fromLocale() =>
      _fromCountryCode(PlatformDispatcher.instance.locale.countryCode);

  String? _fromCountryCode(String? code) {
    final iso = code?.trim().toUpperCase();
    if (iso == null || iso.length != 2) return null;
    final raw = CountryCode.tryFromCountryCode(iso)?.dialCode?.trim();
    if (raw == null || raw.isEmpty) return null;
    return raw.startsWith('+') ? raw : '+$raw';
  }

  String? _asString(dynamic value) {
    final s = value?.toString().trim();
    return (s == null || s.isEmpty) ? null : s;
  }
}
