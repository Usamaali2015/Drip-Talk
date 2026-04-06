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
}
