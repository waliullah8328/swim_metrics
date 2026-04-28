import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/l10n/app_localizations.dart';
import '../../../../../../config/route/routes_name.dart';
import '../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../core/common/widgets/new_custon_widgets/split_calculator_selector_one.dart';
import '../../../../../../core/services/token_storage.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/constants/icon_path.dart';
import '../../../../calculator_section/calculator/presentation/screen/widget/custom_drawer_widget.dart';
import '../../../../calculator_section/calculator/riverpod/audio_controller.dart';
import '../../../../calculator_section/setting_section/settings/riverpod/setting_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../riverpod/stop_watch_controller_2.dart';

enum StopwatchStatus { initial, running, stopped }

// ── Per-mode independent UI status providers ─────────────────
final stopwatchStatusProvider = StateProvider<StopwatchStatus>((ref) => StopwatchStatus.initial);
final converterStatusProvider  = StateProvider<StopwatchStatus>((ref) => StopwatchStatus.initial);
final predictorStatusProvider  = StateProvider<StopwatchStatus>((ref) => StopwatchStatus.initial);

final showCourseSectionStopWatchProvider  = StateProvider<bool>((ref) => true);
final showCourseSectionStopWatchProvider2 = StateProvider<bool>((ref) => true);

class StopwatchScreen extends ConsumerStatefulWidget {
  const StopwatchScreen({super.key});
  @override
  ConsumerState<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends ConsumerState<StopwatchScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    checkPlanExpiry(context);
    super.initState();
  }

  Future<void> checkPlanExpiry(BuildContext context) async {
    final planEndDate = await TokenStorage.getPlanEndDate();
    if (planEndDate == null) return;
    if (DateTime.now().isAfter(planEndDate)) {
      await TokenStorage.clearAll();
      await TokenStorage.deleteLoginFlag();
      if (context.mounted) context.go(RouteNames.loginScreen);
    }
  }

  double getAdjustedFontSize(double baseSize, FontSizeOption option) {
    switch (option) {
      case FontSizeOption.small:  return baseSize - 2;
      case FontSizeOption.medium: return baseSize;
      case FontSizeOption.big:    return baseSize + 2;
    }
  }

  // ── Helper: get the status provider for a given mode ─────────
  StateProvider<StopwatchStatus> _statusProviderFor(String mode) {
    switch (mode) {
      case 'Converter':  return converterStatusProvider;
      case 'Predictor':  return predictorStatusProvider;
      default:           return stopwatchStatusProvider;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeMode        = ref.watch(stopwatchProvider2.select((s) => s.activeMode));
    final isDark            = Theme.of(context).brightness == Brightness.dark;
    final settings          = ref.watch(settingsProvider);
    final showCourse        = ref.watch(showCourseSectionStopWatchProvider);
    final showCourse2       = ref.watch(showCourseSectionStopWatchProvider2);
    final fontOption        = settings.fontSize;
    final isHaptic          = ref.watch(settingsProvider.select((s) => s.haptic));
    final isStopWatch       = ref.watch(settingsProvider.select((s) => s.stopwatchSound));

    // Each mode watches its own status independently
    final swStatus   = ref.watch(stopwatchStatusProvider);
    final convStatus = ref.watch(converterStatusProvider);
    final predStatus = ref.watch(predictorStatusProvider);

    final log  = ref.watch(stopwatchProvider2.select((s) => s.logStopwatch));
    final log2 = ref.watch(stopwatchProvider2.select((s) => s.logConverter));
    final log3 = ref.watch(stopwatchProvider2.select((s) => s.logPredictor));

    final modes = ["Stopwatch", "Converter", "Predictor"];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: CustomText(
          text: AppLocalizations.of(context)!.stopWatch,
          fontSize: getAdjustedFontSize(24, fontOption).sp,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            if (isHaptic) HapticFeedback.lightImpact();
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Padding(
            padding: EdgeInsets.only(left: 18.w),
            child: SvgPicture.asset(
              IconPath.lightModeDrawerIcon,
              height: 48.h, width: 48.w, fit: BoxFit.contain,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1, thickness: 1,
            color: isDark ? const Color(0xffDADADA) : Colors.grey.shade300,
          ),
        ),
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CustomText(
                text: AppLocalizations.of(context)!.mode,
                fontSize: getAdjustedFontSize(18, fontOption).sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xffE3D99B),
              ),
              SizedBox(height: 10.h),

              // ── Mode Tabs ───────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkThemeContainerColor : const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(blurRadius: 8, spreadRadius: 1, offset: Offset(0, 4), color: Colors.black12)],
                ),
                child: Row(
                  children: List.generate(modes.length * 2 - 1, (index) {
                    if (index.isOdd) return SizedBox(width: 6.w);
                    final itemIndex = index ~/ 2;
                    final mode     = modes[itemIndex];
                    final isActive = activeMode == mode;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          // ✅ Switch mode in controller — does NOT reset other modes' timers
                          ref.read(stopwatchProvider2.notifier).setMode(mode);
                          if (isHaptic) HapticFeedback.lightImpact();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 45.h,
                          decoration: BoxDecoration(
                            color: isActive ? const Color(0xFFC9A84C) : const Color(0xFFEAEDF1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CustomText(
                            text: mode,
                            fontWeight: FontWeight.w600,
                            fontSize: getAdjustedFontSize(14, fontOption).sp,
                            color: isActive ? Colors.black : const Color(0xFF82888E),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 20.h),

              if (!showCourse  && activeMode == 'Converter') _pullDownHint(isHaptic, fontOption, context, () => ref.read(showCourseSectionStopWatchProvider.notifier).state  = true),
              if (!showCourse2 && activeMode == 'Predictor') _pullDownHint(isHaptic, fontOption, context, () => ref.read(showCourseSectionStopWatchProvider2.notifier).state = true),

              // ── Content per mode (all rendered, only active shown) ──
              if (activeMode == 'Stopwatch')
                _stopwatchSection(isDark, fontOption, swStatus,   isHaptic, isStopWatch, context, log,  'Stopwatch'),
              if (activeMode == 'Converter')
                _converterSection(isDark, fontOption, convStatus, isHaptic, isStopWatch, context, showCourse,  log2, 'Converter'),
              if (activeMode == 'Predictor')
                _predictorSection(isDark, fontOption, predStatus, isHaptic, isStopWatch, context, showCourse2, log3, 'Predictor'),
            ],
          ),
        ),
      ),
    );
  }

  // ── Pull Down Hint ───────────────────────────────────────────
  Widget _pullDownHint(bool isHaptic, FontSizeOption fontOption, BuildContext context, VoidCallback onTap) {
    return Center(
      child: GestureDetector(
        onTap: () { FocusManager.instance.primaryFocus?.unfocus(); onTap(); if (isHaptic) HapticFeedback.lightImpact(); },
        child: Column(children: [
          SizedBox(height: 10.h),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SvgPicture.asset(IconPath.pullIcon),
            CustomText(text: AppLocalizations.of(context)!.pullDownToSeeOptions, fontSize: getAdjustedFontSize(14, fontOption).sp, color: const Color(0xffC7C7C7)),
          ]),
          SizedBox(height: 20.h),
        ]),
      ),
    );
  }

  // ── Stopwatch Section ────────────────────────────────────────
  Widget _stopwatchSection(bool isDark, FontSizeOption fontOption, StopwatchStatus status, bool isHaptic, bool isStopWatch, BuildContext context, String log, String mode) {
    return Column(children: [
      Container(
        padding: EdgeInsets.only(
          left: 12.w,
          right: 12.w,
          top: 14.h,
          bottom: 14.h,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkThemeContainerColor : const Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, spreadRadius: 1, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            _timerCard(isDark, fontOption, context, mode),
            SizedBox(height: 20.h),
            _statusButtons(status, isDark, fontOption, context, isHaptic, isStopWatch, mode),
          ],
        ),
      ),
      if (log.isNotEmpty) _logSection(log, isDark, fontOption, isHaptic, isStopWatch, context, 1),
    ]);
  }

  // ── Converter Section ────────────────────────────────────────
  Widget _converterSection(bool isDark, FontSizeOption fontOption, StopwatchStatus status, bool isHaptic, bool isStopWatch, BuildContext context, bool showCourse, String log2, String mode) {
    return Column(children: [

      Container(
        padding: EdgeInsets.only(
          left: 12.w,
          right: 12.w,
          top: 14.h,
          bottom: 14.h,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkThemeContainerColor : const Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, spreadRadius: 1, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            if (showCourse) _converterSelector(context, fontOption, isHaptic),
            SizedBox(height: 10.h),
            _timerCard(isDark, fontOption, context, mode),
            SizedBox(height: 20.h),
            _statusButtons(status, isDark, fontOption, context, isHaptic, isStopWatch, mode, isConverter: true),

          ],
        ),
      ),

      if (log2.isNotEmpty) _logSection(log2, isDark, fontOption, isHaptic, isStopWatch, context, 2),
    ]);
  }

  // ── Predictor Section ────────────────────────────────────────
  Widget _predictorSection(bool isDark, FontSizeOption fontOption, StopwatchStatus status, bool isHaptic, bool isStopWatch, BuildContext context, bool showCourse2, String log3, String mode) {
    return Column(children: [

      Container(
        padding: EdgeInsets.only(
          left: 12.w,
          right: 12.w,
          top: 14.h,
          bottom: 14.h,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkThemeContainerColor : const Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, spreadRadius: 1, offset: const Offset(0, 4))],
        ),

        child: Column(
          children: [
            if (showCourse2) _predictorSelector(context, fontOption),
            SizedBox(height: 10.h),
            _timerCard(isDark, fontOption, context, mode),
            SizedBox(height: 20.h),
            _statusButtons(status, isDark, fontOption, context, isHaptic, isStopWatch, mode),
          ],
        ),
      ),

      if (log3.isNotEmpty) _logSection(log3, isDark, fontOption, isHaptic, isStopWatch, context, 3),
    ]);
  }

  // ── Timer Card — shows elapsed for the ACTIVE mode ──────────
  Widget _timerCard(bool isDark, FontSizeOption fontOption, BuildContext context, String mode) {
    return Consumer(
      builder: (context, ref, child) {
        // ✅ Each mode reads its OWN controller's elapsed via setMode-awareness
        // StopwatchController2 already isolates elapsed() per activeMode
        final time = ref.watch(stopwatchProvider2.select((s) => s.elapsed()));
        return Card(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: CustomText(
                text: _formatElapsed(time),
                fontSize: getAdjustedFontSize(35, fontOption).sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Status Buttons — fully independent per mode ──────────────
  Widget _statusButtons(
      StopwatchStatus status,
      bool isDark,
      FontSizeOption fontOption,
      BuildContext context,
      bool isHaptic,
      bool isStopWatch,
      String mode, {
        bool isConverter = false,
      }) {
    // ✅ Each mode reads/writes its OWN status provider
    final statusProvider = _statusProviderFor(mode);

    return Column(
      children: [

        // ── INITIAL: Show Start ────────────────────────────────
        if (status == StopwatchStatus.initial)
          _buildButton(
            bg: isDark ? const Color(0xffC69C3F) : AppColors.primary,
            children: [SvgPicture.asset(IconPath.startIcon, colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn))],
            text: AppLocalizations.of(context)!.start,
            fontSize: 14,
            context: context,
            fontOption: fontOption,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              // ✅ First switch controller to this mode, then start
              ref.read(stopwatchProvider2.notifier).setMode(mode);
              ref.read(stopwatchProvider2.notifier).start();
              ref.read(statusProvider.notifier).state = StopwatchStatus.running;
              if (isConverter) ref.read(showCourseSectionStopWatchProvider.notifier).state  = false;
              if (mode == 'Predictor') ref.read(showCourseSectionStopWatchProvider2.notifier).state = false;
              if (isHaptic)   HapticFeedback.lightImpact();
              if (isStopWatch) ref.read(audioProvider.notifier).play();
            },
          ),

        // ── RUNNING: Show Split + Undo/Stop ───────────────────
        if (status == StopwatchStatus.running)
          Column(children: [
            _buildButton(
              bg: const Color(0xff2DA8F0),
              side: const BorderSide(color: Color(0xff2DA8F0)),
              children: [SvgPicture.asset(IconPath.splitIcon, colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn))],
              text: AppLocalizations.of(context)!.split,
              fontSize: 16,
              context: context,
              fontOption: fontOption,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                ref.read(stopwatchProvider2.notifier).setMode(mode);
                ref.read(stopwatchProvider2.notifier).split(context);
                if (isHaptic)    HapticFeedback.lightImpact();
                if (isStopWatch) ref.read(audioProvider.notifier).play();
              },
            ),
            SizedBox(height: 20.h),
            Row(children: [
              Expanded(child: _buildButton(
                bg: const Color(0xff475569),
                side: const BorderSide(color: Color(0xff475569)),
                children: [SvgPicture.asset(IconPath.undoIcon, colorFilter: const ColorFilter.mode(AppColors.textWhite, BlendMode.srcIn))],
                text: AppLocalizations.of(context)!.undoSplit,
                fontSize: 12,
                context: context,
                fontOption: fontOption,
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  ref.read(stopwatchProvider2.notifier).setMode(mode);
                  ref.read(stopwatchProvider2.notifier).undoLastSplit();
                  if (isHaptic)    HapticFeedback.lightImpact();
                  if (isStopWatch) ref.read(audioProvider.notifier).play();
                },
                textColor: AppColors.textWhite,
              )),
              SizedBox(width: 10.w),
              Expanded(child: _buildButton(
                bg: const Color(0xffFE484C),
                side: const BorderSide(color: Color(0xffFE484C)),
                children: [SvgPicture.asset(IconPath.stopIcon, colorFilter: const ColorFilter.mode(AppColors.textWhite, BlendMode.srcIn))],
                text: AppLocalizations.of(context)!.stop,
                fontSize: 12,
                context: context,
                fontOption: fontOption,
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  ref.read(stopwatchProvider2.notifier).setMode(mode);
                  ref.read(stopwatchProvider2.notifier).pause();
                  ref.read(statusProvider.notifier).state = StopwatchStatus.stopped;
                  if (isHaptic)    HapticFeedback.lightImpact();
                  if (isStopWatch) ref.read(audioProvider.notifier).play();
                },
                textColor: AppColors.textWhite,
              )),
            ]),
          ]),

        // ── STOPPED: Show Resume + Clear ──────────────────────
        if (status == StopwatchStatus.stopped)
          Row(children: [
            Expanded(child: _buildButton(
              bg: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              children: [SvgPicture.asset(IconPath.startIcon, colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn))],
              text: AppLocalizations.of(context)!.resume,
              fontSize: 12,
              context: context,
              fontOption: fontOption,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                ref.read(stopwatchProvider2.notifier).setMode(mode);
                ref.read(stopwatchProvider2.notifier).start();
                ref.read(statusProvider.notifier).state = StopwatchStatus.running;
                if (isHaptic)    HapticFeedback.lightImpact();
                if (isStopWatch) ref.read(audioProvider.notifier).play();
              },
              textColor: Colors.black,
            )),
            SizedBox(width: 10.w),
            Expanded(child: _buildButton(
              bg: const Color(0xff234B6E),
              side: const BorderSide(color: Color(0xff234B6E)),
              children: [SvgPicture.asset(IconPath.clearIcon, colorFilter: const ColorFilter.mode(AppColors.textWhite, BlendMode.srcIn))],
              text: AppLocalizations.of(context)!.clearTime,
              fontSize: 14,
              context: context,
              fontOption: fontOption,
              textColor: AppColors.textWhite,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                if (isStopWatch) ref.read(audioProvider.notifier).stop();
                ref.read(stopwatchProvider2.notifier).setMode(mode);
                ref.read(stopwatchProvider2.notifier).clearTime();
                // ✅ Reset ONLY this mode's status back to initial
                ref.read(statusProvider.notifier).state = StopwatchStatus.initial;
                if (isHaptic) HapticFeedback.lightImpact();
              },
            )),
          ]),
      ],
    );
  }

  Widget _buildButton({
    required Color? bg,
    BorderSide? side,
    required List<Widget> children,
    required String text,
    required double fontSize,
    required BuildContext context,
    required FontSizeOption fontOption,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 52.h),
        backgroundColor: bg,
        side: side,
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ...children,
          SizedBox(width: 6.w),

          Flexible(
            child: CustomText(
              text: text,
              fontSize: getAdjustedFontSize(fontSize, fontOption).sp,
              fontWeight: FontWeight.w700,
              color: textColor,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _logSection(String logText, bool isDark, FontSizeOption fontOption, bool isHaptic, bool isStopWatch, BuildContext context, int type) {
    return Column(children: [
      SizedBox(height: 16.h),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xff0C3156) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1.w, color: const Color(0xff2DA8F0)),
          boxShadow: const [BoxShadow(blurRadius: 12, color: Colors.black12)],
        ),
        child: SingleChildScrollView(child: CustomText(text: logText)),
      ),
      SizedBox(height: 16.h),
      Row(children: [
        Expanded(child: _buildButton(
          bg: const Color(0xff234B6E),
          side: const BorderSide(color: Color(0xff234B6E)),
          children: [SvgPicture.asset(IconPath.clearIcon, colorFilter: const ColorFilter.mode(AppColors.textWhite, BlendMode.srcIn))],
          text: AppLocalizations.of(context)!.clear,
          fontSize: 16,
          context: context,
          fontOption: fontOption,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            // ✅ Clear log + reset ONLY this mode
            final mode = type == 1 ? 'Stopwatch' : type == 2 ? 'Converter' : 'Predictor';
            ref.read(stopwatchProvider2.notifier).setMode(mode);
            ref.read(stopwatchProvider2.notifier).clearLog();
            if (isStopWatch) ref.read(audioProvider.notifier).stop();
            ref.read(stopwatchProvider2.notifier).reset();
            ref.read(_statusProviderFor(mode).notifier).state = StopwatchStatus.initial;
            if (isHaptic) HapticFeedback.lightImpact();
          },
          textColor: AppColors.textWhite,
        )),
        SizedBox(width: 12.w),
        Expanded(child: _buildButton(
          bg: AppColors.primary,
          children: [SvgPicture.asset(IconPath.exportIcon, colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn))],
          text: AppLocalizations.of(context)!.export,
          fontSize: 16,
          context: context,
          fontOption: fontOption,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            if (type == 1) exportOutputAsPdf1(context, ref);
            else if (type == 2) exportOutputAsPdf(context, ref);
            else exportOutputAsPdf3(context, ref);
            if (isHaptic) HapticFeedback.lightImpact();
          },
          textColor: Colors.black,
        )),
      ]),
    ]);
  }

  Widget _converterSelector(BuildContext context, FontSizeOption fontOption, bool isHaptic) {
    return Row(children: [
      Expanded(child: Column(children: [
        CustomText(text: AppLocalizations.of(context)!.from, color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: getAdjustedFontSize(16, fontOption).sp),
        SizedBox(height: 8.h),
        Consumer(builder: (context, ref, child) {
          const items = ["SCY", "SCM", "LCM"];
          final course = ref.watch(stopwatchProvider2.select((s) => s.fromCourse));
          final selected = items.contains(course) ? course : items.first;
          return SplitCalculatorSelectorOne(
            items: items,
            selectedValue: selected,
            onChanged: (s) {
              FocusManager.instance.primaryFocus?.unfocus();
              ref.read(stopwatchProvider2.notifier).setConverterCourses(from: s);
              if (isHaptic) HapticFeedback.lightImpact();
            },
          );
        }),
      ])),
      Expanded(child: Column(children: [
        CustomText(text: AppLocalizations.of(context)!.to, color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: getAdjustedFontSize(16, fontOption).sp),
        SizedBox(height: 8.h),
        Consumer(builder: (context, ref, child) {
          const items = ["SCY", "SCM", "LCM"];
          final course = ref.watch(stopwatchProvider2.select((s) => s.toCourse));
          final selected = items.contains(course) ? course : items.first;
          return SplitCalculatorSelectorOne(
            items: items,
            selectedValue: selected,
            onChanged: (s) {
              FocusManager.instance.primaryFocus?.unfocus();
              ref.read(stopwatchProvider2.notifier).setConverterCourses(to: s);
              if (isHaptic) HapticFeedback.lightImpact();
            },
          );
        }),
      ])),
    ]);
  }

  Widget _predictorSelector(BuildContext context, FontSizeOption fontOption) {
    return Column(children: [
      Row(children: [
        Expanded(child: Column(children: [
          CustomText(text: AppLocalizations.of(context)!.gender, color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: getAdjustedFontSize(16, fontOption).sp),
          SizedBox(height: 16.h),
          Consumer(builder: (context, ref, child) {
            final gender = ref.watch(stopwatchProvider2.select((s) => s.gender));
            final selected = gender.isNotEmpty ? "${gender[0].toUpperCase()}${gender.substring(1).toLowerCase()}" : "";
            return SplitCalculatorSelectorOne(
              items: const ["Men", "Women"],
              selectedValue: selected,
              onChanged: (v) => ref.read(stopwatchProvider2.notifier).setPredictorParams(g: v.toLowerCase()),
            );
          }),
        ])),
        Expanded(child: Column(children: [
          CustomText(text: AppLocalizations.of(context)!.stroke, color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: getAdjustedFontSize(16, fontOption).sp),
          SizedBox(height: 16.h),
          Consumer(builder: (context, ref, child) {
            const items = ["Fly", "Back", "Breast", "Free", "IM"];
            final stroke = ref.watch(stopwatchProvider2.select((s) => s.stroke));
            final selected = items.firstWhere((i) => i.toLowerCase() == stroke, orElse: () => items.first);
            return SplitCalculatorSelectorOne(
              items: items,
              selectedValue: selected,
              onChanged: (s) {
                final newStroke     = s.toLowerCase();
                final state         = ref.read(stopwatchProvider2);
                final validDistances = getDistances(state.course, newStroke);
                final newDistance   = validDistances.contains(state.distance) ? state.distance : validDistances.first;
                final validSplits   = getSplitSizes(course: state.course, distance: newDistance, stroke: newStroke);
                ref.read(stopwatchProvider2.notifier).setPredictorParams(s: newStroke, d: newDistance, split: validSplits.first);
              },
            );
          }),
        ])),
      ]),
      SizedBox(height: 10.h),
      Row(children: [
        Expanded(child: Column(children: [
          SizedBox(height: 8.h),
          CustomText(text: AppLocalizations.of(context)!.course, color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: getAdjustedFontSize(16, fontOption).sp),
          SizedBox(height: 16.h),
          Consumer(builder: (context, ref, child) {
            const items    = ["SCY", "SCM", "LCM"];
            final rawCourse = ref.watch(stopwatchProvider2.select((s) => s.course));
            final currentCourse = rawCourse.toUpperCase();
            return SplitCalculatorSelectorOne(
              items: items,
              selectedValue: currentCourse,
              onChanged: (s) {
                final notifier      = ref.read(stopwatchProvider2.notifier);
                final state         = ref.read(stopwatchProvider2);
                final newCourse     = s.toLowerCase();
                final validDistances = getDistances(newCourse, state.stroke);
                final newDistance   = validDistances.contains(state.distance) ? state.distance : validDistances.first;
                final validSplits   = getSplitSizes(course: newCourse, distance: newDistance, stroke: state.stroke);
                notifier.setPredictorParams(c: newCourse, d: newDistance, split: validSplits.isNotEmpty ? validSplits.first : "50");
              },
            );
          }),
        ])),
        Expanded(child: Column(children: [
          SizedBox(height: 8.h),
          CustomText(text: AppLocalizations.of(context)!.distance, color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: getAdjustedFontSize(16, fontOption).sp),
          SizedBox(height: 16.h),
          Consumer(builder: (context, ref, child) {
            final state     = ref.watch(stopwatchProvider2.select((s) => (s.course, s.stroke, s.distance)));
            final distances = getDistances(state.$1, state.$2);
            final selected  = distances.contains(state.$3) ? state.$3 : distances.first;
            return SplitCalculatorSelectorOne(
              items: distances,
              selectedValue: selected,
              onChanged: (v) {
                final validSplits = getSplitSizes(course: state.$1, distance: v, stroke: state.$2);
                ref.read(stopwatchProvider2.notifier).setPredictorParams(d: v, split: validSplits.first);
              },
            );
          }),
        ])),
      ]),
      SizedBox(height: 10.h),
      Row(children: [
        Expanded(child: Column(children: [
          SizedBox(height: 8.h),
          CustomText(text: AppLocalizations.of(context)!.splitSize, color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: getAdjustedFontSize(16, fontOption).sp),
          SizedBox(height: 16.h),
          Consumer(builder: (context, ref, child) {
            final state  = ref.watch(stopwatchProvider2.select((s) => (s.course, s.stroke, s.distance, s.splitSize)));
            final splits = getSplitSizes(course: state.$1, distance: state.$3, stroke: state.$2);
            final selected = splits.contains(state.$4) ? state.$4 : splits.first;
            return SplitCalculatorSelectorOne(
              items: splits,
              selectedValue: selected,
              onChanged: (v) => ref.read(stopwatchProvider2.notifier).setPredictorParams(split: v),
            );
          }),
        ])),
        Expanded(child: Column(children: [
          SizedBox(height: 8.h),
          CustomText(text: AppLocalizations.of(context)!.startType, color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: getAdjustedFontSize(16, fontOption).sp),
          SizedBox(height: 16.h),
          Consumer(builder: (context, ref, child) {
            final start = ref.watch(stopwatchProvider2.select((s) => s.startType));
            return SplitCalculatorSelectorOne(
              items: const ["From Start", "From Push"],
              selectedValue: start,
              onChanged: (v) => ref.read(stopwatchProvider2.notifier).setPredictorParams(start: v),
            );
          }),
        ])),
      ]),
      SizedBox(height: 10.h),
      Consumer(builder: (context, ref, child) {
        final state = ref.watch(stopwatchProvider2.select((s) => (s.course, s.distance, s.splitSize, s.progressiveActive)));
        final shouldShow = state.$1 == "lcm" && state.$2 == "50" && state.$3 == "15";
        if (!shouldShow) return const SizedBox();
        return Row(children: [
          Checkbox(value: true, onChanged: (v) {}),
          CustomText(text: "Progressive", color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: getAdjustedFontSize(14, fontOption).sp),
        ]);
      }),
    ]);
  }

  // ── Predictor Data & Helpers (unchanged) ─────────────────────
  static const Map<String, Map<String, Map<String, List<String>>>> _predictorData = {
    'scy': {
      'free':   {'50': ['25'], '100': ['25','50'], '200': ['50','100'], '500': ['50','100'], '1000': ['50','100'], '1650': ['50','100']},
      'fly':    {'50': ['25'], '100': ['25','50'], '200': ['50','100']},
      'back':   {'50': ['25'], '100': ['25','50'], '200': ['50','100']},
      'breast': {'50': ['25'], '100': ['25','50'], '200': ['50','100']},
      'im':     {'100': ['25','50'], '200': ['50','100'], '400': ['50','100']},
    },
    'scm': {
      'free':   {'50': ['25'], '100': ['25','50'], '200': ['50','100'], '400': ['50','100'], '800': ['50','100'], '1500': ['50','100']},
      'fly':    {'50': ['25'], '100': ['25','50'], '200': ['50','100']},
      'back':   {'50': ['25'], '100': ['25','50'], '200': ['50','100']},
      'breast': {'50': ['25'], '100': ['25','50'], '200': ['50','100']},
      'im':     {'100': ['25','50'], '200': ['50','100'], '400': ['50','100']},
    },
    'lcm': {
      'free':   {'50': ['15','25','35'], '100': ['25','50'], '200': ['50','100'], '400': ['50','100'], '800': ['50','100'], '1500': ['50','100']},
      'fly':    {'50': ['15','25','35'], '100': ['25','50'], '200': ['50','100']},
      'back':   {'50': ['15','25','35'], '100': ['25','50'], '200': ['50','100']},
      'breast': {'50': ['15','25','35'], '100': ['25','50'], '200': ['50','100']},
      'im':     {'200': ['50','100'], '400': ['50','100']},
    },
  };

  List<String> getDistances(String course, String stroke) {
    final d = _predictorData[course.toLowerCase()]?[stroke.toLowerCase()];
    return d?.keys.toList() ?? ['50'];
  }

  List<String> getSplitSizes({required String course, required String distance, required String stroke}) {
    return _predictorData[course.toLowerCase()]?[stroke.toLowerCase()]?[distance] ?? ['50'];
  }

  // ── PDF Export (unchanged) ────────────────────────────────────
  Future<void> exportOutputAsPdf(BuildContext context, WidgetRef ref)  async => _exportPdf(ref.read(stopwatchProvider2).logConverter,  'swim_converter_output.pdf',  context);
  Future<void> exportOutputAsPdf3(BuildContext context, WidgetRef ref) async => _exportPdf(ref.read(stopwatchProvider2).logPredictor,  'swim_predictor_output.pdf',  context);
  Future<void> exportOutputAsPdf1(BuildContext context, WidgetRef ref) async => _exportPdf(ref.read(stopwatchProvider2).logStopwatch,  'swim_stopwatch_output.pdf',  context);

  Future<void> _exportPdf(String log, String fileName, BuildContext context) async {
    if (log.isEmpty) return;

    final pdf      = pw.Document();
    final fontData = await rootBundle.load('assets/font/Merriweather-font.ttf');
    final ttf      = pw.Font.ttf(fontData);

    final allLines = log
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    // ── Page & column geometry ────────────────────────────────
    const double pageMargin    = 32;
    const double headerHeight  = 60;  // SwimMetrics + divider + spacing
    const double colGap        = 30;
    const double lineHeight    = 13.0;
    const double headerLineH   = 15.0;

    final double pageH   = PdfPageFormat.a4.height;
    final double usableH = pageH - (pageMargin * 2) - headerHeight;

    // ── Measure how tall a single line will be ───────────────
    double _lineH(String text) {
      final isHeader = text.contains('Projection') ||
          text.contains('→') ||
          text.startsWith('===') ||
          text.contains('Breakdown');
      return (isHeader ? headerLineH : lineHeight) + (isHeader ? 12 : 0);
    }

    // ── Bin lines into columns, then pages ───────────────────
    // Structure: pages → columns(2) → lines
    final List<List<List<String>>> pages = [];

    List<String> currentCol = [];
    double colUsed = 0;
    bool fillingLeft = true;

    List<String> leftCol  = [];
    List<String> rightCol = [];
    double leftUsed  = 0;
    double rightUsed = 0;

    void flushPage() {
      pages.add([List.from(leftCol), List.from(rightCol)]);
      leftCol   = [];
      rightCol  = [];
      leftUsed  = 0;
      rightUsed = 0;
      fillingLeft = true;
    }

    for (final line in allLines) {
      final h = _lineH(line);

      if (fillingLeft) {
        if (leftUsed + h > usableH && leftCol.isNotEmpty) {
          // Left column full → switch to right
          fillingLeft = false;
        } else {
          leftCol.add(line);
          leftUsed += h;
          continue;
        }
      }

      // Filling right column
      if (rightUsed + h > usableH && rightCol.isNotEmpty) {
        // Right column full → flush page
        flushPage();
        leftCol.add(line);
        leftUsed += h;
        fillingLeft = true;
      } else {
        rightCol.add(line);
        rightUsed += h;
      }
    }

    // Flush remaining lines
    if (leftCol.isNotEmpty || rightCol.isNotEmpty) {
      flushPage();
    }

    // ── Build one pw.Page per logical page ───────────────────
    for (final page in pages) {
      final left  = page[0];
      final right = page[1];

      final double pageW   = PdfPageFormat.a4.width;
      final double usableW = pageW - (pageMargin * 2);
      final double colW    = (usableW - colGap) / 2;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(pageMargin),
          build: (pw.Context ctx) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [

                // ── Header ──────────────────────────────────────
                pw.Center(
                  child: pw.Text(
                    'SwimMetrics',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Divider(thickness: 0.5),
                pw.SizedBox(height: 10),

                // ── Two Columns ──────────────────────────────────
                pw.Expanded(
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [

                      // LEFT — filled first
                      pw.SizedBox(
                        width: colW,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: left.map((l) => _renderLine(l, ttf)).toList(),
                        ),
                      ),

                      pw.SizedBox(width: colGap),

                      // RIGHT — filled after left is full
                      pw.SizedBox(
                        width: colW,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: right.map((l) => _renderLine(l, ttf)).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    // ── Save & Open ───────────────────────────────────────────
    try {
      final dir  = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(await pdf.save());
      if (context.mounted) await OpenFile.open(file.path);
    } catch (e) {
      debugPrint("PDF export error: $e");
    }
  }

  pw.Widget _renderLine(String text, pw.Font font) {
    final isMainHeader = text.contains('Projection') || text.contains('→');
    final isSubHeader  = text.startsWith('===') || text.contains('Breakdown');
    return pw.Container(
      alignment: pw.Alignment.centerLeft,
      padding: pw.EdgeInsets.only(
        top:    isMainHeader ? 12 : (isSubHeader ? 6 : 0),
        bottom: 1,
      ),
      child: pw.Text(
        text.replaceAll('=', '').trim(),
        style: pw.TextStyle(
          font:       font,
          fontSize:   9,
          lineSpacing: 1.2,
          fontWeight: (isMainHeader || isSubHeader)
              ? pw.FontWeight.bold
              : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static String _formatElapsed(double s) => '${_twoDigits((s ~/ 60))}:${_secondsPart(s)}';
  static String _secondsPart(double s)   { final secs = s % 60; return secs.toStringAsFixed(2).padLeft(5, '0'); }
  static String _twoDigits(int n)        => n.toString().padLeft(2, '0');
}