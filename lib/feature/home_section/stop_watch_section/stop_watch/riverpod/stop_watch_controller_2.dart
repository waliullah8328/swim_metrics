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
  String activeMode = 'Stopwatch';
  String logStopwatch = '';
  String logPredictor = '';
  String logConverter = '';

  String gender = 'men';
  String stroke = 'free';
  String distance = '100';
  String course = 'scy';
  String splitSize = '50';
  String startType = 'From Start';
  bool progressiveActive = false;
  String fromCourse = 'SCY';
  String toCourse = 'LCM';

  StopwatchController2() {
    initializeRatios1();
  }

  TimerState get current => _timers[activeMode]!;

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (current.running) notifyListeners();
    });
  }

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

  bool isRunning() => current.running;

  void start() {
    final t = current;
    if (t.running) return;
    final now = DateTime.now();
    if (activeMode == 'Predictor') {
      final header = _predictorHeader();
      logPredictor = logPredictor.isEmpty ? header : '$header\n$logPredictor';
    } else {
      if (t.startTime == null && t.accumulated == 0.0 && t.splits.isEmpty) {
        t.accumulated = 0.0;
        t.splits.clear();
        _appendLog('Start');
      } else {
        _appendLog('Resume');
      }
    }
    t.startTime = now;
    t.running = true;
    t.lastSplitWall = now;
    notifyListeners();
    _startTicker();
  }

  void pause() {
    final t = current;
    if (!t.running) return;
    final now = DateTime.now();
    t.accumulated += now.difference(t.startTime!).inMilliseconds / 1000.0;
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
    final now = DateTime.now();
    t.accumulated += now.difference(t.startTime!).inMilliseconds / 1000.0;
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
      final now = DateTime.now();
      return t.accumulated +
          now.difference(t.startTime!).inMilliseconds / 1000.0;
    }
    return t.accumulated;
  }

  void split() {
    final t = current;
    if (!t.running) return;
    final now = DateTime.now();
    final totalElapsed = elapsed();
    final lapElapsed = t.lastSplitWall == null
        ? totalElapsed
        : now.difference(t.lastSplitWall!).inMilliseconds / 1000.0;
    t.lastSplitWall = now;
    t.splits.add(totalElapsed);
    final lapNo = t.splits.length;

    String text;
    if (activeMode == 'Converter') {
      final from = fromCourse.toUpperCase();
      final to = toCourse.toUpperCase();
      final factor = _simpleConversionFactor(from, to);
      final converted = totalElapsed * factor;
      text =
      'Lap $lapNo: ${TimeUtils1.formatSeconds(totalElapsed)} $from → ${TimeUtils1.formatSeconds(converted)} $to';
    } else if (activeMode == 'Predictor') {
      if (progressiveActive &&
          course.toLowerCase() == 'lcm' &&
          distance == '50' &&
          (splitSize == '15' || splitSize == '25' || splitSize == '35')) {
        final push = startType == 'From Push';
        final pred = SplitsCore1.predictorLCM50(
            elapsedSeconds: totalElapsed, gender: gender, marker: splitSize, pushStart: push);
        text =
        '$splitSize: ${TimeUtils1.formatSeconds(totalElapsed)} / Projected finish ${TimeUtils1.formatSeconds(pred)}';
        splitSize = splitSize == '15'
            ? '25'
            : splitSize == '25'
            ? '35'
            : '15';
      } else {
        final push = startType == 'From Push';
        final sp = int.tryParse(splitSize) ?? 50;
        final pred = SplitsCore1.predictorStandard(
          elapsedSeconds: totalElapsed,
          splitCount: t.splits.length,
          gender: gender,
          stroke: stroke,
          distance: distance,
          course: course.toLowerCase(),
          splitSize: sp,
          pushStart: push,
        );
        text =
        'Lap $lapNo: ${TimeUtils1.formatSeconds(lapElapsed)} / ${TimeUtils1.formatSeconds(totalElapsed)} / Projected Finish: ${TimeUtils1.formatSeconds(pred)}';
      }
      _appendPredictorSplit(text);
      notifyListeners();
      return;
    } else {
      text =
      'Lap $lapNo: ${TimeUtils1.formatSeconds(lapElapsed)} / ${TimeUtils1.formatSeconds(totalElapsed)}';
    }

    _appendLog(text);
    notifyListeners();
  }

  void undoLastSplit() {
    final t = current;
    if (t.splits.isEmpty) return;
    t.splits.removeLast();
    if (activeMode == 'Predictor' &&
        progressiveActive &&
        course.toLowerCase() == 'lcm' &&
        distance == '50') {
      if (splitSize == '25') {
        splitSize = '15';
      } else if (splitSize == '35') {
        splitSize = '25';
      } else {
        splitSize = '35';
      }
    }
    double prevCum = t.splits.isNotEmpty ? t.splits.last : 0.0;
    if (t.running) {
      final now = DateTime.now();
      final currElapsed = elapsed();
      final delta = currElapsed - prevCum;
      t.lastSplitWall = now.subtract(Duration(milliseconds: (delta * 1000).round()));
    } else {
      t.lastSplitWall = null;
    }
    _popLatestSplitLogLine();
    notifyListeners();
  }

  void _popLatestSplitLogLine() {
    if (activeMode == 'Predictor') {
      final lines = logPredictor.split('\n');
      int idx = lines.indexOf('Split Breakdown:');
      if (idx != -1) {
        int insertPos = idx + 2;
        if (insertPos < lines.length) lines.removeAt(insertPos);
        logPredictor = lines.join('\n');
      }
      return;
    }
    String currentLog =
    activeMode == 'Stopwatch' ? logStopwatch : logConverter;
    final lines = currentLog.split('\n');
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty ||
          line.startsWith('Start') ||
          line.startsWith('Stop') ||
          line.startsWith('Pause') ||
          line.startsWith('Resume')) continue;
      lines.removeAt(i);
      break;
    }
    _replaceLog(lines.join('\n'));
  }

  void _appendLog(String line) {
    if (activeMode == 'Stopwatch') {
      logStopwatch = '$line\n$logStopwatch';
    } else if (activeMode == 'Predictor') {
      logPredictor = '$line\n$logPredictor';
    } else {
      logConverter = '$line\n$logConverter';
    }
  }

  void _replaceLog(String content) {
    if (activeMode == 'Stopwatch') {
      logStopwatch = content;
    } else if (activeMode == 'Predictor') {
      logPredictor = content;
    } else {
      logConverter = content;
    }
  }

  String _predictorHeader() {
    final g = gender.toLowerCase() == 'women' ? "Women's" : "Men's";
    final d = distance;
    final s = stroke.isEmpty ? '' : stroke[0].toUpperCase() + stroke.substring(1);
    final c = course.toUpperCase();
    final st = startType;
    final ss = splitSize;
    final lines = <String>[
      '===============',
      "$g $d $s $c Projection",
      'Start Type: $st | Split Size: $ss',
      '===============',
      'Split Breakdown:',
      ''
    ];
    return lines.join('\n');
  }

  void _appendPredictorSplit(String line) {
    if (logPredictor.isEmpty) {
      logPredictor = '${_predictorHeader()}\n$line';
      return;
    }
    final lines = logPredictor.split('\n');
    int idx = lines.indexOf('Split Breakdown:');
    if (idx != -1) {
      int insertPos = idx + 2;
      if (insertPos < 0) insertPos = lines.length;
      lines.insert(insertPos, line);
      logPredictor = lines.join('\n');
    } else {
      logPredictor = '$line\n$logPredictor';
    }
  }

  double _simpleConversionFactor(String from, String to) {
    if (from == to) return 1.0;
    const factors = {
      'SCY->SCM': 1.11,
      'SCY->LCM': 1.12,
      'SCM->SCY': 0.90,
      'LCM->SCY': 0.89,
      'SCM->LCM': 1.01,
      'LCM->SCM': 0.99,
    };
    final key = '$from->$to';
    return factors[key] ?? 1.0;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}