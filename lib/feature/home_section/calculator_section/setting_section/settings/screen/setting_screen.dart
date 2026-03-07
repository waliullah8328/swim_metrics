import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_metrics/config/route/routes_name.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/core/utils/constants/image_path.dart';

import '../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../core/utils/constants/icon_path.dart';
import '../riverpod/setting_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: "Settings",fontSize: 24.sp,fontWeight: FontWeight.w600,),
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
                          fontSize: 19.sp,
                        ),
                        CustomText(
                          text:
                          "Premium user",
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
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
                      child: Center(child: CustomText(text: "Edit Profile",fontSize: 14.sp,fontWeight: FontWeight.w400,)),
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
                const SizedBox(height: 20),

                /// APPEARANCE
                const Text("APPEARANCE"),

                SwitchListTile(
                  title: const Text("Dark Mode"),
                  value: settings.darkMode,
                  onChanged: (v) =>
                      ref.read(settingsProvider.notifier).toggleDarkMode(v),
                ),

                const SizedBox(height: 20),

                /// ACCESSIBILITY
                const Text("ACCESSIBILITY"),

                SwitchListTile(
                  title: const Text("Stopwatch Sound"),
                  value: settings.stopwatchSound,
                  onChanged: (v) =>
                      ref.read(settingsProvider.notifier).toggleStopwatch(v),
                ),

                SwitchListTile(
                  title: const Text("Voice Input"),
                  value: settings.voiceInput,
                  onChanged: (v) =>
                      ref.read(settingsProvider.notifier).toggleVoice(v),
                ),

                SwitchListTile(
                  title: const Text("Haptic Feedback"),
                  value: settings.haptic,
                  onChanged: (v) =>
                      ref.read(settingsProvider.notifier).toggleHaptic(v),
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