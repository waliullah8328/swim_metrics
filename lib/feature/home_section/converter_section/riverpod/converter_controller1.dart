// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../../core/utils/utils/conversation_core_1.dart';
// import '../../../../core/utils/utils/ratios_1.dart' hide TimeUtils1;
// import '../../../../core/utils/utils/split_core_1.dart';
// import '../../../../core/utils/utils/splits.dart';
// import '../../../../core/utils/utils/time_utils_1.dart';
// import '../../../../l10n/app_localizations.dart';
//
// final converterProvider1 =
// NotifierProvider<ConverterController, ConverterState>(
//   ConverterController.new,
// );
//
// class ConverterState {
//   final String course;
//   final String gender;
//   final String stroke;
//   final String distance;
//   final String timeText;
//   final bool showSplits;
//   final Set<String> targets;
//   final bool preferWR;
//   final String output;
//
//   const ConverterState({
//     this.course = 'scm',
//     this.gender = 'men',
//     this.stroke = 'free',
//     this.distance = '100',
//     this.timeText = '',
//     this.showSplits = false,
//     this.targets = const {},
//     this.preferWR = true,
//     this.output = '',
//   });
//
//   ConverterState copyWith({
//     String? course,
//     String? gender,
//     String? stroke,
//     String? distance,
//     String? timeText,
//     bool? showSplits,
//     Set<String>? targets,
//     bool? preferWR,
//     String? output,
//   }) {
//     return ConverterState(
//       course: course ?? this.course,
//       gender: gender ?? this.gender,
//       stroke: stroke ?? this.stroke,
//       distance: distance ?? this.distance,
//       timeText: timeText ?? this.timeText,
//       showSplits: showSplits ?? this.showSplits,
//       targets: targets ?? this.targets,
//       preferWR: preferWR ?? this.preferWR,
//       output: output ?? this.output,
//     );
//   }
// }
//
// class ConverterController extends Notifier<ConverterState> {
//   @override
//   ConverterState build() {
//     initializeRatios1();
//     return const ConverterState();
//   }
//
//   void setCourse(String v) {
//     final newTargets = {...state.targets};
//     newTargets.remove(v.toLowerCase());
//
//     state = state.copyWith(
//       course: v.toLowerCase(),
//       targets: newTargets,
//     );
//   }
//
//   void setGender(String v) {
//     state = state.copyWith(gender: v.toLowerCase());
//   }
//
//   void setStroke(String v) {
//     state = state.copyWith(stroke: v.toLowerCase());
//   }
//
//   void setDistance(String v) {
//     state = state.copyWith(distance: v);
//   }
//
//   void setTimeText(String v) {
//     state = state.copyWith(timeText: v);
//   }
//
//   void setShowSplits(bool v) {
//     state = state.copyWith(showSplits: v);
//   }
//
//   void toggleTarget(String v, bool selected) {
//     final key = v.toLowerCase();
//     final newTargets = {...state.targets};
//
//     if (selected) {
//       if (key != state.course) {
//         newTargets.add(key);
//       }
//     } else {
//       newTargets.remove(key);
//     }
//
//     state = state.copyWith(targets: newTargets);
//   }
//
//   List<String> allowedTargets() {
//     return ['scy', 'scm', 'lcm']
//         .where((e) => e != state.course)
//         .toList();
//   }
//
//
//
//   void convert({required context}) {
//     final s = state;
//
//     if ([s.course, s.gender, s.stroke, s.distance, s.timeText]
//         .any((e) => e.trim().isEmpty)) {
//       state = s.copyWith(
//         output: '${AppLocalizations.of(context)!.pleaseFillAllFields}\n\n${s.output}',
//       );
//       return;
//     }
//
//     double totalSeconds;
//     try {
//       totalSeconds = TimeUtils1.parseToSeconds(s.timeText.trim());
//     } catch (_) {
//       state = s.copyWith(
//         output: '${AppLocalizations.of(context)!.invalidTimeFormat}\n\n${s.output}',
//       );
//       return;
//     }
//
//     final results = <String>[];
//     final splitResults = <String>[];
//
//     results.add('=== Conversion Results ===');
//     if (s.showSplits) splitResults.add('=== Conversion Results with Splits ===');
//
//     final targets = s.targets.isEmpty
//         ? allowedTargets()
//         : allowedTargets().where((e) => s.targets.contains(e)).toList();
//
//     for (final to in targets) {
//       // 1. Skip LCM result calculation entirely if source is LCM and it's a 100 IM
//       if (s.course.toLowerCase() == 'lcm' &&
//           s.stroke.toLowerCase() == 'im' &&
//           s.distance == '100' &&
//           to.toLowerCase() == 'lcm') {
//         continue;
//       }
//
//       final displayDistance = ConversionCore1.mappedDistance(s.stroke, s.distance, s.course, to);
//
//       // Skip if no mapping exists
//       if (displayDistance == null || displayDistance.toString().isEmpty) continue;
//
//       final multiplier = s.preferWR
//           ? ConversionCore1.computeMultiplier(s.gender, s.stroke, s.distance, s.course, to)
//           : ConversionCore1.poolRatio(s.course, to);
//
//       final converted = totalSeconds * multiplier;
//       final convertedText = TimeUtils1.formatSeconds(converted);
//
//       final strokeLabel = s.stroke.toUpperCase() == 'IM' ? 'IM' :
//       '${s.stroke[0].toUpperCase()}${s.stroke.substring(1).toLowerCase()}';
//       final genderLabel = '${s.gender[0].toUpperCase()}${s.gender.substring(1).toLowerCase()}';
//
//       // ✅ NEW CHECK: Detect if this specific result is 100 IM LCM
//       final bool is100ImLcm = s.stroke.toUpperCase() == 'IM' &&
//           s.distance == '100' &&
//           to.toUpperCase() == 'LCM';
//
//       // Only add to results if NOT 100 IM LCM
//       if (!is100ImLcm) {
//         results.add('$genderLabel ${s.distance} $strokeLabel ${s.timeText} ${s.course.toUpperCase()} → $displayDistance $strokeLabel ${to.toUpperCase()}: $convertedText');
//       }
//
//       if (s.showSplits) {
//         // Only add splits if NOT 100 IM LCM
//         if (!is100ImLcm) {
//           splitResults.add('$genderLabel ${s.distance} $strokeLabel ${s.timeText} ${s.course.toUpperCase()} → $displayDistance $strokeLabel ${to.toUpperCase()}: $convertedText');
//
//           String splitsText = '';
//           if (to == 'lcm' && displayDistance.toString() == '50') {
//             splitsText = _calculate50LcmSplits(converted, s.gender);
//           } else {
//             final ratios = SplitsCore1.getRatios(to, s.gender, s.stroke, displayDistance.toString()) ?? [];
//
//             splitsText = SplitsCore1.calculateSplits(
//               converted,
//               ratios,
//               int.parse(displayDistance.toString()),
//               targetCourse: to,
//             );
//           }
//           splitResults.add(splitsText);
//           splitResults.add('');
//         }
//       }
//     }
//
//     // Clean up the output: remove the headers if no valid results were added
//     if (results.length == 1) results.clear();
//     if (splitResults.length == 1) splitResults.clear();
//
//     final finalOutput = [
//       ...results,
//       if (results.isNotEmpty && splitResults.isNotEmpty) '',
//       ...splitResults,
//       if (s.output.isNotEmpty && (results.isNotEmpty || splitResults.isNotEmpty)) '',
//       if (s.output.isNotEmpty) s.output,
//     ].join('\n').trim();
//
//     state = s.copyWith(output: finalOutput);
//   }
//
//   /// SPECIAL 50 LCM SPLITS
//   String _calculate50LcmSplits(
//       double total,
//       String gender,
//       ) {
//     double m15;
//     double m25;
//     double m35;
//
//     if (gender == 'men') {
//       m15 = total * 0.238;
//       m25 = total * 0.448;
//       m35 = total * 0.659;
//     } else {
//       m15 = total * 0.248;
//       m25 = total * 0.456;
//       m35 = total * 0.671;
//     }
//
//     return '''
// 15m: ${TimeUtils1.formatSeconds(m15)}
// 25m: ${TimeUtils1.formatSeconds(m25)}
// 35m: ${TimeUtils1.formatSeconds(m35)}
// 50m: ${TimeUtils1.formatSeconds(total)}
// ''';
//   }
//
//   void reset() {
//     state = state.copyWith(output: '');
//   }
// }

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';

