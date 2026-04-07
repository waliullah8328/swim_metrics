class Ratios1 {
  /// LCM 50 cumulative ratios
  static Map<String, Map<String, double>> lcm50Cum = {
    'men': {'15': 0.238, '25': 0.448, '35': 0.659},
    'women': {'15': 0.248, '25': 0.456, '35': 0.671},
  };

  /// SCY ratios
  static Map<String, dynamic> ratiosSCY = {
    'men': {
      'free': {
        '50': [0.4828, 0.5172],
        '100': [0.2233, 0.2508, 0.2618, 0.2641],
        '200': [0.2297, 0.2527, 0.2569, 0.2607],
      },
      'fly': {
        '50': [0.460, 0.540],
        '100': [0.2121, 0.2537, 0.2630, 0.2712],
      },
      'back': {
        '50': [0.483, 0.517],
        '100': [0.2346, 0.2483, 0.2583, 0.2588],
      },
      'breast': {
        '50': [0.448, 0.552],
        '100': [0.2110, 0.2562, 0.2625, 0.2703],
      },
      'im': {
        '100': [0.205, 0.249, 0.299, 0.247],
      },
    },
    'women': {
      'free': {
        '50': [0.4845, 0.5155],
        '100': [0.2264, 0.2521, 0.2596, 0.2619],
        '200': [0.2346, 0.2542, 0.2552, 0.2560],
      },
      'fly': {
        '50': [0.4692, 0.5308],
        '100': [0.2126, 0.2536, 0.2635, 0.2703],
      },
    },
  };

  /// SCM ratios
  static Map<String, dynamic> ratiosSCM = {
    'men': {
      'free': {
        '50': [0.4791, 0.5209],
        '100': [0.2262, 0.2513, 0.2605, 0.2620],
        '200': [0.2337, 0.2519, 0.2565, 0.2579],
      },
      'fly': {
        '50': [0.4553, 0.5447],
        '100': [0.2134, 0.2509, 0.2617, 0.2740],
      },
    },
    'women': {
      'free': {
        '50': [0.4843, 0.5157],
        '100': [0.2283, 0.2526, 0.2590, 0.2601],
        '200': [0.2332, 0.2507, 0.2569, 0.2592],
      },
    },
  };

  /// LCM ratios
  static Map<String, dynamic> ratiosLCM = {
    'men': {
      'free': {
        '100': [0.4800, 0.5200],
        '200': [0.2330, 0.2532, 0.2567, 0.2571],
      },
      'fly': {
        '100': [0.4678, 0.5322],
        '200': [0.2210, 0.2534, 0.2589, 0.2667],
      },
    },
    'women': {
      'free': {
        '100': [0.481, 0.519],
        '200': [0.235, 0.252, 0.256, 0.257],
      },
      'fly': {
        '100': [0.468, 0.532],
        '200': [0.225, 0.254, 0.258, 0.263],
      },
    },
  };

  /// Conversion factors (example: yards ↔ meters)
  static Map<String, double> conversionFactors = {
    'yards_to_meters': 0.9144,
    'meters_to_yards': 1.09361,
  };

  /// Normalize a single ratio list
  static List<double> normalize(List<double> r) {
    final s = r.fold<double>(0, (a, b) => a + b);
    return r.map((e) => e / s).toList();
  }

  /// Normalize all ratios in SCY, SCM, LCM
  static void normalizeAll() {
    for (final course in [ratiosSCY, ratiosSCM, ratiosLCM]) {
      for (final gender in course.keys) {
        final g = course[gender] as Map<String, dynamic>;
        for (final stroke in g.keys) {
          final s = g[stroke] as Map<String, dynamic>;
          for (final dist in s.keys) {
            final r = List<double>.from(s[dist]);
            s[dist] = normalize(r);
          }
        }
      }
    }
  }
}

/// Call this at app startup
void initializeRatios1() {
  Ratios1.normalizeAll();
}