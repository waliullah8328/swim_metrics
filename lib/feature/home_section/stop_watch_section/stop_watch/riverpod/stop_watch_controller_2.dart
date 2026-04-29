import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../../core/utils/utils/ratios_1.dart';
import '../../../../../core/utils/utils/time_utils_1.dart' hide TimeUtils1;
import '../../../../on_boarding/presentation/screens/widget/course_page_widget.dart';





final stopwatchProvider2 =
ChangeNotifierProvider<StopwatchController2>((ref) => StopwatchController2());

class TimerState {
  bool running = false;
  DateTime? startTime;
  double accumulated = 0.0;

  /// ❌ No longer used for lap calculation
  DateTime? lastSplitWall;

  final List<double> splits = [];
}

// stop_watch_controller_2.dart
// ── Only the changed parts shown ─────────────────────────────

class StopwatchController2 extends ChangeNotifier {
  final Map<String, TimerState> _timers = {
    'Stopwatch': TimerState(),
    'Predictor': TimerState(),
    'Converter': TimerState(),
  };
  StopwatchController2() {
    initFromCourseOrder();
  }

  Timer? _ticker;

  String activeMode = 'Stopwatch';

  String logStopwatch = '';
  String logPredictor = '';
  String logConverter = '';

  String gender    = 'men';
  String stroke    = 'free';
  String distance  = '100';
  String course    = 'SCM';
  String splitSize = '50';
  String startType = 'From Start';

  bool   progressiveActive     = false;
  String _marker               = '15';
  String fromCourse            = 'SCM';
  String toCourse              = 'SCM';
  String lastPredictorConfig   = '';


  Future<void> initFromCourseOrder() async {
    final savedOrder = await CourseOrderStorage.loadCourseOrder();
    final middleItem = savedOrder[savedOrder.length ~/ 2];
    fromCourse = middleItem; // ✅ direct field assignment
    toCourse  = middleItem; // ✅ direct field assignment
    course  = middleItem; // ✅ direct field assignment
    notifyListeners();       // ✅ notify UI to rebuild
  }

  // ✅ NEW: stores all completed predictor sessions separately
  // Each session = { 'header': String, 'laps': List<String> }
  final List<Map<String, dynamic>> _predictorSessions = [];

