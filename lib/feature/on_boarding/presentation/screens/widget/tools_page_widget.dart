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
      padding:  EdgeInsets.only(left: 20.w,right: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: "The Core Tools",fontSize: 22.sp,fontWeight: FontWeight.w600,color: AppColors.textWhite,),
          CoreToolCard(
            title: "Split Calculator",
            description:
            "Calculate target splits for any event. Select your distance, input your goal time, and get precise splits instantly.",
            icon: IconPath.calculatorIcon,
            onTap: () {},
          ),
          Text(
            "The Core Tools\n\nSplit Calculator\nCourse Conversion\nStopwatch",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}