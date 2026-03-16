

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:swim_metrics/config/route/routes_name.dart';

import 'package:swim_metrics/core/common/widgets/new_custon_widgets/custom_primary_button.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/custom_text_form_field.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/icon_path.dart';
import 'package:swim_metrics/feature/auth/login_section/create_new_password/presentation/riverpod/create_new_password_controller.dart';
import '../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../core/utils/constants/app_sizer.dart';
import '../../../../../../core/utils/constants/image_path.dart';
import '../../../../../../core/utils/validators/app_validator.dart';
import '../../../../../../l10n/app_localizations.dart';




class CreateNewPasswordScreen extends ConsumerStatefulWidget {
  const CreateNewPasswordScreen(this.forgetToken, {super.key, required this.email, required this.code, required this.isSignUp});

  final String email,code,isSignUp,forgetToken;

  @override
  ConsumerState<CreateNewPasswordScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<CreateNewPasswordScreen> {

  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  final _createNewPasswordFormKey = GlobalKey<FormState>();


  @override
  void dispose() {

    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    debugPrint("build");
    debugPrint(widget.email);
    debugPrint(widget.code);
    debugPrint(widget.forgetToken);






    return Scaffold(
      body: Center(
        child: Padding(
          padding:  EdgeInsets.only(left: 20.w,right: 20.w),
          child: SingleChildScrollView(
            child: Form(
              key: _createNewPasswordFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(ImagePath.appLogoImage,width: 80.w,height: 80.h,),
                  SizedBox(height: 32.h,),
                  CustomText(text: AppLocalizations.of(context)!.createNewPassword,fontSize: 23.sp,fontWeight: FontWeight.w700,textAlign: TextAlign.center,),
                  SizedBox(height: 16.h,),
                  CustomText(text: AppLocalizations.of(context)!.yourNewPasswordMustBeUnique,fontSize: 14.sp,color: AppColors.primary,fontWeight: FontWeight.w400,textAlign: TextAlign.center,),
                  SizedBox(height: 24.h,),

                  Consumer(builder:  (context,ref,child){
                    final isRemember = ref.watch(createNewPasswordProvider.select((s)=>s.isPasswordVisible));
                    return  CustomTextField(
                      focusNode: _passwordFocusNode,
                      hintText: AppLocalizations.of(context)!.enterYourPassword,
                      obscureText: !isRemember ,
                      validator: (value){

                        return  AppValidator.validatePassword(value,context);
                      },
                      onChanged: (password) {
                        ref.read(createNewPasswordProvider.notifier).
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
                          ref.read(createNewPasswordProvider.notifier)
                              .togglePasswordVisibility();
                        },
                      ),
                    );
                  }),
                  SizedBox(height: 8.h,),
                  Consumer(builder:  (context,ref,child){
                    final isPasswordVisible = ref.watch(createNewPasswordProvider.select((s)=>s.isConfirmPasswordVisible));
                    return  CustomTextField(
                      focusNode: _confirmPasswordFocusNode,
                      hintText: AppLocalizations.of(context)!.enterYourConfirmPassword,
                      obscureText: !isPasswordVisible ,
                      validator: (value){
                        final password = ref.watch(createNewPasswordProvider.select((s)=>s.password));
                        return AppValidator.validateConfirmPassword(value,password ,context);

                      },
                      onChanged: (confirmPassword) {
                        ref.read(createNewPasswordProvider.notifier).
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
                          ref.read(createNewPasswordProvider.notifier)
                              .toggleConfirmPasswordVisibility();
                        },
                      ),
                    );
                  }),

                  SizedBox(height: 24.h,),
                  Consumer(builder: (context,ref,child){
                    final isLoading = ref.watch(createNewPasswordProvider.select((s)=>s.isLoading));


                    return CustomPrimaryButton(title: AppLocalizations.of(context)!.save,
                      isLoading: isLoading,
                      onPressed: () async {
                        final String title = AppLocalizations.of(context)!.passwordChanged;
                        final String subTitle = AppLocalizations.of(context)!.yourPasswordHasBeenChangedSuccessfully;

                        if(_createNewPasswordFormKey.currentState!.validate()){
                          final result = await ref.read(createNewPasswordProvider.notifier).resetPassword(context: context,email: widget.email,forgotPasswordToken: widget.forgetToken);
                          if(result){
                            context.go("${RouteNames.verifyEmailSuccessScreen}/$title/$subTitle/false");
                          }


                        }





                      },);

                  }),









                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}