final converterProvider1 =
NotifierProvider<ConverterController, ConverterState>(
  ConverterController.new,
);

class ConverterState {
  final String course;
  final String gender;
  final String stroke;
  final String distance;
  final String timeText;
  final bool showSplits;
  final Set<String> targets;
  final bool preferWR;
  final String output;

  const ConverterState({
    this.course = 'scm',
    this.gender = 'men',
    this.stroke = 'free',
    this.distance = '100',
    this.timeText = '',
    this.showSplits = false,
    this.targets = const {},
    this.preferWR = true,
    this.output = '',
  });

  ConverterState copyWith({
    String? course,
    String? gender,
    String? stroke,
    String? distance,
    String? timeText,
    bool? showSplits,
    Set<String>? targets,
    bool? preferWR,
    String? output,
  }) {
    return ConverterState(
      course: course ?? this.course,
      gender: gender ?? this.gender,
      stroke: stroke ?? this.stroke,
      distance: distance ?? this.distance,
      timeText: timeText ?? this.timeText,
      showSplits: showSplits ?? this.showSplits,
      targets: targets ?? this.targets,
      preferWR: preferWR ?? this.preferWR,
      output: output ?? this.output,
    );
  }
}

// ==================== UTILITY FUNCTIONS ====================

double _mmssToSeconds(String mmss) {
  final trimmed = mmss.trim();
  if (trimmed.contains(':')) {
    final parts = trimmed.split(':');
    final m = double.parse(parts[0]);
    final s = double.parse(parts[1]);
    return m * 60 + s;
  }
  return double.parse(trimmed);
}

String _secondsToMmss(double seconds) {
  if (seconds < 60) {
    return seconds.toStringAsFixed(2);
  }
  final m = seconds ~/ 60;
  final sec = seconds % 60;
  return '$m:${sec.toStringAsFixed(2).padLeft(5, '0')}';
}

String _stripLeadingZero(String timeStr) {
  if (timeStr.startsWith('0:')) {
    return timeStr.substring(2);
  }
  return timeStr;
}

// ==================== NCAA CONVERSION DATA ====================

final Map<String, Map<String, double>> _ncaaScmToScy = {
  "free": {"50": 0.906, "100": 0.906, "200": 0.906, "400": 1.153, "800": 1.153, "1500": 1.013},
  "fly":  {"50": 0.906, "100": 0.906, "200": 0.906},
  "back": {"50": 0.906, "100": 0.906, "200": 0.906},
  "breast": {"50": 0.906, "100": 0.906, "200": 0.906},
  "im":  {"100": 0.906, "200": 0.906, "400": 0.906},
};

final Map<String, Map<String, double>> _ncaaScyToScm = () {
  final result = <String, Map<String, double>>{};
  for (final stroke in _ncaaScmToScy.keys) {
    result[stroke] = {};
    for (final dist in _ncaaScmToScy[stroke]!.keys) {
      result[stroke]![dist] = 1.0 / _ncaaScmToScy[stroke]![dist]!;
    }
  }
  return result;
}();

final double _scyToLcmFactor = 50.0 / 22.86;
final double _lcmToScyFactor = 1.0 / (50.0 / 22.86);

final Map<String, Map<String, double>> _ncaaScyToLcm = () {
  final result = <String, Map<String, double>>{};
  for (final stroke in _ncaaScmToScy.keys) {
    result[stroke] = {};
    for (final dist in _ncaaScmToScy[stroke]!.keys) {
      result[stroke]![dist] = 50.0 / 22.86;
    }
  }
  return result;
}();

final Map<String, Map<String, double>> _ncaaLcmToScy = () {
  final result = <String, Map<String, double>>{};
  for (final stroke in _ncaaScmToScy.keys) {
    result[stroke] = {};
    for (final dist in _ncaaScmToScy[stroke]!.keys) {
      result[stroke]![dist] = 1.0 / (50.0 / 22.86);
    }
  }
  return result;
}();

// ==================== FINA IM OVERRIDES ====================

final Map<String, Map<String, Map<String, double>>> _finaIm = {
  "men": {
    "lcm_to_scy": {"200": 0.857, "400": 0.885},
    "scy_to_lcm": {"200": 1.0 / 0.857, "400": 1.0 / 0.885},
  },
  "women": {
    "lcm_to_scy": {"200": 0.866, "400": 0.895},
    "scy_to_lcm": {"200": 1.0 / 0.866, "400": 1.0 / 0.895},
  },
};

// ==================== WORLD RECORD CONVERSION MULTIPLIERS ====================

final Map<String, Map<String, Map<String, Map<String, double?>>>> _conversion = {
  "men":       _buildMenScy(),
  "women":     _buildWomenScy(),
  "men_scm":   _buildMenScm(),
  "women_scm": _buildWomenScm(),
  "men_lcm":   _buildMenLcm(),
  "women_lcm": _buildWomenLcm(),
};

