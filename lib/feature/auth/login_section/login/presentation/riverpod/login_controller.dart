import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  /// Login logic
  Future<bool> login() async {
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
      await saveCredentialsIfRemembered();

      state = state.copyWith(
        isLoading: false,
        successMessage: "Login Successful",
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}

final loginProvider =
StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  final notifier = LoginNotifier();
  notifier.loadSavedLogin();
  return notifier;
});