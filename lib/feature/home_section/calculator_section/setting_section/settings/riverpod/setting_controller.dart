import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_state.dart';


final themeModeProvider = Provider<ThemeMode>((ref) {
  // Watch only the darkMode property.
  // Whenever toggleDarkMode is called, this provider auto-updates.
  final isDarkMode = ref.watch(settingsProvider.select((s) => s.darkMode));

  return isDarkMode ? ThemeMode.dark : ThemeMode.light;
});
enum FontSizeOption { small, medium, big }

enum AppLanguage {
  english('en', 'ENGLISH'),
  french('fr', 'FRENCH'),
  spanish('es', 'SPANISH'),
  italian('it', 'ITALIAN');

  final String code;
  final String name;
  const AppLanguage(this.code, this.name);
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState()) {
    _init();
  }

  Future<void> _init() async {
    await loadSettings();
  }

  static const String fontSizeKey = "font_size";
  static const String darkModeKey = "dark_mode";
  static const String languageKey = "app_language";
  static const String stopwatchKey = "stopwatch_sound";
  static const String hapticKey = "haptic_feedback";

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final darkMode = prefs.getBool(darkModeKey) ?? true;
    final stopwatch = prefs.getBool(stopwatchKey) ?? true;
    final haptic = prefs.getBool(hapticKey) ?? true;

    final fontSizeValue = prefs.getString(fontSizeKey);
    final languageCode = prefs.getString(languageKey);

    final fontSize = fontSizeValue != null
        ? FontSizeOption.values.firstWhere(
          (e) => e.name == fontSizeValue,
      orElse: () => FontSizeOption.medium,
    )
        : state.fontSize;

    final language = languageCode != null
        ? AppLanguage.values.firstWhere(
          (e) => e.code == languageCode,
      orElse: () => AppLanguage.english,
    )
        : state.language;

    state = state.copyWith(
      fontSize: fontSize,
      darkMode: darkMode,
      language: language,
      stopwatchSound: stopwatch,
      haptic: haptic,
    );
  }

  Future<void> toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(darkModeKey, value);
    state = state.copyWith(darkMode: value);
  }

  Future<void> toggleStopwatch(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(stopwatchKey, value);
    state = state.copyWith(stopwatchSound: value);
  }

  Future<void> toggleHaptic(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(hapticKey, value);
    state = state.copyWith(haptic: value);
  }

  Future<void> changeFontSize(FontSizeOption size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(fontSizeKey, size.name);
    state = state.copyWith(fontSize: size);
  }

  Future<void> changeLanguage(AppLanguage language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(languageKey, language.code);
    state = state.copyWith(language: language);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
      (ref) => SettingsNotifier(),
);