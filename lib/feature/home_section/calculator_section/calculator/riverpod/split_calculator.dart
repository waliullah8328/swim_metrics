import 'dart:convert';

import 'package:flutter_riverpod/legacy.dart';

import 'calculations.dart';



class SplitResult {
  final String output;
  final List<dynamic> splits;

  SplitResult({required this.output, required this.splits});
}

class SplitCalcState {
  final String course;
  final String gender;
  final String stroke;
  final String distance;
  final String goalTime;
  final List<SplitResult> history; // store all results

  const SplitCalcState({
    this.course = 'SCY',
    this.gender = '',
    this.stroke = '',
    this.distance = '',
    this.goalTime = '',
    this.history = const [],
  });

  SplitCalcState copyWith({
    String? course,
    String? gender,
    String? stroke,
    String? distance,
    String? goalTime,
    List<SplitResult>? history,
  }) {
    return SplitCalcState(
      course: course ?? this.course,
      gender: gender ?? this.gender,
      stroke: stroke ?? this.stroke,
      distance: distance ?? this.distance,
      goalTime: goalTime ?? this.goalTime,
      history: history ?? this.history,
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

  void clearHistory() => state = state.copyWith(history: []);

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

      final newResult = decoded['success'] == true
          ? SplitResult(
        output: decoded['formatted_text'] ?? '',
        splits: List.from(decoded['splits'] ?? []),
      )
          : SplitResult(
        output: decoded['error'] ?? 'Something went wrong',
        splits: [],
      );

      state = state.copyWith(
        history: [...state.history, newResult], // append to history
      );
    } catch (e) {
      state = state.copyWith(
        history: [
          ...state.history,
          SplitResult(output: 'Error: ${e.toString()}', splits: []),
        ],
      );
    }
  }
}

final splitCalcProvider =
StateNotifierProvider<SplitCalcNotifier, SplitCalcState>(
        (ref) => SplitCalcNotifier());

