import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  static const String _themePreferenceKey = 'theme_preference';

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themePreferenceKey);

    if (savedTheme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  Future<void> toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    if (isDark) {
      _themeMode = ThemeMode.dark;
      await prefs.setString(_themePreferenceKey, 'dark');
    } else {
      _themeMode = ThemeMode.light;
      await prefs.setString(_themePreferenceKey, 'light');
    }
    notifyListeners();
  }
}
