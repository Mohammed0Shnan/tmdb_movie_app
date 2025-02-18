import 'package:flutter/material.dart';
import 'light_theme.dart'; // Assuming LightTheme is defined in this file
import 'dark_theme.dart';  // Assuming DarkTheme is defined in this file

class AppTheme {
  static ThemeData getLightTheme() {
    return LightTheme.theme;
  }

  static ThemeData getDarkTheme() {
    return DarkTheme.theme;
  }

  static ThemeData getTheme(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.dark:
        return getDarkTheme();
      case ThemeMode.light:
        return getLightTheme();
      case ThemeMode.system:
      return LightTheme.theme;
    }
  }

}
