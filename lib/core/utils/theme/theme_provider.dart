

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/theme_service.dart';

final themeModeProvider =
StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  static const String prefKey = 'theme_mode';
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final savedTheme = await ThemeService.getThemeMode();
    state = savedTheme;
  }

  void toggleTheme() async {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
      await ThemeService.saveThemeMode(ThemeMode.dark);
    } else {
      state = ThemeMode.light;
      await ThemeService.saveThemeMode(ThemeMode.light);
    }
  }

  void setSystemTheme() async {
    state = ThemeMode.system;
    await ThemeService.saveThemeMode(ThemeMode.system);
  }

  Future<void> _loadTheme1() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString(prefKey);
    if (mode == 'light') {
      state = ThemeMode.light;
    } else if (mode == 'dark') {state = ThemeMode.dark;}
    else {state = ThemeMode.system;}
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    final value = mode == ThemeMode.light
        ? 'light'
        : mode == ThemeMode.dark
        ? 'dark'
        : 'system';
    await prefs.setString(prefKey, value);
  }
}