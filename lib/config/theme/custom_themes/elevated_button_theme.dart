import 'package:flutter/material.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';



class AppElevatedButtonTheme {
  AppElevatedButtonTheme._();

  static ElevatedButtonThemeData _baseTheme({
    required Color defaultTextColor,
    required Color disabledTextColor,
    required Color defaultBackgroundColor,
    required Color disabledBackgroundColor,
    required Color borderColor,
  }) {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(0),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) => states.contains(WidgetState.disabled) ? disabledTextColor : defaultTextColor,
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) => states.contains(WidgetState.disabled) ? disabledBackgroundColor : defaultBackgroundColor,
        ),
        side: WidgetStateProperty.all(BorderSide(color: borderColor)),
        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 18)),
        textStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }

  static final ElevatedButtonThemeData lightElevatedButtonTheme = _baseTheme(
    defaultTextColor: AppColors.textPrimary,
    disabledTextColor: Colors.grey,
    defaultBackgroundColor: AppColors.primary,
    disabledBackgroundColor: Colors.grey.shade300,
    borderColor: AppColors.primary,
  );

  static final ElevatedButtonThemeData darkElevatedButtonTheme = _baseTheme(
    defaultTextColor: Color(0xffFFFFFF),
    disabledTextColor: Colors.grey.shade600,
    defaultBackgroundColor: Color(0xff16A8AD),
    disabledBackgroundColor: Colors.grey.shade800,
    borderColor: AppColors.primary,
  );
}