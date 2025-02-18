import 'package:flutter/material.dart';

class LightThemeColors {
  static const Color primary = Color(0xFFFFFFFF); // White
  static const Color secondary = Color(0xFFF5F5F5); // Light grey
  static const Color accent = Color(0xFF00796B); // Green accent color
  static const Color dividerTwo = Color(0xFFE0E0E0); // Light divider color
  static const Color text = Color(0xFF212121); // Dark text on light background
}

class LightTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: LightThemeColors.primary,
      scaffoldBackgroundColor: LightThemeColors.primary,
      hintColor: LightThemeColors.accent,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: LightThemeColors.text),
        bodyMedium: TextStyle(color: LightThemeColors.text),
      ),
      dividerColor: LightThemeColors.dividerTwo,
      appBarTheme: AppBarTheme(
        backgroundColor: LightThemeColors.primary,
        elevation: 0,
        titleTextStyle: TextStyle(color: LightThemeColors.text),
      ),
      buttonTheme: ButtonThemeData(buttonColor: LightThemeColors.accent),
      iconTheme: IconThemeData(color: LightThemeColors.text),
    );
  }
}
