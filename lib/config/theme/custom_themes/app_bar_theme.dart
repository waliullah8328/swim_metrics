import 'package:flutter/material.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';

import '../../../core/utils/constants/app_colors.dart';



class AppBarThemeData {
  AppBarThemeData._();

  static AppBarTheme _baseAppBarTheme({
    required Color backgroundColor,
    required Color iconColor,
    required Color titleColor,
    required Color surfaceTintColor,
    required double elevation,
  }) {
    return AppBarTheme(
      foregroundColor: Colors.transparent,
      surfaceTintColor: surfaceTintColor,
      elevation: elevation,
      backgroundColor: backgroundColor,
      iconTheme: IconThemeData(color: iconColor),
      titleTextStyle: TextStyle(
        color: titleColor,
        fontSize: 20.0.sp,
        fontWeight: FontWeight.bold,
      ),
      actionsIconTheme: IconThemeData(color: iconColor),
      centerTitle: true,
      // systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }

  static final AppBarTheme lightAppBarTheme = _baseAppBarTheme(
    backgroundColor:Color(0xffF5F5F5),
    iconColor: AppColors.textPrimary,
    titleColor: AppColors.textPrimary,
    surfaceTintColor: AppColors.textWhite,
    elevation: 3,
  );

  static final AppBarTheme darkAppBarTheme = _baseAppBarTheme(
    backgroundColor: Color(0xff022740),
    iconColor: AppColors.textWhite,
    titleColor: AppColors.textWhite,
    surfaceTintColor: AppColors.textPrimary,
    elevation: 0,
  );
}