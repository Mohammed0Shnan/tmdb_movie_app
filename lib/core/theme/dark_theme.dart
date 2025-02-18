import 'package:flutter/material.dart';

class DarkThemeColors {
  static const Color primary = Color(0xFF121212); // Dark background
  static const Color secondary = Color(0xFF1E1E1E); // Darker grey
  static const Color accent = Color(0xFF90CAF9); // Light blue accent color
  static const Color dividerOne = Color(0xFF333333); // Dark divider color
  static const Color text = Color(0xFFE0E0E0); // Light text on dark background
}

class DarkTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: DarkThemeColors.primary,
      scaffoldBackgroundColor: DarkThemeColors.primary,
      hintColor: DarkThemeColors.accent,
      textTheme: TextTheme(
        bodyLarge:  TextStyle(color: DarkThemeColors.text),
        bodyMedium: TextStyle(color: DarkThemeColors.text),
      ),
      dividerColor: DarkThemeColors.dividerOne,
      appBarTheme: AppBarTheme(
        backgroundColor: DarkThemeColors.primary,
        elevation: 0,
        titleTextStyle: TextStyle(color: DarkThemeColors.text),
      ),
      buttonTheme: ButtonThemeData(buttonColor: DarkThemeColors.accent),
      iconTheme: IconThemeData(color: DarkThemeColors.text),
    );
  }
}
