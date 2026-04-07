import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../../core/utils/utils/ratios_1.dart';
import '../../../../../core/utils/utils/split_core_1.dart';
import '../../../../../core/utils/utils/time_utils_1.dart';

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

  // Active mode & logs
  String activeMode = 'Stopwatch';
  String logStopwatch = '';
  String logPredictor = '';
  String logConverter = '';

  // Predictor parameters
  String gender = 'men';
  String stroke = 'free';
  String distance = '100';
  String course = 'scy';
  String splitSize = '50';
  String startType = 'From Start';
  bool progressiveActive = false;

  // Converter parameters
  String fromCourse = 'SCY';
  String toCourse = 'LCM';

  StopwatchController2() {
    initializeRatios1(); // Load ratios
  }

  TimerState get current => _timers[activeMode]!;

  /// ----------------- Core Controls -----------------
  bool isRunning() => current.running;

  void clearLog() {
    if (activeMode == 'Stopwatch') {
      logStopwatch = '';
    } else if (activeMode == 'Predictor') {
      logPredictor = '';
    } else if (activeMode == 'Converter') {
      logConverter = '';
    }

    notifyListeners();
  }

  void start() {
    final t = current;
    if (t.running) return;

    final now = DateTime.now();
    if (activeMode == 'Predictor' && logPredictor.isEmpty) {
      logPredictor = _predictorHeader();
    }

    t.startTime ??= now;
    t.running = true;
    t.lastSplitWall ??= now;

    notifyListeners();
    _startTicker();
  }

  void pause() {
    final t = current;
    if (!t.running) return;

    t.accumulated += elapsed();
    t.running = false;
    t.startTime = null;
    t.lastSplitWall = null;

    _appendLog('Pause');
    notifyListeners();
    _ticker?.cancel();
  }

  void stop() {
    final t = current;
    if (!t.running) return;

    t.accumulated += elapsed();
    t.running = false;
    t.startTime = null;
    t.lastSplitWall = null;

    _appendLog('Stop');
    notifyListeners();
    _ticker?.cancel();
  }

  void reset() {
    final t = current;
    t.running = false;
    t.startTime = null;
    t.accumulated = 0.0;
    t.lastSplitWall = null;
    t.splits.clear();
    _replaceLog('');
    notifyListeners();
    _ticker?.cancel();
  }

  double elapsed() {
    final t = current;
    if (t.running && t.startTime != null) {
      return t.accumulated +
          DateTime.now().difference(t.startTime!).inMilliseconds / 1000.0;
    }
    return t.accumulated;
  }

  /// ----------------- Split Logic -----------------
  void split() {
    final t = current;
    if (!t.running) return;

    final now = DateTime.now();
    final totalElapsed = elapsed(); // total elapsed seconds
    final lapElapsed = t.lastSplitWall == null
        ? totalElapsed
        : now.difference(t.lastSplitWall!).inMilliseconds / 1000.0;

    // Update last split wall
    t.lastSplitWall = now;

    // Add total elapsed to splits
    t.splits.add(totalElapsed);

    final lapNo = t.splits.length; // lap number is always last

    String text;

    if (activeMode == 'Converter') {
      double factor =
      _simpleConversionFactor(fromCourse.toUpperCase(), toCourse.toUpperCase());
      double converted = totalElapsed * factor;

      text =
      'Lap $lapNo: ${TimeUtils1.formatSeconds(totalElapsed)} $fromCourse → ${TimeUtils1.formatSeconds(converted)} $toCourse';
      _appendConverterSplit(text);
    } else if (activeMode == 'Predictor') {
      text = _processPredictorLap(t, lapElapsed, lapNo);
      _appendPredictorSplit(text);
    } else {
      text =
      'Lap $lapNo: ${TimeUtils1.formatSeconds(lapElapsed)} / ${TimeUtils1.formatSeconds(totalElapsed)}';
      _appendStopWatchSplit(text);
    }

    notifyListeners();
  }

  /// =======================
  /// Undo last split: always removes last lap first
  /// =======================
  // void undoLastSplit() {
  //   final t = current;
  //   if (t.splits.isEmpty) return;
  //
  //   // Remove last lap (always last)
  //   t.splits.removeLast();
  //
  //   // Handle Predictor LCM 50 progressive logic
  //   if (activeMode == 'Predictor' &&
  //       progressiveActive &&
  //       course.toLowerCase() == 'lcm' &&
  //       distance == '50') {
  //     if (splitSize == '25') splitSize = '15';
  //     else if (splitSize == '35') splitSize = '25';
  //     else splitSize = '35';
  //   }
  //
  //   // Recalculate lastSplitWall
  //   double prevCum = t.splits.isNotEmpty ? t.splits.last : 0.0;
  //   if (t.running) {
  //     final now = DateTime.now();
  //     final delta = elapsed() - prevCum;
  //     t.lastSplitWall =
  //         now.subtract(Duration(milliseconds: (delta * 1000).round()));
  //   } else {
  //     t.lastSplitWall = null;
  //   }
  //
  //   // Remove last split line from logs
  //   _popLatestSplitLogLine();
  //
  //   notifyListeners();
  // }
  void undoLastSplit() {
    final t = current;
    if (t.splits.isEmpty) return;

    t.splits.removeLast();

    double prevCum = t.splits.isNotEmpty ? t.splits.last : 0.0;

    if (t.running) {
      final now = DateTime.now();
      final delta = elapsed() - prevCum;
      t.lastSplitWall =
          now.subtract(Duration(milliseconds: (delta * 1000).round()));
    } else {
      t.lastSplitWall = null;
    }

    if (activeMode == 'Predictor') {
      _rebuildPredictorLog(t);
    } else {
      _popLatestSplitLogLine();
    }

    notifyListeners();
  }

  /// ----------------- Predictor -----------------
  String _processPredictorLap(TimerState t, double lapElapsed, int lapNo) {
    double totalElapsed = t.splits.last;

    if (progressiveActive &&
        course.toLowerCase() == 'lcm' &&
        distance == '50' &&
        (splitSize == '15' || splitSize == '25' || splitSize == '35')) {

      final pred = SplitsCore1.predictorLCM50(
        elapsedSeconds: totalElapsed,
        gender: gender,
        marker: splitSize,
        pushStart: startType == 'From Push',
      );

      return '$splitSize: ${TimeUtils1.formatSeconds(totalElapsed)} / Projected finish ${TimeUtils1.formatSeconds(pred)}';
    } else {
      final pred = SplitsCore1.predictorStandard(
        elapsedSeconds: totalElapsed,
        splitCount: t.splits.length,
        gender: gender,
        stroke: stroke,
        distance: distance,
        course: course.toLowerCase(),
        splitSize: int.tryParse(splitSize) ?? 50,
        pushStart: startType == 'From Push',
      );

      return 'Lap $lapNo: ${TimeUtils1.formatSeconds(lapElapsed)} / ${TimeUtils1.formatSeconds(totalElapsed)} / Projected Finish: ${TimeUtils1.formatSeconds(pred)}';
    }
  }

  void _rebuildPredictorLog(TimerState t) {
    logPredictor = _predictorHeader();

    String tempSplit = splitSize;

    for (int i = 0; i < t.splits.length; i++) {
      final totalElapsed = t.splits[i];
      final lapElapsed =
      i == 0 ? totalElapsed : totalElapsed - t.splits[i - 1];

      if (progressiveActive &&
          course.toLowerCase() == 'lcm' &&
          distance == '50' &&
          (tempSplit == '15' || tempSplit == '25' || tempSplit == '35')) {

        final pred = SplitsCore1.predictorLCM50(
          elapsedSeconds: totalElapsed,
          gender: gender,
          marker: tempSplit,
          pushStart: startType == 'From Push',
        );

        logPredictor +=
        '$tempSplit: ${TimeUtils1.formatSeconds(totalElapsed)} / Projected finish ${TimeUtils1.formatSeconds(pred)}\n';

        tempSplit =
        tempSplit == '15' ? '25' : tempSplit == '25' ? '35' : '15';
      } else {
        final pred = SplitsCore1.predictorStandard(
          elapsedSeconds: totalElapsed,
          splitCount: i + 1,
          gender: gender,
          stroke: stroke,
          distance: distance,
          course: course.toLowerCase(),
          splitSize: int.tryParse(splitSize) ?? 50,
          pushStart: startType == 'From Push',
        );

        logPredictor +=
        'Lap ${i + 1}: ${TimeUtils1.formatSeconds(lapElapsed)} / ${TimeUtils1.formatSeconds(totalElapsed)} / Projected Finish: ${TimeUtils1.formatSeconds(pred)}\n';
      }
    }
  }

  /// ----------------- Logs -----------------
  void _appendPredictorSplit(String line) {
    logPredictor = '$line\n$logPredictor';
  }

  /// ----------------- Internal Helpers -----------------
  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (current.running) notifyListeners();
    });
  }

  // String _processPredictorLap(TimerState t, double lapElapsed, int lapNo) {
  //   double totalElapsed = t.splits.last;
  //   if (progressiveActive && course.toLowerCase() == 'lcm' && distance == '50' &&
  //       (splitSize == '15' || splitSize == '25' || splitSize == '35')) {
  //     final pred = SplitsCore1.predictorLCM50(
  //         elapsedSeconds: totalElapsed, gender: gender, marker: splitSize, pushStart: startType == 'From Push');
  //     String text =
  //         '$splitSize: ${TimeUtils1.formatSeconds(totalElapsed)} / Projected finish ${TimeUtils1.formatSeconds(pred)}';
  //
  //     // Rotate progressive marker
  //     splitSize = splitSize == '15' ? '25' : splitSize == '25' ? '35' : '15';
  //     return text;
  //   } else {
  //     final pred = SplitsCore1.predictorStandard(
  //         elapsedSeconds: totalElapsed,
  //         splitCount: t.splits.length,
  //         gender: gender,
  //         stroke: stroke,
  //         distance: distance,
  //         course: course.toLowerCase(),
  //         splitSize: int.tryParse(splitSize) ?? 50,
  //         pushStart: startType == 'From Push');
  //     return 'Lap $lapNo: ${TimeUtils1.formatSeconds(lapElapsed)} / ${TimeUtils1.formatSeconds(totalElapsed)} / Projected Finish: ${TimeUtils1.formatSeconds(pred)}';
  //   }
  // }

  double _simpleConversionFactor(String from, String to) {
    if (from == to) return 1.0;
    Map<String, double> conversion = {
      'SCY_SCM': 1.11,
      'SCY_LCM': 1.12,
      'SCM_SCY': 0.90,
      'LCM_SCY': 0.89,
      'SCM_LCM': 1.01,
      'LCM_SCM': 0.99,
    };
    return conversion['${from}_$to'] ?? 1.0;
  }

  void _appendLog(String line) {
    if (activeMode == 'Stopwatch') logStopwatch = '$line\n$logStopwatch';
    else if (activeMode == 'Converter') logConverter = '$line\n$logConverter';
  }

  // void _appendPredictorSplit(String line) {
  //   logPredictor += '$line\n';
  // }

  void _appendConverterSplit(String line) {
    logConverter += '$line\n';
  }
  void _appendStopWatchSplit(String line) {
    logStopwatch += '$line\n';
  }

  void _replaceLog(String text) {
    if (activeMode == 'Stopwatch') logStopwatch = text;
    else if (activeMode == 'Predictor') logPredictor = text;
    else logConverter = text;
  }

  void _popLatestSplitLogLine() {
    if (activeMode == 'Predictor') {
      final lines = logPredictor.split('\n');
      int idx = lines.indexOf('Split Breakdown:');
      if (idx != -1 && idx + 2 < lines.length) lines.removeAt(idx + 2);
      logPredictor = lines.join('\n');
      return;
    }

    String currentLog = activeMode == 'Stopwatch' ? logStopwatch : logConverter;
    final lines = currentLog.split('\n');
    for (int i = lines.length - 1; i >= 0; i--) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      lines.removeAt(i);
      break;
    }
    _replaceLog(lines.join('\n'));
  }

  String _predictorHeader() {
    return "==============\nPredictor Log\n==============\nSplit Breakdown:\n";
  }

  /// ----------------- Param Setters -----------------
  void setMode(String m) {
    activeMode = m;
    notifyListeners();
  }

  void setPredictorParams(
      {String? g,
        String? s,
        String? d,
        String? c,
        String? split,
        String? start}) {
    if (g != null) gender = g;
    if (s != null) stroke = s;
    if (d != null) distance = d;
    if (c != null) course = c.toLowerCase();
    if (split != null) splitSize = split;
    if (start != null) startType = start;
    notifyListeners();
  }

  void setConverterCourses({String? from, String? to}) {
    if (from != null) fromCourse = from;
    if (to != null) toCourse = to;
    notifyListeners();
  }

  void toggleProgressive(bool v) {
    progressiveActive = v;
    notifyListeners();
  }
}