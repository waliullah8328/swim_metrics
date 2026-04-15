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

  // 🔥 progressive runtime marker
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

  void stop() {
    pause();
  }

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
      "Lap $lapNo: ${TimeUtils1.formatTime(lap)} / ${TimeUtils1.formatTime(total)}\n";
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
      logPredictor += _predict(t, lap, lapNo) + "\n";

      // 🔥 ONLY progressive mode rotates marker
      if (_shouldEnableProgressive() && progressiveActive) {
        if (_marker == '15') {
          _marker = '25';
        } else if (_marker == '25') {
          _marker = '35';
        } else {
          _marker = '15';
        }
      }
    }

    notifyListeners();
  }

  // ================= PREDICT =================
  String _predict(TimerState t, double lap, int lapNo) {
    final total = t.splits.last;

    // ================= PROGRESSIVE =================
    if (_shouldEnableProgressive() && progressiveActive) {
      final result = SplitsCore4.predictorLCM50(
        elapsedSeconds: total,
        gender: gender,
        marker: _marker,
        pushStart: startType.toLowerCase() == 'from push',
      );

      final proj = result == null ? 0.0 : result;

      return "$_marker: "
          "${TimeUtils1.formatTimeCompact(total)} / "
          "Projected Finish ${TimeUtils1.formatTimeCompact(proj)}";
    }

    // ================= STANDARD =================
    final split = int.tryParse(splitSize) ?? 50;

    final result = SplitsCore4.predictorStandard(
      elapsedSeconds: total,
      splitCount: t.splits.length,
      gender: gender,
      stroke: stroke,
      distance: distance,
      course: course,
      splitSize: split,
      pushStart: startType.toLowerCase() == 'from push',
    );

    String line =
        "Lap $lapNo: ${TimeUtils1.formatTime(lap)} / ${TimeUtils1.formatTime(total)}";

    if (result != null) {
      line += " / Projected Finish: ${TimeUtils1.formatTime(result)}";
    }

    return line;
  }

  // ================= PROGRESSIVE CHECK =================
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

  // ================= CLEAR LOG =================
  void clearLog() {
    if (activeMode == 'Stopwatch') logStopwatch = '';
    if (activeMode == 'Predictor') logPredictor = '';
    if (activeMode == 'Converter') logConverter = '';
    notifyListeners();
  }

  // ================= UNDO =================
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

  // ================= TICKER =================
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