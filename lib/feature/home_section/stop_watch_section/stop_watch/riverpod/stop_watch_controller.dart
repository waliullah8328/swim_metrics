import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final stopwatchProvider =
StateNotifierProvider<StopwatchController, StopwatchState>((ref) {
  return StopwatchController();
});

class StopwatchState {
  final Duration time;
  final bool isRunning;
  final List<Duration> laps;

  const StopwatchState({
    required this.time,
    required this.isRunning,
    required this.laps,
  });

  StopwatchState copyWith({
    Duration? time,
    bool? isRunning,
    List<Duration>? laps,
  }) {
    return StopwatchState(
      time: time ?? this.time,
      isRunning: isRunning ?? this.isRunning,
      laps: laps ?? this.laps,
    );
  }
}

class StopwatchController extends StateNotifier<StopwatchState> {
  StopwatchController()
      : super(const StopwatchState(
    time: Duration.zero,
    isRunning: false,
    laps: [],
  ));

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  /// START / RESUME
  void start() {
    if (_stopwatch.isRunning) return;

    _stopwatch.start();

    _timer ??= Timer.periodic(const Duration(milliseconds: 100), (_) {
      state = state.copyWith(time: _stopwatch.elapsed);
    });

    state = state.copyWith(isRunning: true);
  }

  /// PAUSE
  void pause() {
    _stopwatch.stop();
    _timer?.cancel();
    _timer = null;

    state = state.copyWith(isRunning: false);
  }

  /// RESET
  void reset() {
    _stopwatch.reset();
    _stopwatch.stop();

    _timer?.cancel();
    _timer = null;

    state = state.copyWith(
      time: Duration.zero,
      laps: [],
      isRunning: false,
    );
  }

  /// LAP
  void lap() {
    if (!_stopwatch.isRunning) return;

    final updatedLaps = [...state.laps, _stopwatch.elapsed];
    state = state.copyWith(laps: updatedLaps);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}