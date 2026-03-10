import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/custom_text_form_field.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/feature/home_section/converter_section/presentation/screen/widget/vertical_selector_widget.dart';
import 'package:swim_metrics/l10n/app_localizations.dart';

import '../../../../../core/common/widgets/custom_text.dart';
import '../../../../../core/utils/constants/icon_path.dart';
import '../../../calculator_section/calculator/presentation/screen/widget/custom_drawer_widget.dart';
import '../../riverpod/converter_controller.dart';

final showCourseSectionConverter = StateProvider<bool>((ref) => true);

class ConverterScreen extends ConsumerWidget {
   ConverterScreen({super.key});

  final timeController = TextEditingController(text: "01 : 00.00");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(converterProvider);
    final controller = ref.read(converterProvider.notifier);
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
                // child: IconButton(
                //   icon: const Icon(Icons.keyboard_arrow_down, size: 32),
                //   onPressed: () {
                //     ref.read(showCourseSectionProvider.notifier).state = true;
                //   },
                // ),
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
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            CustomText(text:
                            AppLocalizations.of(context)!.multipleCourses,

                              color: Colors.grey,

                            ),

                            Checkbox(
                              value: state.multiple,
                              onChanged: (v) =>
                                  controller.toggleMultiple(v!),
                            )
                          ],
                        ),

                        SizedBox(height: 10.h),

                        /// FROM / TO
                        Row(
                          children: [

                            Expanded(
                              child: Column(
                                children: [

                                  CustomText(text:
                                  AppLocalizations.of(context)!.from,

                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,

                                  ),

                                  SizedBox(height: 10.h),

                                  VerticalSelector(
                                    items: [AppLocalizations.of(context)!.scm, AppLocalizations.of(context)!.scy, AppLocalizations.of(context)!.lcm],
                                    selected: state.from,
                                    onTap: controller.selectFrom,
                                  )
                                ],
                              ),
                            ),

                            SizedBox(width: 12.w),

                            Expanded(
                              child: Column(
                                children: [
                                  CustomText(text:
                                  AppLocalizations.of(context)!.to,

                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,

                                  ),

                                  SizedBox(height: 10.h),



                                  VerticalSelector(
                                    items: [AppLocalizations.of(context)!.scm, AppLocalizations.of(context)!.scy, AppLocalizations.of(context)!.lcm],
                                    selected: state.to,
                                    onTap: controller.selectTo,
                                  )
                                ],
                              ),
                            ),

                          ],
                        ),

                        SizedBox(height: 20.h),

                        /// STROKE / DISTANCE

                        Row(
                          children: [

                            Expanded(
                              child: Column(
                                children: [
                                  CustomText(text:
                                  AppLocalizations.of(context)!.stroke,

                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,

                                  ),

                                  SizedBox(height: 10.h),




                                  VerticalSelector(
                                    items:  [AppLocalizations.of(context)!.fly,AppLocalizations.of(context)!.back,AppLocalizations.of(context)!.free, AppLocalizations.of(context)!.im,AppLocalizations.of(context)!.breast],
                                    selected: [state.stroke],
                                    onTap: controller.selectStroke,
                                  )
                                ],
                              ),
                            ),

                            SizedBox(width: 12.w),

                            Expanded(
                              child: Column(
                                children: [
                                  CustomText(text:
                                  AppLocalizations.of(context)!.distance,

                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,

                                  ),

                                  SizedBox(height: 10.h),



                                  VerticalSelector(
                                    items: const ["50", "100", "150","200","250"],
                                    selected: [state.distance],
                                    onTap: controller.selectDistance,
                                  )
                                ],
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: 25.h),
                      ],
                    ),





                  /// TIME INPUT
                  CustomTextField(hintText: "",controller: timeController,),



                  SizedBox(height: 20.h),

                  /// CONVERT BUTTON

                  GestureDetector(
                    onTap: (){
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
                      child:  Text(
                        AppLocalizations.of(context)!.convertTime,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(height: 24.h,),

            Container(
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
              child: Column(
                children: [
                  CustomText(text: AppLocalizations.of(context)!.convertedTime,fontSize: 16.sp,fontWeight: FontWeight.w500,color: Color(0xff368ABB),),
                  SizedBox(height: 10.h,),
                  CustomText(text: AppLocalizations.of(context)!.tapTimeToShowSplits,fontSize: 12.sp,fontWeight: FontWeight.w400,color:AppColors.textGrey,),
                  CustomText(text: "01 : 06.54",fontSize:36.sp,fontWeight: FontWeight.w600,),
                SizedBox(height: 16.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(text: AppLocalizations.of(context)!.scm,fontSize:13.sp,fontWeight: FontWeight.w400,color: AppColors.primary,),
                  SizedBox(width: 10.w,),
                  SvgPicture.asset(IconPath.rightArrowIcon),
                  SizedBox(width: 10.w,),
                  CustomText(text: AppLocalizations.of(context)!.lcm,fontSize:13.sp,fontWeight: FontWeight.w400,color: AppColors.primary,),

                ],
              ),
                ]

              ),

            ),
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
                      //notifier.clear();
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
                    onPressed: () {},
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
        ),
      ),
    );
  }
}