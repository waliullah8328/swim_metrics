import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../../core/utils/constants/app_sizer.dart';
import '../../../../../../../core/utils/constants/icon_path.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../on_boarding/presentation/screens/widget/course_page_widget.dart';

class CoursePageSelectionScreen extends ConsumerWidget {
  const CoursePageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider1);
    final courseList = state.availableCourses;

    return Scaffold(
      //backgroundColor: AppColors.scaffoldColor,

      appBar: AppBar(
        //backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.selectYourCourses,
        ),
      ),

      body: Column(
        children: [
          SizedBox(height: 20.h),

          /// ICON + TITLE
          SvgPicture.asset(
            IconPath.rankCourseIcon,
            height: 42.h,
          ),

          SizedBox(height: 16.h),

          /// SUBTITLE
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: CustomText(
              text: AppLocalizations.of(context)!.dragToReorder,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textGrey,
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: 28.h),

          /// REORDER LIST
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              decoration: BoxDecoration(
                color: const Color(0xFF0B2E4A),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.blueAccent.withOpacity(0.7),
                  width: 1,
                ),
              ),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),

                child: ReorderableListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: courseList.length,

                  /// DRAG ANIMATION
                  proxyDecorator: (child, index, animation) {
                    return Material(
                      color: Colors.transparent,
                      child: ScaleTransition(
                        scale: Tween<double>(
                          begin: 1,
                          end: 1.04,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },

                  /// REORDER + AUTO UPDATE + SAVE
                  onReorder: (oldIndex, newIndex) async {
                    // CRITICAL FIX: If moving an item down, the newIndex is off by 1
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }

                    // Update the state in Riverpod
                    await ref
                        .read(onboardingProvider1.notifier)
                        .reorderCourses(oldIndex, newIndex);
                  },

                  itemBuilder: (context, index) {
                    final course = courseList[index];
                    final isFirst = index == 0;

                    return Container(
                      key: ValueKey(course),
                      color: const Color(0xFF0B2E4A),

                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 22.w,
                              vertical: 18.h,
                            ),
                            child: Row(
                              children: [
                                /// INDEX
                                SizedBox(
                                  width: 42.w,
                                  child: Text(
                                    "${index + 1}.",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: isFirst
                                          ? Colors.amber
                                          : Colors.white60,
                                    ),
                                  ),
                                ),

                                SizedBox(width: 18.w),

                                /// COURSE NAME
                                Expanded(
                                  child: Text(
                                    course,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: isFirst
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      color: isFirst
                                          ? Colors.amber
                                          : Colors.white70,
                                    ),
                                  ),
                                ),

                                /// DRAG HANDLE
                                ReorderableDragStartListener(
                                  index: index,
                                  child: Icon(
                                    Icons.drag_indicator,
                                    color: isFirst
                                        ? Colors.amber.withOpacity(0.7)
                                        : Colors.white24,
                                    size: 24.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (index < courseList.length - 1)
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: AppColors.primary,
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}