import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  
  ThemeMode _mode;
  ThemeMode get mode => _mode;
  ThemeProvider({
    ThemeMode mode = ThemeMode.light,
  }) : _mode = mode;

  void toggleMode(SharedPreferences prefs) {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    
    notifyListeners();
  }

  void setMode(ThemeMode themeMode) {
    _mode = themeMode;
    notifyListeners();
  }
}

