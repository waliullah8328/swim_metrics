import 'package:swim_metrics/feature/home_section/calculator_section/setting_section/settings/riverpod/setting_controller.dart';

class SettingsState {
  final bool darkMode;
  final bool stopwatchSound;
  final bool voiceInput;
  final bool haptic;
  final FontSizeOption fontSize;
  final AppLanguage language;

  SettingsState({
    this.darkMode = false,
    this.stopwatchSound = true,
    this.voiceInput = true,
    this.haptic = true,
    this.fontSize = FontSizeOption.medium,
    this.language = AppLanguage.english
  });

  SettingsState copyWith({
    bool? darkMode,
    bool? stopwatchSound,
    bool? voiceInput,
    bool? haptic,
    FontSizeOption? fontSize,
    AppLanguage? language,
  }) {
    return SettingsState(
      darkMode: darkMode ?? this.darkMode,
      stopwatchSound: stopwatchSound ?? this.stopwatchSound,
      voiceInput: voiceInput ?? this.voiceInput,
      haptic: haptic ?? this.haptic,
      fontSize: fontSize?? this.fontSize,
      language: language??this.language
    );
  }
}