Map<String, Map<String, Map<String, double?>>> _buildMenScy() => {
  "free": {
    "50":   {"scy_to_scm": 19.90 / 17.63, "scy_to_lcm": 20.91 / 17.63},
    "100":  {"scy_to_scm": 44.84 / 39.83, "scy_to_lcm": 46.40 / 39.83},
    "200":  {"scy_to_scm": 98.61 / 88.83, "scy_to_lcm": 102.00 / 88.83},
    "500":  {"scy_to_scm": 212.25 / 242.31, "scy_to_lcm": 220.07 / 242.31},
    "1000": {"scy_to_scm": 440.46 / 513.93, "scy_to_lcm": 452.12 / 513.93},
    "1650": {"scy_to_scm": 846.88 / 852.08, "scy_to_lcm": 870.67 / 852.08},
  },
  "fly": {
    "50":  {"scy_to_scm": 21.51 / 19.38, "scy_to_lcm": 22.80 / 19.38},
    "100": {"scy_to_scm": 47.71 / 42.80, "scy_to_lcm": 49.45 / 42.80},
    "200": {"scy_to_scm": 106.85 / 97.35, "scy_to_lcm": 110.34 / 97.35},
  },
  "back": {
    "50":  {"scy_to_scm": 22.37 / 20.00, "scy_to_lcm": 24.36 / 20.00},
    "100": {"scy_to_scm": 48.33 / 43.35, "scy_to_lcm": 51.60 / 43.35},
    "200": {"scy_to_scm": 105.63 / 95.37, "scy_to_lcm": 111.92 / 95.37},
  },
  "breast": {
    "50":  {"scy_to_scm": 25.52 / 23.35, "scy_to_lcm": 26.57 / 23.35},
    "100": {"scy_to_scm": 55.28 / 49.53, "scy_to_lcm": 56.88 / 49.53},
    "200": {"scy_to_scm": 119.52 / 105.35, "scy_to_lcm": 125.48 / 105.35},
  },
  "im": {
    "100": {"scy_to_scm": 49.28 / 45.74, "scy_to_lcm": null},
    "200": {"scy_to_scm": 108.88 / 96.34, "scy_to_lcm": 116.00 / 96.34},
    "400": {"scy_to_scm": 234.81 / 208.82, "scy_to_lcm": 242.50 / 208.82},
  },
};

Map<String, Map<String, Map<String, double?>>> _buildWomenScy() => {
  "free": {
    "50":   {"scy_to_scm": 22.83 / 20.37, "scy_to_lcm": 23.61 / 20.37},
    "100":  {"scy_to_scm": 50.25 / 44.83, "scy_to_lcm": 51.71 / 44.83},
    "200":  {"scy_to_scm": 110.31 / 99.10, "scy_to_lcm": 112.23 / 99.10},
    "500":  {"scy_to_scm": 230.25 / 264.06, "scy_to_lcm": 235.38 / 264.06},
    "1000": {"scy_to_scm": 477.42 / 539.65, "scy_to_lcm": 484.79 / 539.65},
    "1650": {"scy_to_scm": 908.24 / 901.41, "scy_to_lcm": 920.48 / 901.41},
  },
  "fly": {
    "50":  {"scy_to_scm": 23.72 / 21.23, "scy_to_lcm": 25.18 / 21.23},
    "100": {"scy_to_scm": 52.71 / 47.35, "scy_to_lcm": 55.18 / 47.35},
    "200": {"scy_to_scm": 119.32 / 108.33, "scy_to_lcm": 121.81 / 108.33},
  },
  "back": {
    "50":  {"scy_to_scm": 25.35 / 22.10, "scy_to_lcm": 27.28 / 22.10},
    "100": {"scy_to_scm": 54.02 / 48.10, "scy_to_lcm": 57.13 / 48.10},
    "200": {"scy_to_scm": 118.04 / 106.87, "scy_to_lcm": 123.14 / 106.87},
  },
  "breast": {
    "50":  {"scy_to_scm": 28.81 / 25.59, "scy_to_lcm": 30.00 / 25.59},
    "100": {"scy_to_scm": 62.36 / 55.73, "scy_to_lcm": 64.13 / 55.73},
    "200": {"scy_to_scm": 132.50 / 121.29, "scy_to_lcm": 137.55 / 121.29},
  },
  "im": {
    "100": {"scy_to_scm": 55.11 / 51.97, "scy_to_lcm": null},
    "200": {"scy_to_scm": 121.63 / 108.37, "scy_to_lcm": 126.12 / 108.37},
    "400": {"scy_to_scm": 255.48 / 234.60, "scy_to_lcm": 264.38 / 234.60},
  },
};

Map<String, Map<String, Map<String, double?>>> _buildMenScm() => {
  "free": {
    "50":   {"scm_to_scy": 17.63 / 19.90, "scm_to_lcm": 20.91 / 19.90},
    "100":  {"scm_to_scy": 39.83 / 44.84, "scm_to_lcm": 46.40 / 44.84},
    "200":  {"scm_to_scy": 88.83 / 98.61, "scm_to_lcm": 102.00 / 98.61},
    "400":  {"scm_to_scy": 242.31 / 212.25, "scm_to_lcm": 220.07 / 212.25},
    "800":  {"scm_to_scy": 513.93 / 440.46, "scm_to_lcm": 452.12 / 440.46},
    "1500": {"scm_to_scy": 852.08 / 846.88, "scm_to_lcm": 870.67 / 846.88},
  },
  "fly": {
    "50":  {"scm_to_scy": 19.38 / 21.51, "scm_to_lcm": 22.80 / 21.51},
    "100": {"scm_to_scy": 42.80 / 47.71, "scm_to_lcm": 49.45 / 47.71},
    "200": {"scm_to_scy": 97.35 / 106.85, "scm_to_lcm": 110.34 / 106.85},
  },
  "back": {
    "50":  {"scm_to_scy": 20.00 / 22.37, "scm_to_lcm": 24.36 / 22.37},
    "100": {"scm_to_scy": 43.35 / 48.33, "scm_to_lcm": 51.60 / 48.33},
    "200": {"scm_to_scy": 95.37 / 105.63, "scm_to_lcm": 111.92 / 105.63},
  },
  "breast": {
    "50":  {"scm_to_scy": 23.35 / 25.52, "scm_to_lcm": 26.57 / 25.52},
    "100": {"scm_to_scy": 49.53 / 55.28, "scm_to_lcm": 56.88 / 55.28},
    "200": {"scm_to_scy": 105.35 / 119.52, "scm_to_lcm": 125.48 / 119.52},
  },
  "im": {
    "100": {"scm_to_scy": 45.74 / 49.28, "scm_to_lcm": null},
    "200": {"scm_to_scy": 96.34 / 108.88, "scm_to_lcm": 116.00 / 108.88},
    "400": {"scm_to_scy": 208.82 / 234.81, "scm_to_lcm": 242.50 / 234.81},
  },
};

