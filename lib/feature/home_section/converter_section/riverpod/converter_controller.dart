
import 'package:flutter_riverpod/legacy.dart';

class ConverterState {
  final bool multiple;
  final List<String> from;
  final List<String> to;
  final String stroke;
  final String distance;

  ConverterState({
    this.multiple = false,
    this.from = const ["SCY"],
    this.to = const ["LCM"],
    this.stroke = "FREE",
    this.distance = "100",
  });

  ConverterState copyWith({
    bool? multiple,
    List<String>? from,
    List<String>? to,
    String? stroke,
    String? distance,
  }) {
    return ConverterState(
      multiple: multiple ?? this.multiple,
      from: from ?? this.from,
      to: to ?? this.to,
      stroke: stroke ?? this.stroke,
      distance: distance ?? this.distance,
    );
  }
}

class ConverterController extends StateNotifier<ConverterState> {
  ConverterController() : super(ConverterState());

  void toggleMultiple(bool value) {
    state = state.copyWith(multiple: value);
  }

  void selectFrom(String value) {
    if (state.multiple) {
      final list = [...state.from];
      list.contains(value) ? list.remove(value) : list.add(value);
      state = state.copyWith(from: list);
    } else {
      state = state.copyWith(from: [value]);
    }
  }

  void selectTo(String value) {
    if (state.multiple) {
      final list = [...state.to];
      list.contains(value) ? list.remove(value) : list.add(value);
      state = state.copyWith(to: list);
    } else {
      state = state.copyWith(to: [value]);
    }
  }

  void selectStroke(String value) {
    state = state.copyWith(stroke: value);
  }

  void selectDistance(String value) {
    state = state.copyWith(distance: value);
  }
}

final converterProvider =
StateNotifierProvider<ConverterController, ConverterState>(
        (ref) => ConverterController());