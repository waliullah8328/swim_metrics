

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:swim_metrics/config/route/routes_name.dart';

import 'package:swim_metrics/core/common/widgets/new_custon_widgets/custom_primary_button.dart';

import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/feature/auth/sign_up_section/payment/presentation/screen/payment_screen.dart';

import 'package:swim_metrics/feature/auth/sign_up_section/verify_email/presentation/riverpod/verify_otp_controller.dart';
import 'package:swim_metrics/l10n/app_localizations.dart';

import '../../../../../../core/common/widgets/custom_text.dart';

import '../../../../../../core/utils/constants/app_sizer.dart';
import '../../../../../../core/utils/constants/image_path.dart';




class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key, required this.email, this.isSignUp = "true"});

  final String email;
  final String? isSignUp;

  @override
  ConsumerState<VerifyEmailScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<VerifyEmailScreen> {


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    debugPrint("build");
    debugPrint(widget.email);




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
                CustomText(text: AppLocalizations.of(context)!.verifyYourEmail,fontSize: 23.sp,fontWeight: FontWeight.w700),
                SizedBox(height: 24.h,),
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  cursorColor: const Color(0xFF007AFF),
                  keyboardType: TextInputType.number,
                  enableActiveFill: true,
                  backgroundColor: Colors.transparent,

                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 60.h,
                    fieldWidth: 55.w,
                    borderWidth: 1.5,

                    // Border Colors
                    inactiveColor: isDark ? Colors.grey : Colors.grey.shade400,
                    selectedColor: AppColors.primary,
                    activeColor: AppColors.primary,

                    // Fill Colors
                    inactiveFillColor:
                    isDark ? const Color(0xff022740) : AppColors.textFormFieldFillColorLightMode,
                    selectedFillColor:
                    isDark ? const Color(0xff022740) : AppColors.textFormFieldFillColorLightMode,
                    activeFillColor:
                    isDark ? const Color(0xff022740) : AppColors.textFormFieldFillColorLightMode,
                  ),

                  onChanged: (value) {
                    ref.read(verifyEmailProvider.notifier).setCode(value);
                  },
                ),
                SizedBox(height: 16.h,),
                CustomText(text: AppLocalizations.of(context)!.tips,fontSize: 14.sp,color: AppColors.primary,fontWeight: FontWeight.w400,textAlign: TextAlign.center,),

                SizedBox(height: 230.h,),
                widget.isSignUp== 'true'?Consumer(builder: (context,ref,child){
                  final isLoading = ref.watch(verifyEmailProvider.select((s)=>s.isLoading));

                  return CustomPrimaryButton(title: AppLocalizations.of(context)!.verify,
                    isLoading: isLoading,
                    onPressed: () async {

                    final String title = AppLocalizations.of(context)!.verifiedEmail;
                    final String subTitle = AppLocalizations.of(context)!.yourAccountHasBeenCreatedSuccessfully;
                      final result = await ref.read(verifyEmailProvider.notifier).verifyOtp(context: context,email: widget.email);
                      if(result){

                        context.go("${RouteNames.verifyEmailSuccessScreen}/$title/$subTitle/${widget.isSignUp}");
                      }




                    },);

                }):
                Consumer(builder: (context,ref,child){
                  final isLoading = ref.watch(verifyEmailProvider.select((s)=>s.isLoading));

                  return CustomPrimaryButton(title: AppLocalizations.of(context)!.verify,
                    isLoading: isLoading,
                    onPressed: () async {

                       ref.read(verifyEmailProvider.notifier). verifyForgetOtp(context: context,email: widget.email,code: ref.read(verifyEmailProvider.select((s)=>s.code)),isSignUp: widget.isSignUp!);





                    },);

                }),




              ],
            ),
          ),
        ),
      ),
    );
  }
}







