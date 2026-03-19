import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_file/open_file.dart';

import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/l10n/app_localizations.dart';

import '../../../../../core/common/widgets/custom_text.dart';
import '../../../../../core/common/widgets/new_custon_widgets/custom_check_box_widget.dart';
import '../../../../../core/common/widgets/new_custon_widgets/split_calculator_selector_one.dart';
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


     final state1 = ref.read(converterProvider1);
     timeController.text = state1.timeText;
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

    return Scaffold(
      key: scaffoldKey,

      drawer: CustomDrawer(),
      appBar: AppBar(
        title: CustomText(text: AppLocalizations.of(context)!.converter,fontSize: getAdjustedFontSize(24, fontOption).sp,fontWeight: FontWeight.w600,),
        centerTitle: true,
        leading: GestureDetector(
          onTap: (){
            scaffoldKey.currentState?.openDrawer();
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
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            if(!showCourse)
              Center(
                child: GestureDetector(
                  onTap: (){
                    ref.read(showCourseSectionConverter.notifier).state = true;

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

            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: isDark?Color(0xff0C3156):Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 6,
                    color: Colors.black12,
                  )
                ],
              ),

              child: Column(
                children: [
                  if(showCourse)
                    Column(
                      children: [







                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  CustomText(
                                    text: AppLocalizations.of(
                                      context,
                                    )!.gender,

                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: getAdjustedFontSize(14, fontOption).sp,
                                  ),
                                  SizedBox(height: 8.h),
                                  Consumer(
                                    builder: (context, ref, child) {

                                      final state1 = ref.watch(
                                        converterProvider1.select((s) => s.gender),
                                      );

// convert to match UI
                                      final selectedValue =
                                      state1.isNotEmpty ? state1[0].toUpperCase() + state1.substring(1) : "";
                                      final controller1 = ref.read(converterProvider1.notifier);
                                      debugPrint(state1.toString());


                                      return SplitCalculatorSelectorOne(
                                        items: const [
                                          "Men",
                                          "Women",
                                        ],
                                        selectedValue: selectedValue, // ✅ keep selected after refresh
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
                                    text: AppLocalizations.of(
                                      context,
                                    )!.stroke,

                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: getAdjustedFontSize(14, fontOption).sp,
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
                                        converterProvider1.select((s) => s.stroke),
                                      );

                                      // match lowercase state with UI list
                                      final selectedValue = items.firstWhere(
                                            (item) => item.toLowerCase() == state1,
                                        orElse: () => "",
                                      );

                                      final controller1 = ref.read(converterProvider1.notifier);

                                      return SplitCalculatorSelectorOne(
                                        items: items,
                                        selectedValue: selectedValue,
                                        onChanged: (selected) {
                                          controller1.setStroke(selected); // store lowercase inside
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h,),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  CustomText(
                                    text: AppLocalizations.of(
                                      context,
                                    )!.from,

                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: getAdjustedFontSize(14, fontOption).sp,
                                  ),
                                  SizedBox(height: 8.h),
                                  Consumer(
                                    builder: (context, ref, child) {

                                      final items = const [
                                        "SCY",
                                        "SCM",
                                        "LCM",
                                      ];

                                      final state1 = ref.watch(
                                        converterProvider1.select((s) => s.course),
                                      );

                                      // match lowercase state with UI list
                                      final selectedValue = items.firstWhere(
                                            (item) => item.toLowerCase() == state1,
                                        orElse: () => "",
                                      );

                                      final controller1 = ref.read(converterProvider1.notifier);

                                      return SplitCalculatorSelectorOne(
                                        items: items,
                                        selectedValue: selectedValue,
                                        onChanged: (selected) {
                                          controller1.setCourse(selected); // store lowercase
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
                                    text: AppLocalizations.of(
                                      context,
                                    )!.distance,

                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: getAdjustedFontSize(14, fontOption).sp,
                                  ),
                                  SizedBox(height: 8.h),
                                  Consumer(
                                    builder: (context, ref, child) {
                                      final state = ref.watch(converterProvider1);
                                      final controller1 = ref.read(converterProvider1.notifier);

                                      return SplitCalculatorSelectorOne(
                                        items: const [
                                          "50",
                                          "100",
                                          "150",
                                          "200",
                                          "250",
                                          "300",
                                          "350",
                                          "400",
                                          "450",
                                          "500",
                                        ],
                                        selectedValue: state
                                            .distance, // ✅ keep selected after refresh
                                        onChanged: controller1.setDistance,

                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),



                          ],
                        ),
                        SizedBox(height: 20.h,),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: AppLocalizations.of(context)!.to,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: getAdjustedFontSize(14, fontOption).sp,
                            ),
                            Consumer(builder: (context,ref,child){

                              final state = ref.watch(converterProvider1);
                              final controller1 = ref.read(converterProvider1.notifier);
                              return Row(
                                children: [
                                  // SCY
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Checkbox(
                                        value: state.targets.contains('scy'),
                                        onChanged: state.course.isNotEmpty && state.course == 'scy'
                                            ? null
                                            : (val) => controller1.toggleTarget('scy', val ?? false),
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
                                        onChanged: state.course.isNotEmpty && state.course == 'scm'
                                            ? null
                                            : (val) => controller1.toggleTarget('scm', val ?? false),
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
                                        onChanged: state.course.isNotEmpty && state.course == 'lcm'
                                            ? null
                                            : (val) => controller1.toggleTarget('lcm', val ?? false),
                                      ),
                                      Text('LCM'),
                                    ],
                                  ),
                                ],
                              );
                            })
                          ],
                        ),
                        SizedBox(height: 20.h,),


                      ],
                    ),





                  /// TIME INPUT
                  /// TIME INPUT
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: AppLocalizations.of(context)!.timeMmSs,
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
                          hintText: "mm:ss or ss.ss",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),

                        ),
                        onChanged: (value) {
                          ref.read(converterProvider1.notifier).setTimeText(value);
                        },
                      ),
                    ],
                  ),



                  SizedBox(height: 20.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(text:
                      AppLocalizations.of(context)!.showSplits,
                      ),

                      Consumer(builder: (context, ref, child) {
                        final isRemember = ref.watch(converterProvider1.select((s)=>s.showSplits));
                        return CustomCheckBoxWidget(
                          value: isRemember,
                          onChanged: (v) => controller1.setShowSplits(v ?? false),
                        );
                      },)



                    ],
                  ),

                  /// CONVERT BUTTON

                  GestureDetector(
                    onTap: (){
                      controller1.convert(context: context);
                      ref.read(showCourseSectionConverter.notifier).state = false;
                    },
                    child: Container(
                      width: double.infinity,
                      height: 55.h,
                      decoration: BoxDecoration(
                        color: const Color(0xffc59d3f),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(IconPath.calculatorSplitIcon),
                          SizedBox(width: 6.w,),
                          CustomText(text:
                            AppLocalizations.of(context)!.convertTime,

                                fontSize: getAdjustedFontSize(16, fontOption).sp,
                                fontWeight: FontWeight.w600,
                              color: AppColors.backgroundDark


                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(height: 24.h,),

            Consumer(builder: (context,ref,child){
              final output = ref.watch(converterProvider1.select((s)=>s.output));

              return output .isEmpty?SizedBox():Container(
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: isDark?Color(0xff0C3156):Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 1,color:Color (0xff2DA8F0)),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 12,
                      color: Colors.black12,
                    )
                  ],
                ),

                child: SingleChildScrollView(
                  child: Text(
                    output ,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              );

            }),

            Consumer(builder: (context,ref,child){
              final output = ref.watch(converterProvider1.select((s)=>s.output));

              return output.isEmpty?SizedBox():Column(
                children: [
                  SizedBox(height: 24.h,),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:Color(0xff234B6E),
                              side: BorderSide(color: Color(0xff234B6E))
                          ),
                          onPressed: () {
                            controller1.reset();
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(IconPath.clearIcon),
                                SizedBox(width: 6.w,),
                                CustomText(text: AppLocalizations.of(context)!.clear,fontSize: getAdjustedFontSize(16, fontOption).sp,color: AppColors.textWhite,fontWeight: FontWeight.w700,),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:AppColors.primary,
                          ),
                          onPressed: (){
                            final output = ref.read(converterProvider1).output;
                            exportOutputAsPdf(context, output);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(IconPath.exportIcon,colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),),
                              SizedBox(width: 6.w,),
                              CustomText(text: AppLocalizations.of(context)!.export,fontSize: getAdjustedFontSize(16, fontOption).sp,fontWeight: FontWeight.w700,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );

            }),





          ],
        ),
      ),
    );
  }

   Future<void> exportOutputAsPdf(BuildContext context, String output) async {
     if (output.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content:CustomText(text: AppLocalizations.of(context)!.noOutputToExport)),
       );
       return;
     }

     final pdf = pw.Document();

     pdf.addPage(
       pw.Page(
         build: (pw.Context context) {
           return pw.Container(
             padding: const pw.EdgeInsets.all(16),
             child: pw.Text(
               output,
               style: pw.TextStyle(font: pw.Font.courier()),
             ),
           );
         },
       ),
     );

     try {
       final dir = await getTemporaryDirectory();
       final file = File('${dir.path}/swim_converter_output.pdf');
       await file.writeAsBytes(await pdf.save());

       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: CustomText(text: '${AppLocalizations.of(context)!.pDFSavedAt}: ${file.path}')),
       );

       // Open the PDF
       await OpenFile.open(file.path);
     } catch (e) {
       debugPrint("PDF export error: $e");
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: CustomText(text: AppLocalizations.of(context)!.failedToExportPDF)),
       );
     }
   }
}