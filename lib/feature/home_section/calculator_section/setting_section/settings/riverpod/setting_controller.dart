import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swim_metrics/feature/home_section/calculator_section/setting_section/settings/riverpod/settings_state.dart';

import '../../../../../../config/theme/theme_provider.dart';


enum FontSizeOption {
  small,
  medium,
  big,
}
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState());

  Future<void> toggleDarkMode(bool value,ref) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(darkModeKey, value);

    state = state.copyWith(
      darkMode: value,
    );

    /// Update theme
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

  static const String key = "font_size";
  static const String darkModeKey = "dark_mode";

  Future<void> loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key);
    final darkMode = prefs.getBool(darkModeKey) ?? false;

    if (value != null) {
      state = state.copyWith(
        fontSize: FontSizeOption.values.firstWhere(
              (e) => e.name == value,
          orElse: () => FontSizeOption.medium,
        ),
      );
    }
    state = state.copyWith(
      darkMode: darkMode,
    );
  }

  Future<void> changeFontSize(FontSizeOption size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, size.name);

    state = state.copyWith(fontSize: size);
  }
}

final settingsProvider =
StateNotifierProvider<SettingsNotifier, SettingsState>(
        (ref) => SettingsNotifier()..loadFontSize());