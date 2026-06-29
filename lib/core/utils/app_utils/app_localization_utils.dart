import 'package:drip_talk/core/common/constants/app_keys.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

AppLocalizations? currentAppLocalizations() {
  final context = AppKeys.navigatorKey.currentContext;
  if (context == null) {
    return null;
  }

  return AppLocalizations.of(context);
}

AppLocalizations englishAppLocalizations() {
  return lookupAppLocalizations(const Locale('en'));
}

String localizedString({
  String? fallback,
  required String Function(AppLocalizations l10n) select,
}) {
  final l10n = currentAppLocalizations();
  if (l10n != null) {
    return select(l10n);
  }

  final englishValue = select(englishAppLocalizations());
  if (englishValue.trim().isNotEmpty) {
    return englishValue;
  }

  return fallback ?? '';
}
