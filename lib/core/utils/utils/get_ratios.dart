import 'dart:math';

class SwimSplitCalculator {
  // ---------------- NORMALIZE ----------------
  static List<double> normalize(List<double> r) {
    final sum = r.reduce((a, b) => a + b);
    return r.map((e) => e / sum).toList();
  }

  // ---------------- SCY RATIOS ----------------
  static final Map<String, dynamic> ratiosScy = {
    "men": {
      "free": {
        "50": normalize([0.4828, 0.5172]),
        "100": normalize([0.2233, 0.2508, 0.2618, 0.2641]),
        "200": normalize([0.2297, 0.2527, 0.2569, 0.2607]),
        "500": normalize([0.0912, 0.1000, 0.1015, 0.1019, 0.1021, 0.1021, 0.1016, 0.1013, 0.1004, 0.0979]),
        "1000": normalize([
          0.0455, 0.0490, 0.0496, 0.0498, 0.0500, 0.0501, 0.0501, 0.0503, 0.0503, 0.0505,
          0.0502, 0.0502, 0.0507, 0.0508, 0.0509, 0.0505, 0.0507, 0.0508, 0.0508, 0.0493
        ]),
        "1650": normalize([
          0.0279, 0.0303, 0.0307, 0.0307, 0.0308, 0.0307, 0.0307, 0.0308, 0.0307, 0.0307,
          0.0306, 0.0304, 0.0305, 0.0302, 0.0303, 0.0303, 0.0301, 0.0304, 0.0303, 0.0304,
          0.0302, 0.0302, 0.0302, 0.0301, 0.0303, 0.0302, 0.0304, 0.0304, 0.0302, 0.0303,
          0.0301, 0.0301, 0.0293
        ]),
      },
      "back": {
        "100": normalize([0.4832, 0.5168]),
        "200": normalize([0.2353, 0.2522, 0.2556, 0.2569]),
      },
      "breast": {
        "100": normalize([0.466, 0.534]),
        "200": normalize([0.2282, 0.2547, 0.2572, 0.2599]),
      },
      "fly": {
        "100": normalize([0.4678, 0.5322]),
        "200": normalize([0.221, 0.2534, 0.2589, 0.2667]),
      },
      "im": {
        "200": normalize([0.214, 0.2523, 0.2896, 0.2441]),
        "400": normalize([0.1041, 0.1199, 0.1298, 0.127, 0.1421, 0.1438, 0.1193, 0.114]),
      },
    },
    "women": {
      "free": {
        "50": normalize([0.4845, 0.5155]),
        "100": normalize([0.2264, 0.2521, 0.2596, 0.2619]),
        "200": normalize([0.2346, 0.2542, 0.2552, 0.2560]),
      },
      "back": {
        "100": normalize([0.486, 0.514]),
        "200": normalize([0.235, 0.251, 0.256, 0.258]),
      },
      "breast": {
        "100": normalize([0.465, 0.535]),
        "200": normalize([0.232, 0.251, 0.257, 0.26]),
      },
      "fly": {
        "100": normalize([0.468, 0.532]),
        "200": normalize([0.225, 0.254, 0.258, 0.263]),
      },
      "im": {
        "200": normalize([0.214, 0.254, 0.291, 0.241]),
        "400": normalize([0.1049, 0.1204, 0.1285, 0.1268, 0.1424, 0.1467, 0.1188, 0.1114]),
      },
    },
  };

  // ---------------- SCM RATIOS ----------------
  static final Map<String, dynamic> ratiosScm = {
    "men": {
      "free": {
        "50": normalize([0.4791, 0.5209]),
        "100": normalize([0.2262, 0.2513, 0.2605, 0.2620]),
        "200": normalize([0.2337, 0.2519, 0.2565, 0.2579]),
      },
    },
    "women": {
      "free": {
        "50": normalize([0.4843, 0.5157]),
        "100": normalize([0.2283, 0.2526, 0.2590, 0.2601]),
        "200": normalize([0.2332, 0.2507, 0.2569, 0.2592]),
      },
    },
  };

  // ---------------- LCM RATIOS RAW ----------------
  static final Map<String, dynamic> ratiosLcmRaw = {
    "men": {
      "free": {
        "100": [0.48, 0.52],
        "200": [0.2330, 0.2532, 0.2567, 0.2571],
        "400": [0.1156, 0.1249, 0.1267, 0.1276, 0.1275, 0.1276, 0.1268, 0.1233],
      },
    },
    "women": {
      "free": {
        "100": [0.481, 0.519],
        "200": [0.235, 0.252, 0.256, 0.257],
        "400": [0.1151, 0.1245, 0.1262, 0.1268, 0.1267, 0.1273, 0.1278, 0.1256],
      },
    },
  };

  // ---------------- NORMALIZE ALL LCM ----------------
  static Map<String, dynamic> normalizeAll(Map<String, dynamic> data) {
    Map<String, dynamic> result = {};

    data.forEach((gender, strokes) {
      result[gender] = {};
      strokes.forEach((stroke, distances) {
        result[gender]![stroke] = {};
        distances.forEach((distance, values) {
          result[gender]![stroke]![distance] = normalize(List<double>.from(values));
        });
      });
    });

    return result;
  }

  static final Map<String, dynamic> ratiosLcm = normalizeAll(ratiosLcmRaw);

  // ---------------- GET RATIOS ----------------
  static List<double>? getRatios(String course, String gender, String stroke, String distance) {
    final source = course.toLowerCase() == "scy"
        ? ratiosScy
        : course.toLowerCase() == "scm"
        ? ratiosScm
        : ratiosLcm;

    return source[gender]?[stroke]?[distance];
  }

  // ---------------- LCM 50 FINAL RATIOS ----------------
  static Map<String, double> getLcm50FinalRatios(String gender) {
    if (gender.toLowerCase() == "men") {
      return {"15m": 0.249, "25m": 0.456, "35m": 0.668};
    } else {
      return {"15m": 0.255, "25m": 0.465, "35m": 0.675};
    }
  }

  // ---------------- GET DISTANCES ----------------
  static List<int> getDistances(String course, String stroke, String gender) {
    course = course.toLowerCase();
    stroke = stroke.toLowerCase();
    gender = gender.toLowerCase();

    Map<String, dynamic>? data;

    if (course == "scy") {
      data = SwimSplitCalculator.ratiosScy[gender]?[stroke];
    } else if (course == "scm") {
      data = SwimSplitCalculator.ratiosScm[gender]?[stroke];
    } else if (course == "lcm") {
      data = SwimSplitCalculator.ratiosLcmRaw[gender]?[stroke];
    }

    if (data != null) {
      final distances = data.keys.map((k) => int.tryParse(k) ?? 0).toList();
      distances.sort();
      return distances;
    }

    return [];
  }
}