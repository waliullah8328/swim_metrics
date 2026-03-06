class SignUpState {
  final String email;
  final String password;
  final bool isRemember;
  final bool isPasswordVisible;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const SignUpState({
    this.email = '',
    this.password = '',
    this.isRemember = false,
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  SignUpState copyWith({
    String? email,
    String? password,
    bool? isRemember,
    bool? isPasswordVisible,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      isRemember: isRemember ?? this.isRemember,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}