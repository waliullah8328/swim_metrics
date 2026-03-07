import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_metrics/config/route/routes_name.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/core/utils/constants/image_path.dart';

import '../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../core/common/widgets/new_custon_widgets/custom_switch_widget.dart';
import '../../../../../../core/utils/constants/icon_path.dart';
import '../riverpod/setting_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

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
    final settings = ref.watch(settingsProvider);
    final fontOption = ref.watch(settingsProvider).fontSize;



    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: "Settings",fontSize: getAdjustedFontSize(24, fontOption).sp,fontWeight: FontWeight.w600,),
        centerTitle: true,
        leading: GestureDetector(
          onTap: (){
            context.pop();

          },
          child: Padding(
            padding: EdgeInsets.only(left: 18.w),
            child: SvgPicture.asset(
              IconPath.backIcon,
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
      body: ListView(
        children: [

          /// PROFILE
          Card(
            margin: EdgeInsets.zero,


            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                 CircleAvatar(radius: 35,backgroundImage: AssetImage(ImagePath.profileDeleteImage),),
                 SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text:
                          "Mr. Sahil Khan",
                          fontWeight: FontWeight.w600,
                          fontSize: getAdjustedFontSize(19, fontOption).sp,
                        ),
                        CustomText(
                          text:
                          "Premium user",
                          fontWeight: FontWeight.w400,
                          fontSize: getAdjustedFontSize(15, fontOption).sp,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      context.push(RouteNames.editProfileScreen);
                    },
                    child: Card(
                      color: AppColors.textGrey,
                      child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Center(child: CustomText(text: "Edit Profile",fontSize: getAdjustedFontSize(12, fontOption).sp,fontWeight: FontWeight.w400,)),
                    ),),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 SizedBox(height: 20.h),

                /// APPEARANCE
                CustomText(text: "APPEARANCE",fontSize: getAdjustedFontSize(18, fontOption).sp,fontWeight: FontWeight.w600,),
                SizedBox(height: 10.h,),

                Card(
                  color: Color(0xffFFFFFF),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(IconPath.darkModeLightIcon ),
                                SizedBox(width: 10.w,),
                                CustomText(text: "Dark Mode",fontSize: getAdjustedFontSize(16, fontOption).sp,fontWeight: FontWeight.w500,),
                              ],
                            ),
                            Consumer(builder: (context, ref, child) {
                              final isRemember = ref.watch(settingsProvider.select((s)=>s.darkMode));
                              return CustomSwitchWidget(
                                value: isRemember,
                                onChanged: (value) {
                                  ref.read(settingsProvider.notifier)
                                      .toggleDarkMode(value,ref );


                                },
                              );
                            },),
                          ],
                        ),
                        SizedBox(height: 16.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(IconPath.textSizeIcon),
                                SizedBox(width: 10.w,),
                                CustomText(text: "Text Size",fontSize: getAdjustedFontSize(16, fontOption).sp,fontWeight: FontWeight.w500,),
                              ],
                            ),
                            Consumer(
                              builder: (context, ref, child) {
                                final fontSize =
                                ref.watch(settingsProvider.select((s) => s.fontSize));

                                return SizedBox(
                                  width: 100.w,
                                  height: 40.h,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Color(0xffEAEDF1),
                                      borderRadius: BorderRadius.circular(45),
                                      border: Border.all(color: Color(0xffEAEDF1),),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<FontSizeOption>(
                                              value: fontSize,
                                              isExpanded: true,
                                              isDense: true,
                                              icon: const SizedBox(), // removes default icon
                                              borderRadius: BorderRadius.circular(12),
                                              items:  [
                                                DropdownMenuItem(
                                                  value: FontSizeOption.small,
                                                  child: CustomText(text: "SMALL",fontSize: 10.sp,),
                                                ),
                                                DropdownMenuItem(
                                                  value: FontSizeOption.medium,
                                                  child: CustomText(text: "MEDIUM",fontSize: 10.sp,),
                                                ),
                                                DropdownMenuItem(
                                                  value: FontSizeOption.big,
                                                  child: CustomText(text: "BIG",fontSize: 10.sp,),
                                                ),
                                              ],
                                              onChanged: (value) {
                                                if (value != null) {
                                                  ref
                                                      .read(settingsProvider.notifier)
                                                      .changeFontSize(value);
                                                }
                                              },
                                            ),
                                          ),
                                        ),

                                        /// Your custom icon
                                        const Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),

                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20.h),
                CustomText(text: "ACCESSIBILITY",fontSize: getAdjustedFontSize(18, fontOption).sp,fontWeight: FontWeight.w600,),
                SizedBox(height: 10.h,),



                Container(
                  decoration: BoxDecoration(
                    color: Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(IconPath.stopSoundIcon),
                                SizedBox(width: 10.w,),
                                CustomText(text: "Stopwatch Sound",fontSize: getAdjustedFontSize(16, fontOption).sp,fontWeight: FontWeight.w500,),
                              ],
                            ),
                            Consumer(builder: (context, ref, child) {
                              final isRemember = ref.watch(settingsProvider.select((s)=>s.stopwatchSound));
                              return CustomSwitchWidget(
                                value: isRemember,
                                onChanged: (value) {
                                  ref.read(settingsProvider.notifier)
                                      .toggleStopwatch(value);


                                },
                              );
                            },),
                          ],
                        ),
                        SizedBox(height: 16.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(IconPath.voiceInputIcon),
                                SizedBox(width: 10.w,),
                                CustomText(text: "Voice Input",fontSize: getAdjustedFontSize(16, fontOption).sp,fontWeight: FontWeight.w500,),
                              ],
                            ),
                            Consumer(builder: (context, ref, child) {
                              final isRemember = ref.watch(settingsProvider.select((s)=>s.voiceInput));
                              return CustomSwitchWidget(
                                value: isRemember,
                                onChanged: (value) {
                                  ref.read(settingsProvider.notifier)
                                      .toggleVoice(value);


                                },
                              );
                            },),
                          ],
                        ),
                        SizedBox(height: 16.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(IconPath.hapticIcon),
                                SizedBox(width: 10.w,),
                                CustomText(text: "Haptic Feedback",fontSize: getAdjustedFontSize(16, fontOption).sp,fontWeight: FontWeight.w500,),
                              ],
                            ),
                            Consumer(builder: (context, ref, child) {
                              final isRemember = ref.watch(settingsProvider.select((s)=>s.haptic));
                              return CustomSwitchWidget(
                                value: isRemember,
                                onChanged: (value) {
                                  ref.read(settingsProvider.notifier)
                                      .toggleHaptic(value);


                                },
                              );
                            },),
                          ],
                        ),



                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {},
                  child: const Text("Log Out"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}