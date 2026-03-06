class VerifyEmailState {
  final String code;

  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const VerifyEmailState({
    this.code = '',

    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  VerifyEmailState copyWith({

    String? code,

    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return VerifyEmailState(
      code: code ?? this.code,

      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}