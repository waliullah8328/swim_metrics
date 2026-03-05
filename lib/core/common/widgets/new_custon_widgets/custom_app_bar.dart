import 'package:flutter/material.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
 // Make sure you have the ScreenUtil dependency in pubspec.yaml

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const CustomAppBar({super.key, required this.title,  this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 25.sp, // Adjust size based on screen
          ),
          onPressed: onBackPressed?? ()=> Navigator.pop(context), // Back button functionality
        ),
        Expanded(
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600, // Font weight for the title
                fontSize: 22.sp, // Font size based on screen size
                color: Colors.black, // Title text color
              ),
            ),
          ),
        ),
        SizedBox(width: 35.w,)
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(110.h); // The height of the app bar
}
