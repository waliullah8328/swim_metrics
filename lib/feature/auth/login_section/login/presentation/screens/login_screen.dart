

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_metrics/config/route/routes_name.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/app_snackbar.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/custom_primary_button.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/custom_text_form_field.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/icon_path.dart';
import 'package:swim_metrics/l10n/app_localizations.dart';

import '../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../core/common/widgets/new_custon_widgets/custom_account_widget.dart';
import '../../../../../../core/common/widgets/new_custon_widgets/custom_switch_widget.dart';
import '../../../../../../core/common/widgets/new_custon_widgets/social_login.dart';
import '../../../../../../core/services/token_storage.dart';
import '../../../../../../core/utils/constants/app_sizer.dart';
import '../../../../../../core/utils/constants/image_path.dart';
import '../../../../../../core/utils/validators/app_validator.dart';
import '../riverpod/login_controller.dart';
import '../riverpod/login_state.dart';


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    print("build");

    ref.listen<LoginState>(loginProvider, (previous, next) {
      if (next.errorMessage != null) {

        AppSnackBar.showError(context, next.errorMessage.toString());
      }

      if (next.successMessage != null) {

        AppSnackBar.showSuccess(context, next.successMessage.toString());
      }

      /// Update controllers whenever email/password state changes
      if (next.email != emailController.text) {
        emailController.text = next.email;
      }

      if (next.password != passwordController.text) {
        passwordController.text = next.password;
      }
    });


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
                CustomText(text: AppLocalizations.of(context)!.welcomeBack,fontSize: 23.sp,fontWeight: FontWeight.w700),
                SizedBox(height: 24.h,),
                CustomTextField(
                  controller: emailController,
                  hintText: AppLocalizations.of(context)!.enterYourEmail,
            
                  validator: AppValidator.validateEmail,
            
                  onChanged: (value) {
                    ref.read(loginProvider.notifier).setEmail(value);
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
                 final isRemember = ref.watch(loginProvider.select((s)=>s.isPasswordVisible));
                 return  CustomTextField(
                   controller: passwordController,
                   hintText: AppLocalizations.of(context)!.enterYourPassword,
                   obscureText: !isRemember ,
                   validator: AppValidator.validatePassword,
                   onChanged: (password) {
                     ref.read(loginProvider.notifier).
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
                       ref.read(loginProvider.notifier)
                           .togglePasswordVisibility();
                     },
                   ),
                 );
               }),
                SizedBox(height: 24.h,),
                Consumer(builder: (context,ref,child){
                  final isLoading = ref.watch(loginProvider.select((s)=>s.isLoading));
            
                  return CustomPrimaryButton(title: AppLocalizations.of(context)!.signIn,
                    isLoading: isLoading,
                    onPressed: () async {
                     final result = await ref.read(loginProvider.notifier).login(context: context);
                     if(result){
                       await TokenStorage.setLogin(true);
                       context.go(RouteNames.homeNavBarScreen);
                     }
            
            
            
            
                  },);
            
                }),
                SizedBox(height: 24.h,),
            
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Consumer(builder: (context, ref, child) {
                          final isRemember = ref.watch(loginProvider.select((s)=>s.isRemember));
                          return CustomSwitchWidget(
                            value: isRemember,
                            onChanged: (value) {
                              ref.read(loginProvider.notifier)
                                  .toggleRemember(value );
            
            
                            },
                          );
                        },),
                        SizedBox(width: 10.w,),
                        CustomText(text: AppLocalizations.of(context)!.rememberMe,color: AppColors.textGrey,fontSize: 16.sp,fontWeight: FontWeight.w400,),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                       context.go( RouteNames.forgetPasswordScreen);
                      },
                      child: CustomText(
                        text: AppLocalizations.of(context)!.forgetPassword,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
            
                SizedBox(height: 24.h,),
                SvgPicture.asset(ImagePath.orImage),
                SizedBox(height: 32.h,),
                CustomSocialLogin(),
            
            
                SizedBox(height: 60.h,),
            
                CustomAccountWidget(firstTitle: AppLocalizations.of(context)!.donNotHaveAnAccount,buttonTitle: " ${AppLocalizations.of(context)!.signUp}",onTap: (){
                  context.go(RouteNames.signUpScreen);
                },),
            
            
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}







