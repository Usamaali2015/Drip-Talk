import 'package:flutter/foundation.dart';

class WardrobeSyncNotifier extends ChangeNotifier {
  int _revision = 0;

  int get revision => _revision;

  void notifyChanged() {
    _revision += 1;
    notifyListeners();
  }
}
