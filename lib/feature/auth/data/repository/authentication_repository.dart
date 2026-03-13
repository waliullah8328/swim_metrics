import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/services/auth_error_handler.dart';
import '../../../../core/services/token_storage.dart';



class AuthenticationRepository{

  late final Dio _dio;
  final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

  AuthenticationRepository() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      headers: {'Content-Type': 'application/json'},

    ));
  }


  Future<void> saveToken(String token) async {
    // For backward compatibility, save as access token
    await TokenStorage.saveTokens(accessToken: token, refreshToken: '');
  }

  Future<String?> getToken() async {
    return await TokenStorage.getAccessToken();
  }

  Future<void> clearToken() async {
    await TokenStorage.clearAll();
  }



  Future<bool> isLoggedIn() async {
    return await TokenStorage.isLoggedIn();
  }

// Sign On Boarding

  Future<Map<String, dynamic>> createSignUpOnBoarding(
      {required String userGender,
        required String age,
        required bool isSedentaryLife,
        required String height,
        required String heightUnit,
        required String weight,
        required String weightUnit,
        required String stepGoal,
        required String token1,
      }) async {
    try {
      final Map<String, dynamic> payload = {
        "user_gender": userGender,
        "age_at_signup": int.tryParse(age),
        "sedentary_life": isSedentaryLife,
        "height": int.tryParse(height),
        "h_string": heightUnit,
        "weight": int.tryParse(weight),
        "w_string": weightUnit,
        "step_goal": int.tryParse(stepGoal)
      };
      debugPrint(payload.toString());


      final endpoint = dotenv.env['AUTH_USER_REGISTRATION_FINAL_ENDPOINT'] ?? 'signup/final/';

      // Log API request
      debugPrint('🚀 API REQUEST - USER SIGNUP FINAL');
      debugPrint('📍 URL: $_baseUrl$endpoint');
      debugPrint('📦 Payload: ${jsonEncode(payload)}');
      debugPrint('🔑 Headers: ${_dio.options.headers}');
      debugPrint('⏰ Timestamp: ${DateTime.now()}');


      final response = await _dio.post(
        endpoint,
        data: jsonEncode(payload),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token1',
            'Content-Type': 'application/json',
          },
        ),
      );

      // Log API response
      debugPrint('✅ API RESPONSE - USER SIGNUP FINAL');
      debugPrint('📊 Status Code: ${response.statusCode}');
      debugPrint('📦 Response Data: ${response.data}');
      debugPrint('⏰ Response Time: ${DateTime.now()}');

      final data = response.data is String ? jsonDecode(response.data) : response.data;

      // Handle success response (201 Created or 200 OK)
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Check if the response contains tokens (new API format)
        if (data['data'] != null ) {


          return {
            'success': true,
            'message': data['message'] ?? 'User data updated successfully',


          };
        } else {
          // Handle old API format (without tokens)
          return {
            'success': true,
            'message': data['message'] ?? 'User data updated successfully',
            'data': null,
          };
        }
      }

      // Handle unexpected success codes
      return {
        'success': false,
        'error': 'Unexpected response from server',
      };

    } on DioException catch (e) {
      // Handle specific error cases
      debugPrint('✅ API RESPONSE - USER SIGNUP FINAL');
      debugPrint('📊 Status Code: ${e.response?.statusCode}');
      debugPrint('📦 Response Data: ${e.response?.data}');
      debugPrint('⏰ Response Time: ${DateTime.now()}');
      if (e.response != null) {
        final data = e.response!.data is String ? jsonDecode(e.response!.data) : e.response!.data;

        // Handle 400 Bad Request - Email already registered
        if (e.response!.statusCode == 401) {
          return {
            'success': false,
            'error': data['error'] ?? 'Authentication credentials were not provided',
          };
        }

        // Handle other HTTP errors
        return {
          'success': false,
          'error': data['error'] ?? data['message'] ?? 'Registration failed',
        };
      }

      // Handle network/connection errors
      return {
        'success': false,
        'error': _handleError(e),
      };
    } catch (e) {
      // Handle any other unexpected errors
      return {
        'success': false,
        'error': 'An unexpected error occurred during registration',
      };
    }
  }

  Future<Map<String, dynamic>> signup(
      {required String name,required String email,required String password,required String confirmPassword}) async {
    try {
      final Map<String, dynamic> payload = {
        "name":name,
        "email": email,
        "password": password,
        "confirm_password": confirmPassword
      };


      final endpoint = dotenv.env['AUTH_USER_REGISTRATION_ENDPOINT'] ?? 'auth/register/';

      // Log API request
      debugPrint('🚀 API REQUEST - USER SIGNUP');
      debugPrint('📍 URL: $_baseUrl$endpoint');
      debugPrint('📦 Payload: ${jsonEncode(payload)}');
      debugPrint('🔑 Headers: ${_dio.options.headers}');
      debugPrint('⏰ Timestamp: ${DateTime.now()}');


      final response = await _dio.post(
        endpoint,
        data: jsonEncode(payload),
      );

      // Log API response
      debugPrint('✅ API RESPONSE - USER SIGNUP');
      debugPrint('📊 Status Code: ${response.statusCode}');
      debugPrint('📦 Response Data: ${response.data}');
      debugPrint('⏰ Response Time: ${DateTime.now()}');

      final data = response.data is String ? jsonDecode(response.data) : response.data;

      // Handle success response (201 Created or 200 OK)
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Check if the response contains tokens (new API format)
        if (data['data'] != null ) {
          final tokens = data['data']['access'];
          debugPrint("Get Access Token : $tokens");
          final refreshToken = data['data']['refresh'];
          debugPrint("Get Refresh Token : $refreshToken");
          final user = data['data']["user"];

          // Store tokens in SharedPreferences
          await TokenStorage.saveTokens(
            accessToken: tokens,
            refreshToken: refreshToken,
          );
          final getAccessToken = await TokenStorage.getAccessToken();
          debugPrint("Get SaveAccess Token : $getAccessToken");

          // Store user data in SharedPreferences
          // await TokenStorage.saveUserData(
          //   userId: user['id'],
          //   email: user['email'],
          //   userRole:user['role'],
          // );

          return {
            'success': true,
            'message': data['message'] ?? 'User created successfully',
            'data': {
              'user': user,
              'tokens': tokens,
            },
          };
        } else {
          // Handle old API format (without tokens)
          return {
            'success': true,
            'message': data['message'] ?? 'User created successfully',
            'data': null,
          };
        }
      }

      // Handle unexpected success codes
      return {
        'success': false,
        'error': 'Unexpected response from server',
      };

    } on DioException catch (e) {
      // Handle specific error cases
      if (e.response != null) {
        final data = e.response!.data is String ? jsonDecode(e.response!.data) : e.response!.data;

        // Handle 400 Bad Request - Email already registered
        if (e.response!.statusCode == 400) {
          return {
            'success': false,
            'error': data['error'] ?? 'Email already registered',
          };
        }

        // Handle other HTTP errors
        return {
          'success': false,
          'error': data['error'] ?? data['message'] ?? 'Registration failed',
        };
      }

      // Handle network/connection errors
      return {
        'success': false,
        'error': _handleError(e),
      };
    } catch (e) {
      // Handle any other unexpected errors
      return {
        'success': false,
        'error': 'An unexpected error occurred during registration',
      };
    }
  }




  Future<Map<String, dynamic>> signUpOnBoarding(
      {required String email,required String password,}) async {
    try {
      final Map<String, dynamic> payload = {
        'email': email,
        'password': password,

      };


      final endpoint = dotenv.env['AUTH_USER_REGISTRATION_ENDPOINT'] ?? 'auth/signup/';

      // Log API request
      debugPrint('🚀 API REQUEST - USER SIGNUP');
      debugPrint('📍 URL: $_baseUrl$endpoint');
      debugPrint('📦 Payload: ${jsonEncode(payload)}');
      debugPrint('🔑 Headers: ${_dio.options.headers}');
      debugPrint('⏰ Timestamp: ${DateTime.now()}');


      final response = await _dio.post(
        endpoint,
        data: jsonEncode(payload),
      );

      // Log API response
      debugPrint('✅ API RESPONSE - USER SIGNUP');
      debugPrint('📊 Status Code: ${response.statusCode}');
      debugPrint('📦 Response Data: ${response.data}');
      debugPrint('⏰ Response Time: ${DateTime.now()}');

      final data = response.data is String ? jsonDecode(response.data) : response.data;

      // Handle success response (201 Created or 200 OK)
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Check if the response contains tokens (new API format)
        if (data['access'] != null && data['user'] != null) {
          final tokens = data['access'];
          debugPrint("Get Access Token : $tokens");
          final refreshToken = data['refresh'];
          debugPrint("Get Refresh Token : $refreshToken");
          final user = data['user'];

          // Store tokens in SharedPreferences
          // await TokenStorage.saveTokens(
          //   accessToken: tokens,
          //   refreshToken: refreshToken,
          // );
          final getAccessToken = await TokenStorage.getAccessToken();
          debugPrint("Get Access Token : $getAccessToken");

          // Store user data in SharedPreferences
          // await TokenStorage.saveUserData(
          //   userId: user['id'],
          //   email: user['email'],
          //   userRole:'',
          //   userGoal: user['step_goal']
          // );

          return {
            'success': true,
            'message': data['message'] ?? 'User created successfully',
            'data': {
              'user': user,
              'tokens': tokens,
            },
          };
        } else {
          // Handle old API format (without tokens)
          return {
            'success': true,
            'message': data['message'] ?? 'User created successfully',
            'data': null,
          };
        }
      }

      // Handle unexpected success codes
      return {
        'success': false,
        'error': 'Unexpected response from server',
      };

    } on DioException catch (e) {
      // Handle specific error cases
      if (e.response != null) {
        final data = e.response!.data is String ? jsonDecode(e.response!.data) : e.response!.data;

        // Handle 400 Bad Request - Email already registered
        if (e.response!.statusCode == 400) {
          return {
            'success': false,
            'error': data['error'] ?? 'Email already registered',
          };
        }

        // Handle other HTTP errors
        return {
          'success': false,
          'error': data['error'] ?? data['message'] ?? 'Registration failed',
        };
      }

      // Handle network/connection errors
      return {
        'success': false,
        'error': _handleError(e),
      };
    } catch (e) {
      // Handle any other unexpected errors
      return {
        'success': false,
        'error': 'An unexpected error occurred during registration',
      };
    }
  }

  Future<Map<String, dynamic>> login(
      {required String email,required String password,}) async {
    try {
      final Map<String, dynamic> payload = {
        "email": email,
        "password": password
      };


      final endpoint = dotenv.env['AUTH_LOGIN_ENDPOINT'] ?? 'auth/sign-in/';

      // Log API request
      debugPrint('🚀 API REQUEST - USER LOGIN');
      debugPrint('📍 URL: $_baseUrl$endpoint');
      debugPrint('📦 Payload: ${jsonEncode(payload)}');
      debugPrint('🔑 Headers: ${_dio.options.headers}');
      debugPrint('⏰ Timestamp: ${DateTime.now()}');


      final response = await _dio.post(
        endpoint,
        data: jsonEncode(payload),
      );

      // Log API response
      debugPrint('✅ API RESPONSE - USER LOGIN');
      debugPrint('📊 Status Code: ${response.statusCode}');
      debugPrint('📦 Response Data: ${response.data}');
      debugPrint('⏰ Response Time: ${DateTime.now()}');

      final data = response.data is String ? jsonDecode(response.data) : response.data;

      // Handle success response (201 Created or 200 OK)
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Check if the response contains tokens (new API format)

        if (data['data'] != null ) {
          //final tokens = data['data']['access'];
          final tokens = data['access'];
          //final refreshToken = data['data']['refresh'];
          final refreshToken = data['refresh'];
          //final user = data['data']["user"];


          // Store user data in SharedPreferences


          return {
            'success': true,
            'message': data['message'] ?? 'Login successfully',
            'data': {
              //'user': user,
              'tokens': tokens,
              'refreshToken':refreshToken
            },
          };
        } else {
          // Handle old API format (without tokens)
          return {
            'success': true,
            'message': data['message'] ?? 'Login  successfully',
            'data': null,
          };
        }
      }

      // Handle unexpected success codes
      return {
        'success': false,
        'error': 'Unexpected response from server',
      };

    } on DioException catch (e) {
      // Handle specific error cases
      debugPrint(e.message);
      debugPrint(e.response.toString());

      if (e.response != null) {
        final data = e.response!.data is String ? jsonDecode(e.response!.data) : e.response!.data;

        // Handle 400 Bad Request - Email already registered
        if (e.response!.statusCode == 400) {
          return {
            'success': false,
            'error': data['error'] ?? 'Invalid email or password.',
          };
        }

        // Handle other HTTP errors
        return {
          'success': false,
          'error': data['error'] ?? data['message'] ?? 'Registration failed',
        };
      }

      // Handle network/connection errors
      return {
        'success': false,
        'error': _handleError(e),
      };
    } catch (e) {
      // Handle any other unexpected errors
      return {
        'success': false,
        'error': 'An unexpected error occurred during registration',
      };
    }
  }
