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

    const int maxLogs = 50; // limit history size

    final now = DateTime.now();
    final total = elapsed();

    final lap = t.lastSplitWall == null
        ? total
        : now.difference(t.lastSplitWall!).inMilliseconds / 1000;

    t.lastSplitWall = now;
    t.splits.add(total);

    final lapNo = t.splits.length;

    void trimLog(List<String> lines) {
      if (lines.length > maxLogs) {
        lines.removeLast(); // remove oldest (bottom)
      }
    }

    // ================= STOPWATCH =================
    if (activeMode == 'Stopwatch') {
      final lines = logStopwatch.isEmpty
          ? <String>[]
          : logStopwatch.trim().split('\n');

      lines.insert(
        0,
        "Lap $lapNo: ${TimeUtils1.formatTime(lap)} / "
            "${TimeUtils1.formatTime(total)}",
      );

      trimLog(lines);
      logStopwatch = lines.join('\n');
    }

    // ================= CONVERTER =================
    else if (activeMode == 'Converter') {
      final factor = _factor(fromCourse, toCourse);
      final converted = total * factor;

      final lines = logConverter.isEmpty
          ? <String>[]
          : logConverter.trim().split('\n');

      lines.insert(
        0,
        "Lap $lapNo: ${TimeUtils1.formatTime(total)} ${fromCourse.toUpperCase()}  → "
            "${TimeUtils1.formatTime(converted)}  ${toCourse.toUpperCase()}",
      );

      trimLog(lines);
      logConverter = lines.join('\n');
    }

    // ================= PREDICTOR =================
    // ================= PREDICTOR =================
    // ================= PREDICTOR =================
    else {
      // Create header only once (static until Clear button resets logPredictor)
      if (logPredictor.trim().isEmpty) {
        logPredictor =
        "${gender[0].toUpperCase()}${gender.substring(1).toLowerCase()}'s "
            "$distance "
            "${stroke[0].toUpperCase()}${stroke.substring(1).toLowerCase()} "
            "${course.toUpperCase()} Projection\n"
            "Start Type: $startType | Split Size: $splitSize\n"
            "===============\n"
            "Split Breakdown:\n";
      }

      final projected = _predict(lapNo) ?? 0.0;
      final isProgressive = _shouldEnableProgressive() && progressiveActive;
      final label = isProgressive ? _marker : "Lap $lapNo";

      final allLines = logPredictor.split('\n');

      // Find split section
      int insertIndex = allLines.indexOf("Split Breakdown:") + 1;

      // Safety fallback
      if (insertIndex == 0) insertIndex = allLines.length;

      String fLap = TimeUtils1.formatTime(lap);
      String fTotal = TimeUtils1.formatTime(total);
      String fProj = TimeUtils1.formatTime(projected);

      final newEntry =
          "$label $fLap / $fTotal / Projected Finish $fProj";

      // Add lap below header only
      allLines.insert(insertIndex, newEntry);

      // Keep only lap logs, header stays fixed
      final headerLines = allLines.sublist(0, insertIndex);
      final lapLines = allLines.sublist(insertIndex);

      if (lapLines.length > maxLogs) {
        lapLines.removeLast();
      }

      logPredictor = [...headerLines, ...lapLines].join('\n');

      if (isProgressive) {
        _marker = _nextMarker(_marker);
      }
    }

    notifyListeners();
  }

  void initializePredictorLog() {
    logPredictor = "${gender.toUpperCase()}'$distance e ${stroke.toUpperCase()} ${course.toUpperCase()}Projection\n"
        "Start Type: $startType | Split Size: $splitSize\n"
        "===============\n"
        "Split Breakdown:\n";
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

    // Remove latest split data
    t.splits.removeLast();

    if (activeMode == 'Stopwatch') {
      logStopwatch = _removeFirst(logStopwatch);
    } else if (activeMode == 'Predictor') {
      // Remove first lap only, keep static header text
      logPredictor = _removeFirstPredictorLap(logPredictor);

      // Optional: reset marker back one step if using progressive mode
      // _marker = _previousMarker(_marker);
    } else {
      logConverter = _removeFirst(logConverter);
    }

    notifyListeners();
  }

  String _removeFirst(String log) {
    if (log.isEmpty) return "";

    List<String> lines = log.trim().split("\n");

    if (lines.isNotEmpty) {
      lines.removeAt(0);
    }

    return lines.join("\n");
  }

// Predictor: preserve header, remove first lap after "Split Breakdown:"
  String _removeFirstPredictorLap(String log) {
    if (log.isEmpty) return "";

    List<String> lines = log.split("\n");

    int headerIndex = lines.indexOf("Split Breakdown:");

    if (headerIndex == -1) {
      return log; // header not found
    }

    int lapIndex = headerIndex + 1;

    // Skip empty line(s)
    while (lapIndex < lines.length && lines[lapIndex].trim().isEmpty) {
      lapIndex++;
    }

    // Remove first lap only
    if (lapIndex < lines.length) {
      lines.removeAt(lapIndex);
    }

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