import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';


import '../../../utils/constants/app_colors.dart';


class CustomPasswordTextField extends ConsumerWidget {
  const CustomPasswordTextField(   {
    super.key,
    this.isDarkMode = false,
    required this.obscureText,
    this.validator,
    required this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.controller
  });
  final bool? isDarkMode;

  final bool obscureText;
  final String? Function(String?)? validator;
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      controller:controller ,

      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator:validator,
      onChanged:onChanged ,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintStyle: GoogleFonts.urbanist(
          fontSize: 14.sp,
          color: isDarkMode == true
              ? AppColors.textWhite
              : AppColors.textGrey,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 15.h,
        ),
      ),
    );
  }
}
