import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AppCardThemeData {
  AppCardThemeData._();

  static CardThemeData _baseCardTheme({
    required Color color,
    required Color shadowColor,
    required double elevation,
    required BorderRadius borderRadius,
  }) {
    return CardThemeData(
      color: color,
      shadowColor: shadowColor,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
    );
  }

  /// 🌞 Light Theme Card
  static final CardThemeData lightCardTheme = _baseCardTheme(
    color: AppColors.textWhite,
    shadowColor: AppColors.textWhite.withValues(alpha: 0.08),
    elevation: 1,
    borderRadius: BorderRadius.circular(8),
  );

  /// 🌙 Dark Theme Card
  static final CardThemeData darkCardTheme = _baseCardTheme(
    color: const Color(0xff353434),
    shadowColor: Color(0xff353434).withValues(alpha: 0.08),
    elevation: 1,
    borderRadius: BorderRadius.circular(8),
  );
}
