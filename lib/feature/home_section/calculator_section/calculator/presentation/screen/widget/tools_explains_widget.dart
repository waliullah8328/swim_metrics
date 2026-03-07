import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/core/utils/constants/icon_path.dart';

import '../../../../../../../core/common/widgets/custom_text.dart';


class ToolsHeader extends StatefulWidget {
  const ToolsHeader({super.key});

  @override
  State<ToolsHeader> createState() => _ToolsHeaderState();
}

class _ToolsHeaderState extends State<ToolsHeader> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding:  EdgeInsets.only(left: 10.w,),
        child: Column(
          mainAxisSize: MainAxisSize.min,
         crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(IconPath.toolsExplainIcon),
                    SizedBox(width: 6.w,),
                    Text(
                      "Tools Explained",
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                /// Arrow Button
                IconButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  icon: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Color(0xff368ABB),
                    size: 26,
                    weight: 8.w,
                  ),
                ),
              ],
            ),

            /// EXPANDED CONTENT
            if (isExpanded) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: "Split calculation",color: AppColors.textNavyBlue,fontWeight: FontWeight.w400,fontSize: 14.sp,),
                    Divider(),
                    CustomText(text: "Course conversion",color: AppColors.textNavyBlue,fontWeight: FontWeight.w400,fontSize: 14.sp,),
                    Divider(),
                    CustomText(text: "Stopwatch",color: AppColors.textNavyBlue,fontWeight: FontWeight.w400,fontSize: 14.sp,),
                    SizedBox(height: 16.h,),
                  ],
                ),
              )


            ]
          ],
        ),
      ),
    );
  }
}