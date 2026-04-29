import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';

import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/l10n/app_localizations.dart';

import '../../../../../config/route/routes_name.dart';
import '../../../../../core/common/widgets/custom_text.dart';
import '../../../../../core/common/widgets/new_custon_widgets/custom_check_box_widget.dart';
import '../../../../../core/common/widgets/new_custon_widgets/split_calculator_selector_one.dart';
import '../../../../../core/services/token_storage.dart';
import '../../../../../core/utils/constants/icon_path.dart';

import '../../../calculator_section/calculator/presentation/screen/calculator_page.dart';
import '../../../calculator_section/calculator/presentation/screen/widget/custom_drawer_widget.dart';

import '../../../calculator_section/setting_section/settings/riverpod/setting_controller.dart';
import '../../riverpod/converter_controller1.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

final showCourseSectionConverter = StateProvider<bool>((ref) => true);

class ConverterScreen extends ConsumerStatefulWidget {
  const ConverterScreen({super.key});

  @override
  ConsumerState<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends ConsumerState<ConverterScreen> {
  final TextEditingController timeController = TextEditingController();
  final FocusNode timeFocusNode = FocusNode();

  // ✅ ValueNotifier — only rebuilds the suffix icon, not the whole screen
  final ValueNotifier<bool> _hasText = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    checkPlanExpiry(context);

    final state1 = ref.read(converterProvider1);
    timeController.text = state1.timeText;
    // ✅ Sync initial value
    _hasText.value = state1.timeText.isNotEmpty;
  }

  @override
  void dispose() {
    _hasText.dispose();
    timeController.dispose();
    timeFocusNode.dispose();
    super.dispose();
  }

  Future<void> checkPlanExpiry(BuildContext context) async {
    final planEndDate = await TokenStorage.getPlanEndDate();

    if (planEndDate == null) return;

    if (DateTime.now().isAfter(planEndDate)) {
      await TokenStorage.clearAll();
      await TokenStorage.deleteLoginFlag();
      context.go(RouteNames.loginScreen);
    }
  }

