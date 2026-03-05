
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';



import '../../../utils/constants/app_colors.dart';
import '../../../utils/theme/theme_provider.dart';

class CustomTextField extends ConsumerWidget {
  const CustomTextField(  {
    super.key,
    this.controller,
    required this.hintText,
    this.obscureText = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.fillColor,
    this.maxLine,
    this.radius = 8,
    this.onFieldSubmitted,
    this.onChanged,
    this.value,
    this.prefixIcon,
    this.focusNode,           // ✅ Added focusNode
    this.visibilityProvider,
    this.enable,
    this.decoration,
  });

  final TextEditingController? controller;
  final String hintText;
  final bool obscureText;
  final dynamic fillColor;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool readOnly;
  final int? maxLine;
  final double radius;
  final String? value;
  final void Function(String)? onFieldSubmitted;
  final Widget? prefixIcon;
  final Function(String)? onChanged;
  final FocusNode? focusNode; // ✅ FocusNode added

  final bool? enable;

  final InputDecoration? decoration;

  /// Individual visibility provider
  final StateProvider<bool>? visibilityProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisible = visibilityProvider != null
        ? ref.watch(visibilityProvider!)
        : false;

    final themeMode = ref.watch(themeModeProvider);

// ✅ Detect dark mode correctly
    final brightness = MediaQuery.of(context).platformBrightness;

    final isDarkMode = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system && brightness == Brightness.dark);

    return TextFormField(
      enabled: enable,
      initialValue: value,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      focusNode: focusNode, // ✅ Use the passed focusNode
      maxLines: maxLine ?? 1,
      readOnly: readOnly,
      keyboardType: keyboardType,
      obscureText: obscureText ? !isVisible : false,
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      decoration: decoration??InputDecoration(
        hintText: hintText,
        suffixIcon: obscureText
            ? IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: isDarkMode?AppColors.textWhite:AppColors.textGrey,
          ),
          onPressed: () {
            if (visibilityProvider != null) {
              ref.read(visibilityProvider!.notifier).state = !isVisible;
            }
          },
        )
            : null,
        prefixIcon: prefixIcon,
        hintStyle: GoogleFonts.urbanist(

          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          height: 20 / 14,
          color: isDarkMode? AppColors.textWhite:AppColors.textGrey,
        ),


        contentPadding: EdgeInsets.only(
          left: 12.w,
          right: 10.w,
          top: 15.h,
          bottom: 15.h,
        ),
      ),
      validator: validator,
    );
  }
}
