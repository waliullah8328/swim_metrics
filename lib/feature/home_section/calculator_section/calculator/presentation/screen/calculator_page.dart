import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';

import 'package:swim_metrics/core/common/widgets/custom_text.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/custom_text_form_field.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/core/utils/constants/icon_path.dart';
import 'package:swim_metrics/feature/home_section/calculator_section/calculator/presentation/screen/splict_custom_widget.dart';

import 'package:swim_metrics/feature/home_section/calculator_section/calculator/presentation/screen/widget/custom_drawer_widget.dart';
import 'package:swim_metrics/feature/home_section/calculator_section/calculator/presentation/screen/widget/distance_wheel_selector_widget.dart';
import 'package:swim_metrics/l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../../../config/route/routes_name.dart';
import '../../../../../../core/services/token_storage.dart';

import '../../../setting_section/settings/riverpod/setting_controller.dart';
import '../../riverpod/calculations.dart';
import '../../riverpod/calculator_split_state.dart';
import '../../riverpod/split_calculator.dart';

final currencyProvider = StateProvider<String>((ref) => "SCY");
final showCourseSectionProvider = StateProvider<bool>((ref) => true);
class SplitCalculatorPage extends ConsumerStatefulWidget {
  const SplitCalculatorPage({super.key});

  @override
  ConsumerState<SplitCalculatorPage> createState() => _SplitCalculatorPageState();
}

class _SplitCalculatorPageState extends ConsumerState<SplitCalculatorPage> {
  late TextEditingController timeController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    checkPlanExpiry( context);

    timeController = TextEditingController();
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

