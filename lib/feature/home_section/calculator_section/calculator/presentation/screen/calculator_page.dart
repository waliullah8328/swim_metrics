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
import '../../riverpod/calculator_split_state.dart';
final currencyProvider = StateProvider<String>((ref) => "SCY");
class SplitCalculatorPage extends ConsumerWidget {
  SplitCalculatorPage({super.key});

  final TextEditingController timeController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(splitProvider);
    final notifier = ref.read(splitProvider.notifier);
    final selected = ref.watch(currencyProvider);

    return Scaffold(
      key: _scaffoldKey,

      drawer: CustomDrawer(),
      appBar: AppBar(
        title: CustomText(text: "Split Calculator",fontSize: 24.sp,fontWeight: FontWeight.w600,),
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

        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                /// COURSE CARD
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffFFFFFF),
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
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: "Course",
                              fontSize: 20.sp,
                              color: AppColors.primary,
                            ),


                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selected,
                                  isDense: true, // removes extra height
                                  itemHeight: null, // removes default 48 height
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color(0xFFB8892D),
                                  ),
                                  dropdownColor: Colors.white,
                                  style: TextStyle(
                                    color: const Color(0xFFB8892D),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: "SCY",
                                      child: CustomText(text: "SCY", fontSize: 12.sp),
                                    ),
                                    DropdownMenuItem(
                                      value: "SCM",
                                      child: CustomText(text: "SCM", fontSize: 12.sp),
                                    ),
                                    DropdownMenuItem(
                                      value: "LCM",
                                      child: CustomText(text: "LCM", fontSize: 12.sp),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    ref.read(currencyProvider.notifier).state = value!;
                                  },
                                ),
                              ),
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
                                      text: "GENDER",
                                      fontSize: 16.sp,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(height: 6.h),
                                    SplitCalculatorSelector(
                                      items: const ["Men", "Women"],
                                      onChanged: (value) {
                                        ref.read(splitProvider.notifier).setGender(value);
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
                                      text: "STROKE",
                                      fontSize: 16.sp,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(height: 6.h),
                                    SplitCalculatorSelector(
                                      items: const ["Fly", "Back","Breast","Free","IM"],
                                      onChanged: (value) {
                                        ref.read(splitProvider.notifier).setStroke(value);
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
                                      text: "DIST",
                                      fontSize: 16.sp,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(height: 6.h),
                                    DistanceWheelSelector(
                                      items: [50, 100, 150, 200, 250],
                                      onChanged: (value) {
                                        ref.read(splitProvider.notifier).setDistance(value);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),
                        CustomText(
                          text: "Goal Time",
                          fontSize: 18.sp,
                          color: AppColors.primary,
                        ),
                        SizedBox(height: 16.h),
                        CustomTextField(
                          hintText: "Enter your time",
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
                            final goal = double.tryParse(timeController.text);
                            if (goal != null) {
                              notifier.setGoalTime(goal);
                              notifier.calculateSplits(); // This updates state
                            }
                          },
                          child: Center(child:  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(IconPath.calculatorSplitIcon,colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),),
                              SizedBox(width: 6.w,),
                              CustomText(text: "Calculate Split",fontSize: 14.sp,fontWeight: FontWeight.w600),
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
                    color: Color(0xffEAEDF1),
                    borderRadius:BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10)
                    )
                  ),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(text: "SPLIT",fontSize: 16.sp,fontWeight: FontWeight.w600,color: AppColors.primary,),
                      CustomText(text: "SPLIT TIME",fontSize: 16.sp,fontWeight: FontWeight.w600,color: AppColors.primary,),
                      CustomText(text: "TOTAL",fontSize: 16.sp,fontWeight: FontWeight.w600,color: AppColors.primary,),

                    ],
                  ),
                ),
                SizedBox(
                  height: 300.h, // fixed height for scrollable area
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffFFFFFF),


                    ),
                    child: state.splits.isEmpty
                        ? const Center(
                      child: Text(
                        "No splits yet",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                        : ListView.builder(
                      itemCount: state.splits.length,
                      itemBuilder: (context, index) {
                        final split = state.splits[index];

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
                ),

                SizedBox(height: 16.h),

                /// ACTION BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:Color(0xff234B6E),
                          side: BorderSide(color: Color(0xff234B6E))
                        ),
                        onPressed: () {
                          notifier.clear();
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(IconPath.clearIcon),
                              SizedBox(width: 6.w,),
                              CustomText(text: "Clear",fontSize: 16.sp,color: AppColors.textWhite,fontWeight: FontWeight.w700,),
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
                            SvgPicture.asset(IconPath.exportIcon),
                            SizedBox(width: 6.w,),
                            CustomText(text: "Export",fontSize: 16.sp,fontWeight: FontWeight.w700,),
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