Map<String, Map<String, Map<String, double?>>> _buildWomenScm() => {
  "free": {
    "50":   {"scm_to_scy": 20.37 / 22.83, "scm_to_lcm": 23.61 / 22.83},
    "100":  {"scm_to_scy": 44.83 / 50.25, "scm_to_lcm": 51.71 / 50.25},
    "200":  {"scm_to_scy": 99.10 / 110.31, "scm_to_lcm": 112.23 / 110.31},
    "400":  {"scm_to_scy": 264.06 / 230.25, "scm_to_lcm": 235.38 / 230.25},
    "800":  {"scm_to_scy": 539.65 / 477.42, "scm_to_lcm": 484.79 / 477.42},
    "1500": {"scm_to_scy": 901.41 / 908.24, "scm_to_lcm": 920.48 / 908.24},
  },
  "fly": {
    "50":  {"scm_to_scy": 21.23 / 23.72, "scm_to_lcm": 25.18 / 23.72},
    "100": {"scm_to_scy": 47.35 / 52.71, "scm_to_lcm": 55.18 / 52.71},
    "200": {"scm_to_scy": 108.33 / 119.32, "scm_to_lcm": 121.81 / 119.32},
  },
  "back": {
    "50":  {"scm_to_scy": 22.10 / 25.35, "scm_to_lcm": 27.28 / 25.35},
    "100": {"scm_to_scy": 48.10 / 54.02, "scm_to_lcm": 57.13 / 54.02},
    "200": {"scm_to_scy": 106.87 / 118.04, "scm_to_lcm": 123.14 / 118.04},
  },
  "breast": {
    "50":  {"scm_to_scy": 25.59 / 28.81, "scm_to_lcm": 30.00 / 28.81},
    "100": {"scm_to_scy": 55.73 / 62.36, "scm_to_lcm": 64.13 / 62.36},
    "200": {"scm_to_scy": 121.29 / 132.50, "scm_to_lcm": 137.55 / 132.50},
  },
  "im": {
    "100": {"scm_to_scy": 51.97 / 55.11, "scm_to_lcm": null},
    "200": {"scm_to_scy": 108.37 / 121.63, "scm_to_lcm": 126.12 / 121.63},
    "400": {"scm_to_scy": 234.60 / 255.48, "scm_to_lcm": 264.38 / 255.48},
  },
};

Map<String, Map<String, Map<String, double?>>> _buildMenLcm() => {
  "free": {
    "50":   {"lcm_to_scy": 17.63 / 20.91, "lcm_to_scm": 19.90 / 20.91},
    "100":  {"lcm_to_scy": 39.83 / 46.40, "lcm_to_scm": 44.84 / 46.40},
    "200":  {"lcm_to_scy": 88.83 / 102.00, "lcm_to_scm": 98.61 / 102.00},
    "400":  {"lcm_to_scy": 242.31 / 220.07, "lcm_to_scm": 212.25 / 220.07},
    "800":  {"lcm_to_scy": 513.93 / 452.12, "lcm_to_scm": 440.46 / 452.12},
    "1500": {"lcm_to_scy": 852.08 / 870.67, "lcm_to_scm": 846.88 / 870.67},
  },
  "fly": {
    "50":  {"lcm_to_scy": 19.38 / 22.80, "lcm_to_scm": 21.51 / 22.80},
    "100": {"lcm_to_scy": 42.80 / 49.45, "lcm_to_scm": 47.71 / 49.45},
    "200": {"lcm_to_scy": 97.35 / 110.34, "lcm_to_scm": 106.85 / 110.34},
  },
  "back": {
    "50":  {"lcm_to_scy": 20.00 / 24.36, "lcm_to_scm": 22.37 / 24.36},
    "100": {"lcm_to_scy": 43.35 / 51.60, "lcm_to_scm": 48.33 / 51.60},
    "200": {"lcm_to_scy": 95.37 / 111.92, "lcm_to_scm": 105.63 / 111.92},
  },
  "breast": {
    "50":  {"lcm_to_scy": 23.35 / 26.57, "lcm_to_scm": 25.52 / 26.57},
    "100": {"lcm_to_scy": 49.53 / 56.88, "lcm_to_scm": 55.28 / 56.88},
    "200": {"lcm_to_scy": 105.35 / 125.48, "lcm_to_scm": 119.52 / 125.48},
  },
  "im": {
    "200": {"lcm_to_scy": 96.34 / 116.00, "lcm_to_scm": 108.88 / 116.00},
    "400": {"lcm_to_scy": 208.82 / 242.50, "lcm_to_scm": 234.81 / 242.50},
  },
};

Map<String, Map<String, Map<String, double?>>> _buildWomenLcm() => {
  "free": {
    "50":   {"lcm_to_scy": 20.37 / 23.61, "lcm_to_scm": 22.83 / 23.61},
    "100":  {"lcm_to_scy": 44.83 / 51.71, "lcm_to_scm": 50.25 / 51.71},
    "200":  {"lcm_to_scy": 99.10 / 112.23, "lcm_to_scm": 110.31 / 112.23},
    "400":  {"lcm_to_scy": 264.06 / 235.38, "lcm_to_scm": 230.25 / 235.38},
    "800":  {"lcm_to_scy": 539.65 / 484.79, "lcm_to_scm": 477.42 / 484.79},
    "1500": {"lcm_to_scy": 901.41 / 920.48, "lcm_to_scm": 908.24 / 920.48},
  },
  "fly": {
    "50":  {"lcm_to_scy": 21.23 / 25.18, "lcm_to_scm": 23.72 / 25.18},
    "100": {"lcm_to_scy": 47.35 / 55.18, "lcm_to_scm": 52.71 / 55.18},
    "200": {"lcm_to_scy": 108.33 / 121.81, "lcm_to_scm": 119.32 / 121.81},
  },
  "back": {
    "50":  {"lcm_to_scy": 22.10 / 27.28, "lcm_to_scm": 25.35 / 27.28},
    "100": {"lcm_to_scy": 48.10 / 57.13, "lcm_to_scm": 54.02 / 57.13},
    "200": {"lcm_to_scy": 106.87 / 123.14, "lcm_to_scm": 118.04 / 123.14},
  },
  "breast": {
    "50":  {"lcm_to_scy": 25.59 / 30.00, "lcm_to_scm": 28.81 / 30.00},
    "100": {"lcm_to_scy": 55.73 / 64.13, "lcm_to_scm": 62.36 / 64.13},
    "200": {"lcm_to_scy": 121.29 / 137.55, "lcm_to_scm": 132.50 / 137.55},
  },
  "im": {
    "200": {"lcm_to_scy": 108.37 / 126.12, "lcm_to_scm": 121.63 / 126.12},
    "400": {"lcm_to_scy": 234.60 / 264.38, "lcm_to_scm": 255.48 / 264.38},
  },
};

