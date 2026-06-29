import '../../config/env_config.dart';

class ApiConstants {
  ApiConstants._();

  static String get baseUrl => EnvConfig.baseUrl;

  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;

  static const Map<String, String> defaultHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
  static const String multiPart = 'multipart/form-data';
  static const String appAttestationAssertionHeader =
      'X-App-Attestation-Assertion';
  static const String appAttestationProviderHeader =
      'X-App-Attestation-Provider';
  static const String appAttestationKeyIdHeader = 'X-App-Attestation-Key-Id';
  static const String appAttestationNonceHeader = 'X-App-Attestation-Nonce';
  static const String appAttestationBindingHeader =
      'X-App-Attestation-Binding';
  static const String appAttestationStatusHeader = 'X-App-Attestation-Status';

  static const String appAttestationStatusPresent = 'present';
  static const String appAttestationStatusUnavailable = 'unavailable';

  static const String requiresAppAttestationExtra =
      'requiresAppAttestation';
  static const String enforceAppAttestationExtra = 'enforceAppAttestation';
}
