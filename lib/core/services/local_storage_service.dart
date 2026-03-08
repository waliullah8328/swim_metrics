import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

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

class LocalStorage {
  static const _fontSizeKey = "font_size";
  static const _darkModeKey = "dark_mode";
  static const _languageKey = "app_language";

  static SharedPreferences? _prefs;

  static FontSizeOption? _fontSize;
  static bool? _darkMode;
  static AppLanguage? _language;

  /// Initialize SharedPreferences (call before runApp)
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();

    _fontSize = _getFontSizeFromPrefs();
    _darkMode = _prefs!.getBool(_darkModeKey) ?? false;
    _language = _getLanguageFromPrefs();

    log('LocalStorage initialized: font=$_fontSize, dark=$_darkMode, lang=$_language');
  }

  /// FONT SIZE
  static FontSizeOption get fontSize => _fontSize ?? FontSizeOption.medium;

  static Future<void> setFontSize(FontSizeOption size) async {
    await _prefs?.setString(_fontSizeKey, size.name);
    _fontSize = size;
  }

  static FontSizeOption _getFontSizeFromPrefs() {
    final value = _prefs?.getString(_fontSizeKey);
    return FontSizeOption.values.firstWhere(
          (e) => e.name == value,
      orElse: () => FontSizeOption.medium,
    );
  }

  /// DARK MODE
  static bool get darkMode => _darkMode ?? false;

  static Future<void> setDarkMode(bool value) async {
    await _prefs?.setBool(_darkModeKey, value);
    _darkMode = value;
  }

  /// LANGUAGE
  static AppLanguage get language => _language ?? AppLanguage.english;

  static Future<void> setLanguage(AppLanguage lang) async {
    await _prefs?.setString(_languageKey, lang.code);
    _language = lang;
  }

  static AppLanguage _getLanguageFromPrefs() {
    final code = _prefs?.getString(_languageKey);
    return AppLanguage.values.firstWhere(
          (e) => e.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}