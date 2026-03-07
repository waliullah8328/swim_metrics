import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';

class CustomActiveContainerImage extends StatelessWidget {
  const CustomActiveContainerImage({
    super.key, required this.imagePath,
  });
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58.h,
      width: 58.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // color: const Color(0xFFD9EEF7),
        boxShadow: [
          BoxShadow(
            color: Color(0xff2DA8F0),
            blurRadius: 10,
            spreadRadius: 2,
          ),

        ],
      ),
      child: Center(
        child: SvgPicture.asset(
          imagePath,
          height: 55.h,
        ),
      ),
    );
  }
}