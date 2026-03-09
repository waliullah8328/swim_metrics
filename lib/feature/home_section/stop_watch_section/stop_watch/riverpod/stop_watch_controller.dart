import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../calculator_section/calculator/data/model/split_model.dart';

final stopwatchProvider =
StateNotifierProvider<StopwatchController, StopwatchState>((ref) {
  return StopwatchController();
});

class StopwatchState {
  final Duration time;
  final bool isRunning;
  final List<Duration> laps;

  final List<String> from;
  final List<String> to;
  final String stroke;
  final String distance;
  final List<SplitModel> splits;

  const StopwatchState({
    required this.time,
    required this.isRunning,
    required this.laps,
    this.from = const ["WOMEN"],
    this.to = const ["LCM"],
    this.stroke = "FREE",
    this.distance = "100",
    this.splits = const [],
  });

  StopwatchState copyWith({
    Duration? time,
    bool? isRunning,
    List<Duration>? laps,
    List<String>? from,
    List<String>? to,
    String? stroke,
    String? distance,
    List<SplitModel>? splits,

  }) {
    return StopwatchState(
      time: time ?? this.time,
      isRunning: isRunning ?? this.isRunning,
      laps: laps ?? this.laps,
      from: from ?? this.from,
      to: to ?? this.to,
      stroke: stroke ?? this.stroke,
      distance: distance ?? this.distance,
      splits: splits ?? this.splits,
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

  void selectFrom(String value) {

      state = state.copyWith(from: [value]);

  }

  void selectTo(String value) {

      state = state.copyWith(to: [value]);

  }

  void selectStroke(String value) {
    state = state.copyWith(stroke: value);
  }

  void selectDistance(String value) {
    state = state.copyWith(distance: value);
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