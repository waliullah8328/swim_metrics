class SettingsState {
  final bool darkMode;
  final bool stopwatchSound;
  final bool voiceInput;
  final bool haptic;

  SettingsState({
    this.darkMode = false,
    this.stopwatchSound = true,
    this.voiceInput = true,
    this.haptic = true,
  });

  SettingsState copyWith({
    bool? darkMode,
    bool? stopwatchSound,
    bool? voiceInput,
    bool? haptic,
  }) {
    return SettingsState(
      darkMode: darkMode ?? this.darkMode,
      stopwatchSound: stopwatchSound ?? this.stopwatchSound,
      voiceInput: voiceInput ?? this.voiceInput,
      haptic: haptic ?? this.haptic,
    );
  }
}