  double getAdjustedFontSize(double baseSize, FontSizeOption option) {
    switch (option) {
      case FontSizeOption.small:
        return baseSize - 2;
      case FontSizeOption.medium:
        return baseSize;
      case FontSizeOption.big:
        return baseSize + 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("build");

    final controller1 = ref.read(converterProvider1.notifier);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final showCourse = ref.watch(showCourseSectionConverter);
    final fontOption = ref.watch(settingsProvider).fontSize;
    final isHaptic = ref.watch(settingsProvider.select((s) => s.haptic));

    return Scaffold(
      key: scaffoldKey,
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: CustomText(
          text: AppLocalizations.of(context)!.converter,
          fontSize: getAdjustedFontSize(24, fontOption).sp,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            scaffoldKey.currentState?.openDrawer();
            if (isHaptic == true) HapticFeedback.lightImpact();
          },
          child: Padding(
            padding: EdgeInsets.only(left: 18.w),
            child: SvgPicture.asset(
              IconPath.lightModeDrawerIcon,
              height: 48.h,
              width: 48.w,
              fit: BoxFit.contain,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (!showCourse)
              Center(
                child: GestureDetector(
                  onTap: () {
                    ref.read(showCourseSectionConverter.notifier).state = true;
                    if (isHaptic == true) HapticFeedback.lightImpact();
                  },
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(IconPath.pullIcon),
                          CustomText(
                            text: AppLocalizations.of(context)!.pullDownToSeeOptions,
                            fontSize: getAdjustedFontSize(14, fontOption).sp,
                            color: Color(0xffC7C7C7),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkThemeContainerColor : Color(0xffFFFFFF),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
              ),
              child: Column(
                children: [
                  if (showCourse)
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  CustomText(
                                    text: AppLocalizations.of(context)!.gender,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: getAdjustedFontSize(16, fontOption).sp,
                                  ),
                                  SizedBox(height: 8.h),
                                  Consumer(
                                    builder: (context, ref, child) {
                                      final state1 = ref.watch(
                                        converterProvider1.select((s) => s.gender),
                                      );
                                      final selectedValue = state1.isNotEmpty
                                          ? state1[0].toUpperCase() + state1.substring(1)
                                          : "";
                                      final controller1 = ref.read(converterProvider1.notifier);
                                      return SplitCalculatorSelectorOne(
                                        items: const ["Men", "Women"],
                                        selectedValue: selectedValue,
                                        onChanged: (v) => controller1.setGender(v),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  CustomText(
                                    text: AppLocalizations.of(context)!.stroke,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: getAdjustedFontSize(16, fontOption).sp,
                                  ),
                                  SizedBox(height: 8.h),
                                  Consumer(
                                    builder: (context, ref, child) {
                                      final items = const ["Fly", "Back", "Breast", "Free", "IM"];
                                      final state1 = ref.watch(
                                        converterProvider1.select((s) => s.stroke),
                                      );
                                      final selectedValue = items.firstWhere(
                                            (item) => item.toLowerCase() == state1,
                                        orElse: () => "",
                                      );
                                      final controller1 = ref.read(converterProvider1.notifier);
                                      return SplitCalculatorSelectorOne(
                                        items: items,
                                        selectedValue: selectedValue,
                                        onChanged: (selected) => controller1.setStroke(selected),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  CustomText(
                                    text: AppLocalizations.of(context)!.from,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: getAdjustedFontSize(16, fontOption).sp,
                                  ),
                                  SizedBox(height: 8.h),
                                  Consumer(
                                    builder: (context, ref, child) {
                                      final courseOrderAsync = ref.watch(courseOrderProvider);

                                      final orderedItems = courseOrderAsync.maybeWhen(
                                        data: (courses) => courses,
                                        orElse: () => ["SCY", "SCM", "LCM"],
                                      );

                                      final middleItem = orderedItems[orderedItems.length ~/ 2];

                                      final state      = ref.watch(converterProvider1);
                                      final controller = ref.read(converterProvider1.notifier);

                                      final courseLower = state.course.toLowerCase().trim();

                                      // ✅ All comparisons in same case (lowercase)
                                      final validLowerItems = orderedItems.map((e) => e.toLowerCase()).toList();

                                      final selectedValue = orderedItems.firstWhere(
                                            (item) => item.toLowerCase() == courseLower,
                                        orElse: () => middleItem,
                                      );

                                      // ✅ Only sync when course is genuinely missing — consistent case comparison
                                      if (state.course.isEmpty || !validLowerItems.contains(courseLower)) {
                                        Future.microtask(
                                              () => controller.setCourse(middleItem.toLowerCase()),
                                        );
                                      }

                                      return SplitCalculatorSelectorOne(
                                        items: orderedItems,
                                        selectedValue: selectedValue,
                                        onChanged: (selected) {
                                          controller.setCourse(selected.toLowerCase());
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  CustomText(
                                    text: AppLocalizations.of(context)!.distance,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: getAdjustedFontSize(16, fontOption).sp,
                                  ),
                                  SizedBox(height: 8.h),
                                  Consumer(
                                    builder: (context, ref, child) {
                                      final state = ref.watch(converterProvider1);
                                      final controller = ref.read(converterProvider1.notifier);
                                      final distances = getDistances(state.course, state.stroke);
                                      final selectedDistance = distances.contains(state.distance)
                                          ? state.distance
                                          : distances.first;
                                      return SplitCalculatorSelectorOne(
                                        items: distances,
                                        selectedValue: selectedDistance,
                                        onChanged: (value) => controller.setDistance(value),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: AppLocalizations.of(context)!.to,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: getAdjustedFontSize(16, fontOption).sp,
                            ),
                            Consumer(
                              builder: (context, ref, child) {
                                final state      = ref.watch(converterProvider1);
                                final controller1 = ref.read(converterProvider1.notifier);

                                // ✅ Normalize once — state.course is stored lowercase
                                final courseLower = state.course.toLowerCase().trim();

                                return Row(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Checkbox(
                                          value: state.targets.contains('scy'),
                                          // ✅ Disable if this IS the selected from-course
                                          onChanged: courseLower == 'scy'
                                              ? null
                                              : (val) {
                                            controller1.toggleTarget('scy', val ?? false);
                                            if (isHaptic) HapticFeedback.heavyImpact();
                                          },
                                        ),
                                        const Text('SCY'),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Checkbox(
                                          value: state.targets.contains('scm'),
                                          onChanged: courseLower == 'scm'
                                              ? null
                                              : (val) {
                                            controller1.toggleTarget('scm', val ?? false);
                                            if (isHaptic) HapticFeedback.heavyImpact();
                                          },
                                        ),
                                        const Text('SCM'),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Checkbox(
                                          value: state.targets.contains('lcm'),
                                          onChanged: courseLower == 'lcm'
                                              ? null
                                              : (val) {
                                            controller1.toggleTarget('lcm', val ?? false);
                                            if (isHaptic) HapticFeedback.heavyImpact();
                                          },
                                        ),
                                        const Text('LCM'),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),

                  /// TIME INPUT
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "${AppLocalizations.of(context)!.time}(mm:ss.hh)",
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: getAdjustedFontSize(16, fontOption).sp,
                      ),
                      SizedBox(height: 10.h),

                      TextFormField(
                        controller: timeController,
                        focusNode: timeFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "mm:ss.hh",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          // ✅ ValueListenableBuilder — only this icon widget rebuilds
                          suffixIcon: ValueListenableBuilder<bool>(
                            valueListenable: _hasText,
                            builder: (context, hasText, _) {
                              return hasText
                                  ? GestureDetector(
                                onTap: () {
                                  timeController.clear();
                                  _hasText.value = false; // ✅ no setState
                                  ref.read(converterProvider1.notifier).setTimeText('');
                                },
                                child: const Icon(Icons.close, size: 18),
                              )
                                  : const SizedBox.shrink();
                            },
                          ),
                        ),
                        onChanged: (value) {
                          _hasText.value = value.isNotEmpty; // ✅ no setState — only icon rebuilds
                          ref.read(converterProvider1.notifier).setTimeText(value);
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        text: AppLocalizations.of(context)!.showSplits,
                        fontSize: 14.sp,
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final isRemember = ref.watch(
                            converterProvider1.select((s) => s.showSplits),
                          );
                          return CustomCheckBoxWidget(
                            value: isRemember,
                            onChanged: (v) {
                              controller1.setShowSplits(v ?? false);
                              if (isHaptic) HapticFeedback.heavyImpact();
                            },
                          );
                        },
                      ),
                    ],
                  ),

                  /// CONVERT BUTTON
                  GestureDetector(
                    onTap: () {
                      if (timeController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!.enterYourTime,
                              style: TextStyle(fontSize: 14.sp, color: AppColors.backgroundDark),
                            ),
                            backgroundColor: Colors.grey,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        controller1.convert(context: context);
                        ref.read(showCourseSectionConverter.notifier).state = false;
                        if (isHaptic == true) HapticFeedback.lightImpact();
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 55.h,
                      decoration: BoxDecoration(
                        color: const Color(0xffc59d3f),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(IconPath.calculatorSplitIcon),
                          SizedBox(width: 6.w),
                          CustomText(
                            text: AppLocalizations.of(context)!.convertTime,
                            fontSize: getAdjustedFontSize(16, fontOption).sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.backgroundDark,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            Consumer(
              builder: (context, ref, child) {
                final output = ref.watch(
                  converterProvider1.select((s) => s.output),
                );
                return output.isEmpty
                    ? SizedBox()
                    : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Color(0xff0C3156) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 1, color: Color(0xff2DA8F0)),
                    boxShadow: const [BoxShadow(blurRadius: 12, color: Colors.black12)],
                  ),
                  child: SingleChildScrollView(
                    child: CustomText(
                      text: output,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),

            Consumer(
              builder: (context, ref, child) {
                final output = ref.watch(
                  converterProvider1.select((s) => s.output),
                );
                return output.isEmpty
                    ? SizedBox()
                    : Column(
                  children: [
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff234B6E),
                              side: BorderSide(color: Color(0xff234B6E)),
                            ),
                            onPressed: () {
                              controller1.reset();
                              if (isHaptic == true) HapticFeedback.lightImpact();
                            },
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(IconPath.clearIcon),
                                  SizedBox(width: 6.w),
                                  CustomText(
                                    text: AppLocalizations.of(context)!.clear,
                                    fontSize: getAdjustedFontSize(16, fontOption).sp,
                                    color: AppColors.textWhite,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            onPressed: () {
                              final output = ref.read(converterProvider1).output;
                              exportOutputAsPdf(context, output);
                              if (isHaptic == true) HapticFeedback.lightImpact();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  IconPath.exportIcon,
                                  colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                                ),
                                SizedBox(width: 6.w),
                                CustomText(
                                  text: AppLocalizations.of(context)!.export,
                                  fontSize: getAdjustedFontSize(16, fontOption).sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<String> getDistances(String course, String stroke) {
    course = course.toLowerCase();
    stroke = stroke.toLowerCase();

    final Map<String, List<String>> scy = {
      "fly": ["50", "100", "200"],
      "back": ["50", "100", "200"],
      "breast": ["50", "100", "200"],
      "free": ["50", "100", "200", "500", "1000", "1650"],
      "im": ["100", "200", "400"],
    };

    final Map<String, List<String>> scmLcm = {
      "fly": ["50", "100", "200"],
      "back": ["50", "100", "200"],
      "breast": ["50", "100", "200"],
      "free": ["50", "100", "200", "400", "800", "1500"],
      "im": ["100", "200", "400"],
    };

    if (course == "scy") {
      return scy[stroke] ?? ["50"];
    } else if (course == "scm" || course == "lcm") {
      return scmLcm[stroke] ?? ["50"];
    } else {
      return ["50"];
    }
  }

  List<String> getDistancesByCourseAndStroke(String course, String stroke) {
    course = course.toLowerCase().trim();
    stroke = stroke.toLowerCase().trim();
    const sprintStrokes = ["fly", "back", "breast"];

    if (course == 'lcm' || course == 'scm') {
      if (sprintStrokes.contains(stroke)) return ["50", "100", "200"];
      if (stroke == "free") return ["50", "100", "200", "400", "800", "1500"];
      if (stroke == "im") return ["200", "400"];
    }
    if (course == 'scy') {
      if (sprintStrokes.contains(stroke)) return ["50", "100", "200"];
      if (stroke == "free") return ["50", "100", "200", "500", "1000", "1650"];
      if (stroke == "im") return ["100", "200", "400"];
    }
    return ["50"];
  }

  // ═══════════════════════════════════════════════════════════
  //  CONSTANTS — tuned for full page utilization
  // ═══════════════════════════════════════════════════════════
  static const double _kPageMarginH     = 20;    // ✅ reduced: more horizontal space
  static const double _kPageMarginV     = 20;    // ✅ reduced: more vertical space
  static const double _kHeaderHeight    = 45;    // ✅ reduced: header takes less space
  static const double _kColumnGap       = 10;
  static const double _kBlockPaddingV   = 4;     // ✅ reduced: tighter block padding
  static const double _kLineHeight      = 9 * 1.2;  // ✅ tighter line spacing
  static const double _kTitleLineHeight = 11 * 1.2; // ✅ tighter title spacing
  static const double _kInterBlockGap   = 4;     // ✅ reduced: tighter gap between blocks
  static const double _kBottomReserve   = 20;    // ✅ exactly 20px empty at bottom

  // ═══════════════════════════════════════════════════════════
  //  MEASURE — how tall a block will be
  // ═══════════════════════════════════════════════════════════
  double _measureBlock(List<String> lines) {
    double h = _kBlockPaddingV * 2; // top + bottom padding
    for (final raw in lines) {
      final line = raw.trim();
      final isHeader = line.contains('===') ||
          line.contains('→') ||
          line.contains('Projection');
      h += isHeader ? _kTitleLineHeight : _kLineHeight;
    }
    h += _kInterBlockGap; // gap after block
    return h;
  }

  // ═══════════════════════════════════════════════════════════
  //  MAIN EXPORT
  // ═══════════════════════════════════════════════════════════
  Future<void> exportOutputAsPdf(BuildContext context, String output) async {
    if (output.trim().isEmpty) return;

    final pdf      = pw.Document();
    final fontData = await rootBundle.load('assets/font/Merriweather-font.ttf');
    final ttf      = pw.Font.ttf(fontData);

    // ── Parse blocks ─────────────────────────────────────────
    final List<List<String>> allBlocks = output
        .split('\n\n')
        .map((s) => s
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList())
        .where((b) => b.isNotEmpty)
        .toList();

    // ── Page geometry ─────────────────────────────────────────
    final double pageW   = PdfPageFormat.a4.width;
    final double pageH   = PdfPageFormat.a4.height;
    final double usableW = pageW - (_kPageMarginH * 2);
    // ✅ subtract bottom reserve so last block stops 20px from bottom
    final double usableH = pageH
        - (_kPageMarginV * 2)
        - _kHeaderHeight
        - _kBottomReserve;
    final double colW    = (usableW - _kColumnGap) / 2;

    // ── Bin blocks: LEFT fills first → RIGHT → new page ──────
    final List<List<List<List<String>>>> pages = [];

    List<List<String>> col0     = [];
    List<List<String>> col1     = [];
    double             col0Used = 0;
    double             col1Used = 0;

    void flushPage() {
      pages.add([List.from(col0), List.from(col1)]);
      col0 = []; col1 = []; col0Used = 0; col1Used = 0;
    }

    for (final block in allBlocks) {
      final blockH = _measureBlock(block);

      if (col0Used + blockH <= usableH) {
        // ✅ Step 1: left column has room
        col0.add(block);
        col0Used += blockH;
      } else if (col1Used + blockH <= usableH) {
        // ✅ Step 2: left full, right has room
        col1.add(block);
        col1Used += blockH;
      } else {
        // ✅ Step 3: both full → flush, restart on left
        flushPage();
        col0.add(block);
        col0Used += blockH;
      }
    }

    // Flush remaining
    if (col0.isNotEmpty || col1.isNotEmpty) flushPage();

    // ── Build PDF pages ───────────────────────────────────────
    for (int pageIdx = 0; pageIdx < pages.length; pageIdx++) {
      final leftBlocks  = pages[pageIdx][0];
      final rightBlocks = pages[pageIdx][1];

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.only(
            left:   _kPageMarginH,
            right:  _kPageMarginH,
            top:    _kPageMarginV,
            bottom: _kBottomReserve, // ✅ exactly 20px bottom gap
          ),
          build: (pw.Context ctx) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [

                // ── Header ──────────────────────────────────
                pw.Center(
                  child: pw.Text(
                    'SwimMetrics',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Divider(thickness: 0.5),
                pw.SizedBox(height: 6),

                // ── Two columns ──────────────────────────────
                pw.Expanded(
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [

                      // LEFT column — fills first
                      pw.SizedBox(
                        width: colW,
                        child: _buildColumn(leftBlocks, ttf),
                      ),

                      pw.SizedBox(width: _kColumnGap),

                      // RIGHT column — fills after left
                      pw.SizedBox(
                        width: colW,
                        child: _buildColumn(rightBlocks, ttf),
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
      final file = File('${dir.path}/swim_metrics_output.pdf');
      await file.writeAsBytes(await pdf.save());
      if (context.mounted) await OpenFile.open(file.path);
    } catch (e) {
      debugPrint('PDF Export Error: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════
  //  COLUMN BUILDER — same logic, no changes
  // ═══════════════════════════════════════════════════════════
  pw.Widget _buildColumn(List<List<String>> blocks, pw.Font ttf) {
    if (blocks.isEmpty) return pw.SizedBox();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: blocks.map((block) {
        return pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: _kInterBlockGap),
          child: _buildOutputBlock(block, ttf),
        );
      }).toList(),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  BLOCK RENDERER — same logic, no changes
  // ═══════════════════════════════════════════════════════════
  pw.Widget _buildOutputBlock(List<String> lines, pw.Font font) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: lines.map((raw) {
        final line    = raw.trim();
        final display = line.replaceAll('=', '').replaceAll('-', '').trim();
        final bool isTitle  = line.contains('===') || line.contains('---');
        final bool isResult = line.contains('→');

        return pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 1),
          child: pw.Text(
            display,
            style: pw.TextStyle(
              font: font,
              fontSize: isTitle ? 11 : 9,
              fontWeight: isTitle || isResult
                  ? pw.FontWeight.bold
                  : pw.FontWeight.normal,
              color: PdfColors.black,
              lineSpacing: 1.2,
            ),
          ),
        );
      }).toList(),
    );
  }
}