import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';

class CustomDrawerButtonWidget extends StatelessWidget {
  const CustomDrawerButtonWidget({
    super.key, required this.icon, required this.buttonTitle, this.onTap,
  });
  final String icon,buttonTitle;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding:  EdgeInsets.only(left: 10.w,top: 12.h,bottom: 12.h,right: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(icon),
                      SizedBox(width: 6.w,),
                      Text(
                        buttonTitle,
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  /// Arrow Button
                  Icon(

                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xff368ABB),
                    size: 16,
                    weight: 8.w,
                  ),

                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
}