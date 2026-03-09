import 'package:flutter/material.dart';
import 'package:swim_metrics/core/common/widgets/custom_text.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';


class CustomPrimaryButton extends StatelessWidget {
  const CustomPrimaryButton({
    super.key, required this.title, this.onPressed, this.isLoading = false,
  });
  final String title;
  final void Function()? onPressed;

  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize:  Size(double.infinity, 60.h), // width = full, height = 50
      ),
      onPressed: onPressed,
      child: isLoading!? Center(child: CircularProgressIndicator()):Center(child:  CustomText(text: title,fontSize: 17.sp,fontWeight: FontWeight.w600)),
    );
  }
}