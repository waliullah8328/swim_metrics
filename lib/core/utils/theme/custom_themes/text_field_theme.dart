import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';


class AppTextFormFieldTheme {
  AppTextFormFieldTheme._();

  static InputDecorationTheme _baseInputDecorationTheme({
    required Color labelColor,
    required Color hintColor,
    required Color errorColor,
    required Color focusedErrorColor,
    required Color prefixIconColor,
    required Color suffixIconColor,
    required Color borderColor,
    required Color enabledBorderColor,
    required Color focusedBorderColor,
    required Color errorBorderColor,
    required Color focusedErrorBorderColor,
    required Color fillColor,
  }) {
    return InputDecorationTheme(
      errorMaxLines: 3,
      prefixIconColor: prefixIconColor,
       filled: true,
       fillColor: fillColor,
      suffixIconColor: suffixIconColor,
      labelStyle: TextStyle(fontSize: 14, color: labelColor),
      hintStyle: TextStyle(fontSize: 14, color: hintColor),
      errorStyle: TextStyle(fontSize: 12, color: errorColor),
      floatingLabelStyle: TextStyle(color: labelColor.withValues(alpha: 0.8)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: enabledBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: focusedBorderColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: errorBorderColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: focusedErrorBorderColor),
      ),
    );
  }

  static final InputDecorationTheme lightInputDecorationTheme =
      _baseInputDecorationTheme(
        fillColor:  Color(0xffFAFAFA),
    labelColor: Colors.black,
    hintColor: Color(0xff9E9E9E),
    errorColor: Colors.red,
    
    focusedErrorColor: Colors.orange,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    borderColor: Color(0xffFAFAFA),
    enabledBorderColor: Color(0xffFAFAFA),
    focusedBorderColor: Color(0xffFAFAFA),
    errorBorderColor: Colors.red,
    focusedErrorBorderColor: Colors.orange,
  );

  static final InputDecorationTheme darkInputDecorationTheme =
      _baseInputDecorationTheme(
        fillColor: Color(0xff353434),
    labelColor: Colors.white,
    hintColor: AppColors.textWhite,
    errorColor: Colors.redAccent,
    focusedErrorColor: Colors.orangeAccent,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    borderColor: Colors.grey,
    enabledBorderColor: Colors.grey,
    focusedBorderColor: Colors.white,
    errorBorderColor: Colors.redAccent,
    focusedErrorBorderColor: Colors.orangeAccent,
  );
}