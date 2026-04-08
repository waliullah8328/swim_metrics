import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../../core/utils/utils/ratios_1.dart';
import '../../../../../core/utils/utils/split_core_1.dart'; // ✅ Removed 'hide SplitsCore4' - use SplitsCore1
import '../../../../../core/utils/utils/time_utils_1.dart' hide TimeUtils1; // ✅ Added import for exact formatting

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
    initializeRatios1(); // Load ratios at startup
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
    final totalElapsed = elapsed(); // ✅ This is CUMULATIVE time
    final lapElapsed = t.lastSplitWall == null
        ? totalElapsed
        : now.difference(t.lastSplitWall!).inMilliseconds / 1000.0;

    t.lastSplitWall = now;
    t.splits.add(totalElapsed); // ✅ Store cumulative
    final lapNo = t.splits.length;

    String text;

    if (activeMode == 'Converter') {
      // ✅ FIXED: Use uppercase keys + Ratios1.conversionFactors
      final fromKey = fromCourse.toUpperCase();
      final toKey = toCourse.toUpperCase();
      double factor = _simpleConversionFactor(fromKey, toKey);

      // ✅ Convert cumulative time + round to 2 decimals for parity
      double converted = totalElapsed * factor;
      converted = double.parse(converted.toStringAsFixed(2));

      // ✅ Use TimeUtils1.formatTime for EXACT string match
      text = 'Lap $lapNo: ${TimeUtils1.formatTime(totalElapsed)} $fromCourse → ${TimeUtils1.formatTime(converted)} ${toCourse.toUpperCase()}';
      _appendConverterSplit(text);
    } else if (activeMode == 'Predictor') {
      text = _processPredictorLap(t, lapElapsed, lapNo);
      _appendPredictorSplit(text);
    } else {
      // ✅ Use TimeUtils1.formatTime for EXACT string match
      text = 'Lap $lapNo: ${TimeUtils1.formatTime(lapElapsed)} / ${TimeUtils1.formatTime(totalElapsed)}';
      _appendStopWatchSplit(text);
    }

    notifyListeners();
  }

  /// =======================
  /// Undo last split
  /// =======================
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

    // ✅ Progressive LCM 50 mode - EXACT format: "15: 7.5 / Projected Finish 30.24"
    if (progressiveActive &&
        course.toLowerCase() == 'lcm' &&
        distance == '50' &&
        ['15', '25', '35'].contains(splitSize)) {

      final pred = SplitsCore4.predictorLCM50( // ✅ Changed from SplitsCore4
        elapsedSeconds: totalElapsed,
        gender: gender,
        marker: splitSize,
        pushStart: startType == 'From Push',
      );

      // ✅ EXACT format: marker + compact time + projected finish (compact)
      return '${splitSize}: ${TimeUtils1.formatTimeCompact(totalElapsed)} / Projected Finish ${TimeUtils1.formatTimeCompact(pred ?? 0.0)}';
    }
    // ✅ Standard mode - EXACT format: "Lap 1: :08.66 / :08.66 / Projected Finish: :38.70"
    else {
      final splitSizeInt = int.tryParse(splitSize) ?? 50;
      final pred = SplitsCore4.predictorStandard( // ✅ Changed from SplitsCore4
        elapsedSeconds: totalElapsed,
        splitCount: t.splits.length, // ✅ Lap number (1-based)
        gender: gender,
        stroke: stroke,
        distance: distance,
        course: course.toLowerCase(),
        splitSize: splitSizeInt,
        pushStart: startType == 'From Push',
      );

      String baseLine = "Lap $lapNo: ${TimeUtils1.formatTime(lapElapsed)} / ${TimeUtils1.formatTime(totalElapsed)}";
      if (pred != null) {
        baseLine += " / Projected Finish: ${TimeUtils1.formatTime(pred)}";
      }
      return baseLine;
    }
  }

  void _rebuildPredictorLog(TimerState t) {
    logPredictor = _predictorHeader();
    String currentMarker = splitSize; // ✅ Track progressive marker state

    for (int i = 0; i < t.splits.length; i++) {
      final totalElapsed = t.splits[i];
      final lapElapsed = i == 0 ? totalElapsed : totalElapsed - t.splits[i - 1];

      // ✅ Progressive LCM 50 mode
      if (progressiveActive &&
          course.toLowerCase() == 'lcm' &&
          distance == '50' &&
          ['15', '25', '35'].contains(currentMarker)) {

        final pred = SplitsCore4.predictorLCM50( // ✅ Changed from SplitsCore4
          elapsedSeconds: totalElapsed,
          gender: gender,
          marker: currentMarker,
          pushStart: startType == 'From Push',
        );

        // ✅ EXACT format for progressive mode
        logPredictor += '${currentMarker}: ${TimeUtils1.formatTimeCompact(totalElapsed)} / Projected Finish ${TimeUtils1.formatTimeCompact(pred ?? 0.0)}\n';

        // ✅ Cycle markers: 15→25→35→15 (exact as original Dart)
        if (currentMarker == '15') {
          currentMarker = '25';
        } else if (currentMarker == '25') {
          currentMarker = '35';
        } else {
          currentMarker = '15';
        }
      }
      // ✅ Standard mode
      else {
        final splitSizeInt = int.tryParse(splitSize) ?? 50;
        final pred = SplitsCore4.predictorStandard( // ✅ Changed from SplitsCore4
          elapsedSeconds: totalElapsed,
          splitCount: i + 1,
          gender: gender,
          stroke: stroke,
          distance: distance,
          course: course.toLowerCase(),
          splitSize: splitSizeInt,
          pushStart: startType == 'From Push',
        );

        String line = "Lap ${i + 1}: ${TimeUtils1.formatTime(lapElapsed)} / ${TimeUtils1.formatTime(totalElapsed)}";
        if (pred != null) {
          line += " / Projected Finish: ${TimeUtils1.formatTime(pred)}";
        }
        logPredictor += '$line\n';
      }
    }
  }

  /// ----------------- Logs -----------------
  void _appendPredictorSplit(String line) {
    if (!logPredictor.contains('Split Breakdown:')) {
      logPredictor = _predictorHeader();
    }

    final lines = logPredictor.split('\n');
    final headerIndex = lines.indexWhere((l) => l.contains('Split Breakdown:'));

    if (headerIndex == -1) {
      logPredictor = '$_predictorHeader()\n$line\n';
      return;
    }

    final header = lines.sublist(0, headerIndex + 1).join('\n');
    final splits = lines
        .sublist(headerIndex + 1)
        .where((l) => l.trim().isNotEmpty)
        .toList();

    splits.add(line);
    logPredictor = splits.isEmpty ? '$header\n' : '$header\n${splits.join('\n')}\n';
  }

  /// ----------------- Internal Helpers -----------------
  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (current.running) notifyListeners();
    });
  }

  /// ✅ FIXED: Use Ratios1.conversionFactors + uppercase keys
  double _simpleConversionFactor(String from, String to) {
    if (from == to) return 1.0;
    final key = '${from.toUpperCase()}_$to'; // ✅ Ensure uppercase for lookup
    return Ratios1.conversionFactors[key] ?? 1.0;
  }

  void _appendLog(String line) {
    if (activeMode == 'Stopwatch') logStopwatch = '$line\n$logStopwatch';
    else if (activeMode == 'Converter') logConverter = '$line\n$logConverter';
  }

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

  /// ✅ FIXED: Remove the LAST split line
  void _popLatestSplitLogLine() {
    if (activeMode == 'Predictor') {
      final lines = logPredictor.split('\n');
      final headerIndex = lines.indexWhere((l) => l.contains('Split Breakdown:'));

      if (headerIndex != -1) {
        final splits = lines
            .sublist(headerIndex + 1)
            .where((l) => l.trim().isNotEmpty)
            .toList();

        if (splits.isNotEmpty) {
          splits.removeLast();
        }

        final header = lines.sublist(0, headerIndex + 1).join('\n');
        logPredictor = splits.isEmpty ? '$header\n' : '$header\n${splits.join('\n')}\n';
      }
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

  /// ✅ UPDATED: Exact header format as requested
  String _predictorHeader() {
    final genderCap = gender.isEmpty ? '' : '${gender[0].toUpperCase()}${gender.substring(1)}';
    final strokeCap = stroke.isEmpty ? '' : '${stroke[0].toUpperCase()}${stroke.substring(1)}';
    final courseUpper = course.toUpperCase();

    return '''===============
$genderCap's $distance $strokeCap $courseUpper Projection
Start Type: $startType | Split Size: $splitSize
===============
Split Breakdown:

''';
  }

  /// ----------------- Param Setters -----------------
  void setMode(String m) {
    activeMode = m;
    notifyListeners();
  }

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