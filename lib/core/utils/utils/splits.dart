import 'dart:math';
import 'ratios.dart';
import 'time_utils.dart';

class SplitsCore {
  static List<double> normalize(List<double> r) {
    final s = r.fold<double>(0, (a, b) => a + b);
    return r.map((e) => e / s).toList();
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
      src = Ratios.ratiosSCY;
    } else if (course == 'scm') {
      src = Ratios.ratiosSCM;
    } else {
      src = Ratios.ratiosLCM;
    }

    final g = src[gender] as Map<String, dynamic>?;
    if (g == null) return null;

    // LCM 50 special case
    if (course == 'lcm' && distance == '50' && stroke != 'im') {
      final segs = lcm50Segments(gender);
      return [segs['s1']!, segs['s2']!, segs['s3']!, segs['s4']!];
    }

    final s = g[stroke] as Map<String, dynamic>?;
    if (s == null) return null;

    final r = s[distance];
    if (r == null) return null;

    return List<double>.from(r);
  }

  static Map<String, double> lcm50Segments(String gender, {bool pushStart = false}) {
    final cum = Ratios.lcm50Cum[gender] as Map<String, double>;
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
}