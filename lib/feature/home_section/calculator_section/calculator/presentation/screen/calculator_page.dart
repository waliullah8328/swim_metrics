import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swim_metrics/core/common/widgets/custom_text.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/custom_text_form_field.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/core/utils/constants/icon_path.dart';
import 'package:swim_metrics/feature/home_section/calculator_section/calculator/presentation/screen/splict_custom_widget.dart';

import 'package:swim_metrics/feature/home_section/calculator_section/calculator/presentation/screen/widget/custom_drawer_widget.dart';
import 'package:swim_metrics/feature/home_section/calculator_section/calculator/presentation/screen/widget/distance_wheel_selector_widget.dart';
import 'package:swim_metrics/l10n/app_localizations.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../riverpod/calculator_split_state.dart';
import '../../riverpod/split_calculator_controller.dart';
final currencyProvider = StateProvider<String>((ref) => "SCY");
final showCourseSectionProvider = StateProvider<bool>((ref) => true);
class SplitCalculatorPage extends ConsumerWidget {
  SplitCalculatorPage({super.key});

  final TextEditingController timeController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final selected = ref.watch(currencyProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final showCourse = ref.watch(showCourseSectionProvider);

    return Scaffold(
      key: _scaffoldKey,

      drawer: CustomDrawer(),
      appBar: AppBar(
        title: CustomText(text: AppLocalizations.of(context)!.splitCalculator,fontSize: 24.sp,fontWeight: FontWeight.w600,),
        centerTitle: true,
        leading: GestureDetector(
          onTap: (){
            _scaffoldKey.currentState?.openDrawer();
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
                              CustomText(text: AppLocalizations.of(context)!.pullDownToSeeOptions,fontSize: 14.sp,color: Color(0xffC7C7C7),)
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
                                    fontSize: 20.sp,
                                    color: AppColors.primary,
                                  ),


                                  Consumer(
                                    builder: (context, ref, child) {

                                      final state = ref.watch(splitCalcProvider);
                                      final selected = state.course.toUpperCase(); // get updated value

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
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            items: [
                                              DropdownMenuItem(
                                                value: "SCY",
                                                child: CustomText(
                                                  text: AppLocalizations.of(context)!.scy,
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                              DropdownMenuItem(
                                                value: "SCM",
                                                child: CustomText(
                                                  text: AppLocalizations.of(context)!.scm,
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                              DropdownMenuItem(
                                                value: "LCM",
                                                child: CustomText(
                                                  text: AppLocalizations.of(context)!.lcm,
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ],
                                            onChanged: (value) {
                                              ref
                                                  .read(splitCalcProvider.notifier)
                                                  .setCourse((value ?? 'SCY').toLowerCase());
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                              SizedBox(height: 20.h),

                              /// GENDER, STROKE, DIST
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          CustomText(
                                            text: AppLocalizations.of(context)!.gender,
                                            fontSize: 16.sp,
                                            color: AppColors.primary,
                                          ),
                                          SizedBox(height: 6.h),
                                          SplitCalculatorSelector(
                                            items:  [AppLocalizations.of(context)!.men, AppLocalizations.of(context)!.women],
                                            onChanged: (value) {
                                              ref.read(splitCalcProvider.notifier).setGender((value ).toLowerCase());
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          CustomText(
                                            text: AppLocalizations.of(context)!.stroke,
                                            fontSize: 16.sp,
                                            color: AppColors.primary,
                                          ),
                                          SizedBox(height: 6.h),
                                          SplitCalculatorSelector(
                                            items: [AppLocalizations.of(context)!.fly, AppLocalizations.of(context)!.back,AppLocalizations.of(context)!.breast,AppLocalizations.of(context)!.free,AppLocalizations.of(context)!.im],
                                            onChanged: (value) {
                                              ref.read(splitCalcProvider.notifier).setStroke((value ?? 'SCY').toLowerCase());
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          CustomText(
                                            text: AppLocalizations.of(context)!.dist,
                                            fontSize: 16.sp,
                                            color: AppColors.primary,
                                          ),
                                          SizedBox(height: 6.h),
                                          DistanceWheelSelector(
                                            items: [50, 100, 150, 200, 250],
                                            onChanged: (value) {
                                              ref.read(splitCalcProvider.notifier).setDistance(value.toString());

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
                          fontSize: 18.sp,
                          color: AppColors.primary,
                        ),
                        SizedBox(height: 16.h),
                        CustomTextField(
                          keyboardType: TextInputType.number,
                          hintText: AppLocalizations.of(context)!.enterYourTime,
                          onChanged: (value){
                            ref.read(splitCalcProvider.notifier).setGoalTime(value);
                          },
                          controller: timeController,
                          suffixIcon: GestureDetector(
                            onTap: (){


                            },
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
                          )),

                        SizedBox(height: 16.h),






                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize:  Size(double.infinity, 52.h), // width = full, height = 50
                          ),
                          onPressed: (){

                            ref.read(splitCalcProvider.notifier).project1();
                            ref.read(showCourseSectionProvider.notifier).state = false;
                          },
                          child: Center(child:  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(IconPath.calculatorSplitIcon,colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),),
                              SizedBox(width: 6.w,),
                              CustomText(text: AppLocalizations.of(context)!.calculateSplit,fontSize: 14.sp,fontWeight: FontWeight.w600),
                            ],
                          )),
                        ),


                      ],
                    ),
                  ),
                ),

                 SizedBox(height: 20.h),

                /// RESULT TABLE
                ///
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark?Color(0xff234B6E):Color(0xffEAEDF1),
                    borderRadius:BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10)
                    )
                  ),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(text: AppLocalizations.of(context)!.split,fontSize: 16.sp,fontWeight: FontWeight.w600,color: AppColors.primary,),
                      CustomText(text: AppLocalizations.of(context)!.splitTime,fontSize: 16.sp,fontWeight: FontWeight.w600,color: AppColors.primary,),
                      CustomText(text: AppLocalizations.of(context)!.total,fontSize: 16.sp,fontWeight: FontWeight.w600,color: AppColors.primary,),

                    ],
                  ),
                ),
                 Container(
                   height: 200.h,
                    decoration: BoxDecoration(
                      color: isDark?Color(0xff1B3A5C):Color(0xffFFFFFF),


                    ),
                    child: ref.watch(splitCalcProvider).splits.isEmpty
                        ?  Center(
                      child: CustomText(text:
                      AppLocalizations.of(context)!.noSplitsYet,
                       color: Colors.grey
                      ),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: ref.watch(splitCalcProvider).splits.length,
                      itemBuilder: (context, index) {
                        final split = ref.watch(splitCalcProvider).splits[index];

                        // alternate colors: even -> E3F0FF, odd -> FFFFFF
                        final bgColor = index % 2 == 0 ? Color(0xFFE3F0FF) : Color(0xFFFFFFFF);

                        return Container(
                          color: bgColor,
                          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: split.distance.toString(),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                              CustomText(
                                text: split.splitTime.toStringAsFixed(2),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                              CustomText(
                                text: split.total.toStringAsFixed(2),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),


                SizedBox(height: 16.h),

                /// ACTION BUTTONS
                 if(ref.watch(splitCalcProvider).splits.isNotEmpty)
                   Row(
                     children: [
                       Expanded(
                         child: ElevatedButton(
                           style: ElevatedButton.styleFrom(
                               backgroundColor:Color(0xff234B6E),
                               side: BorderSide(color: Color(0xff234B6E))
                           ),
                           onPressed: () {
                             ref.watch(splitCalcProvider.notifier).clear();
                           },
                           child: Center(
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 SvgPicture.asset(IconPath.clearIcon,colorFilter: ColorFilter.mode(AppColors.textWhite, BlendMode.srcIn),),
                                 SizedBox(width: 6.w,),
                                 CustomText(text:  AppLocalizations.of(context)!.clear,fontSize: 16.sp,color: AppColors.textWhite,fontWeight: FontWeight.w700,),
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
                           onPressed: () {
                             exportSplitPdf(context, ref);
                           },
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               SvgPicture.asset(IconPath.exportIcon,colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),),
                               SizedBox(width: 6.w,),
                               CustomText(text:  AppLocalizations.of(context)!.export,fontSize: 16.sp,fontWeight: FontWeight.w700,),
                             ],
                           ),
                         ),
                       ),
                     ],
                   ),

              ],
            ),
          ),
        )
    );
  }

  Future<void> exportSplitPdf(BuildContext context, WidgetRef ref) async {
    final pdf = pw.Document();

    final splits = ref.read(splitCalcProvider).splits;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Swim Split Calculator",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),

              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text("Split"),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text("Split Time"),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text("Total"),
                      ),
                    ],
                  ),

                  ...splits.map(
                        (e) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(e.distance.toString()),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(e.splitTime.toStringAsFixed(2)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(e.total.toStringAsFixed(2)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
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