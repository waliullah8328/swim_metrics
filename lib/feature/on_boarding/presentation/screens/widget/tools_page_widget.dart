import 'package:flutter/material.dart';
import 'package:swim_metrics/core/common/widgets/custom_text.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/core/utils/constants/icon_path.dart';

import '../../../../../l10n/app_localizations.dart';
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
          CustomText(text: AppLocalizations.of(context)!.theCoreTools,fontSize: 22.sp,fontWeight: FontWeight.w600,color: AppColors.textWhite,),
          SizedBox(height: 8.h,),
          CoreToolCard(
            title: AppLocalizations.of(context)!.splitCalculator,
            description:
            AppLocalizations.of(context)!.calculateTargetSplitsFor,
            icon: IconPath.calculatorIcon,
            onTap: () {},
          ),
          CoreToolCard(
            isLeft: false,
            title: AppLocalizations.of(context)!.courseConversion,
            description:
            AppLocalizations.of(context)!.seamlesslyConvertTimesBetweenSCY,
            icon: IconPath.conversionIcon,
            onTap: () {},
          ),


          CoreToolCard(
            title: AppLocalizations.of(context)!.stopWatch,
            description:
            AppLocalizations.of(context)!.timeSwimsWithPrecision,
            icon: IconPath.stopWatchIcon,
            onTap: () {},
          ),

        ],
      ),
    );
  }
}