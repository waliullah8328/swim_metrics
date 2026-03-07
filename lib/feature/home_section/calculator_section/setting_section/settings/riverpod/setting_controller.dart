import 'package:flutter_riverpod/legacy.dart';
import 'package:swim_metrics/feature/home_section/calculator_section/setting_section/settings/riverpod/settings_state.dart';

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState());

  void toggleDarkMode(bool value) {
    state = state.copyWith(darkMode: value);
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
}

final settingsProvider =
StateNotifierProvider<SettingsNotifier, SettingsState>(
        (ref) => SettingsNotifier());