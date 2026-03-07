class CreateNewPasswordState {

  final String confirmPassword;
  final String password;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const CreateNewPasswordState({

    this.password = '',

    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,

    this.confirmPassword = '',
  });

  CreateNewPasswordState copyWith({

    String? password,

    bool? isPasswordVisible,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,

    String? confirmPassword,
    bool? isConfirmPasswordVisible,
  }) {
    return CreateNewPasswordState(

      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
      confirmPassword: confirmPassword??this.confirmPassword,
      isConfirmPasswordVisible: isConfirmPasswordVisible??this.isConfirmPasswordVisible
    );
  }
}