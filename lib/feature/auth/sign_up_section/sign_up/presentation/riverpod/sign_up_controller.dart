
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:swim_metrics/config/route/routes_name.dart';

import 'package:swim_metrics/feature/auth/sign_up_section/sign_up/presentation/riverpod/sign_up_state.dart';


class SignUpNotifier extends StateNotifier<SignUpState> {
  SignUpNotifier() : super(const SignUpState());

  void setName(String name) {
    state = state.copyWith(name: name);
  }


  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(
      isPasswordVisible: !state.isPasswordVisible,
    );
  }

  void setConfirmPassword(String confirmPassword) {
    state = state.copyWith(confirmPassword: confirmPassword);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
    );
  }

  /// Toggle Remember Me
  Future<void> toggleTermAndPrivacy(bool value) async {
    state = state.copyWith(isTermsAndPolicy: value);

  }



  /// Login logic
  Future<bool> signUp({required context}) async {
    try {
      state = state.copyWith(
        isLoading: true,
        errorMessage: null,
        successMessage: null,
      );

      await Future.delayed(const Duration(seconds: 2));

      if (state.email.isEmpty || state.password.isEmpty) {
        throw Exception("Email and password required");
      }

      /// Save credentials if Remember Me is checked


      state = state.copyWith(
        isLoading: false,
        successMessage: "Sign Up Successful",
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign Up Successful")),
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      return false;
    }
  }
}

final signUpProvider =
StateNotifierProvider<SignUpNotifier, SignUpState>((ref) {
  final notifier = SignUpNotifier();

  return notifier;
});