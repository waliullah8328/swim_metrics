import 'dart:developer';


import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _tokenKey = 'token';
  static const String _roleKey = 'role';
  static const String _isSeeOnboardingKey = 'isSeeOnboarding';

  // Remember me keys
  static const String _emailKey = 'remember_email';
  static const String _passwordKey = 'remember_password';

  static SharedPreferences? _preferences;

  static String? _token;
  static String? _role;

  /// Initialize SharedPreferences (call during app startup)
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    _token = _preferences?.getString(_tokenKey);
    _role = _preferences?.getString(_roleKey);
  }

  static bool hasToken() {
    return _preferences?.containsKey(_tokenKey) ?? false;
  }

  static Future<void> saveToken(String token, String role) async {
    try {
      if (_preferences == null) {
        log("SharedPreferences not initialized, calling init()");
        await init();
      }
      await _preferences!.setString(_tokenKey, token);
      await _preferences!.setString(_roleKey, role);
      _token = token;
      _role = role;
      log("✅ Token and Role saved");
    } catch (e) {
      log('❌ Error saving token and role: $e');
    }
  }

  static Future<void> setOnboardingSeen(bool seen) async {
    try {
      if (_preferences == null) await init();
      await _preferences!.setBool(_isSeeOnboardingKey, seen);
      log('Onboarding flag saved: $seen');
    } catch (e) {
      log('Error saving onboarding flag: $e');
    }
  }

  static bool hasSeenOnboarding() {
    return _preferences?.getBool(_isSeeOnboardingKey) ?? false;
  }

  static Future<void> logoutUser(context) async {
    try {
      if (_preferences == null) await init();
      await _preferences!.remove(_tokenKey);
      await _preferences!.remove(_roleKey);
      _token = null;
      _role = null;
      log("+++++ Logout complete");
      await goToLogin(context);
    } catch (e) {
      log('Error during logout: $e');
    }
  }
  /// ✅ Helper to check initialization
  static Future<void> _ensureInitialized() async {
    if (_preferences == null) {
      await init();
    }
  }

  static Future<void> saveCredentials(String email, String password) async {
    await _ensureInitialized();
    await _preferences!.setString(_emailKey, email);
    await _preferences!.setString(_passwordKey, password);
  }

  static Future<void> clearCredentials() async {
    await _ensureInitialized();
    await _preferences!.remove(_emailKey);
    await _preferences!.remove(_passwordKey);
  }

  static Future<void> goToLogin(context) async {
    // Example navigation logic here
     //Get.offAll(() => OnBoardingScreen());
    //GoRouter.of(context).go(RouteNames.loginScreen);
   // Navigator.pushNamedAndRemoveUntil(context, RouteNames.loginScreen, (route)=>false);
  }

  static Future<String?> get rememberedEmail async {
    await _ensureInitialized();
    return _preferences!.getString(_emailKey);
  }

  static Future<String?> get rememberedPassword async {
    await _ensureInitialized();
    return _preferences!.getString(_passwordKey);
  }

  static String? get token => _token;
  static String? get role => _role;
}
