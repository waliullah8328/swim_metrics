
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:swim_metrics/feature/auth/sign_up_section/payment/data/model/payment_model.dart';
import 'package:swim_metrics/feature/auth/sign_up_section/payment/data/repository/payment_repository.dart';
import 'package:swim_metrics/feature/auth/sign_up_section/payment/river_pod/payment_state.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/common/widgets/new_custon_widgets/app_snackbar.dart';


final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository();
});


final getPaymentProvider = FutureProvider.autoDispose<PaymentModel>((ref) async {
  return await ref.watch(paymentRepositoryProvider).getSubscriptionPackage();
});

class PaymentNotifier extends StateNotifier<PaymentState> {

  PaymentNotifier() : super(PaymentState());






  //
  // Future<bool> saveProfile({required BuildContext context}) async {
  //   state = state.copyWith(isLoading: true);
  //
  //   try {
  //     final response = await ProfileRepository().updateProfile(
  //         email: state.email,
  //         name: state.name,
  //         phoneNumber: state.phone,
  //         profilePicturePath: state.profileImage!.path.toString()
  //     );
  //
  //     if (response['success'] == true) {
  //       state = state.copyWith(isLoading: false,  );
  //       AppSnackBar.showSuccess(context, response['message']);
  //
  //       return true;
  //     } else {
  //       final error = response['error'] ?? response['message'];
  //       state = state.copyWith(isLoading: false, );
  //       AppSnackBar.showError(context, error);
  //
  //       return false;
  //     }
  //   } catch (e) {
  //     state = state.copyWith(isLoading: false,);
  //     AppSnackBar.showError(context, e.toString());
  //     return false;
  //   }
  // }
  //
  //
  Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
  Future<bool> applyCupon({required BuildContext context,required String code,required String token}) async {



    state = state.copyWith(cuponLoading: true, );

    try {
      final response = await PaymentRepository().applyCupon(
          code: code, token:token,
      );

      debugPrint("Signup response: $response");


      if (response['success'] == true) {
        state = state.copyWith(cuponLoading: false,);

        AppSnackBar.showSuccess(context,  response['message']);
        final price = response['price'];
        debugPrint ("Price $price");





        return true;
      } else {
        // Handle specific error messages from the API
        final error = response['error'] ?? response['message'];
        AppSnackBar.showError(context,  error);


        state = state.copyWith(cuponLoading: false);

        // Notify UI of error
        return false;
      }
    } catch (e) {
      debugPrint("Signup exception: $e");
      AppSnackBar.showError(context,  e.toString());

      state = state.copyWith(cuponLoading:  false);
      // Notify UI of exception
      return false;
    }


  }
  Future<bool> paymentFunction({required BuildContext context,required String token}) async {



    state = state.copyWith(paymentLoading: true, );

    try {
      final response = await PaymentRepository().paymentFunction(
          token:token,
      );

      debugPrint("Signup response: $response");


      if (response['success'] == true) {
        state = state.copyWith(paymentLoading: false,);


        final price = response['url'];
        debugPrint ("Url $price");
        debugPrint("Url $price");

        await openUrl(price);





        return true;
      } else {
        // Handle specific error messages from the API
        final error = response['error'] ?? response['message'];
        AppSnackBar.showError(context,  error);


        state = state.copyWith(paymentLoading: false);

        // Notify UI of error
        return false;
      }
    } catch (e) {
      debugPrint("Signup exception: $e");
      AppSnackBar.showError(context,  e.toString());

      state = state.copyWith(paymentLoading:  false);
      // Notify UI of exception
      return false;
    }


  }



}

final paymentProvider =
StateNotifierProvider<PaymentNotifier, PaymentState>(
        (ref) => PaymentNotifier());