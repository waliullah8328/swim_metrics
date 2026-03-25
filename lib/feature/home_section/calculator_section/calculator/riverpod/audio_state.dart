class AudioState {
  final bool isPlaying;

  const AudioState({
    this.isPlaying = false,
  });

  AudioState copyWith({
    bool? isPlaying,
  }) {
    return AudioState(
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}