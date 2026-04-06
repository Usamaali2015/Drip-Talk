import 'dart:developer' as developer;

class AppLogger {
  AppLogger._();

  static void log(String message, {String name = 'APP'}) {
    developer.log(message, name: name);
  }

  static void error(String message, Object error) {
    developer.log(message, error: error, name: 'ERROR');
  }
}
