// onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/feature/on_boarding/presentation/screens/widget/course_page_widget.dart';
import 'package:swim_metrics/feature/on_boarding/presentation/screens/widget/language_page_widget.dart';
import 'package:swim_metrics/feature/on_boarding/presentation/screens/widget/plan_page_widget.dart';
import 'package:swim_metrics/feature/on_boarding/presentation/screens/widget/tools_page_widget.dart';

import '../../../../core/common/widgets/new_custon_widgets/custom_screen_back_ground.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../riverpod/on_boarding_view_model.dart';


class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState
    extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Scaffold(

      body:  CustomScreenBackground(
        isSvg: false,
          backgroundImage: ImagePath.onBoardingBackGroundImage,
          child: SafeArea(
            child: Column(
            children: [
              SizedBox(height:40.h),
            
              /// Step Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                      (index) => Container(
                    margin:EdgeInsets.symmetric(horizontal: 4.w),
                    height: 6.h,
                    width: state.currentPage == index ? 80.w : 68.w,
                    decoration: BoxDecoration(
                      color: state.currentPage == index
                          ? AppColors.primary
                          : Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            
              SizedBox(height: 30.h),
            
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: notifier.changePage,
                  children: const [
                    LanguagePage(),
                    CoursePage(),
                    ToolsPage(),
                    PlanPage(),
                  ],
                ),
              ),
            
               SizedBox(height: 20.h),

              state.currentPage<3?GestureDetector(
                onTap: (){
                  _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn);

                },
                  child: SvgPicture.asset(IconPath.nextArrowIcon)):
            
              /// Next Button
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 24.w),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    if (state.currentPage < 3) {
                      _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    } else {
                      debugPrint("Complete Onboarding");
                    }
                  },
                  child: const Text("Next"),
                ),
              ),
            
               SizedBox(height: 30.h),
            ],
                    ),
          ),
      ),
    );
  }
}