// ==================== SPLIT RATIOS ====================

final Map<String, Map<String, Map<String, List<double>>>> _ratiosScm = {
  "women": {
    "free": {
      "50":   [0.4843, 0.5157],
      "100":  [0.2283, 0.2526, 0.2590, 0.2601],
      "200":  [0.2332, 0.2507, 0.2569, 0.2592],
      "400":  [0.1157, 0.1244, 0.1257, 0.1265, 0.1265, 0.1271, 0.1280, 0.1260],
      "800":  [0.0570, 0.0615, 0.0624, 0.0629, 0.0633, 0.0635, 0.0634, 0.0635,
        0.0633, 0.0632, 0.0633, 0.0632, 0.0629, 0.0631, 0.0625, 0.0611],
      "1500": [0.0318, 0.0331, 0.0333, 0.0332, 0.0333, 0.0334, 0.0333, 0.0334,
        0.0333, 0.0332, 0.0334, 0.0335, 0.0334, 0.0335, 0.0334, 0.0336,
        0.0335, 0.0334, 0.0335, 0.0334, 0.0336, 0.0335, 0.0334, 0.0336,
        0.0335, 0.0336, 0.0335, 0.0336, 0.0335, 0.0328],
    },
    "fly": {
      "50":  [0.4668, 0.5332],
      "100": [0.2120, 0.2525, 0.2634, 0.2721],
      "200": [0.2257, 0.2519, 0.2600, 0.2624],
    },
    "back": {
      "50":  [0.4913, 0.5087],
      "100": [0.2338, 0.2473, 0.2588, 0.2601],
      "200": [0.2354, 0.2524, 0.2561, 0.2563],
    },
    "breast": {
      "50":  [0.4571, 0.5429],
      "100": [0.2127, 0.2573, 0.2627, 0.2673],
      "200": [0.2286, 0.2534, 0.2575, 0.2606],
    },
    "im": {
      "100": [0.2065, 0.2473, 0.2991, 0.2471],
      "200": [0.2179, 0.2523, 0.2883, 0.2415],
      "400": [0.1072, 0.1220, 0.1287, 0.1268, 0.1410, 0.1440, 0.1171, 0.1132],
    },
  },
  "men": {
    "free": {
      "50":   [0.4791, 0.5209],
      "100":  [0.2262, 0.2513, 0.2605, 0.2620],
      "200":  [0.2337, 0.2519, 0.2565, 0.2579],
      "400":  [0.1153, 0.1262, 0.1274, 0.1282, 0.1263, 0.1264, 0.1261, 0.1241],
      "800":  [0.0567, 0.0612, 0.0622, 0.0628, 0.0628, 0.0631, 0.0632, 0.0635,
        0.0634, 0.0635, 0.0634, 0.0636, 0.0635, 0.0633, 0.0632, 0.0610],
      "1500": [0.0304, 0.0328, 0.0331, 0.0335, 0.0336, 0.0335, 0.0336, 0.0334,
        0.0335, 0.0336, 0.0335, 0.0334, 0.0335, 0.0334, 0.0335, 0.0334,
        0.0336, 0.0335, 0.0336, 0.0337, 0.0336, 0.0337, 0.0336, 0.0337,
        0.0336, 0.0335, 0.0336, 0.0335, 0.0331, 0.0315],
    },
    "fly": {
      "50":  [0.4553, 0.5447],
      "100": [0.2134, 0.2509, 0.2617, 0.2740],
      "200": [0.2283, 0.2536, 0.2577, 0.2605],
    },
    "back": {
      "50":  [0.4906, 0.5094],
      "100": [0.2330, 0.2483, 0.2579, 0.2608],
      "200": [0.2351, 0.2543, 0.2541, 0.2565],
    },
    "breast": {
      "50":  [0.4506, 0.5494],
      "100": [0.2096, 0.2558, 0.2633, 0.2713],
      "200": [0.2250, 0.2519, 0.2606, 0.2625],
    },
    "im": {
      "100": [0.2025, 0.2491, 0.2986, 0.2498],
      "200": [0.2158, 0.2492, 0.2875, 0.2475],
      "400": [0.1067, 0.1219, 0.1284, 0.1264, 0.1407, 0.1437, 0.1186, 0.1136],
    },
  },
};

