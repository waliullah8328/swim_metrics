import 'package:flutter_riverpod/legacy.dart';
import 'package:swim_metrics/core/utils/utils/get_ratios.dart';
import 'split_item.dart';

class SplitCalcState {
  final String course;
  final String gender;
  final String stroke;
  final String distance;
  final String goalTime;
  final String output;
  final List<SplitItem> splits;

  const SplitCalcState({
    this.course = 'scy',
    this.gender = 'men',
    this.stroke = 'free',
    this.distance = '200',
    this.goalTime = '',
    this.output = '',
    this.splits = const [],
  });

  SplitCalcState copyWith({
    String? course,
    String? gender,
    String? stroke,
    String? distance,
    String? goalTime,
    String? output,
    List<SplitItem>? splits,
  }) {
    return SplitCalcState(
      course: course ?? this.course,
      gender: gender ?? this.gender,
      stroke: stroke ?? this.stroke,
      distance: distance ?? this.distance,
      goalTime: goalTime ?? this.goalTime,
      output: output ?? this.output,
      splits: splits ?? this.splits,
    );
  }
}

class SplitCalcNotifier extends StateNotifier<SplitCalcState> {
  SplitCalcNotifier() : super(const SplitCalcState());

  // ------------------- Setters -------------------
  void setCourse(String v) => state = state.copyWith(course: v.toLowerCase());
  void setGender(String v) => state = state.copyWith(gender: v.toLowerCase());
  void setStroke(String v) => state = state.copyWith(stroke: v.toLowerCase());
  void setDistance(String v) => state = state.copyWith(distance: v);
  void setGoalTime(String v) => state = state.copyWith(goalTime: v);

  // ------------------- Clear -------------------
  void clear() {
    state = state.copyWith(goalTime: '', splits: [], output: '');
  }

  // ------------------- MAIN CALC -------------------
  void project() {
    final s = state;

    if ([s.course, s.gender, s.stroke, s.distance, s.goalTime]
        .any((e) => e.isEmpty)) {
      state = s.copyWith(output: 'Please fill all fields.');
      return;
    }

    double totalSeconds;
    try {
      totalSeconds = _parseToSeconds(s.goalTime);
    } catch (_) {
      state = s.copyWith(output: 'Invalid time format. Use mm:ss or ss.ss');
      return;
    }

    final course = s.course;
    final gender = s.gender;
    final stroke = s.stroke;
    final distance = s.distance;

    // ================= LCM 50 SPECIAL =================
    if (course == 'lcm' && distance == '50' && stroke != 'im') {
      final ratios = getLcm50FinalRatios(gender);

      final split15 = totalSeconds * ratios["15m"]!;
      final split25 = totalSeconds * (ratios["25m"]! - ratios["15m"]!);
      final split35 = totalSeconds * (ratios["35m"]! - ratios["25m"]!);

      final buffer = StringBuffer();
      buffer.writeln("===============");
      buffer.writeln(
          "${_cap(gender)} 50m ${_cap(stroke)} LCM (15/25/35 Avg Model)");
      buffer.writeln("Goal Time: ${totalSeconds.toStringAsFixed(2)}");
      buffer.writeln("===============");

      // ✅ MATCH EXACT UI OUTPUT
      buffer.writeln("15m: ${split15.toStringAsFixed(2)}");
      buffer.writeln(
          "25m: ${(split15 + split25).toStringAsFixed(2)}");
      buffer.writeln(
          "35m: ${(split15 + split25 + split35).toStringAsFixed(2)}");
      buffer.writeln("Total time: ${totalSeconds.toStringAsFixed(2)}");

      buffer.writeln("===============");

      state = s.copyWith(output: buffer.toString());
      return;
    }

    // ================= NORMAL RATIOS =================
    final ratioList = getRatios(course, gender, stroke, distance);

    if (ratioList == null || ratioList.isEmpty) {
      state = s.copyWith(output: 'Ratios not defined for this event.');
      return;
    }

    final splitsTimes = ratioList.map((r) => r * totalSeconds).toList();

    double cumulative = 0;
    final splits = <SplitItem>[];
    final buffer = StringBuffer();

    buffer.writeln("===============");
    buffer.writeln(
        "${_cap(gender)}'s $distance ${_cap(stroke)} ${course.toUpperCase()} Projection");
    buffer.writeln("Goal Time: ${_formatSeconds(totalSeconds)}");
    buffer.writeln("===============");

    for (int i = 0; i < splitsTimes.length; i++) {
      cumulative += splitsTimes[i];

      final dist = ((i + 1) * (distance == "50" ? 25 : 50));

      splits.add(SplitItem(
        distance: dist,
        splitTime: splitsTimes[i],
        total: cumulative,
      ));

      buffer.writeln(
          "$dist: ${splitsTimes[i].toStringAsFixed(2)} / ${_formatSeconds(cumulative)}");
    }

    if (stroke == "im") {
      buffer.writeln("\n⚠️ Does not account for best/worst stroke.");
    }

    buffer.writeln("===============");

    state = s.copyWith(output: buffer.toString(), splits: splits);
  }

  // ------------------- HELPERS -------------------
  double _parseToSeconds(String input) {
    if (input.contains(":")) {
      final parts = input.split(":");
      final min = double.parse(parts[0]);
      final sec = double.parse(parts[1]);
      return min * 60 + sec;
    } else {
      return double.parse(input);
    }
  }

  // ✅ FIXED TIME FORMAT (mm:ss.ss)
  String _formatSeconds(double seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;

    if (minutes > 0) {
      return "$minutes:${secs.toStringAsFixed(2).padLeft(5, '0')}";
    } else {
      return secs.toStringAsFixed(2);
    }
  }

  String _cap(String s) => s[0].toUpperCase() + s.substring(1);
}

// ------------------- PROVIDER -------------------
final splitCalcProvider =
StateNotifierProvider<SplitCalcNotifier, SplitCalcState>(
        (ref) => SplitCalcNotifier());