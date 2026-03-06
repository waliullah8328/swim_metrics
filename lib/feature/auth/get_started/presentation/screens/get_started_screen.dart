

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_metrics/config/route/routes_name.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/custom_primary_button.dart';
import '../../../../../core/common/widgets/custom_text.dart';
import '../../../../../core/common/widgets/new_custon_widgets/custom_account_widget.dart';
import '../../../../../core/common/widgets/new_custon_widgets/social_login.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/app_sizer.dart';
import '../../../../../core/utils/constants/image_path.dart';

class GetStartedScreen extends ConsumerWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding:  EdgeInsets.only(left: 20.w,right: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(ImagePath.appLogoImage,width: 80.w,height: 80.h,),
              SizedBox(height: 24.h,),
              CustomText(text: "Get Started",fontSize: 23.sp,fontWeight: FontWeight.w700),
              SizedBox(height: 14.h,),
              CustomText(text: "Joined by thousands of elite users who trust us to maximize their efforts and results.",fontSize: 13.sp,fontWeight: FontWeight.w400,color: AppColors.primary,textAlign: TextAlign.center,),
              SizedBox(height: 32.h,),
              CustomSocialLogin(),
              SizedBox(height: 24.h,),
              SvgPicture.asset(ImagePath.orImage),
              SizedBox(height: 24.h,),
              CustomPrimaryButton(title: "Create an Account",onPressed: (){
                context.go(RouteNames.signUpScreen);
              },),
              SizedBox(height: 60.h,),

              CustomAccountWidget(firstTitle: "Already have an account?",buttonTitle: " Sign In",onTap: (){
                context.push(RouteNames.loginScreen);              },),



            ],
          ),
        ),
      ),
    );
  }
}