final Map<String, Map<String, Map<String, List<double>>>> _ratiosScy = {
  "men": {
    "free": {
      "50":   [0.4828, 0.5172],
      "100":  [0.2233, 0.2508, 0.2618, 0.2641],
      "200":  [0.2297, 0.2527, 0.2569, 0.2607],
      "500":  [0.0912, 0.1000, 0.1015, 0.1019, 0.1021, 0.1021, 0.1016, 0.1013, 0.1004, 0.0979],
      "1000": [0.0455, 0.0490, 0.0496, 0.0498, 0.0500, 0.0501, 0.0501, 0.0503, 0.0503, 0.0505,
        0.0502, 0.0502, 0.0507, 0.0508, 0.0509, 0.0505, 0.0507, 0.0508, 0.0508, 0.0493],
      "1650": [0.0278, 0.0302, 0.0304, 0.0306, 0.0305, 0.0307, 0.0306, 0.0306, 0.0307, 0.0306,
        0.0305, 0.0306, 0.0305, 0.0305, 0.0306, 0.0305, 0.0306, 0.0305, 0.0304, 0.0303,
        0.0304, 0.0305, 0.0304, 0.0306, 0.0303, 0.0304, 0.0305, 0.0303, 0.0302, 0.0303,
        0.0302, 0.0299, 0.0285],
    },
    "fly": {
      "50":  [0.460, 0.540],
      "100": [0.2121, 0.2537, 0.2630, 0.2712],
      "200": [0.2236, 0.2539, 0.2581, 0.2644],
    },
    "breast": {
      "50":  [0.448, 0.552],
      "100": [0.2110, 0.2562, 0.2625, 0.2703],
      "200": [0.2237, 0.2537, 0.2587, 0.2639],
    },
    "back": {
      "50":  [0.483, 0.517],
      "100": [0.2346, 0.2483, 0.2583, 0.2588],
      "200": [0.2340, 0.2532, 0.2561, 0.2567],
    },
    "im": {
      "100": [0.205, 0.249, 0.299, 0.247],
      "200": [0.2134, 0.2489, 0.2919, 0.2458],
      "400": [0.1056, 0.1212, 0.1288, 0.1257, 0.1417, 0.1441, 0.1190, 0.1139],
    },
  },
  "women": {
    "free": {
      "50":   [0.4845, 0.5155],
      "100":  [0.2264, 0.2521, 0.2596, 0.2619],
      "200":  [0.2346, 0.2542, 0.2552, 0.2560],
      "500":  [0.0927, 0.0999, 0.1009, 0.1015, 0.1015, 0.1014, 0.1014, 0.1010, 0.1008, 0.0989],
      "1000": [0.0473, 0.0500, 0.0507, 0.0508, 0.0505, 0.0504, 0.0501, 0.0499, 0.0502, 0.0500,
        0.0499, 0.0498, 0.0499, 0.0501, 0.0499, 0.0502, 0.0505, 0.0503, 0.0504, 0.0491],
      "1650": [0.0279, 0.0303, 0.0307, 0.0307, 0.0308, 0.0307, 0.0307, 0.0308, 0.0307, 0.0307,
        0.0306, 0.0304, 0.0305, 0.0302, 0.0303, 0.0303, 0.0301, 0.0304, 0.0303, 0.0304,
        0.0302, 0.0302, 0.0302, 0.0301, 0.0303, 0.0302, 0.0304, 0.0304, 0.0302, 0.0303,
        0.0301, 0.0301, 0.0293],
    },
    "fly": {
      "50":  [0.4692, 0.5308],
      "100": [0.2126, 0.2536, 0.2635, 0.2703],
      "200": [0.2235, 0.2534, 0.2584, 0.2647],
    },
    "breast": {
      "50":  [0.4560, 0.5440],
      "100": [0.2220, 0.2490, 0.2620, 0.2670],
      "200": [0.2328, 0.2509, 0.2549, 0.2614],
    },
    "back": {
      "50":  [0.4880, 0.5120],
      "100": [0.2363, 0.2484, 0.2573, 0.2580],
      "200": [0.2328, 0.2506, 0.2576, 0.2590],
    },
    "im": {
      "100": [0.2100, 0.2570, 0.3000, 0.2330],
      "200": [0.2159, 0.2505, 0.2911, 0.2425],
      "400": [0.1096, 0.1188, 0.1267, 0.1258, 0.1398, 0.1428, 0.1184, 0.1180],
    },
  },
};

final Map<String, Map<String, Map<String, List<double>>>> _ratiosLcm = {
  "women": {
    "fly": {
      "100": [0.468, 0.532],
      "200": [0.225, 0.254, 0.258, 0.263],
    },
    "back": {
      "100": [0.486, 0.514],
      "200": [0.235, 0.251, 0.256, 0.258],
    },
    "breast": {
      "100": [0.465, 0.535],
      "200": [0.232, 0.251, 0.257, 0.260],
    },
    "free": {
      "100": [0.481, 0.519],
      "200": [0.235, 0.252, 0.256, 0.257],
      "400": [0.1151, 0.1245, 0.1262, 0.1268, 0.1267, 0.1273, 0.1278, 0.1256],
      "800": [0.0563, 0.0607, 0.0620, 0.0628, 0.0631, 0.0635, 0.0636, 0.0634,
        0.0636, 0.0637, 0.0635, 0.0632, 0.0630, 0.0630, 0.0628, 0.0618],
      "1500": [0.0301, 0.0323, 0.0329, 0.0330, 0.0331, 0.0333, 0.0334, 0.0334,
        0.0333, 0.0335, 0.0334, 0.0335, 0.0336, 0.0337, 0.0338, 0.0336,
        0.0337, 0.0335, 0.0336, 0.0337, 0.0335, 0.0338, 0.0336, 0.0341,
        0.0335, 0.0339, 0.0336, 0.0339, 0.0335, 0.0322],
    },
    "im": {
      "200": [0.214, 0.254, 0.291, 0.241],
      "400": [0.1049, 0.1204, 0.1285, 0.1268, 0.1424, 0.1467, 0.1188, 0.1114],
    },
  },
  "men": {
    "back": {
      "100": [0.4832, 0.5168],
      "200": [0.2353, 0.2522, 0.2556, 0.2569],
    },
    "breast": {
      "100": [0.4660, 0.5340],
      "200": [0.2282, 0.2547, 0.2572, 0.2599],
    },
    "fly": {
      "100": [0.4678, 0.5322],
      "200": [0.2210, 0.2534, 0.2589, 0.2667],
    },
    "free": {
      "100": [0.4800, 0.5200],
      "200": [0.2330, 0.2532, 0.2567, 0.2571],
      "400": [0.1156, 0.1249, 0.1267, 0.1276, 0.1275, 0.1276, 0.1268, 0.1233],
      "800": [0.0577, 0.0617, 0.0622, 0.0625, 0.0626, 0.0627, 0.0628, 0.0629,
        0.0630, 0.0631, 0.0632, 0.0634, 0.0635, 0.0636, 0.0633, 0.0618],
      "1500": [0.0308, 0.0329, 0.0336, 0.0332, 0.0334, 0.0333, 0.0338, 0.0336,
        0.0337, 0.0336, 0.0339, 0.0336, 0.0338, 0.0336, 0.0338, 0.0337,
        0.0336, 0.0334, 0.0335, 0.0334, 0.0336, 0.0335, 0.0334, 0.0335,
        0.0334, 0.0335, 0.0336, 0.0337, 0.0333, 0.0302],
    },
    "im": {
      "200": [0.2140, 0.2523, 0.2896, 0.2441],
      "400": [0.1041, 0.1199, 0.1298, 0.1270, 0.1421, 0.1438, 0.1193, 0.1140],
    },
  },
};

final Map<String, Map<String, double>> _lcm50Splits = {
  "men":   {"15": 0.238, "25": 0.448, "35": 0.659},
  "women": {"15": 0.248, "25": 0.456, "35": 0.671},
};

// ==================== CORE COMPUTATION FUNCTIONS ====================

double? _tryGetWrMultiplier(String key, String stroke, String distance, String convType) {
  try {
    return _conversion[key]?[stroke]?[distance]?[convType];
  } catch (_) {
    return null;
  }
}

double? _tryGetNcaaValue(Map<String, Map<String, double>> ncaaMap, String stroke, String distance) {
  try {
    return ncaaMap[stroke]?[distance];
  } catch (_) {
    return null;
  }
}

