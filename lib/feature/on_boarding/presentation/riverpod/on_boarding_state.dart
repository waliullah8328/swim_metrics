// onboarding_state.dart
class OnboardingState {
  final int currentPage;
  final String? selectedLanguage;
  final String? selectedCourse;
  final bool isPremiumSelected;

  const OnboardingState({
    this.currentPage = 0,
    this.selectedLanguage,
    this.selectedCourse,
    this.isPremiumSelected = true,
  });

  OnboardingState copyWith({
    int? currentPage,
    String? selectedLanguage,
    String? selectedCourse,
    bool? isPremiumSelected,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedCourse: selectedCourse ?? this.selectedCourse,
      isPremiumSelected: isPremiumSelected ?? this.isPremiumSelected,
    );
  }
}