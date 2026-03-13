
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:swim_metrics/config/route/routes_name.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/app_snackbar.dart';

import 'package:swim_metrics/feature/auth/sign_up_section/sign_up/presentation/riverpod/sign_up_state.dart';

import '../../../../data/repository/authentication_repository.dart';


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

  Future<bool> createAccount({required BuildContext context}) async {

    debugPrint(state.email);
    debugPrint(state.password);

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await AuthenticationRepository().signup(
          email:state.email,
          password: state.password,
        confirmPassword: state.confirmPassword,
        name: state.name
      );

      debugPrint("Signup response: $response");


      if (response['success'] == true) {
        state = state.copyWith(isLoading: false,errorMessage: null,successMessage: response['message']);

        AppSnackBar.showSuccess(context,  response['message']);





        return true;
      } else {
        // Handle specific error messages from the API
        final error = response['error'] ?? response['message'];
        AppSnackBar.showSuccess(context,  error);


        state = state.copyWith(isLoading: false,errorMessage: error);

        // Notify UI of error
        return false;
      }
    } catch (e) {
      debugPrint("Signup exception: $e");
      AppSnackBar.showSuccess(context,  e.toString());

      state = state.copyWith(isLoading: false,errorMessage: e.toString());
      // Notify UI of exception
      return false;
    }


  }




}

final signUpProvider =
StateNotifierProvider<SignUpNotifier, SignUpState>((ref) {
  final notifier = SignUpNotifier();

  return notifier;
});