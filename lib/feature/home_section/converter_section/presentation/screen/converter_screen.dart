import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_file/open_file.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/l10n/app_localizations.dart';

import '../../../../../core/common/widgets/custom_text.dart';
import '../../../../../core/common/widgets/new_custon_widgets/custom_check_box_widget.dart';
import '../../../../../core/common/widgets/new_custon_widgets/split_calculator_selector_one.dart';
import '../../../../../core/utils/constants/icon_path.dart';

import '../../../calculator_section/calculator/presentation/screen/widget/custom_drawer_widget.dart';
import '../../riverpod/converter_controller.dart';
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

   late stt.SpeechToText _speech;
   bool _isListening = false;

   @override
   void initState() {
     super.initState();
     _speech = stt.SpeechToText();

     final state1 = ref.read(converterProvider1);
     timeController.text = state1.timeText;
   }

   /// Start listening and update TextFormField
   Future<void> startListening() async {
     bool available = await _speech.initialize();
     if (available) {
       _isListening = true;
       _speech.listen(
         onResult: (result) {
           if (result.finalResult) {
             String spoken = result.recognizedWords;
             String time = convertSpeechToTime(spoken);
             timeController.text = time;
             ref.read(converterProvider1.notifier).setTimeText(time);
             _isListening = false;
           }
         },
       );
     }
   }

   /// Convert speech to mm:ss.ss format
   String convertSpeechToTime(String spoken) {
     // Map words to numbers
     final wordToNumber = {
       'zero': 0, 'one': 1, 'two': 2, 'three': 3, 'four': 4, 'five': 5,
       'six': 6, 'seven': 7, 'eight': 8, 'nine': 9, 'ten': 10,
       'eleven': 11, 'twelve': 12, 'thirteen': 13, 'fourteen': 14,
       'fifteen': 15, 'sixteen': 16, 'seventeen': 17, 'eighteen': 18,
       'nineteen': 19, 'twenty': 20
     };

     int hours = 0;
     int minutes = 0;
     double seconds = 0.0;

     final words = spoken.toLowerCase().split(' ');

     for (int i = 0; i < words.length; i++) {
       final word = words[i];
       final value = wordToNumber[word] ?? int.tryParse(word) ?? 0;

       if (i + 1 < words.length) {
         final next = words[i + 1];
         if (next.startsWith('hour')) {
           hours = value;
         } else if (next.startsWith('minute')) {
           minutes = value;
         } else if (next.startsWith('second')) {
           seconds = value.toDouble();
         }
       }
     }

     final totalMinutes = hours * 60 + minutes;
     final minStr = totalMinutes.toString().padLeft(2, '0');
     final secStr = seconds.toStringAsFixed(2).padLeft(5, '0'); // ss.ss

     return '$minStr:$secStr';
   }

  @override
  Widget build(BuildContext context) {

    debugPrint("build");



   

    final controller1 = ref.read(converterProvider1.notifier);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final showCourse = ref.watch(showCourseSectionConverter);

    return Scaffold(
      key: scaffoldKey,

      drawer: CustomDrawer(),
      appBar: AppBar(
        title: CustomText(text: AppLocalizations.of(context)!.converter,fontSize: 24.sp,fontWeight: FontWeight.w600,),
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
                          CustomText(text: AppLocalizations.of(context)!.pullDownToSeeOptions,fontSize: 14.sp,color: Color(0xffC7C7C7),)
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
                                    fontSize: 14.sp,
                                  ),
                                  SizedBox(height: 8.h),
                                  Consumer(
                                    builder: (context, ref, child) {

                                      final state1 = ref.watch(converterProvider1);
                                      final controller1 = ref.read(converterProvider1.notifier);


                                      return SplitCalculatorSelectorOne(
                                        items: const [
                                          "men",
                                          "women",
                                        ],
                                        selectedValue: state1.gender, // ✅ keep selected after refresh
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
                                    fontSize: 14.sp,
                                  ),
                                  SizedBox(height: 8.h),
                                  Consumer(
                                    builder: (context, ref, child) {
                                      final state = ref.watch(converterProvider);
                                      final controller1 = ref.read(converterProvider.notifier);

                                      return SplitCalculatorSelectorOne(
                                        items: const [
                                          "fly",
                                          "back",
                                          "free",
                                          "im",
                                          "breast",
                                        ],
                                        selectedValue: state
                                            .stroke, // ✅ keep selected after refresh
                                        onChanged: (selected) {
                                          //final internalValue = mapping[selected] ?? selected;
                                          controller1.selectStroke(selected);
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
                                    )!.distance,

                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
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
                            Expanded(
                              child: Column(
                                children: [
                                  CustomText(
                                    text: AppLocalizations.of(
                                      context,
                                    )!.from,

                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                                  SizedBox(height: 8.h),
                                  Consumer(
                                    builder: (context, ref, child) {
                                      final state1 = ref.watch(converterProvider1);
                                    

                                      return SplitCalculatorSelectorOne(
                                        items: const [
                                          "scy",
                                          "scm",
                                          "lcm",
                                        ],
                                        selectedValue: state1
                                            .course, // ✅ keep selected after refresh
                                        onChanged: controller1.setCourse,
                                        

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
                              fontSize: 16.sp,
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

                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     CustomText(text:
                        //     AppLocalizations.of(context)!.distance,
                        //
                        //       color: AppColors.primary,
                        //       fontWeight: FontWeight.w600,
                        //       fontSize: 14.sp,
                        //
                        //     ),
                        //
                        //     SizedBox(height: 10.h),
                        //
                        //
                        //
                        //     SizedBox(
                        //       width: double.infinity,
                        //       child: Consumer(builder: (context, ref, _) {
                        //         final state1 = ref.watch(converterProvider1);
                        //         final controller1 = ref.read(converterProvider1.notifier);
                        //
                        //         const distanceItems = ["50", "100", "150", "200", "250","500"];
                        //
                        //         return PopupMenuButton<String>(
                        //           color: isDark?Color(0xff153250):Colors.white,
                        //           /// move dropdown to the right
                        //           offset: const Offset(100, 45),
                        //           onSelected: controller1.setDistance,
                        //           itemBuilder: (context) => distanceItems
                        //               .map(
                        //                 (distance) => PopupMenuItem(
                        //               value: distance,
                        //               child: Text(distance),
                        //             ),
                        //           )
                        //               .toList(),
                        //           child: Container(
                        //             width: double.infinity,
                        //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        //             decoration: BoxDecoration(
                        //               color: isDark?Color(0xff153250):Colors.white,
                        //               borderRadius: BorderRadius.circular(6),
                        //               border: Border.all(color: Colors.grey),
                        //             ),
                        //             child: Row(
                        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //               children: [
                        //                 Text(
                        //                   state1.distance,
                        //                   style: TextStyle(
                        //                     fontSize: 16.sp,
                        //
                        //                   ),
                        //                 ),
                        //                 const Icon(Icons.arrow_drop_down),
                        //               ],
                        //             ),
                        //           ),
                        //         );
                        //       }),
                        //     )
                        //   ],
                        // ),
                        // SizedBox(height: 25.h),
                      ],
                    ),





                  /// TIME INPUT
                  /// TIME INPUT
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Time (mm:ss or ss.ss)",
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
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
                          suffixIcon: GestureDetector(
                            onTap: startListening, // 🔊 Start listening on tap
                            child: SizedBox(
                              height: 24.h,
                              width: 24.w,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  IconPath.voiceIcon,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
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
                      'Show splits',
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
                      controller1.convert();
                      ref.read(showCourseSectionConverter.notifier).state = false;
                    },
                    child: Container(
                      width: double.infinity,
                      height: 55,
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
                          Text(
                            AppLocalizations.of(context)!.convertTime,
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              color: AppColors.backgroundDark

                            ),
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
                                CustomText(text: AppLocalizations.of(context)!.clear,fontSize: 16.sp,color: AppColors.textWhite,fontWeight: FontWeight.w700,),
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
                              CustomText(text: AppLocalizations.of(context)!.export,fontSize: 16.sp,fontWeight: FontWeight.w700,),
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
         const SnackBar(content: Text('No output to export!')),
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
         SnackBar(content: Text('PDF saved at: ${file.path}')),
       );

       // Open the PDF
       await OpenFile.open(file.path);
     } catch (e) {
       debugPrint("PDF export error: $e");
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Failed to export PDF')),
       );
     }
   }
}