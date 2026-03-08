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
import '../riverpod/edit_profile_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Example: load data or initialize controllers
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();

    // Example: load data or initialize controllers
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;


    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: "Edit Profile",
          fontSize: 24.sp,
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
              height: 48.h,
              width: 48.w,
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
            CustomText(text: "PERSONAL DETAILS",fontSize: 18.sp,fontWeight: FontWeight.w600,),
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
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage(ImagePath.profileDeleteImage),
                  ),

                  SizedBox(height: 20.h),
                  CustomEditProfileTextFieldWidget(

                    controller:_nameController ,
                    hintText: "Enter your name",
                    titleName: "Name",
                    onChanged: (value) {
                    ref.read(profileProvider.notifier).updateName(value);
                  },),
                  CustomEditProfileTextFieldWidget(

                    controller:_emailController ,
                    hintText: "Enter your email",
                    titleName: "Email",
                    onChanged: (value) {
                      ref.read(profileProvider.notifier).updateEmail(value);
                    },),

                  CustomEditProfileTextFieldWidget(

                    controller:_emailController ,
                    hintText: "Enter your phone number",
                    titleName: "Phone",
                    onChanged: (value) {
                      ref.read(profileProvider.notifier).updatePhone(value);
                    },),





                  SizedBox(height: 20.h),
                  CustomPrimaryButton(title: "Save Changes",onPressed: (){},)


                ],
              ),
            ),

            SizedBox(height: 30.h),

            CustomText(text: "SECURITY DETAILS",fontSize: 18.sp,fontWeight: FontWeight.w600,),
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

                    controller:_phoneController ,
                    hintText: "Enter your current password",
                    titleName: "Current Password",
                    onChanged: (value) {
                      ref.read(profileProvider.notifier).updateEmail(value);
                    },),

                  CustomEditProfileTextFieldWidget(

                    controller:_phoneController ,
                    hintText: "Enter your new password",
                    titleName: "New Password",
                    onChanged: (value) {
                      ref.read(profileProvider.notifier).updateEmail(value);
                    },),
                  CustomEditProfileTextFieldWidget(

                    controller:_phoneController ,
                    hintText: "Enter your confirm password",
                    titleName: "Confirm Password",
                    onChanged: (value) {
                      ref.read(profileProvider.notifier).updateEmail(value);
                    },),


                   SizedBox(height: 20.h),

                  CustomPrimaryButton(title: "Save Password",onPressed: (){},)
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

    required this.controller, required this.titleName, required this.hintText, this.onChanged,
  }) ;

  final TextEditingController controller;

  final String titleName, hintText;
  final  Function(String)? onChanged;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: titleName,color: Color(0xff82888E),),
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
