
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:swim_metrics/feature/auth/sign_up_section/payment/data/model/payment_model.dart';
import 'package:swim_metrics/feature/auth/sign_up_section/payment/data/repository/payment_repository.dart';
import 'package:swim_metrics/feature/auth/sign_up_section/payment/river_pod/payment_state.dart';
import 'package:swim_metrics/feature/home_section/calculator_section/setting_section/settings/data/model/user_plan_model.dart';
import 'package:swim_metrics/feature/home_section/calculator_section/setting_section/settings/data/remote/user_plan_repository.dart';
import 'package:swim_metrics/feature/home_section/calculator_section/setting_section/settings/riverpod/user_plan_state.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/common/widgets/new_custon_widgets/app_snackbar.dart';



final userPlanRepositoryProvider = Provider<UserPlanRepository>((ref) {
  return UserPlanRepository();
});


final getUserPaymentProvider = FutureProvider.autoDispose<UserPlanModel>((ref) async {
  return await ref.watch(userPlanRepositoryProvider).getUserPlanPackage();
});

class UserPlanNotifier extends StateNotifier<UserPlanState> {

  UserPlanNotifier() : super(UserPlanState());



  Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webViewConfiguration: const WebViewConfiguration(
        enableJavaScript: true,
      ),
    )) {
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

final userPlanProvider =
StateNotifierProvider<UserPlanNotifier, UserPlanState>(
        (ref) => UserPlanNotifier());