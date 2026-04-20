import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/core/utils/constants/icon_path.dart';
import 'package:swim_metrics/feature/home_section/calculator_section/setting_section/settings/screen/split_calculator.dart';
import 'package:swim_metrics/l10n/app_localizations.dart';

import '../../../../../../../core/common/widgets/custom_text.dart';
import '../../../../setting_section/settings/riverpod/setting_controller.dart';
import '../../../../setting_section/settings/screen/stop_watch_calulator.dart';
import '../../../../setting_section/settings/screen/widget/course_conversion.dart';


class ToolsHeader extends StatefulWidget {
  const ToolsHeader({super.key, required this.isDarkMode, required this.currentLanguageCode, required this.fontSizeOption});
  final bool isDarkMode;
  final String currentLanguageCode;
  final FontSizeOption fontSizeOption;

  @override
  State<ToolsHeader> createState() => _ToolsHeaderState();
}

class _ToolsHeaderState extends State<ToolsHeader> {

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
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.isDarkMode?Color(0xff153250):Color(0xffEAEDF1),
      child: Padding(
        padding:  EdgeInsets.only(left: 10.w,top: 10.h,bottom: 10.h,right: 10.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
         crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HEADER
            GestureDetector(
              onTap: (){
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SvgPicture.asset(IconPath.toolsExplainIcon),
                        SizedBox(width: 6.w),

                        /// Expanded keeps text inside available space
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.toolsExplain,
                            maxLines: 1, // single line only
                            overflow: TextOverflow.ellipsis, // show ...
                            softWrap: false,
                            style: TextStyle(
                              fontSize: getAdjustedFontSize(16,
                                widget.fontSizeOption,
                              ).sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Arrow Button
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Color(0xff368ABB),
                    size: 26,
                    weight: 8.w,
                  )
                ],
              ),
            ),

            /// EXPANDED CONTENT
            if (isExpanded) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  SplitCalculatorScreen(),));

                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.h,),
                          CustomText(text: AppLocalizations.of(context)!.splitCalculator,color: widget.isDarkMode?Color(0xffE3D99B):AppColors.textNavyBlue,fontWeight: FontWeight.w400,fontSize: getAdjustedFontSize(12, widget.fontSizeOption).sp,),
                          Divider(),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  CourseConversionScreen(),));

                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(text: AppLocalizations.of(context)!.courseConversion,color: widget.isDarkMode?Color(0xffE3D99B):AppColors.textNavyBlue,fontWeight: FontWeight.w400,fontSize:getAdjustedFontSize(12, widget.fontSizeOption).sp,),
                          Divider(),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  StopWatchCalculatorScreen(),));

                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(text: AppLocalizations.of(context)!.stopWatch,color: widget.isDarkMode?Color(0xffE3D99B):AppColors.textNavyBlue,fontWeight: FontWeight.w400,fontSize: getAdjustedFontSize(12, widget.fontSizeOption).sp,),
                          SizedBox(height: 16.h,),
                        ],
                      ),
                    ),
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