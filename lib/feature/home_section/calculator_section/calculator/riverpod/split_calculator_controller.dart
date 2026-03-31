//
// // ------------------- SPLIT CALC STATE -------------------
// import 'package:flutter_riverpod/legacy.dart';
//
// import '../../../../../core/utils/utils/get_ratios.dart';
//
// class SplitCalcState {
//   final String course;
//   final String gender;
//   final String stroke;
//   final String distance;
//   final String goalTime;
//   final String output;
//   final List<SplitItem> splits;
//
//   const SplitCalcState({
//     this.course = 'scy',
//     this.gender = 'men',
//     this.stroke = 'free',
//     this.distance = '200',
//     this.goalTime = '',
//     this.output = '',
//     this.splits = const [],
//   });
//
//   SplitCalcState copyWith({
//     String? course,
//     String? gender,
//     String? stroke,
//     String? distance,
//     String? goalTime,
//     String? output,
//     List<SplitItem>? splits,
//   }) =>
//       SplitCalcState(
//         course: course ?? this.course,
//         gender: gender ?? this.gender,
//         stroke: stroke ?? this.stroke,
//         distance: distance ?? this.distance,
//         goalTime: goalTime ?? this.goalTime,
//         output: output ?? this.output,
//         splits: splits ?? this.splits,
//       );
// }
//
// // ------------------- SPLIT CALC NOTIFIER -------------------
// class SplitCalcNotifier extends StateNotifier<SplitCalcState> {
//   SplitCalcNotifier() : super(const SplitCalcState());
//
//   void setCourse(String v) => state = state.copyWith(course: v.toLowerCase());
//   void setGender(String v) => state = state.copyWith(gender: v.toLowerCase());
//   void setStroke(String v) => state = state.copyWith(stroke: v.toLowerCase());
//   void setDistance(String v) => state = state.copyWith(distance: v);
//   void setGoalTime(String v) => state = state.copyWith(goalTime: v);
//   void clear() => state = state.copyWith(splits: [], output: '');
//
//
// }
//
// // ------------------- PROVIDER -------------------
// final splitCalcProvider =
// StateNotifierProvider<SplitCalcNotifier, SplitCalcState>(
//         (ref) => SplitCalcNotifier());
//
//
// // void project() {
// //   final s = state;
// //   state = s.copyWith(output: '', splits: []);
// //
// //   if (s.goalTime.trim().isEmpty) {
// //     state = s.copyWith(output: 'Please enter goal time.');
// //     return;
// //   }
// //
// //   double totalSeconds;
// //   try {
// //     totalSeconds = _parseToSeconds(s.goalTime);
// //   } catch (_) {
// //     state = s.copyWith(output: 'Invalid time format. Use mm:ss or ss.ss');
// //     return;
// //   }
// //
// //   final course = s.course;
// //   final gender = s.gender;
// //   final stroke = s.stroke;
// //   final distance = s.distance;
// //
// //   final buffer = StringBuffer();
// //
// //   // 50M SPECIAL CASE
// //   if (distance == '50') {
// //     Map<String, double> ratios;
// //     if (course.toLowerCase() == 'lcm') {
// //       ratios = SwimSplitCalculator.getLcm50FinalRatios(gender);
// //       buffer.writeln("===============");
// //       buffer.writeln("${_cap(gender)} 50 ${_cap(stroke)} ${course.toUpperCase()} (50m Avg Model)");
// //
// //       final splitTimes = ratios.entries.map((e) => totalSeconds * e.value).toList();
// //       int i = 0;
// //       for (var entry in ratios.entries) {
// //         buffer.writeln("${entry.key}: ${splitTimes[i].toStringAsFixed(2)}");
// //         i++;
// //       }
// //       buffer.writeln("Total time: ${totalSeconds.toStringAsFixed(2)}");
// //       buffer.writeln("===============");
// //
// //       state = s.copyWith(output: buffer.toString());
// //       return;
// //     }
// //     // else if (course.toLowerCase() == 'scm') {
// //     //   ratios = SwimSplitCalculator.getScm50FinalRatios(gender);
// //     //   buffer.writeln("===============");
// //     //   buffer.writeln("${_cap(gender)} 50 ${_cap(stroke)} ${course.toUpperCase()} (15/25/35 Avg Model)");
// //     // } else {
// //     //   ratios = SwimSplitCalculator.getScy50FinalRatios(gender);
// //     //   buffer.writeln("===============");
// //     //   buffer.writeln("${_cap(gender)} 50 ${_cap(stroke)} ${course.toUpperCase()} (15/25/35 Avg Model)");
// //     // }
// //
// //
// //   }
// //
// //   // NORMAL DISTANCES (other than 50)
// //   final ratioList = SwimSplitCalculator.getRatios(course, gender, stroke, distance);
// //   if (ratioList == null || ratioList.isEmpty) {
// //     state = s.copyWith(output: 'Ratios not defined for this event.');
// //     return;
// //   }
// //
// //   final splitsTimes = ratioList.map((r) => r * totalSeconds).toList();
// //   double cumulative = 0;
// //   final splits = <SplitItem>[];
// //
// //   buffer.writeln("===============");
// //   buffer.writeln("${_cap(gender)}'s $distance ${_cap(stroke)} ${course.toUpperCase()} Projection");
// //   buffer.writeln("Goal Time: ${_formatSeconds(totalSeconds)}");
// //   buffer.writeln("===============");
// //
// //   for (int i = 0; i < splitsTimes.length; i++) {
// //     cumulative += splitsTimes[i];
// //     // For LCM and other distances, assume each split is 50m, then 25m if distance > 50
// //     final dist = distance == '50' ? (i + 1) * 50 : ((i + 1) * 25);
// //     splits.add(SplitItem(distance: dist, splitTime: splitsTimes[i], total: cumulative));
// //     buffer.writeln("$dist: ${splitsTimes[i].toStringAsFixed(2)} / ${_formatSeconds(cumulative)}");
// //   }
// //
// //   buffer.writeln("===============");
// //   state = s.copyWith(output: buffer.toString(), splits: splits);
// // }
// //
// // double _parseToSeconds(String input) {
// //   input = input.trim();
// //   if (input.contains(":")) {
// //     final parts = input.split(":");
// //     if (parts.length != 2) throw FormatException("Invalid format");
// //     final min = double.tryParse(parts[0]);
// //     final sec = double.tryParse(parts[1]);
// //     if (min == null || sec == null) throw FormatException("Invalid number");
// //     return min * 60 + sec;
// //   } else {
// //     final val = double.tryParse(input);
// //     if (val == null) throw FormatException("Invalid number");
// //     return val;
// //   }
// // }
// //
// // String _formatSeconds(double seconds) {
// //   final minutes = seconds ~/ 60;
// //   final secs = seconds % 60;
// //   return minutes > 0
// //       ? "$minutes:${secs.toStringAsFixed(2).padLeft(5, '0')}"
// //       : secs.toStringAsFixed(2);
// // }
// //
// // String _cap(String s) => s[0].toUpperCase() + s.substring(1);