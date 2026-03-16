

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_metrics/config/route/routes_name.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/custom_primary_button.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/custom_text_form_field.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/icon_path.dart';
import 'package:swim_metrics/l10n/app_localizations.dart';

import '../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../core/utils/constants/app_sizer.dart';
import '../../../../../../core/utils/constants/image_path.dart';
import '../../../../../../core/utils/validators/app_validator.dart';
import '../riverpod/forget_password_controller.dart';



class ForgetPasswordScreen extends ConsumerStatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  ConsumerState<ForgetPasswordScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<ForgetPasswordScreen> {
  final _emailFocusNode = FocusNode();


  @override
  void dispose() {
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    print("build");



    return Scaffold(
      body: Center(
        child: Padding(
          padding:  EdgeInsets.only(left: 20.w,right: 20.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(ImagePath.appLogoImage,width: 80.w,height: 80.h,),
                SizedBox(height: 24.h,),
                CustomText(text: AppLocalizations.of(context)!.forgetPassword,fontSize: 23.sp,fontWeight: FontWeight.w700),
                SizedBox(height: 14.h,),
                CustomText(text: AppLocalizations.of(context)!.doNotWorryPleaseEnterYourEmail,fontSize: 13.sp,fontWeight: FontWeight.w400,color: AppColors.primary,textAlign: TextAlign.center,),
                SizedBox(height: 24.h,),
                CustomTextField(
                  focusNode: _emailFocusNode,
                  hintText: AppLocalizations.of(context)!.enterYourEmail,
            
                  validator: (value){

                    return  AppValidator.validateEmail(value,context);
                  },
            
                  onChanged: (value) {
                    ref.read(forgetPasswordProvider.notifier).setEmail(value);
                  },
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(13.w),
                    child: SvgPicture.asset(
                      IconPath.emailIcon,
                      width: 18.w,
                      height: 18.h,
                      fit: BoxFit.contain,
                      colorFilter: ColorFilter.mode(isDark?AppColors.textWhite:Color(0xff82888E),BlendMode.srcIn),
                    ),
                  ),
            
                ),

                SizedBox(height: 24.h,),
                Consumer(builder: (context,ref,child){
                  final isLoading = ref.watch(forgetPasswordProvider.select((s)=>s.isLoading));
            
                  return CustomPrimaryButton(title: AppLocalizations.of(context)!.sendOtp,
                    isLoading: isLoading,
                    onPressed: () async {
                     final result = await ref.read(forgetPasswordProvider.notifier).forgetPassword(context: context);
                     if(result){
                       context.go("${RouteNames.verifyEmailScreen}/${ref.read(forgetPasswordProvider.select((s)=>s.email))}/false");

                     }
            
            
            
            
                  },);
            
                }),
                SizedBox(height: 24.h,),
            

            
            
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}







