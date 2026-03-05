import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';


import '../../../../core/common/widgets/custom_text.dart';

class CustomSocialLogin extends StatelessWidget {
  const CustomSocialLogin({
    super.key, required this.iconPath, this.onTap, required this.title,
  });
  final String iconPath,title;
  final void Function()? onTap;



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            border: Border.all(width: 1.w,color: Color(0xffEEEEEE)),
            borderRadius: BorderRadius.circular(99)
        ),
        child: Row(
          children: [
            SvgPicture.asset(iconPath,height: 24.h,width: 24.w,),
            Expanded(child: Center(child: CustomText(text: title,fontSize: 16.sp,fontWeight: FontWeight.w600,)))

          ],
        ),
      ),
    );
  }
}