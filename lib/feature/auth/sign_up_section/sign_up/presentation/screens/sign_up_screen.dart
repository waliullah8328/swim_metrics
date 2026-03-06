

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:riverpod/src/framework.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/custom_primary_button.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/custom_text_form_field.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/icon_path.dart';
import 'package:swim_metrics/feature/auth/sign_up_section/sign_up/presentation/riverpod/sign_up_controller.dart';

import '../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../core/common/widgets/new_custon_widgets/custom_account_widget.dart';
import '../../../../../../core/common/widgets/new_custon_widgets/custom_check_box_widget.dart';

import '../../../../../../core/utils/constants/app_sizer.dart';
import '../../../../../../core/utils/constants/image_path.dart';
import '../../../../../../core/utils/validators/app_validator.dart';
import '../../../../login_section/login/presentation/riverpod/login_controller.dart';
import '../../../../login_section/login/presentation/riverpod/login_state.dart';



class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<SignUpScreen> {
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();


  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build");




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
              CustomText(text: "Create An Account",fontSize: 23.sp,fontWeight: FontWeight.w700),
              SizedBox(height: 24.h,),
              CustomTextField(
                focusNode: _nameFocusNode,

                hintText: "Enter your name",

                validator: AppValidator.validateEmail,

                onChanged: (value) {
                  ref.read(signUpProvider.notifier).setEmail(value);
                },
                prefixIcon: Padding(
                  padding: EdgeInsets.all(13.w),
                  child: SvgPicture.asset(
                    IconPath.profileIcon,
                    width: 18.w,
                    height: 18.h,
                    fit: BoxFit.contain,
                  ),
                ),

              ),
              SizedBox(height: 8.h,),
              CustomTextField(
                focusNode: _emailFocusNode,

                hintText: "Enter your email",

                validator: AppValidator.validateEmail,

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
                  ),
                ),

              ),
              SizedBox(height: 8.h,),
              Consumer(builder:  (context,ref,child){
                final isRemember = ref.watch(signUpProvider.select((s)=>s.isPasswordVisible));
                return  CustomTextField(
                  focusNode: _passwordFocusNode,
                  hintText: "Enter your password",
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
              SizedBox(height: 24.h,),
              Consumer(builder: (context,ref,child){
                final isLoading = ref.watch(signUpProvider.select((s)=>s.isLoading));

                return CustomPrimaryButton(title: "Create Account",
                  isLoading: isLoading,
                  onPressed: () async {
                    ref.read(signUpProvider.notifier).login();




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
                      CustomText(text: "Remember Me",color: AppColors.textGrey,fontSize: 16.sp,fontWeight: FontWeight.w400,),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(context, RouteNames.forgetPasswordScreen);
                    },
                    child: CustomText(
                      text: "Forget Password",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h,),
              SvgPicture.asset(ImagePath.orImage),



              SizedBox(height: 60.h,),

              CustomAccountWidget(firstTitle: "Don’t have an account?",buttonTitle: " Sign Up",onTap: (){},),



            ],
          ),
        ),
      ),
    );
  }
}







