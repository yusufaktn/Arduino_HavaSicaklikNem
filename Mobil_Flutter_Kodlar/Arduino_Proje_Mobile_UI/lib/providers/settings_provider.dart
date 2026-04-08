import 'package:flutter/foundation.dart';

class SettingsProvider with ChangeNotifier {
  bool _isAutoRefresh = true;
  int _refreshInterval = 5;

  bool get isAutoRefresh => _isAutoRefresh;
  int get refreshInterval => _refreshInterval;

  void setAutoRefresh(bool value) {
    _isAutoRefresh = value;
    notifyListeners();
  }

  void setRefreshInterval(int value) {
    if (value >= 1) {
      _refreshInterval = value;
      notifyListeners();
    }
  }
}
