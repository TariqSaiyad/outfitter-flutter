import 'package:Outfitter/config.dart';
import 'package:flutter/material.dart';

class Theme with ChangeNotifier {
  static bool _isDark = true;
  static Color _primary = Colors.deepPurple;
  static Color _accent = Colors.pinkAccent;

  Theme() {
    _isDark = themeBox.get('theme', defaultValue: true);
    _primary =
        Color(themeBox.get('primary', defaultValue: Colors.deepPurple.value));
    _accent =
        Color(themeBox.get('accent', defaultValue: Colors.pinkAccent.value));
  }

  ThemeMode get currentTheme => _isDark ? ThemeMode.dark : ThemeMode.light;

  // ThemeMode currentTheme() {
  //   return _isDark ? ThemeMode.dark : ThemeMode.light;
  // }

  ThemeData get themeData => ThemeData(
        brightness: _isDark ? Brightness.dark : Brightness.light,
        primaryColor: _primary,
        accentColor: _accent,
      );

  bool get isDark => _isDark;

  Color get primary => _primary;

  Color get accent => _accent;

  void setDarkMode(bool b) {
    _isDark = b;
    print(isDark);

    themeBox.put('theme', _isDark);
    notifyListeners();
  }

  void setPrimary(Color c) {
    _primary = c;
    themeBox.put('primary', _primary.value);
    notifyListeners();
  }

  void setAccent(Color c) {
    _accent = c;
    themeBox.put('accent', _accent.value);
    notifyListeners();
  }
}
