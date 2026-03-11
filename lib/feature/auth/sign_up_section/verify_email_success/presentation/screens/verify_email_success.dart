import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_metrics/core/common/widgets/custom_text.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/custom_primary_button.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/image_path.dart';
import 'package:swim_metrics/l10n/app_localizations.dart';

import '../../../../../../config/route/routes_name.dart';
import '../../../../../../core/utils/constants/app_sizer.dart';
import '../../../payment/presentation/screen/payment_screen.dart';

class VerifyEmailSuccess extends ConsumerWidget {
  const VerifyEmailSuccess({super.key, required this.title, required this.subTitle, this.isSignUp= "true"});
  final String title;
  final String subTitle;
  final String? isSignUp;

  @override
  Widget build(BuildContext context, WidgetRef ref) {



    return Scaffold(

      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 20.w,right: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(ImagePath.verifiedSuccessImage ),
              SizedBox(height: 24.h,),
              CustomText(text: title,fontSize: 26.sp,fontWeight: FontWeight.w600,),
              SizedBox(height: 16.h,),
              CustomText(text: subTitle,fontSize: 15.sp,fontWeight: FontWeight.w400,color: AppColors.primary,),
              SizedBox(height: 150.h,),
              isSignUp == "true"?CustomPrimaryButton(title: AppLocalizations.of(context)!.continue1,onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder:  (context) => PaymentScreen(),));


              },):CustomPrimaryButton(title: AppLocalizations.of(context)!.backToLogin,onPressed: (){
                context.go(RouteNames.loginScreen);

              },)




            ],
          ),
        ),
      ),

    );
  }
}