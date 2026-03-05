import 'package:flutter/material.dart';
import 'package:swim_metrics/core/common/widgets/custom_text.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/core/utils/constants/icon_path.dart';

import 'core_tool_card_widget.dart';

class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(left: 20.w,right: 20.w,top: 50.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: "The Core Tools",fontSize: 22.sp,fontWeight: FontWeight.w600,color: AppColors.textWhite,),
          SizedBox(height: 8.h,),
          CoreToolCard(
            title: "Split Calculator",
            description:
            "Calculate target splits for any event. Select your distance, input your goal time, and get precise splits instantly.",
            icon: IconPath.calculatorIcon,
            onTap: () {},
          ),
          CoreToolCard(
            isLeft: false,
            title: "Course Conversion",
            description:
            "Seamlessly convert times between SCY, LCM, and SCM courses. Essential for college recruiting and international meets.",
            icon: IconPath.conversionIcon,
            onTap: () {},
          ),


          CoreToolCard(
            title: "Stopwatch",
            description:
            "Time swims with precision. Large, easy-to-hit buttons designed specifically for poolside use.",
            icon: IconPath.stopWatchIcon,
            onTap: () {},
          ),

        ],
      ),
    );
  }
}