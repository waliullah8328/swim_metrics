
import 'package:flutter_riverpod/legacy.dart';
import 'package:swim_metrics/feature/home_section/calculator_section/calculator/riverpod/split_item.dart';

import '../../../../../core/utils/utils/ratios.dart';
import '../../../../../core/utils/utils/splits.dart';
import '../../../../../core/utils/utils/time_utils.dart';



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

  void setCourse(String v) {
    state = state.copyWith(course: v.toLowerCase());
  }

  void setGender(String v) {
    state = state.copyWith(gender: v.toLowerCase());
  }

  void setStroke(String v) {
    state = state.copyWith(stroke: v.toLowerCase());
  }

  void setDistance(String v) {
    state = state.copyWith(distance: v);
  }

  void setGoalTime(String v) {
    state = state.copyWith(goalTime: v);
  }

  void project() {
    final s = state;

    if ([s.course, s.gender, s.stroke, s.distance, s.goalTime]
        .any((e) => e.isEmpty)) {
      state = s.copyWith(output: 'Please fill all fields.');
      return;
    }

    double total;
    try {
      total = TimeUtils.parseToSeconds(s.goalTime);
    } catch (_) {
      state = s.copyWith(
        output: 'Invalid time format. Please use mm:ss or ss.ss.',
      );
      return;
    }

    final r =
        SplitsCore.getRatios(s.course, s.gender, s.stroke, s.distance) ?? [];

    final text = SplitsCore.calculateSplits(
      total,
      r,
      int.parse(s.distance),
      targetCourse: s.course,
    );

    final title =
        "===============\n${s.gender[0].toUpperCase()}${s.gender.substring(1)}'s ${s.distance} ${s.stroke} ${s.course.toUpperCase()} Projection\nGoal Time: ${TimeUtils.formatSeconds(total)}\n===============\n";

    state = s.copyWith(
      output: '$title$text\n===============\n',
    );
  }


  void project1() {
    final s = state;

    if ([s.course, s.gender, s.stroke, s.distance, s.goalTime]
        .any((e) => e.isEmpty)) {
      state = s.copyWith(output: 'Please fill all fields.', splits: []);
      return;
    }

    double total;
    try {
      total = TimeUtils.parseToSeconds(s.goalTime);
    } catch (_) {
      state = s.copyWith(
        output: 'Invalid time format. Please use mm:ss or ss.ss.',
        splits: [],
      );
      return;
    }

    final ratios =
        SplitsCore.getRatios(s.course, s.gender, s.stroke, s.distance) ?? [];

    if (ratios.isEmpty) {
      state = s.copyWith(output: 'No ratios found.', splits: []);
      return;
    }

    final dist = int.parse(s.distance);
    final step = dist ~/ ratios.length;

    double cumulative = 0;

    List<SplitItem> splits = [];

    for (int i = 0; i < ratios.length; i++) {
      final splitTime = ratios[i] * total;
      cumulative += splitTime;

      splits.add(
        SplitItem(
          distance: (i + 1) * step,
          splitTime: splitTime,
          total: cumulative,
        ),
      );
    }

    state = s.copyWith(
      splits: splits,
      output: "Projection Complete",
    );
  }

  void clear() {
    state = state.copyWith(
      goalTime: '',
      splits: [],
      output: '',
    );
  }
}

final splitCalcProvider =
StateNotifierProvider<SplitCalcNotifier, SplitCalcState>((ref) {
  return SplitCalcNotifier();
});