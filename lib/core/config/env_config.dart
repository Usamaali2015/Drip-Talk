import 'app_environment.dart';

class EnvConfig {
  EnvConfig._();

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
}