import 'package:flutter/material.dart';
import 'package:golden_price/core/constants/cons.dart';

/// App-wide theme mode, persisted in SharedPreferences.
/// Toggles between dark (default) and light.
class ThemeModeNotifier extends ValueNotifier<ThemeMode> {
  ThemeModeNotifier._(super.value);

  static final instance = ThemeModeNotifier._(_load());

  static ThemeMode _load() {
    return log.getString(THEME_MODE) == ThemeMode.light.name
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  void toggle() {
    value = value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    log.setString(THEME_MODE, value.name);
  }

  IconData get icon =>
      value == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode;
}
