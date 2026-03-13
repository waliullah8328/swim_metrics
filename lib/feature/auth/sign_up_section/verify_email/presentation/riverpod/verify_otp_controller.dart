
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/app_snackbar.dart';

import 'package:swim_metrics/feature/auth/sign_up_section/verify_email/presentation/riverpod/verify_email_state.dart';

import '../../../../../../config/route/routes_name.dart';
import '../../../../data/repository/authentication_repository.dart';


class VerifyEmailNotifier extends StateNotifier<VerifyEmailState> {
  VerifyEmailNotifier() : super(const VerifyEmailState()) ;



  void setCode(String code) {
    state = state.copyWith(code: code);
  }


  Future<bool> verifyOtp({required BuildContext context,required String email}) async {




    state = state.copyWith(isLoading: true,);

    try {
      final response = await AuthenticationRepository().otpVerify(
          email:email,
          otp: state.code.toString()

      );

      debugPrint("Verify Otp response: $response");


      if (response['success'] == true) {
        state = state.copyWith(isLoading: false );
        AppSnackBar.showSuccess(context, response['message']);



        //notifyListeners(); // Notify UI of successful signup
        return true;
      } else {
        // Handle specific error messages from the API
        final error = response['error'] ?? response['message'];



        state = state.copyWith(isLoading: false,errorMessage: error);
        AppSnackBar.showError(context, response['error']);


        return false;
      }
    } catch (e) {
      debugPrint("Verify Otp exception: $e");

      state = state.copyWith(isLoading: false,errorMessage: e.toString());
      AppSnackBar.showError(context, e.toString());
      // Notify UI of exception
      return false;
    }


  }


  Future<bool> verifyForgetOtp({required BuildContext context,required String email,required String code,required String isSignUp}) async {




    state = state.copyWith(isLoading: true,);

    try {
      final response = await AuthenticationRepository().forgetOtpVerify(
          email:email,
          otp: state.code.toString()

      );

      debugPrint("Verify Otp response: $response");


      if (response['success'] == true) {
        state = state.copyWith(isLoading: false );
        AppSnackBar.showSuccess(context, response['message']);

        context.go("${RouteNames.createNewPasswordScreen}/$email/$code/$isSignUp/${response["forgetPasswordToken"]}");




        return true;
      } else {
        // Handle specific error messages from the API
        final error = response['error'] ?? response['message'];



        state = state.copyWith(isLoading: false,errorMessage: error);
        AppSnackBar.showError(context, response['error']);


        return false;
      }
    } catch (e) {
      debugPrint("Verify Otp exception: $e");

      state = state.copyWith(isLoading: false,errorMessage: e.toString());
      AppSnackBar.showError(context, e.toString());
      // Notify UI of exception
      return false;
    }


  }



  // /// Login logic
  // Future<bool> verifyOtp() async {
  //   try {
  //     state = state.copyWith(
  //       isLoading: true,
  //       errorMessage: null,
  //       successMessage: null,
  //     );
  //
  //     await Future.delayed(const Duration(seconds: 2));
  //
  //     if (state.code.isEmpty) {
  //       throw Exception("Code is required");
  //     }
  //
  //
  //
  //     state = state.copyWith(
  //       isLoading: false,
  //       successMessage: "Verification Successful",
  //     );
  //     return true;
  //   } catch (e) {
  //     state = state.copyWith(
  //       isLoading: false,
  //       errorMessage: e.toString(),
  //     );
  //     return false;
  //   }
  // }
}

final verifyEmailProvider =
StateNotifierProvider<VerifyEmailNotifier, VerifyEmailState>((ref) {
  final notifier = VerifyEmailNotifier();

  return notifier;
});