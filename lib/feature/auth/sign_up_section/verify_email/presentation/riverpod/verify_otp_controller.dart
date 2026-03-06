
import 'package:flutter_riverpod/legacy.dart';

import 'package:swim_metrics/feature/auth/sign_up_section/verify_email/presentation/riverpod/verify_email_state.dart';


class VerifyEmailNotifier extends StateNotifier<VerifyEmailState> {
  VerifyEmailNotifier() : super(const VerifyEmailState()) ;



  void setCode(String code) {
    state = state.copyWith(code: code);
  }



  /// Login logic
  Future<bool> login() async {
    try {
      state = state.copyWith(
        isLoading: true,
        errorMessage: null,
        successMessage: null,
      );

      await Future.delayed(const Duration(seconds: 2));

      if (state.code.isEmpty) {
        throw Exception("Code is required");
      }



      state = state.copyWith(
        isLoading: false,
        successMessage: "Login Successful",
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}

final verifyEmailProvider =
StateNotifierProvider<VerifyEmailNotifier, VerifyEmailState>((ref) {
  final notifier = VerifyEmailNotifier();

  return notifier;
});