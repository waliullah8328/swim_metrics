import 'package:flutter/material.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';

import '../../../core/utils/constants/app_colors.dart';



class BottomNavBarThemeData {
  BottomNavBarThemeData._();

  static BottomNavigationBarThemeData _baseBottomNavBarTheme({
    required Color backgroundColor,
    required Color selectedItemColor,
    required Color unselectedItemColor,
    required double elevation,
  }) {
    return BottomNavigationBarThemeData(
      backgroundColor: backgroundColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      elevation: elevation,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontSize: 15.0.sp,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 14.0.sp,
        fontWeight: FontWeight.w400,
      ),
      selectedIconTheme: IconThemeData(
        size: 23.0.sp,
      ),
      unselectedIconTheme: IconThemeData(
        size: 22.0.sp,
      ),
    );
  }

  static final BottomNavigationBarThemeData lightBottomNavBarTheme =
  _baseBottomNavBarTheme(
    backgroundColor: AppColors.textWhite,
    selectedItemColor: Color(0xff7F27FF),
    unselectedItemColor: Colors.grey,
    elevation: 8,
  );

  static final BottomNavigationBarThemeData darkBottomNavBarTheme =
  _baseBottomNavBarTheme(
    backgroundColor: Color(0xff353434),
    selectedItemColor: Color(0xff7F27FF),
    unselectedItemColor: Colors.grey,
    elevation: 0,
  );
}
