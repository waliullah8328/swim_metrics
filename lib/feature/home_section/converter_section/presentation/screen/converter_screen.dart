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
    checkPlanExpiry( context);

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final showCourse = ref.watch(showCourseSectionConverter);
    final fontOption = ref.watch(settingsProvider).fontSize;
    final isHaptic = ref.watch(settingsProvider.select((s)=>s.haptic));

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
            if(isHaptic == true){
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
                    ref.read(showCourseSectionConverter.notifier).state = true;
                    if(isHaptic == true){
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
                                      14,
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
                                            selectedValue, // ✅ keep selected after refresh
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
                                      14,
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
                                        (item) => item.toLowerCase() == state1,
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
                                      14,
                                      fontOption,
                                    ).sp,
                                  ),
                                  SizedBox(height: 8.h),

                                  Consumer(
                                    builder: (context, ref, child) {
                                      const items = ["SCY", "SCM", "LCM"];

                                      final state = ref.watch(converterProvider1);
                                      final course = state.course;
                                      final stroke = state.stroke;

                                      final controller = ref.read(converterProvider1.notifier);

                                      final selectedValue = items.firstWhere(
                                            (item) => item.toLowerCase() == course,
                                        orElse: () => items.first,
                                      );

                                      return SplitCalculatorSelectorOne(
                                        items: items,
                                        selectedValue: selectedValue,
                                        onChanged: (selected) {
                                          final newCourse = selected.toLowerCase();

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
                                      14,
                                      fontOption,
                                    ).sp,
                                  ),
                                  SizedBox(height: 8.h),

                                  Consumer(
                                    builder: (context, ref, child) {
                                      final state = ref.watch(converterProvider1);
                                      final controller = ref.read(converterProvider1.notifier);

                                      // ✅ use BOTH course + stroke
                                      final distances = getDistances(
                                        state.course,
                                        state.stroke,
                                      );

                                      // ✅ ensure valid selection
                                      final selectedDistance = distances.contains(state.distance)
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
                              fontSize: getAdjustedFontSize(14, fontOption).sp,
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
                                              : (val) =>
                                                    controller1.toggleTarget(
                                                      'scy',
                                                      val ?? false,
                                                    ),
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
                                              : (val) =>
                                                    controller1.toggleTarget(
                                                      'scm',
                                                      val ?? false,
                                                    ),
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
                                              : (val) =>
                                                    controller1.toggleTarget(
                                                      'lcm',
                                                      val ?? false,
                                                    ),
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
                        fontSize: getAdjustedFontSize(14, fontOption).sp,
                      ),
                      SizedBox(height: 10.h),

                      TextFormField(
                        controller: timeController, // ✅ use controller
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
                      ),

                      Consumer(
                        builder: (context, ref, child) {
                          final isRemember = ref.watch(
                            converterProvider1.select((s) => s.showSplits),
                          );
                          return CustomCheckBoxWidget(
                            value: isRemember,
                            onChanged: (v) =>
                                controller1.setShowSplits(v ?? false),
                          );
                        },
                      ),
                    ],
                  ),

                  /// CONVERT BUTTON
                  GestureDetector(
                    onTap: () {
                      controller1.convert(context: context);
                      ref.read(showCourseSectionConverter.notifier).state =
                          false;
                      if(isHaptic == true){
                        HapticFeedback.lightImpact(); // 👈 HAPTIC HERE

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
                          child: Text(
                            output,
                            style: const TextStyle(fontFamily: 'monospace'),
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
                                    if(isHaptic == true){
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
                                    if(isHaptic == true){
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
      "im": ["100","200", "400"],
    };

    final Map<String, List<String>> scmLcm = {
      "fly": ["50", "100", "200"],
      "back": ["50", "100", "200"],
      "breast": ["50", "100", "200"],
      "free": ["50", "100", "200", "400", "800", "1500"],
      "im": ["100","200", "400"],
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
        return ["100","200", "400"];
      }
    }

    // fallback
    return ["50"];
  }

  Future<void> exportOutputAsPdf(BuildContext context, String output) async {
    if (output.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomText(
            text: AppLocalizations.of(context)!.noOutputToExport,
          ),
        ),
      );
      return;
    }

    final pdf = pw.Document();

    // Load logo from assets
    final ByteData logoData = await rootBundle.load('assets/images/app_logo.png');
    final Uint8List logoBytes = logoData.buffer.asUint8List();

    // Load a TrueType font that supports Unicode
    final fontData = await rootBundle.load('assets/font/Merriweather-font.ttf');
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) {
          return pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Page ${context.pageNumber}', style: pw.TextStyle(fontSize: 12,font: ttf )),
              pw.Image(pw.MemoryImage(logoBytes), width: 50, height: 50),
            ],
          );
        },
        build: (pw.Context context) {
          // Preserve spacing by splitting by line breaks
          final lines = output.split('\n');
          return [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: lines.map((line) {
                // Replace normal spaces with non-breaking spaces to preserve spacing
                final formattedLine = line.replaceAll(' ', '\u00A0');
                return pw.Text(
                  formattedLine,
                  style: pw.TextStyle( fontSize: 12,font: ttf),
                  softWrap: true,
                );
              }).toList(),
            ),
          ];
        },
      ),
    );

    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/swim_converter_output.pdf');
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomText(
            text: '${AppLocalizations.of(context)!.pDFSavedAt}: ${file.path}',
          ),
        ),
      );

      await OpenFile.open(file.path);
    } catch (e) {
      debugPrint("PDF export error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomText(
            text: AppLocalizations.of(context)!.failedToExportPDF,
          ),
        ),
      );
    }
  }
}
