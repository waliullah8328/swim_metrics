import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/app_snackbar.dart';
import 'package:swim_metrics/core/services/token_storage.dart';
import '../../../../../../config/route/routes_name.dart';
import '../../../../data/repository/authentication_repository.dart';
import 'login_state.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(const LoginState()) {
    loadSavedLogin();
  }

  final emailKey = "saved_email";
  final passwordKey = "saved_password";
  final rememberKey = "remember_me";

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

  /// Toggle Remember Me
  Future<void> toggleRemember(bool value) async {
    state = state.copyWith(isRemember: value);

    final prefs = await SharedPreferences.getInstance();

    if (value) {
      // Optional: Save immediately or after login
      await prefs.setString(emailKey, state.email);
      await prefs.setString(passwordKey, state.password);
      await prefs.setBool(rememberKey, true);
    } else {
      // 🔹 Remove only local storage, keep state.email/password
      await prefs.remove(emailKey);
      await prefs.remove(passwordKey);
      await prefs.setBool(rememberKey, false);
    }
  }

  /// Load saved credentials on app start
  Future<void> loadSavedLogin() async {
    final prefs = await SharedPreferences.getInstance();

    final savedEmail = prefs.getString(emailKey) ?? '';
    final savedPassword = prefs.getString(passwordKey) ?? '';
    final remember = prefs.getBool(rememberKey) ?? false;

    state = state.copyWith(
      email: savedEmail,
      password: savedPassword,
      isRemember: remember,
    );
  }

  /// Save credentials if Remember Me is checked after login
  Future<void> saveCredentialsIfRemembered() async {
    if (!state.isRemember) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(emailKey, state.email);
    await prefs.setString(passwordKey, state.password);
    await prefs.setBool(rememberKey, true);
  }

  Future<bool> login({required BuildContext context}) async {

    debugPrint(state.email);
    debugPrint(state.password);

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await AuthenticationRepository().login(
          email:state.email,
          password: state.password
      );

      debugPrint("Login response: $response");


      if (response['success'] == true) {
        state = state.copyWith(isLoading: false,errorMessage: null);
        final prefs = await SharedPreferences.getInstance();

        state = state.copyWith(isLoading: false,errorMessage: null,successMessage: response['message']);
        await saveCredentialsIfRemembered();
        final tokens = response['tokens'];
        debugPrint("Get Access Token : $tokens");
        final refreshToken = response['refreshToken'];
        debugPrint("Get Refresh Token : $refreshToken");
        final isPayment = response['isPayment'];
        debugPrint("Get Is Payment : $isPayment");

        final planEndDate = response['plan_end_date'];
        debugPrint("Get Is Plan End Date : ${planEndDate.toString() }");






        if(isPayment){
          await TokenStorage.saveTokens(accessToken: tokens, refreshToken: refreshToken);
          await TokenStorage.setPlanEndDate(
            DateTime.tryParse(planEndDate) ?? DateTime.now(),
          );

          final planDate = await TokenStorage.getPlanEndDate();


          debugPrint("Get Saved Plan End Date : $planDate  ");

          debugPrint(await TokenStorage.getAccessToken());
          await TokenStorage.setLogin(true);
          AppSnackBar.showSuccess(context, response['message']);
          context.go(RouteNames.homeNavBarScreen);
        }
        else{
          context.push("${RouteNames.paymentScreen}/$tokens");
        }






        // Register FCM token after successful sign in
        try {
          // await FCMService().registerFCMToken();
          debugPrint("FCM token registered successfully after sign in");
        } catch (fcmError) {
          debugPrint("FCM token registration failed after sign in: $fcmError");
          // Don't fail the sign in process if FCM registration fails
        }


        return true;
      } else {
        // Handle specific error messages from the API
        final error = response['error'] ?? response['message'];
        AppSnackBar.showError(context, error );


        state = state.copyWith(isLoading: false,errorMessage: error);


        // Notify UI of error
        return false;
      }
    } catch (e) {
      debugPrint("Signup exception: $e");
      AppSnackBar.showError(context, e.toString() );

      state = state.copyWith(isLoading: false,errorMessage: e.toString());

      // Notify UI of exception
      return false;
    }


  }

  /// -----------------------
  /// GOOGLE LOGIN
  /// -----------------------
  Future<bool> loginWithGoogle(BuildContext context) async {
    state = state.copyWith(
      isLoadingGoogle: true,
      errorMessage: '',
      successMessage: '',
    );

    try {
      final googleSignIn = GoogleSignIn(scopes: ['email']);

      // Force account chooser
      await googleSignIn.signOut();

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        state = state.copyWith(
          isLoadingGoogle: false,
          errorMessage: 'Google sign-in cancelled',
        );
        return false;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // 🔥 Firebase Login
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception("Firebase user is null");
      }

      // 🔥 Firebase ID Token (SEND THIS TO BACKEND)
      final firebaseIdToken = await firebaseUser.getIdToken();

      debugPrint("Firebase ID Token: $firebaseIdToken");

      // 🔥 Backend Login
      final response = await AuthenticationRepository().signInWithGoogle(
       idToken: firebaseIdToken!,
      );

      if (response['success'] != true) {
        // rollback Firebase session if backend fails
        await FirebaseAuth.instance.signOut();
        await googleSignIn.signOut();

        state = state.copyWith(
          isLoadingGoogle: false,
          errorMessage: response['error'] ?? 'Google login failed',
        );
        return false;
      }

      state = state.copyWith(
        isLoadingGoogle: false,
        successMessage: 'Google login successful',
      );

      debugPrint("All response : ${response['data']}");
      final tokens = response['tokens'];
      debugPrint("Get Access Token : $tokens");
      final refreshToken = response['refreshToken'];
      debugPrint("Get Refresh Token : $refreshToken");
      final isPayment = response['isPayment'];
      debugPrint("Get Is Payment : $isPayment");
      final planEndDate = response['plan_end_date'];
      debugPrint("Get Is Plan End Date : ${planEndDate.toString() }");




      if(isPayment){
        await TokenStorage.saveTokens(accessToken: tokens, refreshToken: refreshToken);

        await TokenStorage.setPlanEndDate(
          DateTime.tryParse(planEndDate) ?? DateTime.now(),
        );

        final planDate = await TokenStorage.getPlanEndDate();


        debugPrint("Get Saved Plan End Date : $planDate  ");

        debugPrint(await TokenStorage.getAccessToken());
        await TokenStorage.setLogin(true);
        AppSnackBar.showSuccess(context, response['message']);
        context.go(RouteNames.homeNavBarScreen);
      }
      else{
        context.push("${RouteNames.paymentScreen}/$tokens");
      }



      return true;
    } catch (e, s) {
      debugPrint('Google login error: $e');
      debugPrintStack(stackTrace: s);

      await FirebaseAuth.instance.signOut();

      state = state.copyWith(
       isLoadingGoogle: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
      return false;
    }
  }



  /// -----------------------
  /// APPLE LOGIN
  /// -----------------------
  Future<bool> loginWithApple(BuildContext context) async {
    state = state.copyWith(
      isLoadingApple: true,
      errorMessage: '',
      successMessage: '',
    );

    try {
      final rawNonce = _generateNonce();
      final nonce = _sha256(rawNonce);

      // 🍎 Apple Sign In
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // 🔐 Firebase OAuth
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final userCred =
      await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      final fullName =
          userCred.user?.displayName ;

      // 🌐 Backend login (IMPORTANT: send Apple identityToken)
      final response = await AuthenticationRepository().signInWithApple(
        idToken:  appleCredential.identityToken!,
      );

      if (response['success'] != true) {
        // 🔴 rollback Firebase
        await FirebaseAuth.instance.signOut();

        state = state.copyWith(
          isLoadingApple: false,
          errorMessage: response['error'] ?? 'Apple login failed',
        );
        return false;
      }

      state = state.copyWith(isLoadingApple: false);

      debugPrint("All response : ${response['data']}");
      final tokens = response['tokens'];
      debugPrint("Get Access Token : $tokens");
      final refreshToken = response['refreshToken'];
      debugPrint("Get Refresh Token : $refreshToken");
      final isPayment = response['isPayment'];
      debugPrint("Get Is Payment : $isPayment");
      final planEndDate = response['plan_end_date'];
      debugPrint("Get Is Plan End Date : ${planEndDate.toString() }");




      if(isPayment){
        await TokenStorage.saveTokens(accessToken: tokens, refreshToken: refreshToken);

        await TokenStorage.setPlanEndDate(
          DateTime.tryParse(planEndDate) ?? DateTime.now(),
        );

        final planDate = await TokenStorage.getPlanEndDate();


        debugPrint("Get Saved Plan End Date : $planDate  ");

        debugPrint(await TokenStorage.getAccessToken());
        await TokenStorage.setLogin(true);
        AppSnackBar.showSuccess(context, response['message']);
        context.go(RouteNames.homeNavBarScreen);
      }
      else{
        context.push("${RouteNames.paymentScreen}/$tokens");
      }

      return true;
    } catch (e, s) {
      debugPrint('Apple login error: $e');
      debugPrintStack(stackTrace: s);

      await FirebaseAuth.instance.signOut();

      state = state.copyWith(
        isLoadingApple: false,
        errorMessage: 'Apple login failed. Please try again.',
      );
      return false;
    }
  }




  /// -----------------------
  /// HELPERS (APPLE)
  /// -----------------------
  String _generateNonce([int length = 32]) {
    const chars =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => chars[random.nextInt(chars.length)])
        .join();
  }

  String _sha256(String input) {
    return sha256.convert(utf8.encode(input)).toString();
  }
}

final loginProvider =
StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  final notifier = LoginNotifier();
  notifier.loadSavedLogin();
  return notifier;
});