double _computeMultiplier(
    String gender, String stroke, String distance, String sourceCourse, String targetCourse) {
  const poolLen = {"scy": 22.86, "scm": 25.0, "lcm": 50.0};

  if (sourceCourse == "scy" || targetCourse == "scy") {
    if (sourceCourse == "scm" && targetCourse == "scy") {
      final wrMult = _tryGetWrMultiplier("${gender}_scm", stroke, distance, "scm_to_scy");
      if (wrMult != null) return wrMult;
      final ncaaVal = _tryGetNcaaValue(_ncaaScmToScy, stroke, distance);
      if (ncaaVal != null) return ncaaVal;
      return poolLen[targetCourse]! / poolLen[sourceCourse]!;
    }
    if (sourceCourse == "scy" && targetCourse == "scm") {
      final wrMult = _tryGetWrMultiplier(gender, stroke, distance, "scy_to_scm");
      if (wrMult != null) return wrMult;
      final ncaaVal = _tryGetNcaaValue(_ncaaScyToScm, stroke, distance);
      if (ncaaVal != null) return ncaaVal;
      return poolLen[targetCourse]! / poolLen[sourceCourse]!;
    }
    if (sourceCourse == "lcm" && targetCourse == "scy") {
      if (stroke == "im") {
        final finaVal = _finaIm[gender]?["lcm_to_scy"]?[distance];
        if (finaVal != null) return finaVal;
      }
      final wrMult = _tryGetWrMultiplier("${gender}_lcm", stroke, distance, "lcm_to_scy");
      if (wrMult != null) return wrMult;
      final ncaaVal = _tryGetNcaaValue(_ncaaLcmToScy, stroke, distance);
      if (ncaaVal != null) return ncaaVal;
      return poolLen[targetCourse]! / poolLen[sourceCourse]!;
    }
    if (sourceCourse == "scy" && targetCourse == "lcm") {
      if (stroke == "im") {
        final finaVal = _finaIm[gender]?["scy_to_lcm"]?[distance];
        if (finaVal != null) return finaVal;
      }
      final wrMult = _tryGetWrMultiplier(gender, stroke, distance, "scy_to_lcm");
      if (wrMult != null) return wrMult;
      final ncaaVal = _tryGetNcaaValue(_ncaaScyToLcm, stroke, distance);
      if (ncaaVal != null) return ncaaVal;
      return poolLen[targetCourse]! / poolLen[sourceCourse]!;
    }
    return poolLen[targetCourse]! / poolLen[sourceCourse]!;
  }

  // Pure metric (SCM ↔ LCM)
  if (sourceCourse == "scm" && targetCourse == "lcm") {
    final wrMult = _tryGetWrMultiplier("${gender}_scm", stroke, distance, "scm_to_lcm");
    if (wrMult != null) return wrMult;
  }
  if (sourceCourse == "lcm" && targetCourse == "scm") {
    final wrMult = _tryGetWrMultiplier("${gender}_lcm", stroke, distance, "lcm_to_scm");
    if (wrMult != null) return wrMult;
  }

  return poolLen[targetCourse]! / poolLen[sourceCourse]!;
}

/// Simple pool ratio (no WR data), used when preferWR is false.
double _poolRatio(String sourceCourse, String targetCourse) {
  const poolLen = {"scy": 22.86, "scm": 25.0, "lcm": 50.0};
  return poolLen[targetCourse]! / poolLen[sourceCourse]!;
}

String _getDisplayDistance(
    String stroke,
    String distance,
    String course,
    String targetCourse,
    ) {
  final s = stroke.toLowerCase();
  final from = course.toLowerCase();
  final to = targetCourse.toLowerCase();

  /// ===== FREESTYLE SPECIAL EVENTS =====
  if (s == "free") {
    // SCY -> SCM / LCM
    if (distance == "500" &&
        from == "scy" &&
        (to == "scm" || to == "lcm")) {
      return "400";
    }

    if (distance == "1000" &&
        from == "scy" &&
        (to == "scm" || to == "lcm")) {
      return "800";
    }

    if (distance == "1650" &&
        from == "scy" &&
        (to == "scm" || to == "lcm")) {
      return "1500";
    }

    // SCM / LCM -> SCY
    if (distance == "400" &&
        (from == "scm" || from == "lcm") &&
        to == "scy") {
      return "500";
    }

    if (distance == "800" &&
        (from == "scm" || from == "lcm") &&
        to == "scy") {
      return "1000";
    }

    if (distance == "1500" &&
        (from == "scm" || from == "lcm") &&
        to == "scy") {
      return "1650";
    }
  }

  /// ===== IM SPECIAL RULE =====
  /// No 100 IM in LCM
  if (s == "im") {
    if (distance == "100" && to == "lcm") {
      return "";
    }

    if (distance == "100" &&
        from == "scm" &&
        to == "scy") {
      return "100";
    }
  }

  /// ===== ALL OTHER STROKES =====
  return distance;
}

List<double> _getOrGenerateRatios(
    String gender,
    String stroke,
    String distance,
    Map<String, Map<String, Map<String, List<double>>>> ratioSource,
    bool isLcm) {
  final ratios = ratioSource[gender]?[stroke]?[distance];
  if (ratios != null) return ratios;

  final distInt = int.tryParse(distance) ?? 0;
  if (distInt == 50) return isLcm ? [1.0] : [0.5, 0.5];
  if (distInt == 100) return [0.25, 0.25, 0.25, 0.25];
  return List.filled(distInt ~/ 50, 1.0);
}

