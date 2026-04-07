// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter_riverpod/legacy.dart';
//
// final stopwatchProvider =
// StateNotifierProvider<StopwatchController, StopwatchState>((ref) {
//   return StopwatchController();
// });
//
// /// =========================
// /// STATE
// /// =========================
// class StopwatchState {
//   final Duration time;
//   final bool isRunning;
//   final List<Duration> laps;
//
//   final List<String> from;
//   final List<String> to;
//   final String stroke;
//   final String distance;
//   final List<SplitModel> splits;
//
//   const StopwatchState({
//     required this.time,
//     required this.isRunning,
//     required this.laps,
//     this.from = const ["WOMEN"],
//     this.to = const ["LCM"],
//     this.stroke = "FREE",
//     this.distance = "100",
//     this.splits = const [],
//   });
//
//   StopwatchState copyWith({
//     Duration? time,
//     bool? isRunning,
//     List<Duration>? laps,
//     List<String>? from,
//     List<String>? to,
//     String? stroke,
//     String? distance,
//     List<SplitModel>? splits,
//   }) {
//     return StopwatchState(
//       time: time ?? this.time,
//       isRunning: isRunning ?? this.isRunning,
//       laps: laps ?? this.laps,
//       from: from ?? this.from,
//       to: to ?? this.to,
//       stroke: stroke ?? this.stroke,
//       distance: distance ?? this.distance,
//       splits: splits ?? this.splits,
//     );
//   }
// }
//
// /// =========================
// /// CONTROLLER
// /// =========================
// class StopwatchController extends StateNotifier<StopwatchState> {
//   StopwatchController()
//       : super(const StopwatchState(
//     time: Duration.zero,
//     isRunning: false,
//     laps: [],
//   ));
//
//   final Stopwatch _stopwatch = Stopwatch();
//   Timer? _timer;
//
//   /// =========================
//   /// START
//   /// =========================
//   void start() {
//     if (_stopwatch.isRunning) return;
//
//     _stopwatch.start();
//
//     _timer ??= Timer.periodic(const Duration(milliseconds: 100), (_) {
//       state = state.copyWith(time: _stopwatch.elapsed);
//     });
//
//     state = state.copyWith(isRunning: true);
//   }
//
//   /// =========================
//   /// PAUSE
//   /// =========================
//   void pause() {
//     _stopwatch.stop();
//     _timer?.cancel();
//     _timer = null;
//
//     state = state.copyWith(isRunning: false);
//   }
//
//   /// =========================
//   /// RESET
//   /// =========================
//   void reset() {
//     _stopwatch.reset();
//     _stopwatch.stop();
//
//     _timer?.cancel();
//     _timer = null;
//
//     state = state.copyWith(
//       time: Duration.zero,
//       laps: [],
//       splits: [],
//       isRunning: false,
//     );
//   }
//
//   /// =========================
//   /// DROPDOWNS
//   /// =========================
//   void selectFrom(String value) {
//     state = state.copyWith(from: [value]);
//   }
//
//   void selectTo(String value) {
//     state = state.copyWith(to: [value]);
//   }
//
//   void selectStroke(String value) {
//     state = state.copyWith(stroke: value);
//   }
//
//   void selectDistance(String value) {
//     state = state.copyWith(distance: value);
//   }
//
//   /// =========================
//   /// ADD LAP
//   /// =========================
//   void lap() {
//     if (!_stopwatch.isRunning) return;
//
//     final updatedLaps = List<Duration>.from(state.laps)
//       ..add(_stopwatch.elapsed);
//
//     state = state.copyWith(laps: updatedLaps);
//
//     _recalculate();
//   }
//
//   /// =========================
//   /// DELETE LAST LAP (FIXED ✅)
//   /// =========================
//   void removeLastLap() {
//     if (state.laps.isEmpty) return;
//
//     final updatedLaps = List<Duration>.from(state.laps)
//       ..removeLast(); // ✅ ALWAYS LAST
//
//     state = state.copyWith(laps: updatedLaps);
//
//     if (updatedLaps.isEmpty) {
//       state = state.copyWith(splits: []);
//     } else {
//       _recalculate();
//     }
//   }
//
//   /// =========================
//   /// CLEAR ALL
//   /// =========================
//   void clearLaps() {
//     state = state.copyWith(laps: [], splits: []);
//   }
//
//   /// =========================
//   /// CENTRAL RECALCULATION
//   /// =========================
//   void _recalculate() {
//     _processPrediction();
//   }
//
//   /// =========================
//   /// PREDICTOR
//   /// =========================
//   void _processPrediction() {
//     if (state.laps.isEmpty) return;
//
//     final cumulativeSeconds =
//     state.laps.map((d) => d.inMilliseconds / 1000.0).toList();
//
//     final resultJson = StopwatchLogic.processPredictorLaps({
//       'gender': state.from.first.toLowerCase(),
//       'stroke': state.stroke.toLowerCase(),
//       'distance': state.distance,
//       'course': state.to.first.toLowerCase(),
//       'split_choice': '50',
//       'start_type': 'From Start',
//       'laps': cumulativeSeconds,
//     });
//
//     final decoded = jsonDecode(resultJson);
//     final List splitsRaw = decoded['splits'] ?? [];
//
//     final parsedSplits = List<SplitModel>.from(
//       splitsRaw.map((e) => SplitModel.fromJson(e)),
//     );
//
//     state = state.copyWith(splits: parsedSplits);
//   }
//
//   /// =========================
//   /// CONVERTER (FIXED NUMBERING ✅)
//   /// =========================
//   void convertSplits() {
//     if (state.laps.isEmpty) return;
//
//     final cumulativeSeconds =
//     state.laps.map((d) => d.inMilliseconds / 1000.0).toList();
//
//     final resultJson = StopwatchLogic.processConverterLaps({
//       'from_course': state.from.first,
//       'to_course': state.to.first,
//       'laps': cumulativeSeconds,
//     });
//
//     final decoded = jsonDecode(resultJson);
//     final List splitsRaw = decoded['splits'] ?? [];
//
//     final parsedSplits = List<SplitModel>.from(
//       splitsRaw.map((e) => SplitModel.fromJson(e)),
//     );
//
//     state = state.copyWith(splits: parsedSplits);
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
// }
//
// /// =========================
// /// MODEL
// /// =========================
// class SplitModel {
//   final int lapNumber;
//   final double? lapElapsed;
//   final double totalElapsed;
//   final double? projected;
//   final String text;
//
//   SplitModel({
//     required this.lapNumber,
//     this.lapElapsed,
//     required this.totalElapsed,
//     this.projected,
//     required this.text,
//   });
//
//   factory SplitModel.fromJson(Map<String, dynamic> json) {
//     return SplitModel(
//       lapNumber: json['lap_number'] ?? 0,
//       lapElapsed: (json['lap_elapsed'] as num?)?.toDouble(),
//       totalElapsed: (json['total_elapsed'] as num).toDouble(),
//       projected: (json['projected'] as num?)?.toDouble(),
//       text: json['text'] ?? '',
//     );
//   }
// }
//
//
// /// =======================
// /// CONSTANTS
// /// =======================
//
// const Map<String, dynamic> LCM_50_CUM_RATIOS = {
//   "men": {"15": 0.238, "25": 0.448, "35": 0.659},
//   "women": {"15": 0.248, "25": 0.456, "35": 0.671}
// };
//
// /// 👉 Keep your full ratios maps here (SCY, SCM, LCM)
// /// (I trimmed here for readability — use your full data)
// const Map<String, dynamic> ratios_scy = {};
// const Map<String, dynamic> ratios_scm = {};
// const Map<String, dynamic> ratios_lcm = {};
//
// const Map<String, double> conversion_factors = {
//   'SCY_SCM': 1.11,
//   'SCY_LCM': 1.12,
//   'SCM_SCY': 0.90,
//   'LCM_SCY': 0.89,
//   'SCM_LCM': 1.01,
//   'LCM_SCM': 0.99,
// };
//
// /// =======================
// /// UTILS
// /// =======================
//
// List<double> linspace(double start, double stop, int numPoints) {
//   if (numPoints <= 1) return [start];
//   double step = (stop - start) / (numPoints - 1);
//   return List.generate(numPoints, (i) => start + step * i);
// }
//
// double interpolate(double x, List<double> xp, List<double> fp) {
//   if (x <= xp.first) return fp.first;
//   if (x >= xp.last) return fp.last;
//
//   for (int i = 0; i < xp.length - 1; i++) {
//     if (x >= xp[i] && x <= xp[i + 1]) {
//       double t = (x - xp[i]) / (xp[i + 1] - xp[i]);
//       return fp[i] + t * (fp[i + 1] - fp[i]);
//     }
//   }
//   return fp.last;
// }
//
// /// =======================
// /// MAIN LOGIC
// /// =======================
//
// class StopwatchLogic {
//   /// ===================
//   /// FORMATTERS
//   /// ===================
//
//   static String formatTime(double seconds) {
//     int minutes = (seconds / 60).floor();
//     double secs = seconds % 60;
//     String secsStr = secs.toStringAsFixed(2).padLeft(5, '0');
//     return minutes == 0 ? ":$secsStr" : "$minutes:$secsStr";
//   }
//
//   static String formatTimeCompact(double seconds) {
//     if (seconds < 60) {
//       String secStr = seconds.toStringAsFixed(2);
//       if (secStr.startsWith('0')) {
//         secStr = secStr.substring(1);
//       }
//       return secStr;
//     }
//     int minutes = (seconds / 60).floor();
//     double secs = seconds % 60;
//     return "$minutes:${secs.toStringAsFixed(2).padLeft(5, '0')}";
//   }
//
//   /// ===================
//   /// SAFE RATIO FETCH
//   /// ===================
//
//   static List<double>? getRatios(
//       String course, String gender, String stroke, String distance) {
//     Map<String, dynamic> ratios;
//
//     if (course == "scy") {
//       ratios = ratios_scy;
//     } else if (course == "scm") {
//       ratios = ratios_scm;
//     } else {
//       ratios = ratios_lcm;
//     }
//
//     try {
//       final genderMap = Map<String, dynamic>.from(ratios[gender] ?? {});
//       final strokeMap = Map<String, dynamic>.from(genderMap[stroke] ?? {});
//       final distList = strokeMap[distance];
//
//       if (distList == null) return null;
//
//       return List<double>.from(
//           (distList as List).map((e) => (e as num).toDouble()));
//     } catch (_) {
//       return null;
//     }
//   }
//
//   /// ===================
//   /// PREDICTION
//   /// ===================
//
//   static double? performPredictTime({
//     required double elapsedSeconds,
//     required int splitCount,
//     required String gender,
//     required String stroke,
//     required String distance,
//     required String course,
//     required String splitChoice,
//     required String startType,
//   }) {
//     if (splitChoice == "None" || splitChoice.isEmpty) return null;
//
//     int distanceInt = int.tryParse(distance) ?? 0;
//
//     /// 🔥 LCM 50 Progressive
//     if (course == "lcm" &&
//         distanceInt == 50 &&
//         ["15", "25", "35"].contains(splitChoice)) {
//       final cums =
//       Map<String, dynamic>.from(LCM_50_CUM_RATIOS[gender] ?? {});
//
//       double? c15 = (cums['15'] as num?)?.toDouble();
//       double? c25 = (cums['25'] as num?)?.toDouble();
//       double? c35 = (cums['35'] as num?)?.toDouble();
//
//       if (c15 == null || c25 == null || c35 == null) return null;
//
//       List<double> segs = [c15, c25 - c15, c35 - c25, 1.0 - c35];
//
//       if (startType == "From Push") {
//         segs[0] *= 1.10;
//         double total = segs.fold(0.0, (a, b) => a + b);
//         if (total == 0) return null;
//         segs = segs.map((s) => s / total).toList();
//       }
//
//       int marker = int.parse(splitChoice);
//
//       double completed = 0.0;
//       if (marker == 15) {
//         completed = segs[0];
//       } else if (marker == 25) {
//         completed = segs[0] + segs[1];
//       } else {
//         completed = segs[0] + segs[1] + segs[2];
//       }
//
//       if (completed == 0) return null;
//
//       return elapsedSeconds / completed;
//     }
//
//     /// 🔥 NORMAL FLOW
//     int splitChoiceInt = int.tryParse(splitChoice) ?? 0;
//     if (splitChoiceInt <= 0) return null;
//
//     int expectedSplits = distanceInt ~/ splitChoiceInt;
//
//     List<double>? ratioList =
//     getRatios(course, gender, stroke, distance);
//
//     if (ratioList == null || ratioList.isEmpty) return null;
//
//     List<double> xp =
//     List.generate(ratioList.length, (i) => i.toDouble());
//
//     List<double> reqX =
//     linspace(0.0, ratioList.length.toDouble(), expectedSplits + 1);
//
//     if (reqX.isNotEmpty) reqX.removeLast();
//
//     final baseRatios = ratioList;
//
//     ratioList =
//         reqX.map((x) => interpolate(x, xp, baseRatios)).toList();
//
//     if (startType == "From Push") {
//       ratioList[0] *= 1.10;
//
//       double total = ratioList.fold(0.0, (a, b) => a + b);
//       if (total == 0) return null;
//
//       ratioList = ratioList.map((r) => r / total).toList();
//     }
//
//     int safeSplitCount =
//     splitCount > ratioList.length ? ratioList.length : splitCount;
//
//     double completed =
//     ratioList.sublist(0, safeSplitCount).fold(0.0, (a, b) => a + b);
//
//     double total = ratioList.fold(0.0, (a, b) => a + b);
//
//     if (completed == 0) return null;
//
//     return (elapsedSeconds / completed) * total;
//   }
//
//   /// ===================
//   /// PROCESS PREDICTOR
//   /// ===================
//
//   static String processPredictorLaps(Map<String, dynamic> params) {
//     List<double> cumulative =
//     (params['laps'] as List).map((e) => (e as num).toDouble()).toList();
//
//     String gender = params['gender'];
//     String stroke = params['stroke'];
//     String distance = params['distance'];
//     String course = params['course'];
//     String splitChoice = params['split_choice'];
//     String startType = params['start_type'];
//
//     List<Map<String, dynamic>> structured = [];
//     List<String> textLines = [];
//
//     for (int i = 0; i < cumulative.length; i++) {
//       double totalElapsed = cumulative[i];
//       double lapElapsed =
//       i == 0 ? totalElapsed : totalElapsed - cumulative[i - 1];
//
//       int lapNumber = i + 1;
//
//       double? projected = performPredictTime(
//         elapsedSeconds: totalElapsed,
//         splitCount: lapNumber,
//         gender: gender,
//         stroke: stroke,
//         distance: distance,
//         course: course,
//         splitChoice: splitChoice,
//         startType: startType,
//       );
//
//       String text =
//           "Lap $lapNumber: ${formatTime(lapElapsed)} / ${formatTime(totalElapsed)}"
//           "${projected != null ? " / ${formatTime(projected)}" : ""}";
//
//       textLines.add(text);
//
//       structured.add({
//         "lap_number": lapNumber,
//         "lap_elapsed": lapElapsed,
//         "total_elapsed": totalElapsed,
//         "projected": projected,
//         "text": text,
//       });
//     }
//
//     return jsonEncode({
//       "formatted_text": textLines.join("\n"),
//       "splits": structured,
//     });
//   }
//
//   /// ===================
//   /// CONVERTER
//   /// ===================
//
//   static double? convertTime(
//       double seconds, String fromCourse, String toCourse) {
//     if (fromCourse == toCourse) return seconds;
//
//     String key = '${fromCourse}_${toCourse}';
//     return conversion_factors.containsKey(key)
//         ? seconds * conversion_factors[key]!
//         : seconds;
//   }
//
//   static String processConverterLaps(Map<String, dynamic> params) {
//     List<double> cumulative =
//     (params['laps'] as List).map((e) => (e as num).toDouble()).toList();
//
//     String from = params['from_course'];
//     String to = params['to_course'];
//
//     List<Map<String, dynamic>> structured = [];
//
//     for (int i = 0; i < cumulative.length; i++) {
//       double total = cumulative[i];
//       double converted = convertTime(total, from, to) ?? 0;
//
//       structured.add({
//         "lap_number": i + 1,
//         "total_elapsed": total,
//         "converted_total": converted,
//         "text":
//         "Lap ${i + 1}: ${formatTime(total)} $from → ${formatTime(converted)} $to",
//       });
//     }
//
//     return jsonEncode({"splits": structured});
//   }
// }