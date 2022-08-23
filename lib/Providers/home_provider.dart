import 'package:app_learn_english/models/config/config_app.dart';
import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  int _index = 0;
  ConfigApp? _configApp;
  bool _isShow = true;

  int get index => _index;
  bool get isShow => _isShow;
  ConfigApp? get configApp => _configApp;

  void setIndex(int idx) {
    _index = idx;
    notifyListeners();
  }

  void setIsShow(bool isShow) {
    _isShow = isShow;
    notifyListeners();
  }

  void setConfigApp(ConfigApp? configApp) {
    _configApp = configApp;
    notifyListeners();
  }
}
