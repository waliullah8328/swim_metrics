import 'package:flutter/material.dart' hide AppBarThemeData;
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import 'custom_themes/app_bar_theme.dart';
import 'custom_themes/app_card_theme.dart';
import 'custom_themes/bottom_app_bar_theme.dart';
import 'custom_themes/elevated_button_theme.dart';
import 'custom_themes/text_field_theme.dart';
import 'custom_themes/text_theme.dart';


class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.urbanist().fontFamily,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.scaFoldBackGroudLightColor,
       textTheme: AppTextTheme.lightTextTheme,
      elevatedButtonTheme: AppElevatedButtonTheme.lightElevatedButtonTheme,
      appBarTheme: AppBarThemeData.lightAppBarTheme,
      inputDecorationTheme: AppTextFormFieldTheme.lightInputDecorationTheme,
    bottomNavigationBarTheme: BottomNavBarThemeData.lightBottomNavBarTheme,
    cardTheme: AppCardThemeData.lightCardTheme,
  );

  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.urbanist().fontFamily,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor:AppColors.scaFoldBackGroudDarkColor,
      textTheme: AppTextTheme.darkTextTheme,
      elevatedButtonTheme: AppElevatedButtonTheme.darkElevatedButtonTheme,
      appBarTheme: AppBarThemeData.darkAppBarTheme,
      inputDecorationTheme: AppTextFormFieldTheme.darkInputDecorationTheme,
    bottomNavigationBarTheme: BottomNavBarThemeData.darkBottomNavBarTheme,
    cardTheme: AppCardThemeData.darkCardTheme,
  );
}
