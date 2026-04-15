import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../../core/utils/utils/ratios_1.dart';
import '../../../../../core/utils/utils/time_utils_1.dart' hide TimeUtils1;

final stopwatchProvider2 =
ChangeNotifierProvider<StopwatchController2>((ref) => StopwatchController2());

class TimerState {
  bool running = false;
  DateTime? startTime;
  double accumulated = 0.0;
  DateTime? lastSplitWall;
  final List<double> splits = [];
}

class StopwatchController2 extends ChangeNotifier {
  final Map<String, TimerState> _timers = {
    'Stopwatch': TimerState(),
    'Predictor': TimerState(),
    'Converter': TimerState(),
  };

  Timer? _ticker;

  // ================= MODE =================
  String activeMode = 'Stopwatch';

  String logStopwatch = '';
  String logPredictor = '';
  String logConverter = '';

  // ================= PREDICTOR =================
  String gender = 'men';
  String stroke = 'free';
  String distance = '100';
  String course = 'scm';
  String splitSize = '50';
  String startType = 'From Start';

  bool progressiveActive = false;
  String _marker = '15';

  // ================= CONVERTER =================
  String fromCourse = 'SCM';
  String toCourse = 'SCM';

  StopwatchController2() {
    initializeRatios1();
  }

  TimerState get current => _timers[activeMode]!;

  // ================= MODE =================
  void setMode(String m) {
    activeMode = m;
    notifyListeners();
  }

  // ================= PARAMS =================
  void setPredictorParams({
    String? g,
    String? s,
    String? d,
    String? c,
    String? split,
    String? start,
  }) {
    if (g != null) gender = g;
    if (s != null) stroke = s;
    if (d != null) distance = d;
    if (c != null) course = c.toLowerCase();
    if (split != null) splitSize = split;
    if (start != null) startType = start;

    progressiveActive = _shouldEnableProgressive();
    _marker = '15';
    notifyListeners();
  }

  void setConverterCourses({String? from, String? to}) {
    if (from != null) fromCourse = from;
    if (to != null) toCourse = to;
    notifyListeners();
  }

  void toggleProgressive(bool v) {
    progressiveActive = v;
    _marker = '15';
    notifyListeners();
  }

  // ================= START =================
  void start() {
    final t = current;
    if (t.running) return;

    final now = DateTime.now();

    t.startTime ??= now;
    t.running = true;
    t.lastSplitWall ??= now;

    _marker = '15';

    _startTicker();
    notifyListeners();
  }

  // ================= STOP =================
  void pause() {
    final t = current;
    if (!t.running) return;

    t.accumulated = elapsed();
    t.running = false;
    t.startTime = null;
    t.lastSplitWall = null;

    _ticker?.cancel();
    notifyListeners();
  }

  void stop() => pause();

  // ================= ELAPSED =================
  double elapsed() {
    final t = current;
    if (t.running && t.startTime != null) {
      return t.accumulated +
          DateTime.now().difference(t.startTime!).inMilliseconds / 1000;
    }
    return t.accumulated;
  }

  // ================= SPLIT =================
  void split() {
    final t = current;
    if (!t.running) return;

    final now = DateTime.now();
    final total = elapsed();

    final lap = t.lastSplitWall == null
        ? total
        : now.difference(t.lastSplitWall!).inMilliseconds / 1000;

    t.lastSplitWall = now;
    t.splits.add(total);

    final lapNo = t.splits.length;

    // ================= STOPWATCH =================
    if (activeMode == 'Stopwatch') {
      logStopwatch +=
      "Lap $lapNo: ${TimeUtils1.formatTime(lap)} / "
          "${TimeUtils1.formatTime(total)}\n";
    }

    // ================= CONVERTER =================
    else if (activeMode == 'Converter') {
      final factor = _factor(fromCourse, toCourse);
      final converted = total * factor;

      logConverter +=
      "Lap $lapNo: ${TimeUtils1.formatTime(total)} $fromCourse → "
          "${TimeUtils1.formatTime(converted)} $toCourse\n";
    }

    // ================= PREDICTOR =================
    else {
      final projected = _predict(lapNo) ?? 0.0;

      final isProgressive =
          _shouldEnableProgressive() && progressiveActive;

      // Show 15 / 25 / 35 instead of Lap 1 / Lap 2 / Lap 3
      final label = isProgressive ? _marker : "Lap $lapNo";

      logPredictor +=
      "$label: ${TimeUtils1.formatTime(lap)} / "
          "${TimeUtils1.formatTime(total)} / "
          "Projected: ${TimeUtils1.formatTime(projected)}\n";

      // Move next marker
      if (isProgressive) {
        _marker = _nextMarker(_marker);
      }
    }

    notifyListeners();
  }

  // ================= PREDICT (FIXED) =================
  double? _predict(int lapNo) {
    final total = elapsed(); // ✅ FIX: ALWAYS REAL TIME
    if (total <= 0) return null;

    if (_shouldEnableProgressive() && progressiveActive) {
      return SplitsCore4.predictorLCM50(
        elapsedSeconds: total,
        gender: gender,
        marker: _marker,
        pushStart: startType.toLowerCase() == 'from push',
      );
    }

    final split = int.tryParse(splitSize) ?? 50;

    return SplitsCore4.predictorStandard(
      elapsedSeconds: total,
      splitCount: lapNo,
      gender: gender,
      stroke: stroke,
      distance: distance,
      course: course,
      splitSize: split,
      pushStart: startType.toLowerCase() == 'from push',
    );
  }

  // ================= MARKER =================
  String _nextMarker(String current) {
    switch (current) {
      case '15':
        return '25';
      case '25':
        return '35';
      default:
        return '15';
    }
  }

  // ================= CHECK =================
  bool _shouldEnableProgressive() {
    return course.toLowerCase() == 'lcm' &&
        distance == '50' &&
        ['15', '25', '35'].contains(splitSize);
  }

  // ================= CONVERTER =================
  double _factor(String from, String to) {
    if (from == to) return 1.0;
    return Ratios1.conversionFactors['${from}_$to'] ?? 1.0;
  }

  // ================= RESET =================
  void reset() {
    final t = current;

    t.running = false;
    t.startTime = null;
    t.accumulated = 0;
    t.lastSplitWall = null;
    t.splits.clear();

    logStopwatch = '';
    logPredictor = '';
    logConverter = '';

    _marker = '15';

    _ticker?.cancel();
    notifyListeners();
  }

  void clearLog() {
    if (activeMode == 'Stopwatch') logStopwatch = '';
    if (activeMode == 'Predictor') logPredictor = '';
    if (activeMode == 'Converter') logConverter = '';
    notifyListeners();
  }

  void undoLastSplit() {
    final t = current;
    if (t.splits.isEmpty) return;

    t.splits.removeLast();

    if (activeMode == 'Stopwatch') {
      logStopwatch = _removeLast(logStopwatch);
    } else if (activeMode == 'Predictor') {
      logPredictor = _removeLast(logPredictor);
      _marker = '15';
    } else {
      logConverter = _removeLast(logConverter);
    }

    notifyListeners();
  }

  String _removeLast(String log) {
    final lines = log.trim().split("\n");
    if (lines.isNotEmpty) lines.removeLast();
    return lines.join("\n");
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(
      const Duration(milliseconds: 100),
          (_) {
        if (current.running) notifyListeners();
      },
    );
  }
}