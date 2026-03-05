import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swim_metrics/core/common/widgets/custom_text.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';


class CoreToolCard extends StatelessWidget {
  final String title;
  final String description;
  final String icon;
  final VoidCallback? onTap;
  final bool? isLeft;

  const CoreToolCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.onTap,
    this.isLeft = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF0F2D3F), // dark navy
              Color(0xFF143B52), // slight lighter navy
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
            width: 1.w,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LEFT ICON
            if(isLeft!)
              Row(
                children: [
                  Center(
                    child: SvgPicture.asset(icon),
                  ),
                  SizedBox(width: 16.h),
                ],
              ),






            /// TEXT AREA
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text:
                    title,

                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,

                  ),
                   SizedBox(height: 8.h),
                  CustomText(
                    text:
                    description,

                      color: Color(0xffE3D99B),
                      fontSize: 11.sp,



                  ),
                ],
              ),
            ),
            if(!isLeft!)
              Row(
                children: [
                  SizedBox(width: 16.h),
                  Center(
                    child: SvgPicture.asset(icon),
                  ),

                ],
              ),
          ],
        ),
      ),
    );
  }
}