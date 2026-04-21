import 'dart:math';
import 'package:swim_metrics/core/utils/utils/ratios_1.dart' hide TimeUtils1;
import 'package:swim_metrics/core/utils/utils/time_utils_1.dart';



class SplitsCore1 {
  static List<double> normalize(List<double> r) {
    final s = r.fold<double>(0, (a, b) => a + b);
    return r.map((e) => e / s).toList();
  }

  static String secondsToLabel(double v) {
    final s = TimeUtils1.formatSeconds(v);
    if (s.startsWith('0:')) return s.substring(2);
    return s;
  }

  static List<double> interpolateRatios(List<double> ratios, int expectedSplits) {
    if (expectedSplits == ratios.length) return ratios;
    final res = <double>[];
    for (int i = 0; i < expectedSplits; i++) {
      final t = i * (ratios.length - 1) / max(1, expectedSplits - 1);
      final i0 = t.floor().clamp(0, ratios.length - 1);
      final i1 = (i0 + 1).clamp(0, ratios.length - 1);
      final f = t - i0;
      final v = ratios[i0] * (1 - f) + ratios[i1] * f;
      res.add(v);
    }
    return normalize(res);
  }

  static List<double>? getRatios(String course, String gender, String stroke, String distance) {
    Map<String, dynamic> src;
    if (course == 'scy') {
      src = Ratios1.ratiosSCY;
    } else if (course == 'scm') {
      src = Ratios1.ratiosSCM;
    } else {
      src = Ratios1.ratiosLCM;
    }
    final g = src[gender] as Map<String, dynamic>?;
    if (g == null) return null;
    final s = g[stroke] as Map<String, dynamic>?;
    if (s == null) return null;
    final r = s[distance];
    if (r == null) return null;
    return List<double>.from(r);
  }

  static String calculateSplits(double totalSeconds, List<double> ratioList, int distance, {String? targetCourse}) {
    // GUARD: If no ratios provided, return early to prevent RangeError
    if (ratioList.isEmpty || totalSeconds <= 0) {
      return '--- Splits ---\nNot available';
    }

    final d = distance;
    final course = targetCourse?.toLowerCase();

    // 1. Short Course (SCY/SCM)
    if ((course == 'scy' || course == 'scm') && (d == 50 || d == 100)) {
      final numSegments = d ~/ 25;
      if (numSegments <= 0) return ''; // Guard against 0 distance

      final normalized = ratioList.length == numSegments ? ratioList : normalize(ratioList);

      // GUARD: Ensure normalize actually returned data
      if (normalized.isEmpty) return '--- Splits ---\nData missing';

      final segTimes = normalized.map((r) => totalSeconds * r).toList();
      final out = <String>['--- Splits ---'];

      double cum = 0;
      for (int i = 0; i < segTimes.length && i < numSegments; i++) {
        final distOut = (i + 1) * 25;
        final lapTime = segTimes[i];
        cum += lapTime;

        final lapStr = secondsToLabel(lapTime);
        final cumStr = secondsToLabel(cum);

        // SAFETY: Check i > 0 before accessing segTimes[i-1]
        if (d == 100 && distOut % 50 == 0 && i > 0) {
          final split50Time = segTimes[i - 1] + segTimes[i];
          final split50Str = secondsToLabel(split50Time);
          out.add('$distOut: $lapStr / $split50Str / $cumStr');
        } else {
          out.add('$distOut: $lapStr / $cumStr');
        }
      }
      return out.join('\n');
    }

    // 2. Long Course (LCM) or longer distances
    final normalized = normalize(ratioList);

    // GUARD: Safety check
    if (normalized.isEmpty) return '--- Splits ---\nData missing';

    final lapTimes = normalized.map((r) => totalSeconds * r).toList();
    final out = <String>['--- Splits ---'];

    double cum = 0;
    const int inc = 50;

    for (int i = 0; i < lapTimes.length; i++) {
      final distOut = (i + 1) * inc;
      final lapTime = lapTimes[i];
      cum += lapTime;

      final lapStr = secondsToLabel(lapTime);
      final cumStr = secondsToLabel(cum);

      // SAFETY: Check i > 0 before accessing lapTimes[i-1]
      if (distOut > 50 && distOut % 100 == 0 && i > 0) {
        final split100Time = lapTimes[i - 1] + lapTimes[i];
        final split100Str = secondsToLabel(split100Time);
        out.add('$distOut: $lapStr / $split100Str / $cumStr');
      } else {
        out.add('$distOut: $lapStr / $cumStr');
      }
    }
    return out.join('\n');
  }

  static Map<String, double> lcm50Segments(String gender, {bool pushStart = false}) {
    final cum = Ratios1.lcm50Cum[gender] as Map<String, double>;
    final c15 = cum['15']!;
    final c25 = cum['25']!;
    final c35 = cum['35']!;
    final segs = [c15, c25 - c15, c35 - c25, 1.0 - c35];
    if (pushStart) {
      segs[0] *= 1.10;
      final sum = segs.reduce((a, b) => a + b);
      for (int i = 0; i < segs.length; i++) {
        segs[i] = segs[i] / sum;
      }
    }
    return {'s1': segs[0], 's2': segs[1], 's3': segs[2], 's4': segs[3]};
  }

  static Map<String, double> lcm50CumsFromSegments(List<double> segs) {
    final c15 = segs[0];
    final c25 = segs[0] + segs[1];
    final c35 = segs[0] + segs[1] + segs[2];
    return {'15': c15, '25': c25, '35': c35};
  }

  static double predictorStandard({
    required double elapsedSeconds,
    required int splitCount,
    required String gender,
    required String stroke,
    required String distance,
    required String course,
    int splitSize = 50,
    bool pushStart = false,
  }) {
    final baseRatios = getRatios(course, gender, stroke, distance) ?? List<double>.filled(distance == '100' ? 2 : (int.parse(distance) ~/ 50), 1.0);
    final expected = int.parse(distance) ~/ splitSize;
    var r = interpolateRatios(baseRatios, expected);
    if (pushStart && r.isNotEmpty) {
      r[0] *= 1.10;
      r = normalize(r);
    }
    final completed = r.take(splitCount).fold<double>(0, (a, b) => a + b);
    final total = r.fold<double>(0, (a, b) => a + b);
    if (completed <= 0) return elapsedSeconds;
    return elapsedSeconds / completed * total;
  }

  static double predictorLCM50({
    required double elapsedSeconds,
    required String gender,
    required String marker,
    bool pushStart = false,
  }) {
    final segsMap = lcm50Segments(gender, pushStart: pushStart);
    final segs = [segsMap['s1']!, segsMap['s2']!, segsMap['s3']!, segsMap['s4']!];
    final cums = lcm50CumsFromSegments(segs);
    final completed = cums[marker] ?? 0.0;
    if (completed <= 0) return elapsedSeconds;
    return elapsedSeconds / completed;
  }
}
