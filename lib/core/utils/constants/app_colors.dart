import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Colors
  static const Color primary = Color(0xFFC69C3F);
  static const Color secondary = Color(0xFFF9F9F9);
  static const Color lightThemeBackgroundColor = Color(0xFFFFFFFF);
  static const Color darkThemeBackgroundColor = Color(0xff212121);


  // Gradient Colors
  static const Gradient linearGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.707, -0.707),
    colors: [
      Color(0xfffffa9e),
      Color(0xFFFAD0C4),
      Color(0xFFFAD0C4),
    ],
  );


  // Text Colors
  static const Color textPrimary = Color(0xFF022740);
  static const Color textSecondary = Color(0xFF368ABB);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFFC8C8C8);
  static const Color textNavyBlue = Color(0xFF368ABB);


  // Background Colors
  static const Color backgroundLight = Color(0xFFF9FAFB);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color primaryBackground = Color(0xFFFFFFFF);

  // Surface Colors
  static const Color surfaceLight = Color(0xFFE0E0E0);
  static const Color surfaceDark = Color(0xFF2C2C2C);

  // Container Colors
  static const Color containerBackground = Color(0xFFD9D9D9);
  static const Color containerBackground1 = Color(0xFFF9F9FB);

  // profile_section Page Icon Colors
  static const Color profileIconColors = Color(0xFF353535);

  // Utility Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF29B6F6);
  /// textformfield border color

  static const Color textFormFieldBorder = Color(0xFFE0E0E0);

  static const Color containerColor = Color(0xFF747474);

// Scaffold BackGround Color
  static const Color scaFoldBackGroudLightColor = Color(0xFFFAFAFA);
  static const Color scaFoldBackGroudDarkColor = Color(0xFF022740);

  // TextForm Field Color
  static const Color textFormFieldFillColorLightMode = Color(0xFFEAEDF1);
  static const Color textFormFieldHintColorLightMode = Color(0xFF82888E);

}