import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/utils/conversation_core_1.dart';

import '../../../../core/utils/utils/ratios_1.dart';
import '../../../../core/utils/utils/split_core_1.dart';

import '../../../../core/utils/utils/time_utils_1.dart';
import '../../../../l10n/app_localizations.dart';


final converterProvider1 =
NotifierProvider<ConverterController, ConverterState>(
    ConverterController.new);

class ConverterState {
  final String course;
  final String gender;
  final String stroke;
  final String distance;
  final String timeText;
  final bool showSplits;
  final Set<String> targets;
  final bool preferWR;
  final String output;

  const ConverterState({
    this.course = 'scy',
    this.gender = 'men',
    this.stroke = 'free',
    this.distance = '100',
    this.timeText = '',
    this.showSplits = false,
    this.targets = const {},
    this.preferWR = true,
    this.output = '',
  });

  ConverterState copyWith({
    String? course,
    String? gender,
    String? stroke,
    String? distance,
    String? timeText,
    bool? showSplits,
    Set<String>? targets,
    bool? preferWR,
    String? output,
  }) {
    return ConverterState(
      course: course ?? this.course,
      gender: gender ?? this.gender,
      stroke: stroke ?? this.stroke,
      distance: distance ?? this.distance,
      timeText: timeText ?? this.timeText,
      showSplits: showSplits ?? this.showSplits,
      targets: targets ?? this.targets,
      preferWR: preferWR ?? this.preferWR,
      output: output ?? this.output,
    );
  }
}

class ConverterController extends Notifier<ConverterState> {
  @override
  ConverterState build() {
    initializeRatios1();
    return const ConverterState();
  }

  void setCourse(String v) {
    final newTargets = {...state.targets};
    newTargets.remove(v);

    state = state.copyWith(
      course: v.toLowerCase(),
      targets: newTargets,
    );
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

  void setTimeText(String v) {
    state = state.copyWith(timeText: v);
  }

  void setShowSplits(bool v) {
    state = state.copyWith(showSplits: v);
  }

  void toggleTarget(String v, bool selected) {
    final newTargets = {...state.targets};

    if (selected) {
      if (v != state.course) newTargets.add(v);
    } else {
      newTargets.remove(v);
    }

    state = state.copyWith(targets: newTargets);
  }

  List<String> allowedTargets() {
    return ['scy', 'scm', 'lcm']
        .where((e) => e != state.course)
        .toList();
  }

  void convert({required context}) {
    final s = state;

    if ([s.course, s.gender, s.stroke, s.distance, s.timeText]
        .any((e) => e.isEmpty)) {
      state = s.copyWith(
        output: (AppLocalizations.of(context)!.pleaseFillAllFields) +
            (s.output.isEmpty ? '' : '\n\n' + s.output),
      );
      return;
    }

    double total;
    try {
      total = TimeUtils1.parseToSeconds(s.timeText);
    } catch (_) {
      state = s.copyWith(
        output: (AppLocalizations.of(context)!.invalidTimeFormat) +
            (s.output.isEmpty ? '' : '\n\n' + s.output),
      );
      return;
    }

    // New conversion results
    final resBasic = <String>['=== Conversion Results ==='];
    final resSplits = <String>[];

    if (s.showSplits) {
      resSplits.add('=== Conversion Results with splits ===');
    }

    final allowed = allowedTargets();
    final listTargets = s.targets.isEmpty
        ? allowed
        : allowed.where((e) => s.targets.contains(e)).toList();

    for (final to in listTargets) {
      final mult = s.preferWR
          ? ConversionCore1.computeMultiplier(
        s.gender,
        s.stroke,
        s.distance,
        s.course,
        to,
      )
          : ConversionCore1.poolRatio(s.course, to);

      final converted = total * mult;
      final convertedStr = TimeUtils1.formatSeconds(converted);

      final displayDistance = ConversionCore1.mappedDistance(
        s.stroke,
        s.distance,
        s.course,
        to,
      );

      final strokeLabel = s.stroke == 'im'
          ? 'IM'
          : s.stroke[0].toUpperCase() + s.stroke.substring(1);

      resBasic.add(
        '${s.gender[0].toUpperCase()}${s.gender.substring(1)} '
            '${s.distance} $strokeLabel ${s.timeText} '
            '${s.course.toUpperCase()} → '
            '$displayDistance $strokeLabel ${to.toUpperCase()}: $convertedStr',
      );

      if (s.showSplits) {
        final r = SplitsCore1.getRatios(to, s.gender, s.stroke, displayDistance) ?? [];
        final splitsText = SplitsCore1.calculateSplits(
          converted,
          r,
          int.parse(displayDistance),
          targetCourse: to,
        );

        resSplits.addAll([
          '${s.gender[0].toUpperCase()}${s.gender.substring(1)} '
              '$displayDistance $strokeLabel ${to.toUpperCase()}: $convertedStr',
          splitsText,
          '',
        ]);
      }
    }

    // PREPEND new results to previous output
    final newOutput = (resBasic + [''] + resSplits).join('\n') +
        (s.output.isEmpty ? '' : '\n\n' + s.output);

    state = s.copyWith(output: newOutput);
  }

  void reset() {
    state = state.copyWith(output: '');
  }
}