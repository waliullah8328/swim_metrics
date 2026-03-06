class SignUpState {
  final String name;
  final String confirmPassword;
  final String email;
  final String password;
  final bool isRemember;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const SignUpState({
    this.email = '',
    this.password = '',
    this.isRemember = false,
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
    bool? isTermsAndPrivacy,
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
      isRemember: isTermsAndPrivacy ?? this.isRemember,
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