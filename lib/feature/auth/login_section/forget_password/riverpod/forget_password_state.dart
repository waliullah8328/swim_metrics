class ForgetPasswordState {
  final String email;

  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const ForgetPasswordState({
    this.email = '',

    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  ForgetPasswordState copyWith({
    String? email,

    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return ForgetPasswordState(
      email: email ?? this.email,

      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}