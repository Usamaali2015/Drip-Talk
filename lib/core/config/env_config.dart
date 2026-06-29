import 'app_environment.dart';

class EnvConfig {
  EnvConfig._();

  static const String reverbAppId = 'fashionai-app';
  static const String reverbAppKey = 'fashionai-key';

  static late AppEnvironment _environment;

  static void init(AppEnvironment env) {
    _environment = env;
  }

  static AppEnvironment get environment => _environment;

  static String get baseUrl {
    switch (_environment) {
      case AppEnvironment.dev:
        return 'https://epic-gates.84-247-185-16.plesk.page/';
      case AppEnvironment.staging:
        return 'https://staging.api.example.com';
      case AppEnvironment.prod:
        return 'https://api.example.com';
    }
  }

  static String get reverbAuthEndpoint =>
      Uri.parse(baseUrl).resolve('/broadcasting/auth').toString();

  static Uri get reverbWebSocketUri {
    final baseUri = Uri.parse(baseUrl);
    return Uri(
      scheme: baseUri.scheme == 'https' ? 'wss' : 'ws',
      host: baseUri.host,
      port: baseUri.hasPort ? baseUri.port : null,
      path: '/app/$reverbAppKey',
      queryParameters: const <String, String>{
        'protocol': '7',
        'client': 'flutter',
        'version': '1.0.0',
        'flash': 'false',
      },
    );
  }
}
