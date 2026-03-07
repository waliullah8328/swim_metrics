
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:swim_metrics/config/route/routes_name.dart';

import 'package:swim_metrics/feature/auth/sign_up_section/sign_up/presentation/riverpod/sign_up_state.dart';

import 'create_new_password_state.dart';


class CreateNewPasswordNotifier extends StateNotifier<CreateNewPasswordState > {
  CreateNewPasswordNotifier() : super(const CreateNewPasswordState ());



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





  /// Login logic
  Future<bool> createNewPassword({required context}) async {
    try {
      state = state.copyWith(
        isLoading: true,
        errorMessage: null,
        successMessage: null,
      );

      await Future.delayed(const Duration(seconds: 2));


      /// Save credentials if Remember Me is checked


      state = state.copyWith(
        isLoading: false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("New Password Created Successful")),
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

final createNewPasswordProvider =
StateNotifierProvider<CreateNewPasswordNotifier, CreateNewPasswordState>((ref) {
  final notifier = CreateNewPasswordNotifier();

  return notifier;
});