import 'package:flutter/material.dart';

class ThemeModeData extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  void changeTheme(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  ThemeMode get themeMode => _themeMode;
}