List<String> _calculateSplits(
    double totalSeconds, List<double> ratioList, int distance, String targetCourse) {
  final output = <String>[];

  if ((targetCourse == "scy" || targetCourse == "scm") &&
      (distance == 50 || distance == 100)) {
    final numSegments = distance ~/ 25;
    final totalRatio = ratioList.reduce((a, b) => a + b);
    final normalized = ratioList.length != numSegments
        ? ratioList.map((r) => r / totalRatio).toList()
        : ratioList;

    final segmentTimes = normalized.map((r) => totalSeconds * r).toList();
    output.add("--- Splits ---");
    var cumulative = 0.0;

    for (var i = 0; i < numSegments; i++) {
      final distOut = (i + 1) * 25;
      final splitVal = segmentTimes[i];
      cumulative += splitVal;

      final splitStr = _stripLeadingZero(_secondsToMmss(splitVal));
      final cumStr = _stripLeadingZero(_secondsToMmss(cumulative));

      if (distance == 100 && distOut == 100) {
        final last25 = segmentTimes[3];
        final last50 = segmentTimes[2] + segmentTimes[3];
        final last25Str = _stripLeadingZero(_secondsToMmss(last25));
        final last50Str = _stripLeadingZero(_secondsToMmss(last50));
        output.add("$distOut: $last25Str / $last50Str / $cumStr");
        continue;
      }
      output.add("$distOut: $splitStr / $cumStr");
    }
    return output;
  }

  // All other events (LCM, 200+)
  final ratioSum = ratioList.reduce((a, b) => a + b);
  final normalized = ratioList.map((r) => r / ratioSum).toList();
  final splits = normalized.map((r) => totalSeconds * r).toList();

  output.add("--- Splits ---");
  var cumulative = 0.0;

  for (var i = 0; i < splits.length; i++) {
    final distOut = (i + 1) * 50;
    cumulative += splits[i];

    final splitStr = _stripLeadingZero(_secondsToMmss(splits[i]));
    final cumStr = _stripLeadingZero(_secondsToMmss(cumulative));

    if (distOut % 100 == 0) {
      final last50 = splits[i];
      final mid100 = i > 0 ? splits[i - 1] + splits[i] : splits[i];
      final last50Str = _stripLeadingZero(_secondsToMmss(last50));
      final mid100Str = _stripLeadingZero(_secondsToMmss(mid100));
      output.add("$distOut: $last50Str / $mid100Str / $cumStr");
      continue;
    }
    output.add("$distOut: $splitStr / $cumStr");
  }
  return output;
}

// ==================== CONTROLLER ====================

class ConverterController extends Notifier<ConverterState> {
  @override
  ConverterState build() {
    return const ConverterState();
  }

  void setCourse(String v) {
    final newTargets = {...state.targets};
    newTargets.remove(v.toLowerCase());
    state = state.copyWith(course: v.toLowerCase(), targets: newTargets);
  }

  void setGender(String v) => state = state.copyWith(gender: v.toLowerCase());
  void setStroke(String v) => state = state.copyWith(stroke: v.toLowerCase());
  void setDistance(String v) => state = state.copyWith(distance: v);
  void setTimeText(String v) => state = state.copyWith(timeText: v);
  void setShowSplits(bool v) => state = state.copyWith(showSplits: v);

  void toggleTarget(String v, bool selected) {
    final key = v.toLowerCase();
    final newTargets = {...state.targets};
    if (selected) {
      if (key != state.course) newTargets.add(key);
    } else {
      newTargets.remove(key);
    }
    state = state.copyWith(targets: newTargets);
  }

  List<String> allowedTargets() {
    return ['scy', 'scm', 'lcm'].where((e) => e != state.course).toList();
  }

  void convert({required context}) {
    final s = state;

    if ([s.course, s.gender, s.stroke, s.distance, s.timeText]
        .any((e) => e.trim().isEmpty)) {
      state = s.copyWith(
        output:
        '${AppLocalizations.of(context)!.pleaseFillAllFields}\n\n${s.output}',
      );
      return;
    }

    double totalSeconds;
    try {
      totalSeconds = _mmssToSeconds(s.timeText.trim());
    } catch (_) {
      state = s.copyWith(
        output:
        '${AppLocalizations.of(context)!.invalidTimeFormat}\n\n${s.output}',
      );
      return;
    }

    final results = <String>[];
    final splitResults = <String>[];

    results.add('=== Conversion Results ===');

    final targets = s.targets.isEmpty
        ? allowedTargets()
        : allowedTargets().where((e) => s.targets.contains(e)).toList();

    for (final to in targets) {
      if (s.course.toLowerCase() == 'lcm' &&
          s.stroke.toLowerCase() == 'im' &&
          s.distance == '100' &&
          to.toLowerCase() == 'lcm') continue;

      final displayDistance =
      _getDisplayDistance(s.stroke, s.distance, s.course, to);

      if (displayDistance.isEmpty) continue;

      final multiplier = s.preferWR
          ? _computeMultiplier(s.gender, s.stroke, s.distance, s.course, to)
          : _poolRatio(s.course, to);

      final converted = totalSeconds * multiplier;
      final convertedText = _secondsToMmss(converted);

      final strokeLabel = s.stroke.toUpperCase() == 'IM'
          ? 'IM'
          : '${s.stroke[0].toUpperCase()}${s.stroke.substring(1).toLowerCase()}';

      final genderLabel =
          '${s.gender[0].toUpperCase()}${s.gender.substring(1).toLowerCase()}';

      final bool is100ImLcm = s.stroke.toUpperCase() == 'IM' &&
          s.distance == '100' &&
          to.toUpperCase() == 'LCM';

      if (!is100ImLcm) {
        results.add(
          '$genderLabel ${s.distance} $strokeLabel ${s.timeText} ${s.course.toUpperCase()} '
              '→ $displayDistance $strokeLabel ${to.toUpperCase()}: $convertedText',
        );
      }

      if (s.showSplits && !is100ImLcm) {
        splitResults.add(
          '$genderLabel ${s.distance} $strokeLabel ${s.timeText} ${s.course.toUpperCase()} '
              '→ $displayDistance $strokeLabel ${to.toUpperCase()}: $convertedText',
        );

        String splitsText;

        if (to == 'lcm' && displayDistance == '50') {
          splitsText = _calculate50LcmSplits(converted, s.gender);
        } else {
          final ratioSource = to == 'scy'
              ? _ratiosScy
              : to == 'scm'
              ? _ratiosScm
              : _ratiosLcm;

          final ratios = _getOrGenerateRatios(
            s.gender,
            s.stroke,
            displayDistance,
            ratioSource,
            to == 'lcm',
          );

          final splitLines = _calculateSplits(
            converted,
            ratios,
            int.parse(displayDistance),
            to,
          );

          splitsText = splitLines.join('\n');
        }

        splitResults.add(splitsText);
      }
    }

    final List<String> sections = [];

    if (results.length > 1) {
      sections.add(results.join('\n'));
    }

    if (splitResults.isNotEmpty) {
      sections.add(splitResults.join('\n\n'));
    }

    if (s.output.isNotEmpty) {
      sections.add(s.output);
    }

    final finalOutput = sections.join('\n\n').trim();

    state = s.copyWith(output: finalOutput);
  }

  String _calculate50LcmSplits(double total, String gender) {
    final r = _lcm50Splits[gender]!;
    final m15 = total * r["15"]!;
    final m25 = total * r["25"]!;
    final m35 = total * r["35"]!;

    return '''
15m: ${_secondsToMmss(m15)}
25m: ${_secondsToMmss(m25)}
35m: ${_secondsToMmss(m35)}
50m: ${_secondsToMmss(total)}
''';
  }

  void reset() {
    state = state.copyWith(output: '');
  }
}
