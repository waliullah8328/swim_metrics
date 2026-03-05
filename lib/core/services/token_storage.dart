import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userRoleKey = 'user_first_name';
  static const String _userGoalKey = 'user_goal';
  static const String _isSeeOnboardingKey = 'isSeeOnboarding';

  // Remember email and Password
  static const String _savedEmailKey = 'saved_email';
  static const String _savedPasswordKey = 'saved_password';
  static const String _rememberMeKey = 'remember_me';


  // Save login credentials
  static Future<void> saveUserCredentials({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_rememberMeKey, rememberMe);

    if (rememberMe) {
      await prefs.setString(_savedEmailKey, email);
      await prefs.setString(_savedPasswordKey, password);
    } else {
      await prefs.remove(_savedEmailKey);
      await prefs.remove(_savedPasswordKey);
    }
  }

// Load saved login credentials
  static Future<Map<String, dynamic>> getUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "rememberMe": prefs.getBool(_rememberMeKey) ?? false,
      "email": prefs.getString(_savedEmailKey),
      "password": prefs.getString(_savedPasswordKey),
    };
  }

  static SharedPreferences? _preferences;
  static String? _token;
  static String? _role;

  // Save tokens
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  // Save user data
  static Future<void> saveUserData({
    required int userId,
    required String email,
    required String userRole,
    required String userGoal,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userRoleKey, userRole);
    await prefs.setString(_userGoalKey, userGoal);
  }

  // Get access token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // SAVE goal
  static Future<void> setUserGoal(String goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userGoalKey, goal);
  }

  // Get user goal
  static Future<String?> geUserGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userGoalKey);
  }


  // Get refresh token
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  // Get user data
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(_userIdKey);
    final email = prefs.getString(_userEmailKey);
    final firstName = prefs.getString(_userRoleKey);

    if (userId != null && email != null && firstName != null) {
      return {
        'id': userId,
        'email': email,
        'first_name': firstName,
      };
    }
    return null;
  }

  /// Initialize SharedPreferences (call during app startup)
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    _token = _preferences?.getString(_accessTokenKey);
    _role = _preferences?.getString(_userRoleKey);
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

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final accessToken = await getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }

  // Clear all stored data
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userRoleKey);
    await prefs.remove(_userGoalKey);
  }

  // Update access token (for token refresh)
  static Future<void> updateAccessToken(String newAccessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, newAccessToken);
  }

  static String? get token => _token;
  static String? get role => _role;
}