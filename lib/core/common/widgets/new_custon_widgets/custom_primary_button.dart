import 'package:flutter/material.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';


class CustomPrimaryButton extends StatelessWidget {
  const CustomPrimaryButton({
    super.key, required this.title, this.onPressed,
  });
  final String title;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize:  Size(double.infinity, 52.h), // width = full, height = 50
      ),
      onPressed: onPressed,
      child: Center(child:  Text(title,style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500),)),
    );
  }
}