  @override
  void dispose() {
    timeController.dispose(); // ✅ prevent memory leak
    super.dispose();
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

    final fontOption = ref.watch(settingsProvider).fontSize;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final showCourse = ref.watch(showCourseSectionProvider);
    final isHaptic = ref.watch(settingsProvider.select((s)=>s.haptic));

    return Scaffold(
      key: _scaffoldKey,

      drawer: CustomDrawer(),
      appBar: AppBar(
        title: CustomText(text: AppLocalizations.of(context)!.splitCalculator,fontSize: getAdjustedFontSize(24, fontOption).sp,fontWeight: FontWeight.w600,),
        centerTitle: true,
        leading: GestureDetector(
          onTap: (){
            _scaffoldKey.currentState?.openDrawer();
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
          child: Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.shade300,
          ),
        ),
      ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if(!showCourse)
                  Center(
                    child: GestureDetector(
                      onTap: (){
                        ref.read(showCourseSectionProvider.notifier).state = true;

                      },
                      child: Column(
                        children: [
                          SizedBox(height: 10.h,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(IconPath.pullIcon),
                              CustomText(text: AppLocalizations.of(context)!.pullDownToSeeOptions,fontSize: getAdjustedFontSize(14, fontOption).sp,color: Color(0xffC7C7C7),)
                            ],
                          ),
                          SizedBox(height: 20.h,)
                        ],
                      ),
                    ),

                  ),

                /// COURSE CARD
                Container(
                  decoration: BoxDecoration(
                    color: isDark?AppColors.darkThemeContainerColor: Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        spreadRadius: 1,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding:  EdgeInsets.only(left: 16.w,right: 16.w,top: 10.h,bottom: 16.h),
                    child: Column(
                      children: [
                        if(showCourse)
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: AppLocalizations.of(context)!.course,
                                    fontSize: getAdjustedFontSize(20, fontOption).sp,
                                    color: AppColors.primary,
                                  ),


                                  Consumer(
                                    builder: (context, ref, child) {
                                      final state = ref.watch(splitCalcProvider);

                                      // ✅ Ensure safe value and default to SCY
                                      final course = state.course.trim().toUpperCase();
                                      const validCourses = ["SCY", "SCM", "LCM"];
                                      final selected = validCourses.contains(course) ? course : "SCY";

                                      // Dropdown display names (localized if needed)
                                      final displayItems = {
                                        "SCY": AppLocalizations.of(context)?.scy ?? "SCY",
                                        "SCM": AppLocalizations.of(context)?.scm ?? "SCM",
                                        "LCM": AppLocalizations.of(context)?.lcm ?? "LCM",
                                      };

                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: isDark ? const Color(0xff033A5E) : const Color(0xFFD9D9D9),
                                          borderRadius: BorderRadius.circular(40),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: selected,
                                            isDense: true,
                                            itemHeight: null,
                                            icon: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Color(0xFFB8892D),
                                            ),
                                            dropdownColor: isDark ? const Color(0xff033A5E) : const Color(0xFFD9D9D9),
                                            style: TextStyle(
                                              color: const Color(0xFFB8892D),
                                              fontSize: getAdjustedFontSize(12, fontOption).sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            items: validCourses
                                                .map((c) => DropdownMenuItem<String>(
                                              value: c,
                                              child: Text(displayItems[c]!),
                                            ))
                                                .toList(),
                                            onChanged: (value) {
                                              if (value == null) return;

                                              // ✅ Update provider safely
                                              ref.read(splitCalcProvider.notifier).setCourse(value.toLowerCase());
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),

                              /// GENDER, STROKE, DIST
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        /// ===================== GENDER =====================
                        Expanded(
                          child: Column(
                            children: [
                              CustomText(
                                text: AppLocalizations.of(context)!.gender,
                                fontSize: 16.sp,
                                color: AppColors.primary,
                              ),
                              SizedBox(height: 6.h),

                              Consumer(
                                builder: (context, ref, child) {
                                  final state = ref.watch(splitCalcProvider);

                                  const rawItems = ["men", "women"];

                                  String capitalize(String s) =>
                                      s.isNotEmpty
                                          ? '${s[0].toUpperCase()}${s.substring(1)}'
                                          : s;

                                  /// ✅ VALIDATE STATE
                                  final current = state.gender.toLowerCase();
                                  final isValid = rawItems.contains(current);
                                  final safeGender = isValid ? current : rawItems.first;

                                  /// 🔥 FORCE SYNC
                                  if (!isValid) {
                                    Future.microtask(() {
                                      ref.read(splitCalcProvider.notifier).setGender(safeGender);
                                    });
                                  }

                                  return SplitCalculatorSelector(
                                    items: rawItems.map(capitalize).toList(),
                                    selectedValue: capitalize(safeGender),
                                    onChanged: (value) {
                                      ref
                                          .read(splitCalcProvider.notifier)
                                          .setGender(value.toLowerCase());
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 12.w),

                        /// ===================== STROKE =====================
                        Expanded(
                          child: Column(
                            children: [
                              CustomText(
                                text: AppLocalizations.of(context)!.stroke,
                                fontSize: 16.sp,
                                color: AppColors.primary,
                              ),
                              SizedBox(height: 6.h),

                              Consumer(
                                builder: (context, ref, child) {
                                  final state = ref.watch(splitCalcProvider);
                                  final course = state.course.toLowerCase();
                                  final gender = state.gender.toLowerCase();

                                  final Map<String, dynamic>? strokesMap =
                                  (course == 'scy'
                                      ? SwimSplitCalculator1.ratiosScy[gender]
                                      : course == 'scm'
                                      ? SwimSplitCalculator1.ratiosScm[gender]
                                      : SwimSplitCalculator1.ratiosLcm[gender])
                                  as Map<String, dynamic>?;

                                  List<String> availableStrokes =
                                  (strokesMap?.keys.toList() ?? [])
                                      .map((e) => e.toString().toLowerCase())
                                      .toSet()
                                      .toList();

                                  const strokeOrder = [
                                    'fly',
                                    'back',
                                    'breast',
                                    'free',
                                    'im'
                                  ];

                                  availableStrokes.sort((a, b) {
                                    final indexA = strokeOrder.indexOf(a);
                                    final indexB = strokeOrder.indexOf(b);
                                    return (indexA == -1 ? 99 : indexA)
                                        .compareTo(indexB == -1 ? 99 : indexB);
                                  });

                                  if (availableStrokes.isEmpty) {
                                    return const SizedBox();
                                  }

                                  /// ✅ VALIDATE STATE
                                  final current = state.stroke.toLowerCase();
                                  final isValid = availableStrokes.contains(current);
                                  final safeStroke =
                                  isValid ? current : availableStrokes.first;

                                  /// 🔥 FORCE SYNC
                                  if (!isValid) {
                                    Future.microtask(() {
                                      ref
                                          .read(splitCalcProvider.notifier)
                                          .setStroke(safeStroke);
                                    });
                                  }

                                  String formatStroke(String s) {
                                    if (s.isEmpty) return '';
                                    return s == 'im'
                                        ? 'IM'
                                        : '${s[0].toUpperCase()}${s.substring(1)}';
                                  }

                                  return SplitCalculatorSelector(
                                    items: availableStrokes.map(formatStroke).toList(),
                                    selectedValue: formatStroke(safeStroke),
                                    onChanged: (value) {
                                      ref
                                          .read(splitCalcProvider.notifier)
                                          .setStroke(value.toLowerCase());
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 12.w),

                        /// ===================== DISTANCE =====================
                        Expanded(
                          child: Column(
                            children: [
                              CustomText(
                                text: AppLocalizations.of(context)!.dist,
                                fontSize: 16.sp,
                                color: AppColors.primary,
                              ),
                              SizedBox(height: 6.h),

                              Consumer(
                                builder: (context, ref, child) {
                                  final state = ref.watch(splitCalcProvider);

                                  final distances = getDistances(
                                    state.course,
                                    state.stroke,
                                    state.gender,
                                  );

                                  if (distances.isEmpty) {
                                    return const SizedBox();
                                  }

                                  final currentDistance = int.tryParse(state.distance);

                                  final safeDistance =
                                  (currentDistance != null && distances.contains(currentDistance))
                                      ? currentDistance
                                      : distances.first;

                                  /// ✅ ONLY update when really needed (NO rebuild loop)
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    final current = ref.read(splitCalcProvider).distance;
                                    if (current != safeDistance.toString()) {
                                      ref
                                          .read(splitCalcProvider.notifier)
                                          .setDistance(safeDistance.toString());
                                    }
                                  });

                                  return DistanceWheelSelector(
                                    key: ValueKey(safeDistance), // 🔥 VERY IMPORTANT FIX
                                    items: distances,
                                    selectedValue: safeDistance,
                                    onChanged: (value) {
                                      ref
                                          .read(splitCalcProvider.notifier)
                                          .setDistance(value.toString());
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                            ],
                          ),
                        


                        SizedBox(height: 20.h),
                        CustomText(
                          text: AppLocalizations.of(context)!.goalTime,
                          fontSize: getAdjustedFontSize(18, fontOption).sp,
                          color: AppColors.primary,
                        ),
                        SizedBox(height: 16.h),
                        CustomTextField(
                          keyboardType: TextInputType.text,
                          hintText: AppLocalizations.of(context)!.enterYourTime,
                          onChanged: (value){
                            ref.read(splitCalcProvider.notifier).setGoalTime(value);
                          },
                          controller: timeController,

                        ),

                        SizedBox(height: 16.h),






                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(double.infinity, 52.h),
                          ),
                          onPressed: () {
                            if (isHaptic) HapticFeedback.lightImpact();

                            ref.read(splitCalcProvider.notifier).calculate();
                            ref.read(showCourseSectionProvider.notifier).state = false;
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  IconPath.calculatorSplitIcon,
                                  colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                                ),
                                SizedBox(width: 6.w),
                                CustomText(
                                  text: AppLocalizations.of(context)!.calculateSplit,
                                  fontSize: getAdjustedFontSize(14, fontOption).sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                        ),


                      ],
                    ),
                  ),
                ),

                 SizedBox(height: 20.h),



                Consumer(
                  builder: (context, ref, child) {
                    final history = ref.watch(splitCalcProvider).history;

                    if (history.isEmpty) return const SizedBox();

                    // Reverse the history to show the latest first
                    final reversedHistory = history.reversed.toList();

                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 1, color: Color(0xff2DA8F0)),
                        boxShadow: const [BoxShadow(blurRadius: 12, color: Colors.black12)],
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reversedHistory.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 30), // 30px gap
                        itemBuilder: (context, index) {
                          final item = reversedHistory[index];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.output),
                              const SizedBox(height: 8),
                              ...item.splits.map((s) => Text(s.toString())).toList(),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),






                /// ACTION BUTTONS
                 if(ref.watch(splitCalcProvider).history.isNotEmpty)
                   Padding(
                     padding:  EdgeInsets.only(top: 16.h),
                     child: Row(
                       children: [
                         Expanded(
                           child: ElevatedButton(
                             style: ElevatedButton.styleFrom(
                                 backgroundColor:Color(0xff234B6E),
                                 side: BorderSide(color: Color(0xff234B6E))
                             ),
                             onPressed: () {
                               if(isHaptic == true){
                                 HapticFeedback.lightImpact(); // 👈 HAPTIC HERE

                               }
                               ref.watch(splitCalcProvider.notifier).clearHistory();
                             },
                             child: Center(
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   SvgPicture.asset(IconPath.clearIcon,colorFilter: ColorFilter.mode(AppColors.textWhite, BlendMode.srcIn),),
                                   SizedBox(width: 6.w,),
                                   CustomText(text:  AppLocalizations.of(context)!.clear,fontSize: getAdjustedFontSize(16, fontOption).sp,color: AppColors.textWhite,fontWeight: FontWeight.w700,),
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
                               if (isHaptic == true) {
                                 HapticFeedback.lightImpact(); // 👈 HAPTIC HERE
                               }

                               final history = ref.read(splitCalcProvider).history;
                               exportHistoryAsPdf(context, history);
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
                   ),

              ],
            ),
          ),
        )
    );
  }



  Future<void> exportHistoryAsPdf(BuildContext context, List history) async {
    final pdf = pw.Document();

    // Load logo
    final ByteData logoData = await rootBundle.load('assets/images/app_logo.png');
    final Uint8List logoBytes = logoData.buffer.asUint8List();

    // Load Merriweather TTF font
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
              pw.Text('Page ${context.pageNumber}', style: pw.TextStyle(font: ttf, fontSize: 12)),
              pw.Image(pw.MemoryImage(logoBytes), width: 50, height: 50),
            ],
          );
        },
        build: (pw.Context context) {
          return history.reversed.map<pw.Widget>((item) {
            final lines = item.output?.split('\n') ?? [];

            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 16),
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.blue, width: 1),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  ...lines.map((line) {
                    // Replace spaces with non-breaking spaces to preserve alignment
                    final formattedLine = line.replaceAll(' ', '\u00A0');
                    return pw.Text(
                      formattedLine,
                      style: pw.TextStyle(font: ttf, fontSize: 12),
                      softWrap: true,
                    );
                  }).toList(),
                ],
              ),
            );
          }).toList();
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

  static List<int> getDistances(String course, String stroke, String gender) {
    course = course.toLowerCase().trim();
    stroke = stroke.toLowerCase().trim();
    gender = gender.toLowerCase().trim();

    Map<String, dynamic>? data;

    if (course == "scy") {
      data = SwimSplitCalculator1.ratiosScy[gender]?[stroke];
    } else if (course == "scm") {
      data = SwimSplitCalculator1.ratiosScm[gender]?[stroke];
    } else if (course == "lcm") {
      data = SwimSplitCalculator1.ratiosLcm[gender]?[stroke];
    }

    if (data == null || data.isEmpty) return []; // ✅ fix

    final distances = data.keys
        .map((k) => int.tryParse(k) ?? 0)
        .where((e) => e > 0)
        .toList();

    distances.sort();
    return distances;
  }
}






Widget genderButton(WidgetRef ref,String value) {
  final state = ref.watch(splitProvider);
  final notifier = ref.read(splitProvider.notifier);

  return GestureDetector(
    onTap: () => notifier.setGender(value),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: state.gender == value
            ? const Color(0xff1B6AA5)
            : const Color(0xff0D446F),
      ),
      child: Text(value,style: const TextStyle(color: Colors.white)),
    ),
  );
}
Widget strokeButton(WidgetRef ref,String value) {
  final state = ref.watch(splitProvider);
  final notifier = ref.read(splitProvider.notifier);

  return GestureDetector(
    onTap: () => notifier.setGender(value),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: state.gender == value
            ? const Color(0xff1B6AA5)
            : const Color(0xff0D446F),
      ),
      child: Text(value,style: const TextStyle(color: Colors.white)),
    ),
  );
}
Widget distButton(WidgetRef ref,String value) {
  final state = ref.watch(splitProvider);
  final notifier = ref.read(splitProvider.notifier);

  return GestureDetector(
    onTap: () => notifier.setGender(value),
    child: Container(
      padding:  EdgeInsets.symmetric(horizontal: 20.w,vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: state.gender == value
            ? const Color(0xff1B6AA5)
            : const Color(0xff0D446F),
      ),
      child: Text(value,style: const TextStyle(color: Colors.white)),
    ),
  );
}

extension StringCasingExtension on String {
  String capitalize() => length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
}