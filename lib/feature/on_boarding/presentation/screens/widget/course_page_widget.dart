import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/common/widgets/custom_text.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/app_sizer.dart';
import '../../../../../core/utils/constants/icon_path.dart';
import '../../../../../l10n/app_localizations.dart';


class OnboardingState {
  final List<String> availableCourses;
  final String selectedCourse;

  OnboardingState({
    required this.availableCourses,
    required this.selectedCourse,
  });

  OnboardingState copyWith({List<String>? availableCourses, String? selectedCourse}) {
    return OnboardingState(
      availableCourses: availableCourses ?? this.availableCourses,
      selectedCourse: selectedCourse ?? this.selectedCourse,
    );
  }
}

class OnboardingViewModel extends StateNotifier<OnboardingState> {
  OnboardingViewModel()
      : super(OnboardingState(
    availableCourses: ["SCY", "SCM", "LCM"],
    selectedCourse: "SCY",
  ));

  // Logic to handle dragging from one index to another
  void reorderCourses(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final List<String> items = List.from(state.availableCourses);
    final String movedItem = items.removeAt(oldIndex);
    items.insert(newIndex, movedItem);

    state = state.copyWith(
      availableCourses: items,
      selectedCourse: items.first, // The new #1 item
    );
  }
}

final onboardingProvider1 = StateNotifierProvider<OnboardingViewModel, OnboardingState>((ref) {
  return OnboardingViewModel();
});
class CoursePage extends ConsumerWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider1);
    final courseList = state.availableCourses;

    return Column(
      children: [
        // Header Section
        Padding(
          padding: EdgeInsets.only(left: 32.w, right: 32.w, top: 120.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(IconPath.rankCourseIcon),
                  SizedBox(width: 10.w),
                  CustomText(
                    text: AppLocalizations.of(context)!.selectYourCourses,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textWhite,
                  )
                ],
              ),
              SizedBox(height: 8.h),
              CustomText(
                text: AppLocalizations.of(context)!.dragToReorder,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textGrey,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),

        SizedBox(height: 32.h),

        // Reorderable List Section
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30.w),
          decoration: BoxDecoration(
            color: Color(0xFF0B2E4A), // Deep dark blue background from image
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.blueAccent.withValues(alpha: 0.8),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ReorderableListView.builder(
              shrinkWrap: true,
              itemCount: courseList.length,
              // 🔥 FIX: proxyDecorator ensures the item stays dark when picked up
              proxyDecorator: (child, index, animation) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (BuildContext context, Widget? child) {
                    // The animation.value helps us add a slight effect (like a shadow or scale)
                    // when the item is picked up
                    final double animValue = Curves.easeInOut.transform(animation.value);
                    //final double elevation = lerpDouble(0, 6, animValue)!;

                    return Material(
                      // Transparent so the ClipRRect below handles the background
                      color: Colors.transparent,
                      //elevation: elevation, // Adds a subtle shadow while dragging
                      shadowColor: Colors.black.withOpacity(0.5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12), // 🔥 This keeps the corners rounded
                        child: Container(
                          color: const Color(0xFF0B2E4A), // Match your list background
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: child,
                );
              },
              onReorder: (oldIndex, newIndex) {
                ref.read(onboardingProvider1.notifier).reorderCourses(oldIndex, newIndex);
              },
              itemBuilder: (context, index) {
                final course = courseList[index];
                final isFirst = index == 0;

                return Column(
                  key: ValueKey(course), // Required for Reorderable
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 20.h),
                      child: Row(
                        children: [
                          // 1. Rank Number (e.g., 1.)
                          SizedBox(
                            width: 40.w,
                            child: Text(
                              "${index + 1}.",
                              style: TextStyle(
                                color: isFirst ? Colors.amber : Colors.white60,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          SizedBox(width: 70.w,),

                          // 2. Course Title (Centered)
                          Text(
                            course,
                            style: TextStyle(
                              color: isFirst ? Colors.amber : Colors.white60,
                              fontSize: 16.sp,
                              fontWeight: isFirst ? FontWeight.bold : FontWeight.w500,
                              letterSpacing: 1.2,
                            ),
                          ),

                          const Spacer(),

                          // 3. Drag Handle (SVG from your project)
                          ReorderableDragStartListener(
                            index: index,
                            child: Icon(
                              Icons.drag_indicator, // Or your SvgPicture.asset(IconPath.courseIcon)
                              color: isFirst ? Colors.amber.withOpacity(0.5) : Colors.white24,
                              size: 24.sp,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 4. Divider: Only show between items, not after the last one
                    if (index < courseList.length - 1)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.5.w),
                        child: Divider(
                          height: 0.5,
                          thickness: 0.5,
                          color: AppColors.primary,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        )
      ],
    );
  }
}


