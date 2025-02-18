
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/theme_constant.dart';

class ThemeRepository {
  final SharedPreferences preferences;

  ThemeRepository({required this.preferences});

  Future<int> getThemeMode() async {
    return preferences.getInt(ThemeConstants.themePreferenceKey) ??
        ThemeConstants.systemTheme;
  }

  Future<bool> saveThemeMode(int themeMode) async {
    return await preferences.setInt(ThemeConstants.themePreferenceKey, themeMode);
  }
}
