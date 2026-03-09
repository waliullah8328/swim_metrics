import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';

import '../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../core/utils/constants/app_sizer.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key, required this.imagePath, required this.title, this.onTap, required this.isDark,  this.isApple = false,
  });

  final String imagePath, title;
  final void Function()? onTap;
  final bool isDark;
  final bool isApple;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(

          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Card(
            elevation: 0,

            // background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: Color(0xffE5E7EB), // border color
                width: 0.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isApple?SvgPicture.asset(imagePath,colorFilter: ColorFilter.mode(isDark?AppColors.textWhite:Colors.black,BlendMode.srcIn),):SvgPicture.asset(imagePath,),
                  SizedBox(width: 16.w),
                  CustomText(
                    text: title,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}