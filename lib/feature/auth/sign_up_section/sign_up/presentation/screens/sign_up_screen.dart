

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:swim_metrics/config/route/routes_name.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/app_snackbar.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/custom_check_box_widget.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/custom_primary_button.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/custom_text_form_field.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/icon_path.dart';
import 'package:swim_metrics/feature/auth/sign_up_section/sign_up/presentation/riverpod/sign_up_controller.dart';
import 'package:swim_metrics/l10n/app_localizations.dart';

import '../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../core/common/widgets/new_custon_widgets/custom_account_widget.dart';

import '../../../../../../core/utils/constants/app_sizer.dart';
import '../../../../../../core/utils/constants/image_path.dart';
import '../../../../../../core/utils/validators/app_validator.dart';
import '../../../../../home_section/calculator_section/setting_section/settings/riverpod/setting_controller.dart';




class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<SignUpScreen> {
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  final _signUpFormKey = GlobalKey<FormState>();


  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settings = ref.watch(settingsProvider);
    final currentLanguageCode = settings.language.code;
    print("build");
    print(currentLanguageCode.toString());




    return Scaffold(
      body: Center(
        child: Padding(
          padding:  EdgeInsets.only(left: 20.w,right: 20.w),
          child: SingleChildScrollView(
            child: Form(
              key: _signUpFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(ImagePath.appLogoImage,width: 80.w,height: 80.h,),
                  SizedBox(height: 32.h,),
                  CustomText(text: AppLocalizations.of(context)!.createAnAccount,fontSize: 23.sp,fontWeight: FontWeight.w700),
                  SizedBox(height: 24.h,),
                  CustomTextField(
                    focusNode: _nameFocusNode,

                    hintText: AppLocalizations.of(context)!.enterYourName,

                    validator: (value){

                      return  AppValidator.validateName(value,context);
                    },

                    onChanged: (value) {
                      ref.read(signUpProvider.notifier).setName(value);
                    },
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(13.w),
                      child: SvgPicture.asset(
                        IconPath.profileIcon,
                        width: 18.w,
                        height: 18.h,
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(isDark?AppColors.textWhite:Color(0xff82888E),BlendMode.srcIn),
                      ),
                    ),

                  ),
                  SizedBox(height: 16.h,),
                  CustomTextField(
                    focusNode: _emailFocusNode,

                    hintText: AppLocalizations.of(context)!.enterYourEmail,

                    validator: (value){

                      return  AppValidator.validateEmail(value,context);
                    },

                    onChanged: (value) {
                      ref.read(signUpProvider.notifier).setEmail(value);
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
                  SizedBox(height: 16.h,),
                  Consumer(builder:  (context,ref,child){
                    final isRemember = ref.watch(signUpProvider.select((s)=>s.isPasswordVisible));
                    return  CustomTextField(
                      focusNode: _passwordFocusNode,
                      hintText: AppLocalizations.of(context)!.enterYourPassword,
                      obscureText: !isRemember ,
                      validator: (value){

                        return  AppValidator.validatePassword(value,context);
                      },
                      onChanged: (password) {
                        ref.read(signUpProvider.notifier).
                        setPassword(password);

                        /// 🔥 If checkbox is unchecked remove saved password

                      },
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(13.w),
                        child: SvgPicture.asset(
                          IconPath.passwordIcon,
                          width: 18.w,
                          height: 18.h,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(isDark?AppColors.textWhite:Color(0xff82888E),BlendMode.srcIn),
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isRemember
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          ref.read(signUpProvider.notifier)
                              .togglePasswordVisibility();
                        },
                      ),
                    );
                  }),
                  SizedBox(height: 16.h,),
                  Consumer(builder:  (context,ref,child){
                    final isPasswordVisible = ref.watch(signUpProvider.select((s)=>s.isConfirmPasswordVisible));
                    return  CustomTextField(
                      focusNode: _confirmPasswordFocusNode,
                      hintText: AppLocalizations.of(context)!.enterYourConfirmPassword,
                      obscureText: !isPasswordVisible ,
                      validator: (value){
                        final password = ref.watch(signUpProvider.select((s)=>s.password));
                        return AppValidator.validateConfirmPassword(value,password,context );

                      },
                      onChanged: (confirmPassword) {
                        ref.read(signUpProvider.notifier).
                        setConfirmPassword(confirmPassword);

                        /// 🔥 If checkbox is unchecked remove saved password

                      },
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(13.w),
                        child: SvgPicture.asset(
                          IconPath.passwordIcon,
                          width: 18.w,
                          height: 18.h,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(isDark?AppColors.textWhite:Color(0xff82888E),BlendMode.srcIn),
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          ref.read(signUpProvider.notifier)
                              .toggleConfirmPasswordVisibility();
                        },
                      ),
                    );
                  }),
                  SizedBox(height: 6.h,),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Consumer(builder: (context, ref, child) {
                            final isRemember = ref.watch(signUpProvider.select((s)=>s.isTermsAndPolicy));
                            return CustomCheckBoxWidget(
                              value: isRemember,
                              onChanged: (value) {
                                ref.read(signUpProvider.notifier)
                                    .toggleTermAndPrivacy(value! );


                              },
                            );
                          },),

                          CustomText(text: "${AppLocalizations.of(context)!.iAgreeTo} ",fontSize:currentLanguageCode.toString() != "en"?10.sp: 14.sp,fontWeight: FontWeight.w400,),
                          CustomText(text: AppLocalizations.of(context)!.termsAndPrivacyPolicy,color: AppColors.primary,fontSize: currentLanguageCode.toString() != "en"?10.sp: 14.sp,fontWeight: FontWeight.w400,),
                        ],
                      ),

                    ],
                  ),
                  SizedBox(height: 24.h,),
                  Consumer(builder: (context,ref,child){
                    final isLoading = ref.watch(signUpProvider.select((s)=>s.isLoading));
                    final email = ref.watch(signUpProvider.select((s)=>s.email));
                    final isTerms= ref.watch(signUpProvider.select((s)=>s.isTermsAndPolicy));

                    return CustomPrimaryButton(title: "Create Account",
                      isLoading: isLoading,
                        onPressed: () async {
                          if (_signUpFormKey.currentState!.validate()) {

                            if (!isTerms) {
                              AppSnackBar.showError(context, "Please agree with terms and conditions");
                              return;
                            }

                            final result = await ref.read(signUpProvider.notifier)
                                .createAccount(context: context);

                            if (result) {
                              context.go("${RouteNames.verifyEmailScreen}/$email/true");
                            }
                          }
                        }
                    );

                  }),






                  SizedBox(height: 68.h,),

                  CustomAccountWidget(firstTitle: AppLocalizations.of(context)!.alreadyHaveAnAccount,buttonTitle: " ${AppLocalizations.of(context)!.signIn}",onTap: (){
                    context.go(RouteNames.loginScreen);
                  },),



                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}







