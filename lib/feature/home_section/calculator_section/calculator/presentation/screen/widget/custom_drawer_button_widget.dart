import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';

import '../../../../setting_section/settings/riverpod/setting_controller.dart';

class CustomDrawerButtonWidget extends StatelessWidget {
  const CustomDrawerButtonWidget({
    super.key, required this.icon, required this.buttonTitle, this.onTap, required this.isDarkMode, required this.fontSizeOption,
  });
  final String icon,buttonTitle;
  final void Function()? onTap;
  final bool isDarkMode;
  final FontSizeOption fontSizeOption;

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: isDarkMode?Color(0xff153250):Color(0xffEAEDF1),
        child: Padding(
          padding:  EdgeInsets.only(left: 10.w,top: 12.h,bottom: 12.h,right: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(icon),
                      SizedBox(width: 6.w,),
                      Text(
                        buttonTitle,
                        style: TextStyle(fontSize: getAdjustedFontSize(16,fontSizeOption).sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  /// Arrow Button
                  Icon(

                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xff368ABB),
                    size: 16,
                    weight: 8.w,
                  ),

                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
}