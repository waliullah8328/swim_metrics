import 'package:flutter/material.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';

class CourseDropdown extends StatefulWidget {
  const CourseDropdown({super.key});

  @override
  State<CourseDropdown> createState() => _CourseDropdownState();
}

class _CourseDropdownState extends State<CourseDropdown> {
  final List<String> courses = ["SCY", "SCM", "LCM"];
  String selectedCourse = "SCY";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      color: AppColors.textWhite,

      height: 70.h,
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(20),

      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCourse,
          //dropdownColor: const Color(0xFF223F5E),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.blue),
          isExpanded: true,
          onChanged: (value) {
            setState(() {
              selectedCourse = value!;
            });
          },
          items: courses.map((course) {
            return DropdownMenuItem(
              value: course,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Expanded(
                    child: Center(
                      child: Text(
                        course,
                        style: TextStyle(
                          color: const Color(0xFFE6D18A),
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}