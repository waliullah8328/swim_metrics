import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  // ================= KEYS =================
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userFirstNameKey = 'user_first_name';
  static const String _userGoalKey = 'user_goal';
  static const String _planEndDateKey = 'plan_end_date';

  static const String _isSeeOnboardingKey = 'isSeeOnboarding';
  static const String _isLoginKey = 'isLogin';

  // Remember email & password
  static const String _savedEmailKey = 'saved_email';
  static const String _savedPasswordKey = 'saved_password';
  static const String _rememberMeKey = 'remember_me';

  static SharedPreferences? _preferences;
  static String? _token;
  static String? _firstName;

  // ================= INIT =================
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    _token = _preferences?.getString(_accessTokenKey);
    _firstName = _preferences?.getString(_userFirstNameKey);
  }

  // ================= SAVE LOGIN CREDENTIALS =================
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

  static Future<Map<String, dynamic>> getUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "rememberMe": prefs.getBool(_rememberMeKey) ?? false,
      "email": prefs.getString(_savedEmailKey),
      "password": prefs.getString(_savedPasswordKey),
    };
  }

  // ================= TOKENS =================
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    String? planEndDate,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);

    if (planEndDate != null) {
      await prefs.setString(_planEndDateKey, planEndDate);
    }

    // update cached token
    _token = accessToken;
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  static Future<void> updateAccessToken(String newAccessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, newAccessToken);
    _token = newAccessToken;
  }

  // ================= USER DATA =================
  static Future<void> saveUserData({
    required int userId,
    required String email,
    required String firstName,
    required String userGoal,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_userIdKey, userId);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userFirstNameKey, firstName);
    await prefs.setString(_userGoalKey, userGoal);

    _firstName = firstName;
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getInt(_userIdKey);
    final email = prefs.getString(_userEmailKey);
    final firstName = prefs.getString(_userFirstNameKey);

    if (userId != null && email != null && firstName != null) {
      return {
        'id': userId,
        'email': email,
        'first_name': firstName,
      };
    }
    return null;
  }

  // ================= USER GOAL =================
  static Future<void> setUserGoal(String goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userGoalKey, goal);
  }

  static Future<String?> getUserGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userGoalKey);
  }

  // ================= PLAN END DATE =================
  static Future<void> setPlanEndDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_planEndDateKey, date.toIso8601String());
  }

  static Future<DateTime?> getPlanEndDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString(_planEndDateKey);

    if (dateString != null) {
      return DateTime.parse(dateString);
    }
    return null;
  }

  static Future<bool> isPlanExpired() async {
    final date = await getPlanEndDate();
    if (date == null) return false;
    return DateTime.now().isAfter(date);
  }

  // ================= FLAGS =================
  static Future<void> setOnboardingSeen(bool seen) async {
    try {
      if (_preferences == null) await init();
      await _preferences!.setBool(_isSeeOnboardingKey, seen);
      log('Onboarding flag saved: $seen');
    } catch (e) {
      log('Error saving onboarding flag: $e');
    }
  }

  static Future<void> setLogin(bool seen) async {
    try {
      if (_preferences == null) await init();
      await _preferences!.setBool(_isLoginKey, seen);
      log('Login flag saved: $seen');
    } catch (e) {
      log('Error saving login flag: $e');
    }
  }

  static Future<void> deleteLoginFlag() async {
    try {
      if (_preferences == null) await init();
      await _preferences!.remove(_isLoginKey);
      log('Login flag deleted');
    } catch (e) {
      log('Error deleting login flag: $e');
    }
  }

  static bool hasSeenOnboarding() {
    return _preferences?.getBool(_isSeeOnboardingKey) ?? false;
  }

  static bool hasSeenLogin() {
    return _preferences?.getBool(_isLoginKey) ?? false;
  }

  // ================= AUTH =================
  static Future<bool> isLoggedIn() async {
    final accessToken = await getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }

  // ================= CLEAR =================
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userFirstNameKey);
    await prefs.remove(_userGoalKey);
    await prefs.remove(_planEndDateKey);
  }

  // ================= GETTERS =================
  static String? get token => _token;
  static String? get firstName => _firstName;
}