// Google Sign In with firebase

  Future<Map<String, dynamic>> signInWithGoogle({
    required String email,
  }) async {
    try {
      final Map<String, dynamic> payload = {"email": email};

      final endpoint =
          dotenv.env['AUTH_GOOGLE_SIGN_UP_ENDPOINT'] ?? 'auth/google/signup/';

      // Log API request
      debugPrint('🚀 API REQUEST - USER GOOGLE SIGN UP');
      debugPrint('📍 URL: $_baseUrl$endpoint');
      debugPrint('📦 Payload: ${jsonEncode(payload)}');
      debugPrint('🔑 Headers: ${_dio.options.headers}');
      debugPrint('⏰ Timestamp: ${DateTime.now()}');

      final response = await _dio.post(endpoint, data: jsonEncode(payload));

      // Log API response
      debugPrint('✅ API RESPONSE - USER GOOGLE SIGN UP');
      debugPrint('📊 Status Code: ${response.statusCode}');
      debugPrint('📦 Response Data: ${response.data}');
      debugPrint('⏰ Response Time: ${DateTime.now()}');

      final data = response.data is String ? jsonDecode(response.data) : response.data;

      // Handle success response (201 Created or 200 OK)
      if (response.statusCode == 201 || response.statusCode == 200) {
        final accessToken = data['access'] ?? '';
        final refreshToken = data['refresh'] ?? '';
        final isSignUpCompleted = data['signup_status']?["is_completed"] ?? false;

        debugPrint("Access Token : $accessToken");
        debugPrint("Refresh Token : $refreshToken");
        debugPrint("Is Sign Up Completed : $isSignUpCompleted");

        return {
          'success': true,
          'message': data['message'] ?? 'Login successfully',
          'data': {
            'user': isSignUpCompleted,
            'tokens': accessToken,
            'refreshToken': refreshToken,
          },
        };
      }

      // Handle unexpected success codes
      return {
        'success': false,
        'error': 'Unexpected response from server',
      };
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      debugPrint('Response: ${e.response}');

      if (e.response != null) {
        final errorData = e.response!.data is String
            ? jsonDecode(e.response!.data)
            : e.response!.data;

        return {
          'success': false,
          'error': errorData['error'] ?? errorData['message'] ?? 'Registration failed',
        };
      }

      return {
        'success': false,
        'error': _handleError(e),
      };
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return {
        'success': false,
        'error': 'An unexpected error occurred during registration',
      };
    }
  }


  // Apple Sign In

  Future<Map<String, dynamic>> signInWithApple({
    required String fullName,
    required String? identityToken,
  }) async {
    try {
      final Map<String, dynamic> payload = {
        "identity_token": identityToken,
        "full_name": fullName
      };

      final endpoint =
          dotenv.env['AUTH_APPLE_SIGN_UP_ENDPOINT'] ?? 'auth/apple-login/';

      // Log API request
      debugPrint('🚀 API REQUEST - USER APPLE SIGN UP');
      debugPrint('📍 URL: $_baseUrl$endpoint');
      debugPrint('📦 Payload: ${jsonEncode(payload)}');
      debugPrint('🔑 Headers: ${_dio.options.headers}');
      debugPrint('⏰ Timestamp: ${DateTime.now()}');

      final response = await _dio.post(endpoint, data: jsonEncode(payload));

      // Log API response
      debugPrint('✅ API RESPONSE - USER APPLE  SIGN UP');
      debugPrint('📊 Status Code: ${response.statusCode}');
      debugPrint('📦 Response Data: ${response.data}');
      debugPrint('⏰ Response Time: ${DateTime.now()}');

      final data = response.data is String ? jsonDecode(response.data) : response.data;

      // Handle success response (201 Created or 200 OK)
      if (response.statusCode == 201 || response.statusCode == 200) {
        final accessToken = data['access'] ?? '';
        final refreshToken = data['refresh'] ?? '';
        final isSignUpCompleted = data['signup_status']?["is_completed"] ?? false;

        debugPrint("Access Token : $accessToken");
        debugPrint("Refresh Token : $refreshToken");
        debugPrint("Is Sign Up Completed : $isSignUpCompleted");

        return {
          'success': true,
          'message': data['message'] ?? 'Login successfully',
          'data': {
            'user': isSignUpCompleted,
            'tokens': accessToken,
            'refreshToken': refreshToken,
          },
        };
      }

      // Handle unexpected success codes
      return {
        'success': false,
        'error': 'Unexpected response from server',
      };
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      debugPrint('Response: ${e.response}');

      if (e.response != null) {
        final errorData = e.response!.data is String
            ? jsonDecode(e.response!.data)
            : e.response!.data;

        return {
          'success': false,
          'error': errorData['error'] ?? errorData['message'] ?? 'Registration failed',
        };
      }

      return {
        'success': false,
        'error': _handleError(e),
      };
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return {
        'success': false,
        'error': 'An unexpected error occurred during registration',
      };
    }
  }


  // Forget Password
  // done

  Future<Map<String, dynamic>> forgetPassword({
    required String email,
  }) async {
    try {
      final payload = {
        "email": email,
      };

      final endpoint =
          dotenv.env['AUTH_FORGOT_PASSWORD_ENDPOINT'] ?? '/auth/forgot-password/';

      // 🚀 Request Logs
      debugPrint('🚀 API REQUEST - USER FORGOT PASSWORD');
      debugPrint('📍 URL: $_baseUrl$endpoint');
      debugPrint('📦 Payload: ${jsonEncode(payload)}');
      debugPrint('🔑 Headers: ${_dio.options.headers}');
      debugPrint('⏰ Timestamp: ${DateTime.now()}');

      final response = await _dio.post(
        endpoint,
        data: payload, // ❗ no need jsonEncode, Dio handles it
      );

      // ✅ Response Logs
      debugPrint('✅ API RESPONSE - USER FORGOT PASSWORD');
      debugPrint('📊 Status Code: ${response.statusCode}');
      debugPrint('📦 Response Data: ${response.data}');

      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'OTP sent successfully',
          'data': null,
        };
      }

      return {
        'success': false,
        'error': 'Unexpected server response',
      };
    }

    // 🔴 Dio Error Handling
    on DioException catch (e) {
      debugPrint('❌ DIO ERROR: ${e.message}');
      debugPrint('❌ RESPONSE: ${e.response?.data}');

      if (e.response?.data != null) {
        final data = e.response!.data is String
            ? jsonDecode(e.response!.data)
            : e.response!.data;

        String errorMessage = 'Something went wrong';

        // ✅ Handle validation errors like: { email: ["error"] }
        if (data is Map<String, dynamic>) {
          for (final entry in data.entries) {
            if (entry.value is List && entry.value.isNotEmpty) {
              errorMessage = entry.value.first.toString();
              break;
            }
          }

          // fallback options
          errorMessage = data['message'] ??
              data['error'] ??
              errorMessage;
        }

        return {
          'success': false,
          'error': errorMessage,
        };
      }

      return {
        'success': false,
        'error': _handleError(e),
      };
    }

    // 🔴 Unknown Error
    catch (e) {
      return {
        'success': false,
        'error': 'Unexpected error occurred',
      };
    }
  }


