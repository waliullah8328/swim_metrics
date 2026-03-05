import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _themeModeKey = 'theme_mode';
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  /// Save ThemeMode
  static Future<void> saveThemeMode(ThemeMode mode) async {
    try {
      await init();
      await _preferences!.setString(_themeModeKey, mode.name);
      log("✅ Theme mode saved: ${mode.name}");
    } catch (e) {
      log("❌ Error saving theme mode: $e");
    }
  }

  /// Get saved ThemeMode
  static Future<ThemeMode> getThemeMode() async {
    try {
      await init();
      final mode = _preferences!.getString(_themeModeKey);
      if (mode == ThemeMode.dark.name) return ThemeMode.dark;
      if (mode == ThemeMode.light.name) return ThemeMode.light;
      return ThemeMode.system;
    } catch (e) {
      log("❌ Error loading theme mode: $e");
      return ThemeMode.system;
    }
  }
}
