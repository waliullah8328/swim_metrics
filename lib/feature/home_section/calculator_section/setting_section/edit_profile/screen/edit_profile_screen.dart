import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/custom_primary_button.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/custom_text_form_field.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';

import '../../../../../../core/common/widgets/custom_text.dart';

import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/constants/icon_path.dart';
import '../../../../../../core/utils/constants/image_path.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../settings/riverpod/setting_controller.dart';
import '../data/repository/profile_repository.dart';
import '../riverpod/edit_profile_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {

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

  String name = '';
  final  TextEditingController nameController = TextEditingController() ;
 final TextEditingController  _emailController = TextEditingController() ;
  final  TextEditingController  _phoneController= TextEditingController() ;
  final  TextEditingController  _currentPasswordController= TextEditingController() ;
  final  TextEditingController  _newPasswordController= TextEditingController() ;
  final  TextEditingController  _confirmPasswordController= TextEditingController() ;

  @override
  void initState() {
    super.initState();

  }


  @override
  void dispose() {
    super.dispose();
   nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _confirmPasswordController.dispose();
    _newPasswordController.dispose();

    // Example: load data or initialize controllers
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fontOption = ref.watch(settingsProvider).fontSize;
    final info = ref.watch(profileProvider);
    final profile = ref.watch(getMeProvider);

    // Update controllers when state changes
    nameController.text = info.name;
    _emailController.text = info.email;
    _phoneController.text = info.phone;


    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppLocalizations.of(context)!.editProfile,
          fontSize: getAdjustedFontSize(24, fontOption).sp,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Padding(
            padding: EdgeInsets.only(left: 18.w),
            child: SvgPicture.asset(
              IconPath.backIcon,
              height: getAdjustedFontSize(48, fontOption).h,
              width: getAdjustedFontSize(48, fontOption).w,
              fit: BoxFit.contain,
            ),
          ),
        ),

        /// Divider below AppBar
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            CustomText(text: AppLocalizations.of(context)!.personalDetails,fontSize: getAdjustedFontSize(18, fontOption).w,fontWeight: FontWeight.w600,),
            SizedBox(height: 18.h),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark?AppColors.darkThemeContainerColor: Color(0xffFFFFFF),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 4), // shadow position
                  ),
                ],
              ),
              child: Column(
                children: [
                  profile.when(data:(data) {
                    return  GestureDetector(
                      onTap: (){
                        ref.read(profileProvider.notifier).pickImage(ref: ref);
                      },
                      child: CircleAvatar(
                        radius: getAdjustedFontSize(45, fontOption),
                        backgroundImage: ref.watch(profileProvider).profileImage != null
                            ? FileImage(ref.watch(profileProvider).profileImage!)
                            :data.profilePicture != ""?NetworkImage(data.profilePicture.toString()): AssetImage(ImagePath.profileDeleteImage)
                        as ImageProvider,
                      ),
                    );
                  },
                      error: (error,stack)=> Text("No data found"),
                      loading: ()=>CircularProgressIndicator(),
                  ),


                  SizedBox(height: 20.h),
                  CustomEditProfileTextFieldWidget(
                    fontOption: fontOption,

                    controller:nameController ,
                    hintText: AppLocalizations.of(context)!.enterYourName,
                    titleName: AppLocalizations.of(context)!.name,
                    onChanged: (value) {
                    ref.read(profileProvider.notifier).updateName(value);
                  },),
                  CustomEditProfileTextFieldWidget(
                    fontOption: fontOption,

                    controller:_emailController ,
                    hintText: AppLocalizations.of(context)!.enterYourEmail,
                    titleName: AppLocalizations.of(context)!.email,
                    onChanged: (value) {
                      ref.read(profileProvider.notifier).updateEmail(value);
                    },),

                  CustomEditProfileTextFieldWidget(
                    fontOption: fontOption,

                    controller:_phoneController ,
                    hintText: AppLocalizations.of(context)!.enterYourPhoneNumber,
                    titleName: AppLocalizations.of(context)!.phone,
                    onChanged: (value) {
                      ref.read(profileProvider.notifier).updatePhone(value);
                    },),





                  SizedBox(height: 20.h),

                  Consumer(builder: (context,ref,child){
                    final isLoading = ref.watch(profileProvider.select((s)=>s.isLoading));

                    return CustomPrimaryButton(title: AppLocalizations.of(context)!.saveChanges,
                      isLoading: isLoading,
                      onPressed: () async {
                         ref.read(profileProvider.notifier).saveProfile(context: context);
                      




                      },);

                  }),
                  


                ],
              ),
            ),

            SizedBox(height: 30.h),

            CustomText(text: AppLocalizations.of(context)!.securityDetails,fontSize: 18.sp,fontWeight: FontWeight.w600,),
            SizedBox(height: 18.h,),

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark?AppColors.darkThemeContainerColor: Color(0xffFFFFFF),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 4), // shadow position
                  ),
                ],
              ),
              child: Column(
                children: [
                  CustomEditProfileTextFieldWidget(
                    fontOption: fontOption,

                    controller:_currentPasswordController ,
                    hintText: AppLocalizations.of(context)!.enterYourCurrentPassword,
                    titleName: AppLocalizations.of(context)!.currentPassword,
                    onChanged: (value) {
                      ref.read(profileProvider.notifier).updateCurrentPassword(value);
                    },),

                  CustomEditProfileTextFieldWidget(
                    fontOption: fontOption,

                    controller:_newPasswordController ,
                    hintText: AppLocalizations.of(context)!.enterYourNewPassword,
                    titleName: AppLocalizations.of(context)!.newPassword,
                    onChanged: (value) {
                      ref.read(profileProvider.notifier).updateNewPassword(value);
                    },),
                  CustomEditProfileTextFieldWidget(
                    fontOption: fontOption,

                    controller:_confirmPasswordController ,
                    hintText: AppLocalizations.of(context)!.enterYourConfirmPassword,
                    titleName: AppLocalizations.of(context)!.confirmPassword,
                    onChanged: (value) {
                      ref.read(profileProvider.notifier).updateConfirmPassword(value);
                    },),


                   SizedBox(height: 20.h),

                  Consumer(builder: (context,ref,child){
                    final isLoading = ref.watch(profileProvider.select((s)=>s.isPasswordLoading));

                    return CustomPrimaryButton(title: AppLocalizations.of(context)!.savePassword,
                      isLoading: isLoading,
                      onPressed: () async {
                        ref.read(profileProvider.notifier).changePassword(context: context);





                      },);

                  }),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomEditProfileTextFieldWidget extends StatelessWidget {
  const CustomEditProfileTextFieldWidget({
    super.key,

    required this.controller, required this.titleName, required this.hintText, this.onChanged, required this.fontOption,
  }) ;

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

  final TextEditingController controller;

  final String titleName, hintText;
  final  Function(String)? onChanged;
  final FontSizeOption fontOption;


  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: titleName,color: Color(0xff82888E),fontSize: getAdjustedFontSize(14, fontOption).w,),
        SizedBox(height: 6.h,),

        CustomTextField(
          hintText: hintText,

          controller: controller,
          onChanged: onChanged,
        ),
        SizedBox(height: 6.h,),
      ],
    );
  }
}
