import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';

import '../../../../../core/common/widgets/custom_text.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/icon_path.dart';
import '../../riverpod/on_boarding_view_model.dart';
import 'course_wheel_selector_wiget.dart';

class CoursePage extends ConsumerWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 32.w,right: 32.w),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    SizedBox(width: 28.w),
                    SvgPicture.asset(IconPath.rankCourseIcon),
                    SizedBox(width: 10.w),
                    CustomText(
                      text: "Rank Your Courses",
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                    )
                  ],
                ),
              ),
              CustomText(
                text: "Drag to reorder by preference",
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textGrey,
              )
            ],
          ),
        ),
        SizedBox(height: 24.h),
        CourseWheelSelector(
          items: const ["SCY", "SCM", "LCM"],
          onChanged: (value) {
            ref.read(onboardingProvider.notifier)
                .selectCourse(value);
            if (kDebugMode) {
              print(ref.read(onboardingProvider.select((s)=>s.selectedCourse)));
            }
          },
        ),


      ],
    );
  }
}

