import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:swim_metrics/feature/auth/login_section/forget_password/riverpod/forget_password_state.dart';


class ForgetPasswordNotifier extends StateNotifier<ForgetPasswordState> {
  ForgetPasswordNotifier() : super(const ForgetPasswordState());



  void setEmail(String email) {
    state = state.copyWith(email: email);
  }



  /// Login logic
  Future<bool> forgetPassword({required context}) async {
    try {
      state = state.copyWith(
        isLoading: true,
        errorMessage: null,
        successMessage: null,
      );

      await Future.delayed(const Duration(seconds: 2));


      state = state.copyWith(
        isLoading: false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Send otp successful")),
      );


      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,

      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      return false;
    }
  }
}

final forgetPasswordProvider =
StateNotifierProvider<ForgetPasswordNotifier, ForgetPasswordState>((ref) {
  final notifier = ForgetPasswordNotifier();

  return notifier;
});