  // ✅ NEW: current active session laps
  List<String> _currentSessionLaps = [];
  String       _currentSessionHeader = '';



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
    if (g != null) gender = g.toLowerCase();
    if (s != null) stroke = s.toLowerCase();
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
  void split(BuildContext context) {
    final t = current;
    if (!t.running) return;

    const int maxLogs = 100;

    if (t.splits.length >= maxLogs) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have reached the maximum of 100 laps')),
      );
      return;
    }

    final total        = elapsed();
    final previousTotal = t.splits.isEmpty ? 0.0 : t.splits.last;
    final lap          = total - previousTotal;

    t.splits.add(total);
    final lapNo = t.splits.length;

    // ================= STOPWATCH =================
    if (activeMode == 'Stopwatch') {
      final lines = logStopwatch.isEmpty ? <String>[] : logStopwatch.trim().split('\n');
      lines.insert(0, "Lap $lapNo: ${TimeUtils1.formatTime(lap)} / ${TimeUtils1.formatTime(total)}");
      logStopwatch = lines.join('\n');
    }

    // ================= CONVERTER =================
    else if (activeMode == 'Converter') {
      final factor    = _factor(fromCourse, toCourse);
      final converted = total * factor;
      final lines     = logConverter.isEmpty ? <String>[] : logConverter.trim().split('\n');
      lines.insert(0, "Lap $lapNo: ${TimeUtils1.formatTime(total)} ${fromCourse.toUpperCase()} → ${TimeUtils1.formatTime(converted)} ${toCourse.toUpperCase()}");
      logConverter = lines.join('\n');
    }

    // ================= PREDICTOR =================
    else {
      final formattedStroke = stroke.toLowerCase() == "im"
          ? "IM"
          : "${stroke[0].toUpperCase()}${stroke.substring(1).toLowerCase()}";

      final currentConfig =
          "$gender|$stroke|$distance|$course|$splitSize|$startType|$progressiveActive";

      // ✅ Config changed OR first lap ever → start a NEW session
      if (lastPredictorConfig != currentConfig) {
        // ✅ Save current active session to history (if it has laps)
        if (_currentSessionLaps.isNotEmpty) {
          _predictorSessions.add({
            'header': _currentSessionHeader,
            'laps':   List<String>.from(_currentSessionLaps),
          });
        }

        // ✅ Reset current session for new config
        lastPredictorConfig    = currentConfig;
        _currentSessionLaps    = [];
        _currentSessionHeader  =
        "${gender[0].toUpperCase()}${gender.substring(1)}'s "
            "$distance $formattedStroke ${course.toUpperCase()} Projection\n"
            "Start Type: $startType | Split Size: $splitSize\n"
            "===============";
        _marker = '15';

        // ✅ Also reset splits so lap numbers restart from 1
        t.splits.clear();
        t.splits.add(total); // re-add current split as lap 1
        final newLap = total; // first lap of new session = total elapsed
        final projected = _predict(1) ?? 0.0;
        final isProgressive = _shouldEnableProgressive() && progressiveActive;
        final label = isProgressive ? _marker : "Lap 1";
        final newEntry = isProgressive
            ? "$label ${TimeUtils1.formatTime(newLap)} / Projected Finish ${TimeUtils1.formatTime(projected)}"
            : "$label ${TimeUtils1.formatTime(newLap)} / ${TimeUtils1.formatTime(total)} / Projected Finish ${TimeUtils1.formatTime(projected)}";
        _currentSessionLaps.insert(0, newEntry);
        if (isProgressive) _marker = _nextMarker(_marker);

        _rebuildPredictorLog();
        notifyListeners();
        return;
      }

      // ✅ Same config → append lap to current session
      final projected     = _predict(lapNo) ?? 0.0;
      final isProgressive = _shouldEnableProgressive() && progressiveActive;
      final label         = isProgressive ? _marker : "Lap $lapNo";
      final newEntry      = isProgressive
          ? "$label ${TimeUtils1.formatTime(lap)} / Projected Finish ${TimeUtils1.formatTime(projected)}"
          : "$label ${TimeUtils1.formatTime(lap)} / ${TimeUtils1.formatTime(total)} / Projected Finish ${TimeUtils1.formatTime(projected)}";

      // ✅ Insert at top of current session (newest first)
      _currentSessionLaps.insert(0, newEntry);
      if (isProgressive) _marker = _nextMarker(_marker);

      _rebuildPredictorLog();
    }

    notifyListeners();
  }

  // ✅ NEW: Rebuild logPredictor from sessions + current session
  void _rebuildPredictorLog() {
    final buffer = StringBuffer();

    // ── Current active session at TOP ──────────────────────
    if (_currentSessionHeader.isNotEmpty) {
      buffer.writeln(_currentSessionHeader);
      buffer.writeln("Split Breakdown:");
      for (final lap in _currentSessionLaps) {
        buffer.writeln(lap);
      }
    }

    // ── Past sessions below, separated by blank line ───────
    for (final session in _predictorSessions.reversed) {
      buffer.writeln(); // blank line separator
      buffer.writeln(session['header'] as String);
      buffer.writeln("Split Breakdown:");
      final laps = session['laps'] as List<String>;
      for (final lap in laps) {
        buffer.writeln(lap);
      }
    }

    logPredictor = buffer.toString().trimRight();
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

    // ✅ Clear predictor sessions too
    _predictorSessions.clear();
    _currentSessionLaps   = [];
    _currentSessionHeader = '';
    lastPredictorConfig   = '';
    _marker = '15';

    _ticker?.cancel();
    notifyListeners();
  }

  // ================= UNDO =================
  void undoLastSplit() {
    final t = current;
    if (t.splits.isEmpty) return;

    t.splits.removeLast();

    if (activeMode == 'Stopwatch') {
      logStopwatch = _removeFirst(logStopwatch);

    } else if (activeMode == 'Predictor') {
      // ✅ Remove from current session laps
      if (_currentSessionLaps.isNotEmpty) {
        _currentSessionLaps.removeAt(0); // newest is at index 0
      }

      if (_shouldEnableProgressive() && progressiveActive) {
        _marker = _getMarkerFromCount(t.splits.length);
      }

      // ✅ If current session is now empty, restore previous session
      if (_currentSessionLaps.isEmpty && _predictorSessions.isNotEmpty) {
        final prev         = _predictorSessions.removeLast();
        _currentSessionHeader = prev['header'] as String;
        _currentSessionLaps   = prev['laps']   as List<String>;

        // Restore config from header so future splits match
        lastPredictorConfig = '';  // force re-detect on next split
      }

      _rebuildPredictorLog();

    } else {
      logConverter = _removeFirst(logConverter);
    }

    notifyListeners();
  }

  // ================= CLEAR LOG =================
  void clearLog() {
    if (activeMode == 'Stopwatch') {
      logStopwatch = '';
    }
    if (activeMode == 'Predictor') {
      logPredictor          = '';
      _predictorSessions.clear();
      _currentSessionLaps   = [];
      _currentSessionHeader = '';
      lastPredictorConfig   = '';
      _marker               = '15';
      // ✅ Also clear splits so next start is fresh
      _timers['Predictor']!.splits.clear();
    }
    if (activeMode == 'Converter') {
      logConverter = '';
    }
    notifyListeners();
  }

  // ================= CLEAR TIME =================
  void clearTime() {
    final t = current;

    t.running = false;
    t.startTime = null;
    t.accumulated = 0;
    t.lastSplitWall = null;

    _ticker?.cancel();
    _ticker = null;

    notifyListeners();
  }

  // ================= HELPERS =================
  String _getMarkerFromCount(int count) {
    const markers = ['15', '25', '35'];
    return markers[count % 3];
  }

  String _removeFirst(String log) {
    if (log.isEmpty) return "";
    final lines = log.trim().split("\n");
    lines.removeAt(0);
    return lines.join("\n");
  }

  String _removeFirstPredictorLap(String log) {
    final lines = log.split("\n");
    final index = lines.indexOf("Split Breakdown:");
    if (index == -1) return log;

    int i = index + 1;
    while (i < lines.length && lines[i].trim().isEmpty) i++;
    if (i < lines.length) lines.removeAt(i);

    return lines.join("\n");
  }

  double? _predict(int lapNo) {
    final total = elapsed();
    if (total <= 0) return null;

    final g     = gender.toLowerCase().trim();
    final s     = stroke.toLowerCase().trim();
    final c     = course.toLowerCase().trim();
    final split = int.tryParse(splitSize) ?? 50;

    if (_shouldEnableProgressive() && progressiveActive) {
      return SplitsCore4.predictorLCM50(
        elapsedSeconds: total,
        gender:         g,
        marker:         _marker,
        pushStart:      startType.toLowerCase() == 'from push',
      );
    }

    return SplitsCore4.predictorStandard(
      elapsedSeconds: total,
      splitCount:     lapNo,
      gender:         g,
      stroke:         s,
      distance:       distance,
      course:         c,
      splitSize:      split,
      pushStart:      startType.toLowerCase() == 'from push',
    );
  }

  bool _shouldEnableProgressive() {
    return course == 'lcm' &&
        distance == '50' &&
        ['15', '25', '35'].contains(splitSize);
  }

  double _factor(String from, String to) {
    if (from == to) return 1.0;
    return Ratios1.conversionFactors['${from}_$to'] ?? 1.0;
  }

  String _nextMarker(String current) {
    switch (current) {
      case '15': return '25';
      case '25': return '35';
      default:   return '15';
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(
      const Duration(milliseconds: 100),
          (_) { if (current.running) notifyListeners(); },
    );
  }
}
// class StopwatchController2 extends ChangeNotifier {
//   final Map<String, TimerState> _timers = {
//     'Stopwatch': TimerState(),
//     'Predictor': TimerState(),
//     'Converter': TimerState(),
//   };
//
//   Timer? _ticker;
//
//   String activeMode = 'Stopwatch';
//
//   String logStopwatch = '';
//   String logPredictor = '';
//   String logConverter = '';
//
//   String gender = 'men';
//   String stroke = 'free';
//   String distance = '100';
//   String course = 'SCM';
//   String splitSize = '50';
//   String startType = 'From Start';
//
//   bool progressiveActive = false;
//   String _marker = '15';
//
//   String fromCourse = 'SCM';
//   String toCourse = 'SCM';
//
//   String lastPredictorConfig = '';
//
//   StopwatchController2() {
//     initializeRatios1();
//   }
//
//   TimerState get current => _timers[activeMode]!;
//
//   // ================= MODE =================
//   void setMode(String m) {
//     activeMode = m;
//     notifyListeners();
//   }
//
//   // ================= PARAMS =================
//   void setPredictorParams({
//     String? g,
//     String? s,
//     String? d,
//     String? c,
//     String? split,
//     String? start,
//   }) {
//     if (g != null) gender = g.toLowerCase();
//     if (s != null) stroke = s.toLowerCase();
//     if (d != null) distance = d;
//     if (c != null) course = c.toLowerCase();
//     if (split != null) splitSize = split;
//     if (start != null) startType = start;
//
//     progressiveActive = _shouldEnableProgressive();
//     _marker = '15';
//
//     notifyListeners();
//   }
//
//   void setConverterCourses({String? from, String? to}) {
//     if (from != null) fromCourse = from;
//     if (to != null) toCourse = to;
//     notifyListeners();
//   }
//
//   void toggleProgressive(bool v) {
//     progressiveActive = v;
//     _marker = '15';
//     notifyListeners();
//   }
//
//   // ================= START =================
//   void start() {
//     final t = current;
//     if (t.running) return;
//
//     final now = DateTime.now();
//
//     t.startTime ??= now;
//     t.running = true;
//
//     _marker = '15';
//
//     _startTicker();
//     notifyListeners();
//   }
//
//   // ================= STOP =================
//   void pause() {
//     final t = current;
//     if (!t.running) return;
//
//     t.accumulated = elapsed();
//     t.running = false;
//     t.startTime = null;
//
//     _ticker?.cancel();
//     notifyListeners();
//   }
//
//   void stop() => pause();
//
//   // ================= ELAPSED =================
//   double elapsed() {
//     final t = current;
//     if (t.running && t.startTime != null) {
//       return t.accumulated +
//           DateTime.now().difference(t.startTime!).inMilliseconds / 1000;
//     }
//     return t.accumulated;
//   }
//
//   // ================= SPLIT =================
//   void split(BuildContext context) {
//     final t = current;
//     if (!t.running) return;
//
//     const int maxLogs = 100;
//
//     if (t.splits.length >= maxLogs) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('You have reached the maximum of 100 laps'),
//         ),
//       );
//       return;
//     }
//
//     final total = elapsed();
//
//     /// ✅ FIXED: Pure calculation (UNDO SAFE)
//     final previousTotal =
//     t.splits.isEmpty ? 0.0 : t.splits.last;
//
//     final lap = total - previousTotal;
//
//     t.splits.add(total);
//     final lapNo = t.splits.length;
//
//     // ================= STOPWATCH =================
//     if (activeMode == 'Stopwatch') {
//       final lines = logStopwatch.isEmpty
//           ? <String>[]
//           : logStopwatch.trim().split('\n');
//
//       lines.insert(
//         0,
//         "Lap $lapNo: ${TimeUtils1.formatTime(lap)} / ${TimeUtils1.formatTime(total)}",
//       );
//
//       logStopwatch = lines.join('\n');
//     }
//
//
//
//     // ================= CONVERTER =================
//     else if (activeMode == 'Converter') {
//       final factor = _factor(fromCourse, toCourse);
//       final converted = total * factor;
//
//       final lines = logConverter.isEmpty
//           ? <String>[]
//           : logConverter.trim().split('\n');
//
//       lines.insert(
//         0,
//         "Lap $lapNo: ${TimeUtils1.formatTime(total)} ${fromCourse.toUpperCase()} → ${TimeUtils1.formatTime(converted)} ${toCourse.toUpperCase()}",
//       );
//
//       logConverter = lines.join('\n');
//     }
//
//     // ================= PREDICTOR =================
//     else {
//       final formattedStroke = stroke.toLowerCase() == "im"
//           ? "IM"
//           : "${stroke[0].toUpperCase()}${stroke.substring(1).toLowerCase()}";
//
//       final currentConfig =
//           "$gender|$stroke|$distance|$course|$splitSize|$startType|$progressiveActive";
//
//       if (lastPredictorConfig != currentConfig ||
//           logPredictor.trim().isEmpty) {
//         lastPredictorConfig = currentConfig;
//
//         logPredictor =
//         "${gender[0].toUpperCase()}${gender.substring(1)}'s $distance $formattedStroke ${course.toUpperCase()} Projection\n"
//             "Start Type: $startType | Split Size: $splitSize\n"
//             "===============\n"
//             "Split Breakdown:";
//
//         _marker = '15';
//       }
//
//       final projected = _predict(lapNo) ?? 0.0;
//       final isProgressive =
//           _shouldEnableProgressive() && progressiveActive;
//
//       final label = isProgressive ? _marker : "Lap $lapNo";
//
//       final newEntry = isProgressive
//           ? "$label ${TimeUtils1.formatTime(lap)} / Projected Finish ${TimeUtils1.formatTime(projected)}"
//           : "$label ${TimeUtils1.formatTime(lap)} / ${TimeUtils1.formatTime(total)} / Projected Finish ${TimeUtils1.formatTime(projected)}";
//
//       final parts = logPredictor.split("Split Breakdown:");
//       final header = parts[0];
//       final body = parts.length > 1 ? parts[1].trim() : "";
//
//       logPredictor = body.isEmpty
//           ? "${header}Split Breakdown:\n$newEntry"
//           : "${header}Split Breakdown:\n$newEntry\n$body";
//
//       if (isProgressive) {
//         _marker = _nextMarker(_marker);
//       }
//     }
//
//     notifyListeners();
//   }
//   void reset() {
//     final t = current;
//
//     t.running = false;
//     t.startTime = null;
//     t.accumulated = 0;
//     t.lastSplitWall = null;
//     t.splits.clear();
//
//     logStopwatch = '';
//     logPredictor = '';
//     logConverter = '';
//
//     _marker = '15';
//
//     _ticker?.cancel();
//     notifyListeners();
//   }
//
//   // ================= UNDO =================
//   void undoLastSplit() {
//     final t = current;
//     if (t.splits.isEmpty) return;
//
//     t.splits.removeLast();
//
//     if (activeMode == 'Stopwatch') {
//       logStopwatch = _removeFirst(logStopwatch);
//     } else if (activeMode == 'Predictor') {
//       logPredictor = _removeFirstPredictorLap(logPredictor);
//
//       if (_shouldEnableProgressive() && progressiveActive) {
//         _marker = _getMarkerFromCount(t.splits.length);
//       }
//     } else {
//       logConverter = _removeFirst(logConverter);
//     }
//
//     notifyListeners();
//   }
//
//   // ================= HELPERS =================
//   String _getMarkerFromCount(int count) {
//     const markers = ['15', '25', '35'];
//     return markers[count % 3];
//   }
//
//   String _removeFirst(String log) {
//     if (log.isEmpty) return "";
//     final lines = log.trim().split("\n");
//     lines.removeAt(0);
//     return lines.join("\n");
//   }
//
//     /// only clear time
//   void clearTime() {
//     final t = current;
//
//     t.running = false;
//     t.startTime = null;
//     t.accumulated = 0;
//     t.lastSplitWall = null;
//
//     /// keep splits if needed
//     /// or use t.splits.clear();
//
//     _ticker?.cancel();
//     _ticker = null;
//
//     notifyListeners();
//   }
//
//   void clearLog() {
//     if (activeMode == 'Stopwatch') logStopwatch = '';
//     if (activeMode == 'Predictor') logPredictor = '';
//     if (activeMode == 'Converter') logConverter = '';
//     notifyListeners();
//   }
//
//   String _removeFirstPredictorLap(String log) {
//     final lines = log.split("\n");
//     final index = lines.indexOf("Split Breakdown:");
//     if (index == -1) return log;
//
//     int i = index + 1;
//     while (i < lines.length && lines[i].trim().isEmpty) {
//       i++;
//     }
//
//     if (i < lines.length) {
//       lines.removeAt(i);
//     }
//
//     return lines.join("\n");
//   }
//
//   double? _predict(int lapNo) {
//     final total = elapsed();
//
//     if (total <= 0) return null;
//
//     /// normalize values
//     final g = gender.toLowerCase().trim();
//     final s = stroke.toLowerCase().trim();
//     final c = course.toLowerCase().trim();
//
//     final split = int.tryParse(splitSize) ?? 50;
//
//     /// Progressive mode
//     if (_shouldEnableProgressive() && progressiveActive) {
//       return SplitsCore4.predictorLCM50(
//         elapsedSeconds: total,
//         gender: g,
//         marker: _marker,
//         pushStart: startType.toLowerCase() == 'from push',
//       );
//     }
//
//     /// Standard mode
//     return SplitsCore4.predictorStandard(
//       elapsedSeconds: total,
//       splitCount: lapNo,
//       gender: g,
//       stroke: s,
//       distance: distance,
//       course: c,
//       splitSize: split,
//       pushStart: startType.toLowerCase() == 'from push',
//     );
//   }
//
//   bool _shouldEnableProgressive() {
//     return course == 'lcm' &&
//         distance == '50' &&
//         ['15', '25', '35'].contains(splitSize);
//   }
//
//   double _factor(String from, String to) {
//     if (from == to) return 1.0;
//     return Ratios1.conversionFactors['${from}_$to'] ?? 1.0;
//   }
//
//   String _nextMarker(String current) {
//     switch (current) {
//       case '15':
//         return '25';
//       case '25':
//         return '35';
//       default:
//         return '15';
//     }
//   }
//
//   void _startTicker() {
//     _ticker?.cancel();
//     _ticker = Timer.periodic(
//       const Duration(milliseconds: 100),
//           (_) {
//         if (current.running) notifyListeners();
//       },
//     );
//   }
// }

