
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swim_metrics/feature/home_section/calculator_section/setting_section/settings/riverpod/settings_state.dart';


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
  final Ref ref;

  SettingsNotifier(this.ref) : super(SettingsState()) {
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

  /// LOAD SETTINGS
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // 🔥 FIX: Defaulting to TRUE if null (first run)
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

    // Sync the ThemeProvider with the loaded (or default) value
    // ref.read(themeModeProvider.notifier).state = darkMode ? ThemeMode.dark : ThemeMode.light;

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
    // ref.read(themeModeProvider.notifier).state = value ? ThemeMode.dark : ThemeMode.light;
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
      (ref) => SettingsNotifier(ref),
);