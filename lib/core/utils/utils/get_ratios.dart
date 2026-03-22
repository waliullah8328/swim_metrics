import 'dart:math';

// ---------------- NORMALIZE ----------------
List<double> normalize(List<double> r) {
  final sum = r.reduce((a, b) => a + b);
  return r.map((e) => e / sum).toList();
}

// ---------------- SCY ----------------
final ratiosScy = {
  "men": {
    "free": {
      "50": normalize([0.4828, 0.5172]),
      "100": normalize([0.2233, 0.2508, 0.2618, 0.2641]),
      "200": normalize([0.2297, 0.2527, 0.2569, 0.2607]),
      "500": normalize([
        0.0912,0.1000,0.1015,0.1019,0.1021,
        0.1021,0.1016,0.1013,0.1004,0.0979
      ]),
      "1000": normalize([
        0.0455,0.0490,0.0496,0.0498,0.0500,
        0.0501,0.0501,0.0503,0.0503,0.0505,
        0.0502,0.0502,0.0507,0.0508,0.0509,
        0.0505,0.0507,0.0508,0.0508,0.0493
      ]),
      "1650": normalize([
        0.0278,0.0302,0.0304,0.0306,0.0305,0.0307,0.0306,0.0306,0.0307,0.0306,
        0.0305,0.0306,0.0305,0.0305,0.0306,0.0305,0.0306,0.0305,0.0304,0.0303,
        0.0304,0.0305,0.0304,0.0306,0.0303,0.0304,0.0305,0.0303,0.0302,0.0303,
        0.0302,0.0299,0.0285
      ]),
    },
  },
  "women": {
    "free": {
      "50": normalize([0.4845, 0.5155]),
      "100": normalize([0.2264, 0.2521, 0.2596, 0.2619]),
      "200": normalize([0.2346, 0.2542, 0.2552, 0.2560]),
    },
  }
};

// ---------------- SCM ----------------
final ratiosScm = {
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
  }
};

// ---------------- LCM ----------------
final ratiosLcm = {
  "men": {
    "free": {
      "100": normalize([0.48, 0.52]),
      "200": normalize([0.2330, 0.2532, 0.2567, 0.2571]),
    }
  },
  "women": {
    "free": {
      "100": normalize([0.481, 0.519]),
      "200": normalize([0.235, 0.252, 0.256, 0.257]),
    }
  }
};

// ---------------- GET RATIOS ----------------
List<double>? getRatios(
    String course,
    String gender,
    String stroke,
    String distance,
    ) {
  final source = course == "scy"
      ? ratiosScy
      : course == "scm"
      ? ratiosScm
      : ratiosLcm;

  return source[gender]?[stroke]?[distance];
}

// ======================================================
// 🔥 LCM 50 FINAL (CORRECT — MATCHES PYTHON)
// ======================================================

Map<String, double> getLcm50FinalRatios(String gender) {
  if (gender == "men") {
    return {
      // ✅ CORRECT ratios (match your expected output)
      "15m": 0.249,
      "25m": 0.456,
      "35m": 0.668,
    };
  } else {
    return {
      // (adjust later if you have real data)
      "15m": 0.255,
      "25m": 0.465,
      "35m": 0.675,
    };
  }
}