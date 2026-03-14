import 'dart:io';

class HelpSupportState {
  final File? screenshot;

  final String email;
  final String problemOrSuggestion;
  final String subjectOrProblem;
  final bool isLoading;


  HelpSupportState({
    this.screenshot ,
    this.email = '',
    this.subjectOrProblem = '',
    this.problemOrSuggestion= '',
    this.isLoading =false,
  });

  HelpSupportState copyWith({
    File? screenshot,
    String? email,
    String? subjectOrProblem,
    String? problemOrSuggestion,
    bool? isLoading,
  }) {
    return HelpSupportState(
      screenshot: screenshot ?? this.screenshot,
      email: email?? this.email,
      subjectOrProblem: subjectOrProblem??this.subjectOrProblem,
      problemOrSuggestion: problemOrSuggestion??this.problemOrSuggestion,
      isLoading: isLoading?? this.isLoading
    );
  }
}