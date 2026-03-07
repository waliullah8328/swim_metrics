
import 'package:flutter_riverpod/legacy.dart';

import '../data/model/split_model.dart';

class SplitState {
  final String gender;
  final String stroke;
  final int distance;
  final double goalTime;
  final List<SplitModel> splits;

  SplitState({
    this.gender = "Men",
    this.stroke = "Fly",
    this.distance = 50,
    this.goalTime = 0,
    this.splits = const [],
  });

  SplitState copyWith({
    String? gender,
    String? stroke,
    int? distance,
    double? goalTime,
    List<SplitModel>? splits,
  }) {
    return SplitState(
      gender: gender ?? this.gender,
      stroke: stroke ?? this.stroke,
      distance: distance ?? this.distance,
      goalTime: goalTime ?? this.goalTime,
      splits: splits ?? this.splits,
    );
  }
}

class SplitNotifier extends StateNotifier<SplitState> {
  SplitNotifier() : super(SplitState());

  void setGender(String value) {
    state = state.copyWith(gender: value);
  }

  void setStroke(String value) {
    state = state.copyWith(stroke: value);
  }

  void setDistance(int value) {
    state = state.copyWith(distance: value);
  }

  void setGoalTime(double value) {
    state = state.copyWith(goalTime: value);
  }

  void calculateSplits() {
    int length = state.distance;
    int laps = 200 ~/ length;

    double split = state.goalTime / laps;

    List<SplitModel> result = [];

    double total = 0;

    for (int i = 0; i < laps; i++) {
      total += split;

      result.add(
        SplitModel(
          distance: length,
          splitTime: split,
          total: total,
        ),
      );
    }

    state = state.copyWith(splits: result);
  }

  void clear() {
    state = state.copyWith(splits: []);
  }
}

final splitProvider =
StateNotifierProvider<SplitNotifier, SplitState>((ref) {
  return SplitNotifier();
});