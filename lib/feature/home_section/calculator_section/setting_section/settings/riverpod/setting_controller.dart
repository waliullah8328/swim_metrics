import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swim_metrics/feature/home_section/calculator_section/setting_section/settings/riverpod/settings_state.dart';

import '../../../../../../config/theme/theme_provider.dart';
import '../../../../../../core/services/theme_service.dart';


enum FontSizeOption {
  small,
  medium,
  big,
}


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
  SettingsNotifier() : super(SettingsState());

  static const String key = "font_size";
  static const String darkModeKey = "dark_mode";
  static const String languageKey = "app_language";

  Future<void> toggleDarkMode(bool value, ref) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(darkModeKey, value);

    state = state.copyWith(
      darkMode: value,
    );

    ref.read(themeModeProvider.notifier).state =
    value ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleStopwatch(bool value) {
    state = state.copyWith(stopwatchSound: value);
  }

  void toggleVoice(bool value) {
    state = state.copyWith(voiceInput: value);
  }

  void toggleHaptic(bool value) {
    state = state.copyWith(haptic: value);
  }

  Future<void> loadSettings(ref) async {
    final prefs = await SharedPreferences.getInstance();

    final fontSizeValue = prefs.getString(key);
    final darkMode = prefs.getBool(darkModeKey) ?? false;
    final languageCode = prefs.getString(languageKey);

    /// font size
    if (fontSizeValue != null) {
      state = state.copyWith(
        fontSize: FontSizeOption.values.firstWhere(
              (e) => e.name == fontSizeValue,
          orElse: () => FontSizeOption.medium,
        ),
      );
    }

    /// language
    if (languageCode != null) {
      state = state.copyWith(
        language: AppLanguage.values.firstWhere(
              (e) => e.code == languageCode,
          orElse: () => AppLanguage.english,
        ),
      );
    }

    /// dark mode
    state = state.copyWith(
      darkMode: darkMode,
    );

    ref.read(themeModeProvider.notifier).state =
    darkMode ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> changeFontSize(FontSizeOption size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, size.name);

    state = state.copyWith(fontSize: size);
  }

  /// LANGUAGE CHANGE
  Future<void> changeLanguage(AppLanguage language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(languageKey, language.code);

    state = state.copyWith(language: language);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>( (ref) => SettingsNotifier()..loadSettings(ref));