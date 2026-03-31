import 'dart:convert';

import 'package:flutter_riverpod/legacy.dart';

import 'calculations.dart';

class SplitCalcState {
  final String course;
  final String gender;
  final String stroke;
  final String distance;
  final String goalTime;
  final String output;
  final List<dynamic> splits;

  const SplitCalcState({
    this.course = '',
    this.gender = '',
    this.stroke = '',
    this.distance = '',
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
    List<dynamic>? splits,
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

  void setCourse(String v) => state = state.copyWith(course: v.toLowerCase());
  void setGender(String v) => state = state.copyWith(gender: v.toLowerCase());
  void setStroke(String v) => state = state.copyWith(stroke: v.toLowerCase());
  void setDistance(String v) => state = state.copyWith(distance: v);
  void setGoalTime(String v) => state = state.copyWith(goalTime: v);

  void clear() => state = state.copyWith(splits: [], output: '');

  /// 🚀 MAIN FUNCTION
  void calculate() {
    try {
      final result = SwimSplitCalculator1.calculateSplits(
        course: state.course,
        gender: state.gender,
        stroke: state.stroke,
        distance: state.distance,
        goalTime: state.goalTime,
      );

      final decoded = jsonDecode(result);

      if (decoded['success'] == true) {
        state = state.copyWith(
          output: decoded['formatted_text'] ?? '',
          splits: decoded['splits'] ?? [],
        );
      } else {
        state = state.copyWith(
          output: decoded['error'] ?? 'Something went wrong',
          splits: [],
        );
      }
    } catch (e) {
      state = state.copyWith(
        output: 'Error: ${e.toString()}',
        splits: [],
      );
    }
  }
}

final splitCalcProvider =
StateNotifierProvider<SplitCalcNotifier, SplitCalcState>(
      (ref) => SplitCalcNotifier(),
);