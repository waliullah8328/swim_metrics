
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'audio_state.dart';

class AudioNotifier extends StateNotifier<AudioState> {
  AudioNotifier() : super(const AudioState()) {
    _init();
  }

  final AudioPlayer _player = AudioPlayer();

  void _init() {
    _player.onPlayerComplete.listen((event) {
      state = state.copyWith(isPlaying: false);
    });
  }

  /// ▶️ PLAY AUDIO
  Future<void> play() async {
    await _player.play(AssetSource('audio/stop_watch_audio.mp3'));
    state = state.copyWith(isPlaying: true);
  }

  /// ⏸ PAUSE AUDIO
  Future<void> pause() async {
    await _player.pause();
    state = state.copyWith(isPlaying: false);
  }

  /// ⏹ STOP AUDIO
  Future<void> stop() async {
    await _player.stop();
    state = state.copyWith(isPlaying: false);
  }

  /// 🔁 LOOP AUDIO (optional)
  Future<void> setLoop(bool loop) async {
    await _player.setReleaseMode(
      loop ? ReleaseMode.loop : ReleaseMode.stop,
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

final audioProvider =
StateNotifierProvider<AudioNotifier, AudioState>(
      (ref) => AudioNotifier(),
);