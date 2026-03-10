import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/feature/home_section/calculator_section/calculator/presentation/screen/widget/tools_explains_widget.dart';
import 'package:swim_metrics/l10n/app_localizations.dart';

import '../../../../../../../config/route/routes_name.dart';
import '../../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../../core/utils/constants/icon_path.dart';
import '../../../../../../../core/utils/constants/image_path.dart';
import '../../../../setting_section/settings/riverpod/setting_controller.dart';
import 'custom_drawer_button_widget.dart';
import 'learning_header_widget.dart';
import 'legal_header_widget.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({
    super.key,
  });
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



  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fontOption = ref.watch(settingsProvider).fontSize;
    final settings = ref.watch(settingsProvider);
    final currentLanguageCode = settings.language.code;
    return Drawer(
      backgroundColor: isDark?Color(0xff0F2A44):AppColors.textWhite,
      child: Padding(
        padding:  EdgeInsets.only(left: 10.w,right: 10.w,top: 16.h,),
        child: ListView(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min, // only takes needed height
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          ImagePath.appLogoImage,
                          width: 50.w,
                          height: 50.h,
                        ),
                        SizedBox(width: 12.w),
                        CustomText(
                          text: AppLocalizations.of(context)!.swimMetrics,
                          fontSize: getAdjustedFontSize(currentLanguageCode.toString() !="en"?14:18, fontOption).sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        context.pop();
                      },
                      icon: Icon(Icons.close, color: Color(0xff368ABB)),
                    ),
                  ],
                ),
              ],
            ),
            Divider(color: isDark?Color(0xff368ABB):null,),
            ToolsHeader(isDarkMode: isDark,currentLanguageCode: currentLanguageCode,fontSizeOption: fontOption,),
            LearningHeaderWidget(isDarkMode: isDark,fontSizeOption: fontOption,),
            CustomDrawerButtonWidget(icon: IconPath.helpAndSupportIcon,buttonTitle: AppLocalizations.of(context)!.helpAndSupport
              ,
              isDarkMode: isDark,
              fontSizeOption: fontOption,
              onTap: (){
              context.push(RouteNames.helpSupportScreen);
            },),
            LegalHeaderWidget(isDarkMode: isDark,fontSizeOption: fontOption,),
            CustomDrawerButtonWidget(icon: IconPath.settingIcon,
              isDarkMode: isDark,
              fontSizeOption: fontOption,
              buttonTitle: AppLocalizations.of(context)!.settings,onTap: (){
              context.push(RouteNames.settingsScreen);
            },),
            SizedBox(height: 116.h,),
            Column(
              children: [
                CustomText(text: AppLocalizations.of(context)!.swimMetrics,fontSize: getAdjustedFontSize(18,fontOption).sp,fontWeight: FontWeight.w500,),
                SizedBox(height: 10.h,),
                CustomText(text: AppLocalizations.of(context)!.version,fontSize: getAdjustedFontSize(14,fontOption).sp,fontWeight: FontWeight.w500,color: AppColors.primary,),
                SizedBox(height: 24.h,),
                CustomText(text: AppLocalizations.of(context)!.manyThanksToMyFamilyAndFriends,fontSize: getAdjustedFontSize(12,fontOption).sp,fontWeight: FontWeight.w400,color:isDark?Color(0xffE3D99B): Color(0xff82888E),),
                SizedBox(height: 10.h,),
                CustomText(text: AppLocalizations.of(context)!.specialThanksToMyFriends,fontSize: getAdjustedFontSize(12,fontOption).sp,fontWeight: FontWeight.w400,color: isDark?Color(0xffE3D99B):Color(0xff82888E),textAlign: TextAlign.center,),

              ],
            ),
            SizedBox(height: 24.h,),




          ],
        ),
      ),
    );
  }
}