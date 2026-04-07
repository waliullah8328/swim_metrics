import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_metrics/config/route/routes_name.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/core/utils/constants/icon_path.dart';
import 'package:swim_metrics/l10n/app_localizations.dart';

import '../../../../../../../core/common/widgets/custom_text.dart';
import '../../../../setting_section/settings/riverpod/setting_controller.dart';
import '../../../../setting_section/settings/screen/idea_for_use.dart';
import '../../../../setting_section/settings/screen/summary_screen.dart';


class LearningHeaderWidget extends  StatefulWidget{
  const LearningHeaderWidget({super.key, required this.isDarkMode,required this.fontSizeOption, });
  final bool isDarkMode;
  final FontSizeOption fontSizeOption;

  @override
  State<LearningHeaderWidget> createState() => _LearningHeaderWidgetState();
}

class _LearningHeaderWidgetState extends State<LearningHeaderWidget> {

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
                    SvgPicture.asset(IconPath.learningIcon),
                    SizedBox(width: 6.w,),
                    CustomText(text:
                      AppLocalizations.of(context)!.learning,
                      fontSize: getAdjustedFontSize(16, widget.fontSizeOption).sp, fontWeight: FontWeight.bold
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
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  SummaryScreen(),));

                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(text: AppLocalizations.of(context)!.summary,color:  widget.isDarkMode?Color(0xffE3D99B):AppColors.textNavyBlue,fontWeight: FontWeight.w400,fontSize: getAdjustedFontSize(14, widget.fontSizeOption).sp,),
                          Divider(),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  IdeaForUseScreen (),));

                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(text: AppLocalizations.of(context)!.ideasForUse,color:  widget.isDarkMode?Color(0xffE3D99B):AppColors.textNavyBlue,fontWeight: FontWeight.w400,fontSize: getAdjustedFontSize(14, widget.fontSizeOption).sp,),
                          Divider(),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        context.push(RouteNames.fAQScreen);
                      },
                        child: CustomText(text: AppLocalizations.of(context)!.fags,color:  widget.isDarkMode?Color(0xffE3D99B):AppColors.textNavyBlue,fontWeight: FontWeight.w400,fontSize: getAdjustedFontSize(14, widget.fontSizeOption).sp,)),
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