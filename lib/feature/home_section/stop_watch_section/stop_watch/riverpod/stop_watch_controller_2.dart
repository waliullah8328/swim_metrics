import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../../core/utils/utils/ratios_1.dart';
import '../../../../../core/utils/utils/time_utils_1.dart' hide TimeUtils1;





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
  String course = 'SCM';
  String splitSize = '50';
  String startType = 'From Start';

  bool progressiveActive = false;
  String _marker = '15';

  String fromCourse = 'SCM';
  String toCourse = 'SCM';

  String lastPredictorConfig = '';

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
        const SnackBar(
          content: Text('You have reached the maximum of 100 laps'),
        ),
      );
      return;
    }

    final total = elapsed();

    /// ✅ FIXED: Pure calculation (UNDO SAFE)
    final previousTotal =
    t.splits.isEmpty ? 0.0 : t.splits.last;

    final lap = total - previousTotal;

    t.splits.add(total);
    final lapNo = t.splits.length;

    // ================= STOPWATCH =================
    if (activeMode == 'Stopwatch') {
      final lines = logStopwatch.isEmpty
          ? <String>[]
          : logStopwatch.trim().split('\n');

      lines.insert(
        0,
        "Lap $lapNo: ${TimeUtils1.formatTime(lap)} / ${TimeUtils1.formatTime(total)}",
      );

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
        "Lap $lapNo: ${TimeUtils1.formatTime(total)} ${fromCourse.toUpperCase()} → ${TimeUtils1.formatTime(converted)} ${toCourse.toUpperCase()}",
      );

      logConverter = lines.join('\n');
    }

    // ================= PREDICTOR =================
    else {
      final formattedStroke = stroke.toLowerCase() == "im"
          ? "IM"
          : "${stroke[0].toUpperCase()}${stroke.substring(1).toLowerCase()}";

      final currentConfig =
          "$gender|$stroke|$distance|$course|$splitSize|$startType|$progressiveActive";

      if (lastPredictorConfig != currentConfig ||
          logPredictor.trim().isEmpty) {
        lastPredictorConfig = currentConfig;

        logPredictor =
        "${gender[0].toUpperCase()}${gender.substring(1)}'s $distance $formattedStroke ${course.toUpperCase()} Projection\n"
            "Start Type: $startType | Split Size: $splitSize\n"
            "===============\n"
            "Split Breakdown:";

        _marker = '15';
      }

      final projected = _predict(lapNo) ?? 0.0;
      final isProgressive =
          _shouldEnableProgressive() && progressiveActive;

      final label = isProgressive ? _marker : "Lap $lapNo";

      final newEntry = isProgressive
          ? "$label ${TimeUtils1.formatTime(lap)} / Projected Finish ${TimeUtils1.formatTime(projected)}"
          : "$label ${TimeUtils1.formatTime(lap)} / ${TimeUtils1.formatTime(total)} / Projected Finish ${TimeUtils1.formatTime(projected)}";

      final parts = logPredictor.split("Split Breakdown:");
      final header = parts[0];
      final body = parts.length > 1 ? parts[1].trim() : "";

      logPredictor = body.isEmpty
          ? "${header}Split Breakdown:\n$newEntry"
          : "${header}Split Breakdown:\n$newEntry\n$body";

      if (isProgressive) {
        _marker = _nextMarker(_marker);
      }
    }

    notifyListeners();
  }
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

  // ================= UNDO =================
  void undoLastSplit() {
    final t = current;
    if (t.splits.isEmpty) return;

    t.splits.removeLast();

    if (activeMode == 'Stopwatch') {
      logStopwatch = _removeFirst(logStopwatch);
    } else if (activeMode == 'Predictor') {
      logPredictor = _removeFirstPredictorLap(logPredictor);

      if (_shouldEnableProgressive() && progressiveActive) {
        _marker = _getMarkerFromCount(t.splits.length);
      }
    } else {
      logConverter = _removeFirst(logConverter);
    }

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

    /// only clear time
  void clearTime() {
    final t = current;

    t.running = false;
    t.startTime = null;
    t.accumulated = 0;
    t.lastSplitWall = null;

    /// keep splits if needed
    /// or use t.splits.clear();

    _ticker?.cancel();
    _ticker = null;

    notifyListeners();
  }

  void clearLog() {
    if (activeMode == 'Stopwatch') logStopwatch = '';
    if (activeMode == 'Predictor') logPredictor = '';
    if (activeMode == 'Converter') logConverter = '';
    notifyListeners();
  }

  String _removeFirstPredictorLap(String log) {
    final lines = log.split("\n");
    final index = lines.indexOf("Split Breakdown:");
    if (index == -1) return log;

    int i = index + 1;
    while (i < lines.length && lines[i].trim().isEmpty) {
      i++;
    }

    if (i < lines.length) {
      lines.removeAt(i);
    }

    return lines.join("\n");
  }

  double? _predict(int lapNo) {
    final total = elapsed();

    if (total <= 0) return null;

    /// normalize values
    final g = gender.toLowerCase().trim();
    final s = stroke.toLowerCase().trim();
    final c = course.toLowerCase().trim();

    final split = int.tryParse(splitSize) ?? 50;

    /// Progressive mode
    if (_shouldEnableProgressive() && progressiveActive) {
      return SplitsCore4.predictorLCM50(
        elapsedSeconds: total,
        gender: g,
        marker: _marker,
        pushStart: startType.toLowerCase() == 'from push',
      );
    }

    /// Standard mode
    return SplitsCore4.predictorStandard(
      elapsedSeconds: total,
      splitCount: lapNo,
      gender: g,
      stroke: s,
      distance: distance,
      course: c,
      splitSize: split,
      pushStart: startType.toLowerCase() == 'from push',
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
      case '15':
        return '25';
      case '25':
        return '35';
      default:
        return '15';
    }
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

// final stopwatchProvider2 =
// ChangeNotifierProvider<StopwatchController2>((ref) => StopwatchController2());
//
// class TimerState {
//   bool running = false;
//   DateTime? startTime;
//   double accumulated = 0.0;
//   DateTime? lastSplitWall;
//   final List<double> splits = [];
// }
//
// class StopwatchController2 extends ChangeNotifier {
//   final Map<String, TimerState> _timers = {
//     'Stopwatch': TimerState(),
//     'Predictor': TimerState(),
//     'Converter': TimerState(),
//   };
//
//   Timer? _ticker;
//
//   // ================= MODE =================
//   String activeMode = 'Stopwatch';
//
//   String logStopwatch = '';
//   String logPredictor = '';
//   String logConverter = '';
//
//   // ================= PREDICTOR =================
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
//   // ================= CONVERTER =================
//   String fromCourse = 'SCM';
//   String toCourse = 'SCM';
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
//     if (g != null) gender = g;
//     if (s != null) stroke = s;
//     if (d != null) distance = d;
//     if (c != null) course = c.toLowerCase();
//     if (split != null) splitSize = split;
//     if (start != null) startType = start;
//
//     progressiveActive = _shouldEnableProgressive();
//     _marker = '15';
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
//     t.lastSplitWall ??= now;
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
//     t.lastSplitWall = null;
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
//   String lastPredictorConfig = '';
//
//   // ================= SPLIT =================
//   // Pass context to the function to show the Snackbar
//   void split(BuildContext context) {
//     final t = current;
//     if (!t.running) return;
//
//     const int maxLogs = 100;
//
//     // 1. CHECK LIMIT FIRST
//     // Check against the current number of splits already recorded
//     if (t.splits.length >= maxLogs) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('You have reached the maximum of $maxLogs laps'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//       return; // Exit function so no more laps are added
//     }
//
//     final now = DateTime.now();
//     final total = elapsed();
//
//     final lap = t.lastSplitWall == null
//         ? total
//         : now.difference(t.lastSplitWall!).inMilliseconds / 1000;
//
//     t.lastSplitWall = now;
//     t.splits.add(total);
//
//     final lapNo = t.splits.length;
//
//     // You can remove the trimLog helper now, as the logic above
//     // prevents the list from ever exceeding the limit.
//
//     // ================= STOPWATCH =================
//     if (activeMode == 'Stopwatch') {
//       final lines = logStopwatch.isEmpty
//           ? <String>[]
//           : logStopwatch.trim().split('\n');
//
//       lines.insert(
//         0,
//         "Lap $lapNo: ${TimeUtils1.formatTime(lap)} / "
//             "${TimeUtils1.formatTime(total)}",
//       );
//
//       logStopwatch = lines.join('\n');
//     }
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
//         "Lap $lapNo: ${TimeUtils1.formatTime(total)} ${fromCourse.toUpperCase()}  → "
//             "${TimeUtils1.formatTime(converted)}  ${toCourse.toUpperCase()}",
//       );
//
//       logConverter = lines.join('\n');
//     }
//
//     // ================= PREDICTOR =================
//     else {
//       final formattedStroke = stroke.toLowerCase() == "im" ? "IM" : "${stroke[0].toUpperCase()}${stroke.substring(1).toLowerCase()}";
//       final currentConfig = "$gender|$stroke|$distance|$course|$splitSize|$startType|$progressiveActive";
//
//       // 1. Reset/Initialize Header if config changes or log is empty
//       if (lastPredictorConfig != currentConfig || logPredictor.trim().isEmpty) {
//         lastPredictorConfig = currentConfig;
//         logPredictor = "${gender[0].toUpperCase()}${gender.substring(1).toLowerCase()}'s $distance $formattedStroke ${course.toUpperCase()} Projection\n"
//             "Start Type: $startType | Split Size: $splitSize\n"
//             "===============\n"
//             "Split Breakdown:";
//
//         _marker = '15';
//         t.lastSplitWall = now;
//       }
//       debugPrint(logPredictor);
//
//       // 2. Prepare the data
//       final projected = _predict(lapNo) ?? 0.0;
//       final isProgressive = _shouldEnableProgressive() && progressiveActive;
//       final label = isProgressive ? _marker : "Lap $lapNo";
//
//       final String fLap = TimeUtils1.formatTime(lap);
//       final String fTotal = TimeUtils1.formatTime(total);
//       final String fProj = TimeUtils1.formatTime(projected);
//
//       final newEntry = isProgressive
//           ? "$label $fLap / Projected Finish $fProj"
//           : "$label $fLap / $fTotal / Projected Finish $fProj";
//
//       // 3. Split the log into Header and Body
//       final parts = logPredictor.split("Split Breakdown:");
//
//       // Use ${header} with braces to avoid the "Undefined name" error
//       final String header = parts[0];
//       final String currentBody = parts.length > 1 ? parts[1].trim() : "";
//
//       // 4. Reconstruct: Header + Label + New Entry + Full History
//       if (currentBody.isEmpty) {
//         // Fixed interpolation here:
//         logPredictor = "${header}Split Breakdown:\n$newEntry";
//       } else {
//         // Fixed interpolation here:
//         logPredictor = "${header}Split Breakdown:\n$newEntry\n$currentBody";
//       }
//
//       if (isProgressive) {
//         _marker = _nextMarker(_marker);
//       }
//     }
//
//     notifyListeners();
//   }
//
//   void initializePredictorLog() {
//     logPredictor = "${gender.toUpperCase()}'$distance e ${stroke.toUpperCase()} ${course.toUpperCase()}Projection\n"
//         "Start Type: $startType | Split Size: $splitSize\n"
//         "===============\n"
//         "Split Breakdown:\n";
//     notifyListeners();
//   }
//
//   // ================= PREDICT (FIXED) =================
//   double? _predict(int lapNo) {
//     final total = elapsed();
//     if (total <= 0) return null;
//
//     // Use normalized lowercase values for lookup
//     final normalizedGender = gender.toLowerCase();
//     final normalizedStroke = stroke.toLowerCase();
//     final normalizedCourse = course.toLowerCase();
//
//     if (_shouldEnableProgressive() && progressiveActive) {
//       return SplitsCore4.predictorLCM50(
//         elapsedSeconds: total,
//         gender: normalizedGender,
//         marker: _marker,
//         pushStart: startType.toLowerCase() == 'from push',
//       );
//     }
//
//     final split = int.tryParse(splitSize) ?? 50;
//
//     return SplitsCore4.predictorStandard(
//       elapsedSeconds: total,
//       splitCount: lapNo,
//       gender: normalizedGender,
//       stroke: normalizedStroke,
//       distance: distance,
//       course: normalizedCourse, // "scm", "scy", or "lcm"
//       splitSize: split,
//       pushStart: startType.toLowerCase() == 'from push',
//     );
//   }
//
//   // ================= MARKER =================
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
//   // ================= CHECK =================
//   bool _shouldEnableProgressive() {
//     return course.toLowerCase() == 'lcm' &&
//         distance == '50' &&
//         ['15', '25', '35'].contains(splitSize);
//   }
//
//   // ================= CONVERTER =================
//   double _factor(String from, String to) {
//     if (from == to) return 1.0;
//     return Ratios1.conversionFactors['${from}_$to'] ?? 1.0;
//   }
//
//   // ================= RESET =================
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
//   /// only clear time
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
//   void undoLastSplit() {
//     final t = current;
//     if (t.splits.isEmpty) return;
//
//     /// remove last split time
//     t.splits.removeLast();
//
//     // ================= STOPWATCH =================
//     if (activeMode == 'Stopwatch') {
//       logStopwatch = _removeFirst(logStopwatch);
//     }
//
//     // ================= PREDICTOR =================
//     else if (activeMode == 'Predictor') {
//       logPredictor = _removeFirstPredictorLap(logPredictor);
//
//       /// ✅ FIX PROGRESSIVE MODE MARKER
//       if (_shouldEnableProgressive() && progressiveActive) {
//         _marker = _getMarkerFromCount(t.splits.length);
//       }
//     }
//
//     // ================= CONVERTER =================
//     else {
//       logConverter = _removeFirst(logConverter);
//     }
//
//     notifyListeners();
//   }
//
//   /// ======================================================
//   /// FIX MARKER AFTER UNDO
//   /// ======================================================
//   String _getMarkerFromCount(int count) {
//     final markers = ['15', '25', '35'];
//
//     /// count = remaining splits
//     /// 0 => 15
//     /// 1 => 25
//     /// 2 => 35
//     /// 3 => 15 again
//     return markers[count % 3];
//   }
//
//   String _removeFirst(String log) {
//     if (log.isEmpty) return "";
//
//     List<String> lines = log.trim().split("\n");
//
//     if (lines.isNotEmpty) {
//       lines.removeAt(0);
//     }
//
//     return lines.join("\n");
//   }
//
// // Predictor: preserve header, remove first lap after "Split Breakdown:"
//   String _removeFirstPredictorLap(String log) {
//     if (log.isEmpty) return "";
//
//     List<String> lines = log.split("\n");
//
//     int headerIndex = lines.indexOf("Split Breakdown:");
//
//     if (headerIndex == -1) {
//       return log; // header not found
//     }
//
//     int lapIndex = headerIndex + 1;
//
//     // Skip empty line(s)
//     while (lapIndex < lines.length && lines[lapIndex].trim().isEmpty) {
//       lapIndex++;
//     }
//
//     // Remove first lap only
//     if (lapIndex < lines.length) {
//       lines.removeAt(lapIndex);
//     }
//
//     return lines.join("\n");
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
//}