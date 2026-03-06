class SignUpState {
  final String name;
  final String confirmPassword;
  final String email;
  final String password;
  final bool isTermsAndPolicy;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const SignUpState({
    this.email = '',
    this.password = '',
    this.isTermsAndPolicy = false,
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.name = '',
    this.confirmPassword = '',
  });

  SignUpState copyWith({
    String? email,
    String? password,
    bool? isTermsAndPolicy,
    bool? isPasswordVisible,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    String? name,
    String? confirmPassword,
    bool? isConfirmPasswordVisible,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      isTermsAndPolicy:
        isTermsAndPolicy?? this.isTermsAndPolicy,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
      name: name??this.name,
      confirmPassword: confirmPassword??this.confirmPassword,
      isConfirmPasswordVisible: isConfirmPasswordVisible??this.isConfirmPasswordVisible
    );
  }
}