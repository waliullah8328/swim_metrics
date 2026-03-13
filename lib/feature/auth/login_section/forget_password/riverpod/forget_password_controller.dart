import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/app_snackbar.dart';
import 'package:swim_metrics/feature/auth/login_section/forget_password/riverpod/forget_password_state.dart';

import '../../../data/repository/authentication_repository.dart';


class ForgetPasswordNotifier extends StateNotifier<ForgetPasswordState> {
  ForgetPasswordNotifier() : super(const ForgetPasswordState());



  void setEmail(String email) {
    state = state.copyWith(email: email);
  }
  Future<bool> forgetPassword({required BuildContext context}) async {

    debugPrint(state.email);


    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await AuthenticationRepository().forgetPassword(
        email:state.email,

      );

      debugPrint("Forget Password response: $response");


      if (response['success'] == true) {
        state = state.copyWith(isLoading: false,errorMessage: null,successMessage: response['message']);
        AppSnackBar.showSuccess(context,response['message']);
        return true;
      } else {
        // Handle specific error messages from the API
        final error = response['error'] ?? response['message'];


        state = state.copyWith(isLoading: false,errorMessage: error);
        AppSnackBar.showError(context,error);


        return false;
      }
    } catch (e) {
      debugPrint("Forget Password exception: $e");

      state = state.copyWith(isLoading: false,errorMessage: e.toString());
      // Notify UI of exception
      AppSnackBar.showError(context,e.toString());
      return false;
    }


  }



  /// Login logic
///
///
  // Future<bool> forgetPassword({required context}) async {
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
  //     state = state.copyWith(
  //       isLoading: false,
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Send otp successful")),
  //     );
  //
  //
  //     return true;
  //   } catch (e) {
  //     state = state.copyWith(
  //       isLoading: false,
  //
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(e.toString())),
  //     );
  //     return false;
  //   }
  // }
}

final forgetPasswordProvider =
StateNotifierProvider<ForgetPasswordNotifier, ForgetPasswordState>((ref) {
  final notifier = ForgetPasswordNotifier();

  return notifier;
});