// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// // ------------------- SPLIT ITEM -------------------
// class SplitItem {
//   final int distance;
//   final double splitTime;
//   final double total;
//
//   SplitItem({
//     required this.distance,
//     required this.splitTime,
//     required this.total,
//   });
// }
//
// // ------------------- SWIM SPLIT CALCULATOR -------------------
// class SwimSplitCalculator {
//   // ---------------- NORMALIZE ----------------
//   static List<double> normalize(List<double> r) {
//     final sum = r.reduce((a, b) => a + b);
//     return r.map((e) => e / sum).toList();
//   }
//
//   // ---------------- SCY RATIOS ----------------
//   static final Map<String, dynamic> ratiosScy = {
//     "men": {
//       "free": {
//         "50": normalize([0.4828, 0.5172]),
//         "100": normalize([0.2233, 0.2508, 0.2618, 0.2641]),
//         "200": normalize([0.2297, 0.2527, 0.2569, 0.2607]),
//         "500": normalize([0.0912, 0.1, 0.1015, 0.1019, 0.1021, 0.1021, 0.1016, 0.1013, 0.1004, 0.0979]),
//       },
//     },
//     "women": {
//       "free": {
//         "50": normalize([0.4845, 0.5155]),
//         "100": normalize([0.2264, 0.2521, 0.2596, 0.2619]),
//         "200": normalize([0.2346, 0.2542, 0.2552, 0.256]),
//         "500": normalize([0.0927, 0.0999, 0.1009, 0.1015, 0.1015, 0.1014, 0.1014, 0.101, 0.1008, 0.0989]),
//       },
//     },
//   };
//
//   // ---------------- SCM & LCM RATIOS (placeholder) ----------------
//   static final Map<String, dynamic> ratiosScm = ratiosScy;
//   static final Map<String, dynamic> ratiosLcmRaw = ratiosScy;
//
//   // ---------------- NORMALIZE LCM ----------------
//   static Map<String, dynamic> normalizeAll(Map<String, dynamic> data) {
//     final result = <String, dynamic>{};
//     data.forEach((gender, strokes) {
//       result[gender] = {};
//       strokes.forEach((stroke, distances) {
//         result[gender]![stroke] = {};
//         distances.forEach((distance, values) {
//           result[gender]![stroke]![distance] = normalize(List<double>.from(values));
//         });
//       });
//     });
//     return result;
//   }
//
//   static final Map<String, dynamic> ratiosLcm = normalizeAll(ratiosLcmRaw);
//
//   // ---------------- 50M FINAL RATIOS ----------------
//   static Map<String, double> getScy50FinalRatios(String gender) =>
//       gender.toLowerCase() == "men"
//           ? {"15m": 0.248, "25m": 0.454, "35m": 0.666}
//           : {"15m": 0.254, "25m": 0.463, "35m": 0.674};
//
//   static Map<String, double> getScm50FinalRatios(String gender) =>
//       gender.toLowerCase() == "men"
//           ? {"15m": 0.247, "25m": 0.455, "35m": 0.667}
//           : {"15m": 0.254, "25m": 0.464, "35m": 0.674};
//
//   static Map<String, double> getLcm50FinalRatios(String gender) =>
//       gender.toLowerCase() == "men"
//           ? {"25m": 0.46, "50m": 1.0} // LCM only 25/50
//           : {"25m": 0.465, "50m": 1.0};
//
//   // ---------------- GET RATIOS ----------------
//   static List<double>? getRatios(String course, String gender, String stroke, String distance) {
//     final lowerCourse = course.toLowerCase();
//     final source = lowerCourse == "scy"
//         ? ratiosScy
//         : lowerCourse == "scm"
//         ? ratiosScm
//         : ratiosLcm;
//     return source?[gender]?[stroke]?[distance];
//   }
//
//   // ---------------- GET DISTANCES ----------------
//   static List<int> getDistances(String course, String stroke, String gender) {
//     final lowerCourse = course.toLowerCase();
//     final lowerStroke = stroke.toLowerCase();
//     final lowerGender = gender.toLowerCase();
//
//     Map<String, dynamic>? data;
//
//     if (lowerCourse == "scy") {
//       data = ratiosScy[lowerGender]?[lowerStroke];
//     } else if (lowerCourse == "scm") {
//       data = ratiosScm[lowerGender]?[lowerStroke];
//     } else {
//       data = ratiosLcmRaw[lowerGender]?[lowerStroke];
//     }
//
//     if (data != null) {
//       final distances = data.keys.map((k) => int.tryParse(k) ?? 0).toList();
//       distances.sort();
//       return distances;
//     }
//
//     return [];
//   }
// }
