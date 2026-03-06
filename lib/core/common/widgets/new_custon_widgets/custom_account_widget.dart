import 'package:flutter/material.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizer.dart';
import '../custom_text.dart';

class CustomAccountWidget extends StatelessWidget {
  const CustomAccountWidget({
    super.key, required this.firstTitle, required this.buttonTitle, this.onTap,
  });
  final String firstTitle, buttonTitle;
  final void Function()? onTap;


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(text: firstTitle,fontWeight: FontWeight.w500,fontSize: 15.sp,color: AppColors.textSecondary,),
        GestureDetector(
            onTap: onTap,
            child: CustomText(text: buttonTitle,fontWeight: FontWeight.w600,fontSize: 15.sp,color: AppColors.primary,)),
      ],
    );
  }
}