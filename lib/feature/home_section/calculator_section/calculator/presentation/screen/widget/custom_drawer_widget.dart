import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/feature/home_section/calculator_section/calculator/presentation/screen/widget/tools_explains_widget.dart';

import '../../../../../../../config/route/routes_name.dart';
import '../../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../../core/utils/constants/icon_path.dart';
import '../../../../../../../core/utils/constants/image_path.dart';
import 'custom_drawer_button_widget.dart';
import 'learning_header_widget.dart';
import 'legal_header_widget.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                          text: "SwimMetrics",
                          fontSize: 18.sp,
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
            Divider(),
            ToolsHeader(),
            LearningHeaderWidget(),
            CustomDrawerButtonWidget(icon: IconPath.helpAndSupportIcon,buttonTitle: "Help & Support",onTap: (){
              context.push(RouteNames.helpSupportScreen);
            },),
            LegalHeaderWidget(),
            CustomDrawerButtonWidget(icon: IconPath.settingIcon,buttonTitle: "Setting",onTap: (){
              context.push(RouteNames.settingsScreen);
            },),
            SizedBox(height: 116.h,),
            Column(
              children: [
                CustomText(text: "SwimMetrics",fontSize: 18.sp,fontWeight: FontWeight.w500,),
                SizedBox(height: 10.h,),
                CustomText(text: "Version 2.5",fontSize: 14.sp,fontWeight: FontWeight.w500,color: AppColors.primary,),
                SizedBox(height: 24.h,),
                CustomText(text: "Many thanks to my family and friends.",fontSize: 12.sp,fontWeight: FontWeight.w400,color: Color(0xff82888E),),
                SizedBox(height: 10.h,),
                CustomText(text: "Special thanks to my friends and mentors\n DCS, JCU, and ECR",fontSize: 12.sp,fontWeight: FontWeight.w400,color: Color(0xff82888E),textAlign: TextAlign.center,),

              ],
            ),
            SizedBox(height: 24.h,),




          ],
        ),
      ),
    );
  }
}