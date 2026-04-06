import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class PlatformConstants {
  PlatformConstants._();

  /// Platform checks
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isWeb => kIsWeb;
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;
  static bool get isWindows => !kIsWeb && Platform.isWindows;
  static bool get isLinux => !kIsWeb && Platform.isLinux;

  /// Mobile only
  static bool get isMobile => isAndroid || isIOS;

  /// Desktop only
  static bool get isDesktop => isMacOS || isWindows || isLinux;

  /// Platform name (useful for logs / analytics)
  static String get platformName {
    if (isWeb) return 'web';
    if (isAndroid) return 'android';
    if (isIOS) return 'ios';
    if (isMacOS) return 'macos';
    if (isWindows) return 'windows';
    if (isLinux) return 'linux';
    return 'unknown';
  }
}
