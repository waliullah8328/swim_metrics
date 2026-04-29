import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/common/widgets/custom_text.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/app_sizer.dart';
import '../../../../../core/utils/constants/icon_path.dart';
import '../../../../../l10n/app_localizations.dart';

/// ═══════════════════════════════════════════════════════════
/// SHARED PREFERENCE HELPER
/// ═══════════════════════════════════════════════════════════
class CourseOrderStorage {
  static const String _key = 'course_order';

  static Future<void> saveCourseOrder(List<String> courses) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, courses);
  }

  static Future<List<String>> loadCourseOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_key);
    return saved ?? ["SCY", "SCM", "LCM"];
  }
}

/// ═══════════════════════════════════════════════════════════
/// STATE
/// ═══════════════════════════════════════════════════════════
class OnboardingState {
  final List<String> availableCourses;
  final String selectedCourse;

  OnboardingState({
    required this.availableCourses,
    required this.selectedCourse,
  });

  OnboardingState copyWith({
    List<String>? availableCourses,
    String? selectedCourse,
  }) {
    return OnboardingState(
      availableCourses: availableCourses ?? this.availableCourses,
      selectedCourse: selectedCourse ?? this.selectedCourse,
    );
  }
}

/// ═══════════════════════════════════════════════════════════
/// VIEW MODEL
/// ═══════════════════════════════════════════════════════════
class OnboardingViewModel extends StateNotifier<OnboardingState> {
  OnboardingViewModel()
      : super(
    OnboardingState(
      availableCourses: ["SCY", "SCM", "LCM"],
      selectedCourse: "SCY",
    ),
  ) {
    _loadSavedOrder();
  }

  Future<void> _loadSavedOrder() async {
    final saved = await CourseOrderStorage.loadCourseOrder();

    // Only update if there is actually saved data
    if (saved.isNotEmpty) {
      state = state.copyWith(
        availableCourses: saved,
        selectedCourse: saved.first,
      );
    }
  }

  // Helper method to persist the data
  Future<void> _saveToDatabase(List<String> list) async {
    await CourseOrderStorage.saveCourseOrder(list);
  }

  Future<void> reorderCourses(int oldIndex, int newIndex) async {
    // --- CRITICAL FIX FOR DOWNWARD DRAG ---
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    // 1. Create a completely new list copy (ensures Riverpod detects change)
    final List<String> updatedList = List.from(state.availableCourses);

    // 2. Perform the swap
    final String movedItem = updatedList.removeAt(oldIndex);
    updatedList.insert(newIndex, movedItem);

    // 3. Update the state
    // This triggers the build method to refresh the 1. 2. 3. numbers
    state = state.copyWith(
      availableCourses: updatedList,
      // Optional: Update selectedCourse if the top item changed
      selectedCourse: updatedList.first,
    );

    // 4. PERSISTENCE
    await _saveToDatabase(updatedList);
  }
}

/// ═══════════════════════════════════════════════════════════
/// PROVIDER
/// ═══════════════════════════════════════════════════════════
final onboardingProvider1 =
StateNotifierProvider<OnboardingViewModel, OnboardingState>((ref) {
  return OnboardingViewModel();
});

/// ═══════════════════════════════════════════════════════════
/// COURSE PAGE
/// ═══════════════════════════════════════════════════════════
class CoursePage extends ConsumerWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider1);
    final courseList = state.availableCourses;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 32.w,
            right: 32.w,
            top: 120.h,
          ),
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
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              CustomText(
                text: AppLocalizations.of(context)!.dragToReorder,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textGrey,
              ),
            ],
          ),
        ),

        SizedBox(height: 32.h),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 30.w),
          decoration: BoxDecoration(
            color: const Color(0xFF0B2E4A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.blueAccent.withOpacity(0.8),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ReorderableListView.builder(
              shrinkWrap: true,
              itemCount: courseList.length,

              onReorder: (oldIndex, newIndex) async {
                await ref
                    .read(onboardingProvider1.notifier)
                    .reorderCourses(oldIndex, newIndex);
              },

              proxyDecorator: (child, index, animation) {
                return Material(
                  color: Colors.transparent,
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 1,
                      end: 1.03,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },

              itemBuilder: (context, index) {
                final course = courseList[index];
                final isFirst = index == 0;

                return Column(
                  key: ValueKey(course),
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 28.w,
                        vertical: 20.h,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 40.w,
                            child: Text(
                              "${index + 1}.",
                              style: TextStyle(
                                color: isFirst
                                    ? Colors.amber
                                    : Colors.white60,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          SizedBox(width: 60.w),

                          Expanded(
                            child: Text(
                              course,
                              style: TextStyle(
                                color: isFirst
                                    ? Colors.amber
                                    : Colors.white60,
                                fontSize: 16.sp,
                                fontWeight: isFirst
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                          ),

                          ReorderableDragStartListener(
                            index: index,
                            child: Icon(
                              Icons.drag_indicator,
                              color: isFirst
                                  ? Colors.amber.withOpacity(0.6)
                                  : Colors.white24,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (index < courseList.length - 1)
                      Divider(
                        height: 1,
                        color: AppColors.primary,
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}