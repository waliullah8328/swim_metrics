class ConversionCore1 {
  static final Map<String, double> poolLen = {
    'scy': 22.86,
    'scm': 25.0,
    'lcm': 50.0,
  };

  static final Map<String, dynamic> baseTimes = {
    'men': {
      'free': {
        '50': {'scy': 17.63, 'scm': 19.90, 'lcm': 20.91},
        '100': {'scy': 39.83, 'scm': 44.84, 'lcm': 46.40},
        '200': {'scy': 88.83, 'scm': 98.61, 'lcm': 102.00},
        '500': {'scy': 242.31},
        '400': {'scm': 212.25, 'lcm': 220.07},
        '1000': {'scy': 513.93},
        '1650': {'scy': 852.08},
        '800': {'scm': 440.46, 'lcm': 452.12},
        '1500': {'scm': 846.88, 'lcm': 870.67},
      },
      'fly': {
        '50': {'scy': 19.38, 'scm': 21.51, 'lcm': 22.80},
        '100': {'scy': 42.80, 'scm': 47.71, 'lcm': 49.45},
        '200': {'scy': 97.35, 'scm': 106.85, 'lcm': 110.34},
      },
      'back': {
        '50': {'scy': 20.00, 'scm': 22.37, 'lcm': 24.36},
        '100': {'scy': 43.35, 'scm': 48.33, 'lcm': 51.60},
        '200': {'scy': 95.37, 'scm': 105.63, 'lcm': 111.92},
      },
      'breast': {
        '50': {'scy': 23.35, 'scm': 25.52, 'lcm': 26.57},
        '100': {'scy': 49.53, 'scm': 55.28, 'lcm': 56.88},
        '200': {'scy': 105.35, 'scm': 119.52, 'lcm': 125.48},
      },
      'im': {
        '100': {'scy': 45.74, 'scm': 49.28},
        '200': {'scy': 96.34, 'scm': 108.88, 'lcm': 116.00},
        '400': {'scy': 208.82, 'scm': 234.81, 'lcm': 242.50},
      }
    },
    'women': {
      'free': {
        '50': {'scy': 20.37, 'scm': 22.83, 'lcm': 23.61},
        '100': {'scy': 44.83, 'scm': 50.25, 'lcm': 51.71},
        '200': {'scy': 99.10, 'scm': 110.31, 'lcm': 112.23},
        '500': {'scy': 264.06},
        '400': {'scm': 230.25, 'lcm': 235.38},
        '1000': {'scy': 539.65},
        '1650': {'scy': 901.41},
        '800': {'scm': 477.42, 'lcm': 484.79},
        '1500': {'scm': 908.24, 'lcm': 920.48},
      },
      'fly': {
        '50': {'scy': 21.23, 'scm': 23.72, 'lcm': 25.18},
        '100': {'scy': 47.35, 'scm': 52.71, 'lcm': 55.18},
        '200': {'scy': 108.33, 'scm': 119.32, 'lcm': 121.81},
      },
      'back': {
        '50': {'scy': 22.10, 'scm': 25.35, 'lcm': 27.28},
        '100': {'scy': 48.10, 'scm': 54.02, 'lcm': 57.13},
        '200': {'scy': 106.87, 'scm': 118.04, 'lcm': 123.14},
      },
      'breast': {
        '50': {'scy': 24.99, 'scm': 28.81, 'lcm': 30.00},
        '100': {'scy': 55.73, 'scm': 62.36, 'lcm': 64.13},
        '200': {'scy': 121.29, 'scm': 132.50, 'lcm': 137.55},
      },
      'im': {
        '100': {'scy': 51.97, 'scm': 55.11},
        '200': {'scy': 108.37, 'scm': 121.63, 'lcm': 126.12},
        '400': {'scy': 234.60, 'scm': 255.48, 'lcm': 264.38},
      }
    }
  };

  static double poolRatio(String from, String to) {
    return poolLen[to]! / poolLen[from]!;
  }

  static double? wrMultiplier(String gender, String stroke, String distance, String from, String to) {
    final g = baseTimes[gender] as Map<String, dynamic>?;
    if (g == null) return null;
    final s = g[stroke] as Map<String, dynamic>?;
    if (s == null) return null;
    final fromMap = s[distance];
    if (fromMap is Map && fromMap[from] is num) {
      final a = fromMap[from] as num;
      final toDistance = mappedDistance(stroke, distance, from, to);
      final toMap = s[toDistance];
      if (toMap is Map && toMap[to] is num) {
        final b = toMap[to] as num;
        return b / a;
      }
    }
    return null;
  }

  static String mappedDistance(String stroke, String distance, String from, String to) {
    if (stroke == 'free') {
      if (from == 'scy' && (to == 'scm' || to == 'lcm')) {
        if (distance == '500') return '400';
        if (distance == '1000') return '800';
        if (distance == '1650') return '1500';
      }
      if ((from == 'scm' || from == 'lcm') && to == 'scy') {
        if (distance == '400') return '500';
        if (distance == '800') return '1000';
        if (distance == '1500') return '1650';
      }
    }
    return distance;
  }

  static double computeMultiplier(String gender, String stroke, String distance, String from, String to) {
    final fromL = from.toLowerCase();
    final toL = to.toLowerCase();
    final g = gender.toLowerCase();
    final s = stroke.toLowerCase();
    final d = distance;
    if (fromL == toL) return 1.0;
    final wr = wrMultiplier(g, s, d, fromL, toL);
    if (wr != null) return wr;
    return poolRatio(fromL, toL);
  }
}
