import 'package:flutter/material.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';


import '../../../utils/constants/app_colors.dart';

class CustomSecondaryButton extends StatelessWidget {
  const CustomSecondaryButton({
    super.key, required this.title, this.onPressed,
  });
  final String title;
  final  void Function()? onPressed;


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(

      style: ElevatedButton.styleFrom(

        fixedSize:  Size(double.infinity, 52.h),
        backgroundColor: Color(0xffF5EEFF),// width = full, height = 50
        side: BorderSide(color:Color(0xffF5EEFF),width:1.w ),
      ),
      onPressed: onPressed,
      child: Center(child:  Text(title,style: TextStyle(color: AppColors.textPrimary,fontSize: 15.sp,fontWeight: FontWeight.w500),)),
    );
  }
}