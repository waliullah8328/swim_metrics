class LoginState {
  final String email;
  final String password;
  final bool isRemember;
  final bool isPasswordVisible;
  final bool isLoading;
  final bool isLoadingGoogle;
  final bool isLoadingApple;
  final String? errorMessage;
  final String? successMessage;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isRemember = false,
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.isLoadingGoogle = false,
    this.isLoadingApple = false,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? isRemember,
    bool? isPasswordVisible,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    bool? isLoadingGoogle,
    bool? isLoadingApple,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isRemember: isRemember ?? this.isRemember,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage?? this.errorMessage,
      successMessage: successMessage?? this.successMessage,
      isLoadingApple: isLoadingApple??this.isLoadingApple,
      isLoadingGoogle: isLoadingGoogle?? this.isLoadingGoogle
    );
  }
}