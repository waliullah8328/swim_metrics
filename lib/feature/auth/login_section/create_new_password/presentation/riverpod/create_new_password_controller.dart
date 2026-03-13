
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:swim_metrics/config/route/routes_name.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/app_snackbar.dart';

import 'package:swim_metrics/feature/auth/sign_up_section/sign_up/presentation/riverpod/sign_up_state.dart';

import '../../../../data/repository/authentication_repository.dart';
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

  Future<bool> resetPassword({required BuildContext context,required String email, required String forgotPasswordToken}) async {




    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await AuthenticationRepository().resetPassword(
          email:email,
          forgotPasswordToken: forgotPasswordToken,
          newPassword: state.password

      );

      debugPrint("Reset password response: $response");


      if (response['success'] == true) {
        state = state.copyWith(isLoading: false,errorMessage: null,successMessage:response['message'] );



        AppSnackBar.showSuccess(context, response['message']);
        return true;
      } else {
        // Handle specific error messages from the API
        final error = response['error'] ?? response['message'];


        state = state.copyWith(isLoading: false,errorMessage: error);
        AppSnackBar.showError(context, error);


        return false;
      }
    } catch (e) {
      debugPrint("Reset password exception: $e");

      state = state.copyWith(isLoading: false,errorMessage: e.toString());
      // Notify UI of exception
      AppSnackBar.showError(context, e.toString());
      return false;
    }


  }





  /// Login logic
  // Future<bool> createNewPassword({required context}) async {
  //   try {
  //     state = state.copyWith(
  //       isLoading: true,
  //       errorMessage: null,
  //       successMessage: null,
  //     );
  //
  //     await Future.delayed(const Duration(seconds: 2));
  //
  //
  //     /// Save credentials if Remember Me is checked
  //
  //
  //     state = state.copyWith(
  //       isLoading: false,
  //     );
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("New Password Created Successful")),
  //     );
  //
  //     return true;
  //   } catch (e) {
  //     state = state.copyWith(
  //       isLoading: false,
  //       errorMessage: e.toString(),
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(e.toString())),
  //     );
  //     return false;
  //   }
  // }
}

final createNewPasswordProvider =
StateNotifierProvider<CreateNewPasswordNotifier, CreateNewPasswordState>((ref) {
  final notifier = CreateNewPasswordNotifier();

  return notifier;
});