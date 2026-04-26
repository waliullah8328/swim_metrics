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

  @override
  void initState() {
    super.initState();
    checkPlanExpiry(context);

    final state1 = ref.read(converterProvider1);
    timeController.text = state1.timeText;
  }

  Future<void> checkPlanExpiry(BuildContext context) async {
    final planEndDate = await TokenStorage.getPlanEndDate();


    if (planEndDate == null) return;

    if (DateTime.now().isAfter(planEndDate)) {
      // ❌ Plan expired → logout
      await TokenStorage.clearAll();
      await TokenStorage.deleteLoginFlag();

      // Navigate to login
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
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    final showCourse = ref.watch(showCourseSectionConverter);
    final fontOption = ref
        .watch(settingsProvider)
        .fontSize;
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
            if (isHaptic == true) {
              HapticFeedback.lightImpact(); // 👈 HAPTIC HERE

            }
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

        /// Divider below AppBar
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
                    ref
                        .read(showCourseSectionConverter.notifier)
                        .state = true;
                    if (isHaptic == true) {
                      HapticFeedback.lightImpact(); // 👈 HAPTIC HERE

                    }
                  },
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(IconPath.pullIcon),
                          CustomText(
                            text: AppLocalizations.of(
                              context,
                            )!.pullDownToSeeOptions,
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
                color: isDark ? Color(0xff0C3156) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(blurRadius: 6, color: Colors.black12),
                ],
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
                                    fontSize: getAdjustedFontSize(
                                      16,
                                      fontOption,
                                    ).sp,
                                  ),
                                  SizedBox(height: 8.h),
                                  Consumer(
                                    builder: (context, ref, child) {
                                      final state1 = ref.watch(
                                        converterProvider1.select(
                                              (s) => s.gender,
                                        ),
                                      );

                                      // convert to match UI
                                      final selectedValue = state1.isNotEmpty
                                          ? state1[0].toUpperCase() +
                                          state1.substring(1)
                                          : "";
                                      final controller1 = ref.read(
                                        converterProvider1.notifier,
                                      );
                                      debugPrint(state1.toString());

                                      return SplitCalculatorSelectorOne(
                                        items: const ["Men", "Women"],
                                        selectedValue:
                                        selectedValue,
                                        // ✅ keep selected after refresh
                                        onChanged: (v) =>
                                            controller1.setGender(v),
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
                                    fontSize: getAdjustedFontSize(
                                      16,
                                      fontOption,
                                    ).sp,
                                  ),
                                  SizedBox(height: 8.h),
                                  Consumer(
                                    builder: (context, ref, child) {
                                      final items = const [
                                        "Fly",
                                        "Back",
                                        "Breast",
                                        "Free",
                                        "IM",
                                      ];

                                      final state1 = ref.watch(
                                        converterProvider1.select(
                                              (s) => s.stroke,
                                        ),
                                      );

                                      // match lowercase state with UI list
                                      final selectedValue = items.firstWhere(
                                            (item) =>
                                        item.toLowerCase() == state1,
                                        orElse: () => "",
                                      );

                                      final controller1 = ref.read(
                                        converterProvider1.notifier,
                                      );

                                      return SplitCalculatorSelectorOne(
                                        items: items,
                                        selectedValue: selectedValue,
                                        onChanged: (selected) {
                                          controller1.setStroke(
                                            selected,
                                          ); // store lowercase inside
                                        },
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

                            /// ================= FROM COURSE =================
                            Expanded(
                              child: Column(
                                children: [
                                  CustomText(
                                    text: AppLocalizations.of(context)!.from,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: getAdjustedFontSize(
                                      16,
                                      fontOption,
                                    ).sp,
                                  ),
                                  SizedBox(height: 8.h),

                                  Consumer(
                                    builder: (context, ref, child) {
                                      const items = ["SCY", "SCM", "LCM"];

                                      final state = ref.watch(
                                          converterProvider1);
                                      final course = state.course;
                                      final stroke = state.stroke;

                                      final controller = ref.read(
                                          converterProvider1.notifier);

                                      final selectedValue = items.firstWhere(
                                            (item) =>
                                        item.toLowerCase() == course,
                                        orElse: () => items.first,
                                      );

                                      return SplitCalculatorSelectorOne(
                                        items: items,
                                        selectedValue: selectedValue,
                                        onChanged: (selected) {
                                          final newCourse = selected
                                              .toLowerCase();

                                          // ✅ use BOTH course + stroke
                                          // final distances = getDistances(newCourse, stroke);

                                          controller.setCourse(newCourse);

                                          // reset distance safely
                                          // controller.setDistance(distances.first);
                                        },
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),


                            /// ================= DISTANCE =================
                            Expanded(
                              child: Column(
                                children: [
                                  CustomText(
                                    text: AppLocalizations.of(
                                      context,
                                    )!.distance,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: getAdjustedFontSize(
                                      16,
                                      fontOption,
                                    ).sp,
                                  ),
                                  SizedBox(height: 8.h),

                                  Consumer(
                                    builder: (context, ref, child) {
                                      final state = ref.watch(
                                          converterProvider1);
                                      final controller = ref.read(
                                          converterProvider1.notifier);

                                      // ✅ use BOTH course + stroke
                                      final distances = getDistances(
                                        state.course,
                                        state.stroke,
                                      );

                                      // ✅ ensure valid selection
                                      final selectedDistance = distances
                                          .contains(state.distance)
                                          ? state.distance
                                          : distances.first;

                                      return SplitCalculatorSelectorOne(
                                        items: distances,
                                        selectedValue: selectedDistance,
                                        onChanged: (value) {
                                          controller.setDistance(value);
                                        },
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
                                final state = ref.watch(converterProvider1);
                                final controller1 = ref.read(
                                  converterProvider1.notifier,
                                );
                                return Row(
                                  children: [
                                    // SCY
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Checkbox(
                                          value: state.targets.contains('scy'),
                                          onChanged:
                                          state.course.isNotEmpty &&
                                              state.course == 'scy'
                                              ? null
                                              : (val) {
                                            controller1.toggleTarget(
                                              'scy',
                                              val ?? false,
                                            );
                                            if (isHaptic) HapticFeedback.heavyImpact();
                                          }

                                        ),
                                        const Text('SCY'),
                                      ],
                                    ),
                                    const SizedBox(width: 12),

                                    // SCM
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Checkbox(
                                          value: state.targets.contains('scm'),
                                          onChanged:
                                          state.course.isNotEmpty &&
                                              state.course == 'scm'
                                              ? null
                                              : (val) {
                                            controller1.toggleTarget(
                                              'scm',
                                              val ?? false,
                                            );
                                            if (isHaptic) HapticFeedback.heavyImpact();
                                          }

                                        ),
                                        const Text('SCM'),
                                      ],
                                    ),
                                    const SizedBox(width: 12),

                                    // LCM
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Checkbox(
                                          value: state.targets.contains('lcm'),
                                          onChanged:
                                          state.course.isNotEmpty &&
                                              state.course == 'lcm'
                                              ? null
                                              : (val) {
                                            controller1.toggleTarget(
                                              'lcm',
                                              val ?? false,
                                            );
                                            if (isHaptic) HapticFeedback.heavyImpact();
                                          }

                                        ),
                                        Text('LCM'),
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
                  /// TIME INPUT
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Time (mm:ss.hh)",
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: getAdjustedFontSize(16, fontOption).sp,
                      ),
                      SizedBox(height: 10.h),

                      TextFormField(
                        controller: timeController,
                        // ✅ use controller
                        focusNode: timeFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "mm:ss.hh",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        onChanged: (value) {
                          ref
                              .read(converterProvider1.notifier)
                              .setTimeText(value);
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
                            }

                          );
                        },
                      ),
                    ],
                  ),

                  /// CONVERT BUTTON
                  GestureDetector(
                    onTap: () {
                      // Check if the time field is empty
                      if (timeController.text
                          .trim()
                          .isEmpty) {
                        // Show a Snackbar if the time field is empty
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!.enterYourTime,
                              // You can customize this message
                              style: TextStyle(fontSize: 14.sp,
                                  color: AppColors.backgroundDark),
                            ),
                            backgroundColor: Colors.grey,
                            duration: Duration(
                                seconds: 2), // Duration of Snackbar
                          ),
                        );
                      } else {
                        // Proceed with conversion if time field is not empty
                        controller1.convert(context: context);
                        ref
                            .read(showCourseSectionConverter.notifier)
                            .state = false;

                        // Trigger haptic feedback if enabled
                        if (isHaptic == true) {
                          HapticFeedback
                              .lightImpact(); // 👈 HAPTIC FEEDBACK HERE
                        }

                        final history = ref.watch(converterProvider1.select((s) => s.output));



                        // Reverse the history to show the latest first
                        final reversedHistory = history;
                        print(history.toString());

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
                    border: Border.all(
                      width: 1,
                      color: Color(0xff2DA8F0),
                    ),
                    boxShadow: const [
                      BoxShadow(blurRadius: 12, color: Colors.black12),
                    ],
                  ),

                  child: SingleChildScrollView(
                    child: CustomText(text:
                      output,
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
                              if (isHaptic == true) {
                                HapticFeedback.lightImpact(); // 👈 HAPTIC HERE

                              }
                            },
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(IconPath.clearIcon),
                                  SizedBox(width: 6.w),
                                  CustomText(
                                    text: AppLocalizations.of(
                                      context,
                                    )!.clear,
                                    fontSize: getAdjustedFontSize(
                                      16,
                                      fontOption,
                                    ).sp,
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
                              final output = ref
                                  .read(converterProvider1)
                                  .output;
                              exportOutputAsPdf(context, output);
                              if (isHaptic == true) {
                                HapticFeedback.lightImpact(); // 👈 HAPTIC HERE

                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  IconPath.exportIcon,
                                  colorFilter: ColorFilter.mode(
                                    Colors.black,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                CustomText(
                                  text: AppLocalizations.of(
                                    context,
                                  )!.export,
                                  fontSize: getAdjustedFontSize(
                                    16,
                                    fontOption,
                                  ).sp,
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

    // Common strokes (Fly, Back, Breast)
    const sprintStrokes = ["fly", "back", "breast"];

    if (course == 'lcm' || course == 'scm') {
      if (sprintStrokes.contains(stroke)) {
        return ["50", "100", "200"];
      } else if (stroke == "free") {
        return ["50", "100", "200", "400", "800", "1500"];
      } else if (stroke == "im") {
        return ["200", "400"];
      }
    }

    if (course == 'scy') {
      if (sprintStrokes.contains(stroke)) {
        return ["50", "100", "200"];
      } else if (stroke == "free") {
        return ["50", "100", "200", "500", "1000", "1650"];
      } else if (stroke == "im") {
        return ["100", "200", "400"];
      }
    }

    // fallback
    return ["50"];
  }


  // ═══════════════════════════════════════════════════════════
//  CONSTANTS
// ═══════════════════════════════════════════════════════════
  static const double _kPageMargin       = 28;
  static const double _kColumnGap        = 16;
  static const double _kHeaderHeight     = 60;   // SwimMetrics + divider
  static const double _kFooterHeight     = 20;
  static const double _kBlockPaddingV    = 12;   // top+bottom padding per block card
  static const double _kLineHeight       = 14.5; // per text line at font 10
  static const double _kTitleLineHeight  = 16.0; // bold header lines
  static const double _kInterBlockGap    = 10;   // gap between blocks

// ═══════════════════════════════════════════════════════════
//  HELPERS — measure how tall a block will be
// ═══════════════════════════════════════════════════════════
  double _measureBlock(List<String> lines) {
    double h = _kBlockPaddingV;
    for (final raw in lines) {
      final line = raw.trim();
      final isHeader = line.contains('===') ||
          line.contains('→') ||
          line.contains('Projection');
      h += isHeader ? _kTitleLineHeight : _kLineHeight;
      h += 3; // bottom padding per text row
    }
    return h;
  }

// ═══════════════════════════════════════════════════════════
//  MAIN EXPORT
// ═══════════════════════════════════════════════════════════
  Future<void> exportOutputAsPdf(
      BuildContext context,
      String output,
      ) async {
    if (output.trim().isEmpty) return;

    final pdf      = pw.Document();
    final fontData = await rootBundle.load('assets/font/Merriweather-font.ttf');
    final ttf      = pw.Font.ttf(fontData);

    // ── Parse: double-newline = section boundary ─────────────────────────
    final List<List<String>> allBlocks = output
        .split('\n\n')
        .map((s) => s
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList())
        .where((b) => b.isNotEmpty)
        .toList();

    // ── Page geometry ─────────────────────────────────────────────────────
    final double pageW        = PdfPageFormat.a4.width;
    final double pageH        = PdfPageFormat.a4.height;
    final double usableW      = pageW  - _kPageMargin * 2;
    final double usableH      = pageH  - _kPageMargin * 2
        - _kHeaderHeight
        - _kFooterHeight;
    final double colW         = (usableW - _kColumnGap) / 2;

    // ── Bin blocks into (page, column) slots ─────────────────────────────
    //   Structure: pages → columns(2) → blocks
    //   Fill col-0 → col-1 → new page col-0 → col-1 → …
    final List<List<List<List<String>>>> pages = [];

    List<List<String>> currentCol    = [];
    int                currentColIdx = 0;          // 0 = left, 1 = right
    double             colUsed       = 0;

    void _nextColumn() {
      // Save current column, advance
      if (pages.isEmpty || pages.last.length == 2) {
        // Start a new page with this column
        pages.add([List.from(currentCol)]);
      } else {
        // Add as right column of current page
        pages.last.add(List.from(currentCol));
      }
      currentCol    = [];
      currentColIdx = pages.isEmpty ? 0 : (pages.last.length % 2);
      colUsed       = 0;
    }

    for (final block in allBlocks) {
      final blockH = _measureBlock(block) + _kInterBlockGap;

      if (colUsed + blockH > usableH && currentCol.isNotEmpty) {
        // Current column is full — move to next column / page
        _nextColumn();
      }

      currentCol.add(block as dynamic); // ← fix below — store block itself
      colUsed += blockH;
    }

    // ── Flush remaining ───────────────────────────────────────────────────
    if (currentCol.isNotEmpty) {
      if (pages.isEmpty) {
        pages.add([List.from(currentCol)]);
      } else if (pages.last.length < 2) {
        pages.last.add(List.from(currentCol));
      } else {
        pages.add([List.from(currentCol)]);
      }
    }

    // Ensure every page has exactly 2 column slots (right may be empty)
    for (final page in pages) {
      while (page.length < 2) page.add([]);
    }

    // ── Build PDF — one pw.Page per logical page ──────────────────────────
    final int totalPages = pages.length;

    for (int pageIdx = 0; pageIdx < totalPages; pageIdx++) {
      final leftBlocks  = pages[pageIdx][0];
      final rightBlocks = pages[pageIdx][1];

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(_kPageMargin),
          build: (pw.Context ctx) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [

                // ── Header ───────────────────────────────────────────────
                pw.Center(
                  child: pw.Text(
                    'SwimMetrics',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Divider(thickness: 0.6),
                pw.SizedBox(height: 10),

                // ── Two columns ──────────────────────────────────────────
                pw.Expanded(
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [

                      // LEFT column
                      pw.SizedBox(
                        width: colW,
                        child: _buildColumn(leftBlocks, ttf),
                      ),

                      pw.SizedBox(width: _kColumnGap),

                      // RIGHT column
                      pw.SizedBox(
                        width: colW,
                        child: _buildColumn(rightBlocks, ttf),
                      ),
                    ],
                  ),
                ),

                // ── Footer ───────────────────────────────────────────────
                // pw.Divider(thickness: 0.4),
                // pw.Row(
                //   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                //   children: [
                //     pw.Text(
                //       'SwimMetrics Report',
                //       style: pw.TextStyle(
                //         font: ttf,
                //         fontSize: 8,
                //         color: PdfColors.grey600,
                //       ),
                //     ),
                //     pw.Text(
                //       'Page ${pageIdx + 1} of $totalPages',
                //       style: pw.TextStyle(
                //         font: ttf,
                //         fontSize: 8,
                //         color: PdfColors.grey600,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            );
          },
        ),
      );
    }

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
//  COLUMN BUILDER — stacks blocks top→bottom
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
//  BLOCK RENDERER
// ═══════════════════════════════════════════════════════════
  pw.Widget _buildOutputBlock(List<String> lines, pw.Font font) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: lines.map((raw) {
        final line = raw.trim();

        // Clean === decorators
        final display = line.replaceAll('=', '').replaceAll('-', '').trim();

        final bool isTitle   = line.contains('===') || line.contains('---');
        final bool isResult  = line.contains('→');
        final bool isSplit   = RegExp(r'^\d+(m)?:').hasMatch(line);

        return pw.Padding(
          padding: pw.EdgeInsets.only(
            bottom: 3,
            // Indent split lines
            left: isSplit ? 0 : 0,
          ),
          child: pw.Text(
            display,
            style: pw.TextStyle(
              font: font,
              fontSize: isTitle ? 11 : 10,
              fontWeight: isTitle || isResult
                  ? pw.FontWeight.bold
                  : pw.FontWeight.bold,
              color: isTitle
                  ? PdfColors.black
                  : isSplit
                  ? PdfColors.black
                  : PdfColors.black,
              lineSpacing: 1.4,
            ),
          ),
        );
      }).toList(),
    );
  }


}
