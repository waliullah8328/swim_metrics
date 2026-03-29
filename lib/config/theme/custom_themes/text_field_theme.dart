import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/constants/app_colors.dart';

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
      suffixIconColor: suffixIconColor,
      filled: true,
      fillColor: fillColor,

      // ✅ Apply GoogleFonts here
      labelStyle: GoogleFonts.merriweather(
        fontSize: 14,
        color: labelColor,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: GoogleFonts.merriweather(
        fontSize: 14,
        color: hintColor,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.merriweather(
        fontSize: 12,
        color: errorColor,
        fontWeight: FontWeight.w400,
      ),
      floatingLabelStyle: GoogleFonts.merriweather(
        color: labelColor.withValues(alpha: 0.8),
        fontWeight: FontWeight.w500,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: enabledBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: focusedBorderColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: errorBorderColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: focusedErrorBorderColor),
      ),
    );
  }

  static final InputDecorationTheme lightInputDecorationTheme =
  _baseInputDecorationTheme(
    fillColor:
    AppColors.textFormFieldFillColorLightMode.withValues(alpha: 0.6),
    labelColor: Colors.black,
    hintColor: AppColors.textFormFieldHintColorLightMode,
    errorColor: Colors.red,
    focusedErrorColor: Colors.orange,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    borderColor: const Color(0xffFAFAFA),
    enabledBorderColor: const Color(0xffFAFAFA),
    focusedBorderColor: const Color(0xffFAFAFA),
    errorBorderColor: Colors.red,
    focusedErrorBorderColor: Colors.orange,
  );

  static final InputDecorationTheme darkInputDecorationTheme =
  _baseInputDecorationTheme(
    fillColor: const Color(0xff153250),
    labelColor: Colors.white,
    hintColor: const Color(0xffDADADA),
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