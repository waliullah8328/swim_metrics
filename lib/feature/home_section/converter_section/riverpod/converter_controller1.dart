import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/utils/conversation_core_1.dart';
import '../../../../core/utils/utils/ratios_1.dart' hide TimeUtils1;
import '../../../../core/utils/utils/split_core_1.dart';
import '../../../../core/utils/utils/time_utils_1.dart';
import '../../../../l10n/app_localizations.dart';

final converterProvider1 =
NotifierProvider<ConverterController, ConverterState>(
  ConverterController.new,
);

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
    this.course = 'scm',
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
    newTargets.remove(v.toLowerCase());

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
    final key = v.toLowerCase();
    final newTargets = {...state.targets};

    if (selected) {
      if (key != state.course) {
        newTargets.add(key);
      }
    } else {
      newTargets.remove(key);
    }

    state = state.copyWith(targets: newTargets);
  }

  List<String> allowedTargets() {
    return ['scy', 'scm', 'lcm']
        .where((e) => e != state.course)
        .toList();
  }

  // void convert({required context}) {
  //   final s = state;
  //
  //   // Validate inputs
  //   if ([s.course, s.gender, s.stroke, s.distance, s.timeText]
  //       .any((e) => e.trim().isEmpty)) {
  //     state = s.copyWith(
  //       output:
  //       '${AppLocalizations.of(context)!.pleaseFillAllFields}\n\n${s.output}',
  //     );
  //     return;
  //   }
  //
  //   double totalSeconds;
  //
  //   try {
  //     totalSeconds = TimeUtils1.parseToSeconds(s.timeText.trim());
  //   } catch (_) {
  //     state = s.copyWith(
  //       output:
  //       '${AppLocalizations.of(context)!.invalidTimeFormat}\n\n${s.output}',
  //     );
  //     return;
  //   }
  //
  //   final results = <String>[];
  //   final splitResults = <String>[];
  //
  //   results.add('=== Conversion Results ===');
  //
  //   if (s.showSplits) {
  //     splitResults.add('=== Conversion Results with Splits ===');
  //   }
  //
  //   final allowed = allowedTargets();
  //
  //   final targets = s.targets.isEmpty
  //       ? allowed
  //       : allowed.where((e) => s.targets.contains(e)).toList();
  //
  //   for (final to in targets) {
  //     final multiplier = s.preferWR
  //         ? ConversionCore1.computeMultiplier(
  //       s.gender,
  //       s.stroke,
  //       s.distance,
  //       s.course,
  //       to,
  //     )
  //         : ConversionCore1.poolRatio(
  //       s.course,
  //       to,
  //     );
  //
  //     final converted = totalSeconds * multiplier;
  //
  //     // SAFE FORMAT (never crash on invalid mapping)
  //     final convertedText = TimeUtils1.formatSeconds(converted);
  //
  //     final displayDistance = ConversionCore1.mappedDistance(
  //       s.stroke,
  //       s.distance,
  //       s.course,
  //       to,
  //     );
  //
  //     // ❗ Skip invalid IM → LCM mapping issues
  //     if (displayDistance == null || displayDistance.toString().isEmpty) {
  //       continue;
  //     }
  //
  //     final strokeLabel = s.stroke.toLowerCase() == 'im'
  //         ? 'IM'
  //         : '${s.stroke[0].toUpperCase()}${s.stroke.substring(1).toLowerCase()}';
  //
  //     final genderLabel =
  //         '${s.gender[0].toUpperCase()}${s.gender.substring(1).toLowerCase()}';
  //
  //     results.add(
  //       '$genderLabel '
  //           '${s.distance} $strokeLabel ${s.timeText} '
  //           '${s.course.toUpperCase()} → '
  //           '$displayDistance $strokeLabel ${to.toUpperCase()}: '
  //           '$convertedText',
  //     );
  //
  //     if (s.showSplits) {
  //       String splitsText = '';
  //
  //       /// SPECIAL FIX FOR 50 LCM
  //       if (to == 'lcm' && displayDistance.toString() == '50') {
  //         splitsText = _calculate50LcmSplits(
  //           converted,
  //           s.gender,
  //         );
  //       } else {
  //         final ratios = SplitsCore1.getRatios(
  //           to,
  //           s.gender,
  //           s.stroke,
  //           displayDistance.toString(),
  //         ) ??
  //             [];
  //
  //         splitsText = SplitsCore1.calculateSplits(
  //           converted,
  //           ratios,
  //           int.parse(displayDistance.toString()),
  //           targetCourse: to,
  //         );
  //       }
  //
  //       splitResults.add(
  //         '$genderLabel '
  //             '$displayDistance $strokeLabel '
  //             '${to.toUpperCase()}: $convertedText',
  //       );
  //
  //       splitResults.add(splitsText);
  //       splitResults.add('');
  //     }
  //   }
  //
  //   final finalOutput = [
  //     ...results,
  //     '',
  //     ...splitResults,
  //     if (s.output.isNotEmpty) '',
  //     if (s.output.isNotEmpty) s.output,
  //   ].join('\n');
  //
  //   state = s.copyWith(output: finalOutput);
  // }

  void convert({required context}) {
    final s = state;

    if ([s.course, s.gender, s.stroke, s.distance, s.timeText]
        .any((e) => e.trim().isEmpty)) {
      state = s.copyWith(
        output: '${AppLocalizations.of(context)!.pleaseFillAllFields}\n\n${s.output}',
      );
      return;
    }

    double totalSeconds;
    try {
      totalSeconds = TimeUtils1.parseToSeconds(s.timeText.trim());
    } catch (_) {
      state = s.copyWith(
        output: '${AppLocalizations.of(context)!.invalidTimeFormat}\n\n${s.output}',
      );
      return;
    }

    final results = <String>[];
    final splitResults = <String>[];

    results.add('=== Conversion Results ===');
    if (s.showSplits) splitResults.add('=== Conversion Results with Splits ===');

    final targets = s.targets.isEmpty
        ? allowedTargets()
        : allowedTargets().where((e) => s.targets.contains(e)).toList();

    for (final to in targets) {
      // 1. Skip LCM result calculation entirely if source is LCM and it's a 100 IM
      if (s.course.toLowerCase() == 'lcm' &&
          s.stroke.toLowerCase() == 'im' &&
          s.distance == '100' &&
          to.toLowerCase() == 'lcm') {
        continue;
      }

      final displayDistance = ConversionCore1.mappedDistance(s.stroke, s.distance, s.course, to);

      // Skip if no mapping exists
      if (displayDistance == null || displayDistance.toString().isEmpty) continue;

      final multiplier = s.preferWR
          ? ConversionCore1.computeMultiplier(s.gender, s.stroke, s.distance, s.course, to)
          : ConversionCore1.poolRatio(s.course, to);

      final converted = totalSeconds * multiplier;
      final convertedText = TimeUtils1.formatSeconds(converted);

      final strokeLabel = s.stroke.toUpperCase() == 'IM' ? 'IM' :
      '${s.stroke[0].toUpperCase()}${s.stroke.substring(1).toLowerCase()}';
      final genderLabel = '${s.gender[0].toUpperCase()}${s.gender.substring(1).toLowerCase()}';

      // ✅ NEW CHECK: Detect if this specific result is 100 IM LCM
      final bool is100ImLcm = s.stroke.toUpperCase() == 'IM' &&
          s.distance == '100' &&
          to.toUpperCase() == 'LCM';

      // Only add to results if NOT 100 IM LCM
      if (!is100ImLcm) {
        results.add('$genderLabel ${s.distance} $strokeLabel ${s.course.toUpperCase()} → $displayDistance $strokeLabel ${to.toUpperCase()}: $convertedText');
      }

      if (s.showSplits) {
        // Only add splits if NOT 100 IM LCM
        if (!is100ImLcm) {
          splitResults.add('$genderLabel ${s.distance} $strokeLabel ${s.course.toUpperCase()} → $displayDistance $strokeLabel ${to.toUpperCase()}: $convertedText');

          String splitsText = '';
          if (to == 'lcm' && displayDistance.toString() == '50') {
            splitsText = _calculate50LcmSplits(converted, s.gender);
          } else {
            final ratios = SplitsCore1.getRatios(to, s.gender, s.stroke, displayDistance.toString()) ?? [];

            splitsText = SplitsCore1.calculateSplits(
              converted,
              ratios,
              int.parse(displayDistance.toString()),
              targetCourse: to,
            );
          }
          splitResults.add(splitsText);
          splitResults.add('');
        }
      }
    }

    // Clean up the output: remove the headers if no valid results were added
    if (results.length == 1) results.clear();
    if (splitResults.length == 1) splitResults.clear();

    final finalOutput = [
      ...results,
      if (results.isNotEmpty && splitResults.isNotEmpty) '',
      ...splitResults,
      if (s.output.isNotEmpty && (results.isNotEmpty || splitResults.isNotEmpty)) '',
      if (s.output.isNotEmpty) s.output,
    ].join('\n').trim();

    state = s.copyWith(output: finalOutput);
  }

  /// SPECIAL 50 LCM SPLITS
  String _calculate50LcmSplits(
      double total,
      String gender,
      ) {
    double m15;
    double m25;
    double m35;

    if (gender == 'men') {
      m15 = total * 0.238;
      m25 = total * 0.448;
      m35 = total * 0.659;
    } else {
      m15 = total * 0.248;
      m25 = total * 0.456;
      m35 = total * 0.671;
    }

    return '''
15m: ${TimeUtils1.formatSeconds(m15)}
25m: ${TimeUtils1.formatSeconds(m25)}
35m: ${TimeUtils1.formatSeconds(m35)}
50m: ${TimeUtils1.formatSeconds(total)}
''';
  }

  void reset() {
    state = state.copyWith(output: '');
  }
}