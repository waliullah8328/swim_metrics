
import 'package:flutter_riverpod/legacy.dart';
import 'split_item.dart';
import '../../../../../core/utils/utils/splits.dart';
import '../../../../../core/utils/utils/time_utils.dart';
import '../../../../../core/utils/utils/ratios.dart';


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
  SplitCalcNotifier() : super(const SplitCalcState()) {
    initializeRatios();
  }

  // ------------------- Setters -------------------
  void setCourse(String v) => state = state.copyWith(course: v.toLowerCase());
  void setGender(String v) => state = state.copyWith(gender: v.toLowerCase());
  void setStroke(String v) => state = state.copyWith(stroke: v.toLowerCase());
  void setDistance(String v) => state = state.copyWith(distance: v);
  void setGoalTime(String v) => state = state.copyWith(goalTime: v);

  // ------------------- Clear -------------------
  void clear() {
    state = state.copyWith(
      goalTime: '',
      splits: [],
      output: '',
    );
  }

  // ------------------- Projection -------------------
  void project() {
    final s = state;

    if ([s.course, s.gender, s.stroke, s.distance, s.goalTime].any((e) => e.isEmpty)) {
      state = s.copyWith(output: 'Please fill all fields.');
      return;
    }

    double totalSeconds;
    try {
      totalSeconds = TimeUtils.parseToSeconds(s.goalTime);
    } catch (_) {
      state = s.copyWith(output: 'Invalid time format. Use mm:ss or ss.ss');
      return;
    }

    final dist = int.parse(s.distance);

    List<int> splitDistances;

    // Special case for LCM 50
    if (s.course == 'lcm' && dist == 50 && s.stroke != 'im') {
      splitDistances = [15, 25, 35, 50];
    } else {
      splitDistances = _getSplitDistances(s.course, s.stroke, dist);
    }

    List<double> modelRatios;
    if (s.course == 'lcm' && dist == 50 && s.stroke != 'im') {
      final segs = SplitsCore.lcm50Segments(s.gender);
      modelRatios = [segs['s1']!, segs['s2']!, segs['s3']!, segs['s4']!];
    } else {
      final ratios = SplitsCore.getRatios(s.course, s.gender, s.stroke, s.distance);
      if (ratios == null || ratios.isEmpty) {
        state = s.copyWith(output: 'No ratios found for this event.');
        return;
      }
      modelRatios = SplitsCore.interpolateRatios(ratios, splitDistances.length);
    }

    double cumulativeModel = 0;
    double cumulativeAvg = 0;
    List<SplitItem> splits = [];

    for (int i = 0; i < splitDistances.length; i++) {
      final splitTimeModel = modelRatios[i] * totalSeconds;
      final splitTimeAvg = totalSeconds / splitDistances.length;

      cumulativeModel += splitTimeModel;
      cumulativeAvg += splitTimeAvg;

      splits.add(SplitItem(
        distance: splitDistances[i],
        splitTime: splitTimeModel,
        total: cumulativeModel,
        // If you want, you can also store average split in SplitItem as extra field
      ));
    }

    final title =
        "===============\n${s.gender[0].toUpperCase()}${s.gender.substring(1)}'s ${s.distance} ${s.stroke} ${s.course.toUpperCase()} Projection\nGoal Time: ${TimeUtils.formatSeconds(totalSeconds)}\n===============\n";

    final splitText = splits
        .map((e) =>
    "${e.distance}m: Model ${TimeUtils.formatSeconds(e.splitTime)} / Avg ${TimeUtils.formatSeconds(totalSeconds / splitDistances.length)} / Total ${TimeUtils.formatSeconds(e.total)}")
        .join("\n");

    state = s.copyWith(
      splits: splits,
      output: "$title$splitText\n===============",
    );
  }

  // ------------------- Helpers -------------------
  List<int> _getSplitDistances(String course, String stroke, int dist) {
    course = course.toLowerCase();
    stroke = stroke.toLowerCase();

    // LCM 50 special case
    if (course == 'lcm' && dist == 50 && stroke != 'im') {
      return [15, 25, 35, 50];
    }

    // Split unit: SCY = 25, SCM/LCM = 50
    final splitUnit = (course == 'scy') ? 25 : 50;

    int count = (dist / splitUnit).ceil();
    return List.generate(count, (i) {
      int val = (i + 1) * splitUnit;
      return val > dist ? dist : val;
    });
  }
}

// ------------------- Provider -------------------
final splitCalcProvider =
StateNotifierProvider<SplitCalcNotifier, SplitCalcState>((ref) {
  return SplitCalcNotifier();
});