// Verify Otp
  // done
  Future<Map<String, dynamic>> otpVerify({
    required String email,
    required String otp,
  }) async {
    try {
      final payload = {
        "email": email,
        "otp": otp
      };

      final endpoint = dotenv.env['AUTH_OTP_VERIFICATION_ENDPOINT']
          ?? '/auth/verify-email/';

      // 🚀 Request Logs
      debugPrint('🚀 API REQUEST - USER VERIFY OTP');
      debugPrint('📍 URL: $_baseUrl$endpoint');
      debugPrint('📦 Payload: ${jsonEncode(payload)}');
      debugPrint('🔑 Headers: ${_dio.options.headers}');
      debugPrint('⏰ Timestamp: ${DateTime.now()}');

      final response = await _dio.post(
        endpoint,
        data: payload, // ✅ Dio handles JSON
      );

      // ✅ Response Logs
      debugPrint('✅ API RESPONSE - USER VERIFY OTP');
      debugPrint('📊 Status Code: ${response.statusCode}');
      debugPrint('📦 Response Data: ${response.data}');
      debugPrint('⏰ Response Time: ${DateTime.now()}');

      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'OTP verified successfully',
          'data': null,
        };
      }

      return {
        'success': false,
        'error': 'Unexpected server response',
      };
    }

    // 🔴 Dio Error Handling
    on DioException catch (e) {
      debugPrint('❌ DIO ERROR: ${e.message}');
      debugPrint('❌ RESPONSE: ${e.response?.data}');

      if (e.response?.data != null) {
        final data = e.response!.data is String
            ? jsonDecode(e.response!.data)
            : e.response!.data;

        String errorMessage = 'Something went wrong';

        // ✅ Handle validation errors like:
        // { "otp": ["Invalid OTP"] }
        // { "email": ["Email not found"] }
        if (data is Map<String, dynamic>) {
          for (final entry in data.entries) {
            if (entry.value is List && entry.value.isNotEmpty) {
              errorMessage = entry.value.first.toString();
              break;
            }
          }

          // fallback messages
          errorMessage = data['message']
              ?? data['error']
              ?? errorMessage;
        }

        return {
          'success': false,
          'error': errorMessage,
        };
      }

      return {
        'success': false,
        'error': _handleError(e),
      };
    }

    // 🔴 Unknown Error
    catch (e) {
      return {
        'success': false,
        'error': 'Unexpected error occurred',
      };
    }
  }


  // Done
  Future<Map<String, dynamic>> forgetOtpVerify({
    required String email,
    required String otp,
  }) async {
    try {
      final payload = {
        "email": email,
        "otp": otp
      };

      final endpoint = dotenv.env['AUTH_FORGET_OTP_VERIFICATION_ENDPOINT']
          ?? '/auth/verify-reset-otp/';

      // 🚀 Request Logs
      debugPrint('🚀 API REQUEST - USER VERIFY OTP');
      debugPrint('📍 URL: $_baseUrl$endpoint');
      debugPrint('📦 Payload: ${jsonEncode(payload)}');
      debugPrint('🔑 Headers: ${_dio.options.headers}');
      debugPrint('⏰ Timestamp: ${DateTime.now()}');

      final response = await _dio.post(
        endpoint,
        data: payload, // ✅ Dio handles JSON
      );

      // ✅ Response Logs
      debugPrint('✅ API RESPONSE - USER VERIFY OTP');
      debugPrint('📊 Status Code: ${response.statusCode}');
      debugPrint('📦 Response Data: ${response.data}');
      debugPrint('⏰ Response Time: ${DateTime.now()}');

      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'OTP verified successfully',
          'forgetPasswordToken': data["forgot_password_token"],
        };
      }

      return {
        'success': false,
        'error': 'Unexpected server response',
      };
    }

    // 🔴 Dio Error Handling
    on DioException catch (e) {
      debugPrint('❌ DIO ERROR: ${e.message}');
      debugPrint('❌ RESPONSE: ${e.response?.data}');

      if (e.response?.data != null) {
        final data = e.response!.data is String
            ? jsonDecode(e.response!.data)
            : e.response!.data;

        String errorMessage = 'Something went wrong';

        // ✅ Handle validation errors like:
        // { "otp": ["Invalid OTP"] }
        // { "email": ["Email not found"] }
        if (data is Map<String, dynamic>) {
          for (final entry in data.entries) {
            if (entry.value is List && entry.value.isNotEmpty) {
              errorMessage = entry.value.first.toString();
              break;
            }
          }

          // fallback messages
          errorMessage = data['message']
              ?? data['error']
              ?? errorMessage;
        }

        return {
          'success': false,
          'error': errorMessage,
        };
      }

      return {
        'success': false,
        'error': _handleError(e),
      };
    }

    // 🔴 Unknown Error
    catch (e) {
      return {
        'success': false,
        'error': 'Unexpected error occurred',
      };
    }
  }


  // Reset Password
  Future<Map<String, dynamic>> resetPassword(
      {required String email, required String newPassword,required String forgotPasswordToken}) async {
    try {
      final Map<String, dynamic> payload = {
        "email": email,
        "forgot_password_token": forgotPasswordToken,
        "new_password": newPassword
      };


      final endpoint = dotenv.env['AUTH_PASSWORD_RESET_ENDPOINT'] ?? '/auth/reset-password/';

      // Log API request
      debugPrint('🚀 API REQUEST - USER RESET PASSWORD');
      debugPrint('📍 URL: $_baseUrl$endpoint');
      debugPrint('📦 Payload: ${jsonEncode(payload)}');
      debugPrint('🔑 Headers: ${_dio.options.headers}');
      debugPrint('⏰ Timestamp: ${DateTime.now()}');


      final response = await _dio.post(
        endpoint,
        data: jsonEncode(payload),
      );

      // Log API response
      debugPrint('✅ API RESPONSE - USER RESET PASSWORD');
      debugPrint('📊 Status Code: ${response.statusCode}');
      debugPrint('📦 Response Data: ${response.data}');
      debugPrint('⏰ Response Time: ${DateTime.now()}');

      final data = response.data is String ? jsonDecode(response.data) : response.data;

      // Handle success response (201 Created or 200 OK)
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Check if the response contains tokens (new API format)
        return {
          'success': true,
          'message': data['message'] ?? 'Password reset Successfully',
          'data': null,
        };
      }

      // Handle unexpected success codes
      return {
        'success': false,
        'error': 'Unexpected response from server',
      };

    } on DioException catch (e) {
      // Handle specific error cases
      debugPrint(e.message);
      debugPrint(e.response.toString());

      if (e.response != null) {
        final data = e.response!.data is String ? jsonDecode(e.response!.data) : e.response!.data;

        // Handle 400 Bad Request - Email already registered
        if (e.response!.statusCode == 400) {
          return {
            'success': false,
            'error': data['error'] ?? 'Invalid email or password.',
          };
        }

        // Handle other HTTP errors
        return {
          'success': false,
          'error': data['error'] ?? data['message'] ?? 'Registration failed',
        };
      }

      // Handle network/connection errors
      return {
        'success': false,
        'error': _handleError(e),
      };
    } catch (e) {
      // Handle any other unexpected errors
      return {
        'success': false,
        'error': 'An unexpected error occurred during registration',
      };
    }
  }















  // ---------------- ERROR HANDLER ---------------- //
  String _handleError(DioException e) {
    debugPrint("❌ AUTH API ERROR DETAILS");
    debugPrint("🔍 Error Type: ${e.type}");
    debugPrint("📊 Status Code: ${e.response?.statusCode}");
    debugPrint("📦 Response Data: ${e.response?.data}");
    debugPrint("🌐 Request URL: ${e.requestOptions.uri}");
    debugPrint("📝 Error Message: ${e.message}");
    debugPrint("⏰ Error Time: ${DateTime.now()}");

    // Check for authentication errors and handle auto logout
    if (AuthErrorHandler.isAuthError(e)) {
      AuthErrorHandler.handleAuthError(e);
      return 'Session expired. Please login again.';
    }

    if (e.response != null && e.response!.data != null) {
      final data = e.response!.data;

      if (data is Map<String, dynamic>) {
        return data['detail'] ?? data['message'] ?? 'Request failed';
      } else if (data is String) {
        try {
          final decoded = jsonDecode(data);
          return decoded['detail'] ?? decoded['message'] ?? 'Request failed';
        } catch (_) {
          return data;
        }
      }
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Try again.';
    }
    return e.message ?? 'Something went wrong. Please try later.';
  }
}