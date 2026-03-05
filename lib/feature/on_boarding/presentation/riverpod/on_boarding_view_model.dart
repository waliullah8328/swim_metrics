// onboarding_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'on_boarding_state.dart';


final onboardingProvider =
StateNotifierProvider<OnboardingController, OnboardingState>(
        (ref) => OnboardingController());

class OnboardingController extends StateNotifier<OnboardingState> {
  OnboardingController() : super(const OnboardingState());

  void changePage(int index) {
    state = state.copyWith(currentPage: index);
  }

  void selectLanguage(String language) {
    state = state.copyWith(selectedLanguage: language);
  }

  void selectCourse(String course) {
    state = state.copyWith(selectedCourse: course);
  }

  void selectPlan(bool premium) {
    state = state.copyWith(isPremiumSelected: premium);
  }
}