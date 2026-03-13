import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../../core/services/auth_error_handler.dart';
import '../../../../../../../core/services/token_storage.dart';
import '../model/get_me_profile_model.dart';


class ProfileRepository {

  late final Dio _dio;
  final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

  ProfileRepository() {
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

  Future<Options> _authorizedHeader({bool isMultipart = false}) async {
    final token = await TokenStorage.getAccessToken();
    debugPrint("token : $token");
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        if (isMultipart) "Content-Type": "multipart/form-data",
      },
    );
  }

  Future<bool> isLoggedIn() async {
    return await TokenStorage.isLoggedIn();
  }


  Future<GetMeModel > getMeProfile() async {
    try {
      final endpoint = dotenv.env['PROFILE_GET_ME_ENDPOINT'] ?? '/user/profile/';

      debugPrint('🚀 API REQUEST - PROFILE GET');
      debugPrint('📍 URL: $_baseUrl$endpoint');
      debugPrint('🔑 Headers: ${(await _authorizedHeader()).headers}');
      debugPrint('⏰ Timestamp: ${DateTime.now()}');

      final response = await _dio.get(
        endpoint,
        options: await _authorizedHeader(),
      );

      debugPrint('✅ API RESPONSE - PROFILE GET');
      debugPrint('📊 Status Code: ${response.statusCode}');
      debugPrint('📦 Response Data: ${response.data}');
      debugPrint('⏰ Response Time: ${DateTime.now()}');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        if (data is Map<String, dynamic>) {
          return GetMeModel  .fromJson(data);
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to get profile list');
      }
    } on DioException catch (e) {
      debugPrint("Get profile DioException: $e");
      throw Exception(_handleError(e));
    } catch (e) {
      debugPrint("Get profile Exception: $e");
      throw Exception('Something went wrong. Please try again.');
    }
  }





  // Future<Map<String, dynamic>> deleteHistory({
  //   required String id,
  // }
  //     ) async {
  //   try {
  //     final Map<String, dynamic> payload = {
  //
  //     };
  //
  //
  //     final endpoint = 'history/daily-progress-delete/$id/';
  //
  //     // Log API request
  //     debugPrint('🚀 API REQUEST - USER DELETE HISTORY');
  //     debugPrint('📍 URL: $_baseUrl$endpoint');
  //     debugPrint('📦 Payload: ${jsonEncode(payload)}');
  //     debugPrint('🔑 Headers: ${_dio.options.headers}');
  //     debugPrint('⏰ Timestamp: ${DateTime.now()}');
  //
  //
  //     final response = await _dio.delete(
  //       endpoint,
  //       data: jsonEncode(payload),
  //       options: await _authorizedHeader(),
  //     );
  //
  //     // Log API response
  //     debugPrint('✅ API RESPONSE - USER DELETE HISTORY');
  //     debugPrint('📊 Status Code: ${response.statusCode}');
  //     debugPrint('📦 Response Data: ${response.data}');
  //     debugPrint('⏰ Response Time: ${DateTime.now()}');
  //
  //     final data = response.data is String ? jsonDecode(response.data) : response.data;
  //
  //     // Handle success response (201 Created or 200 OK)
  //     if (response.statusCode == 201 || response.statusCode == 200) {
  //       // Check if the response contains tokens (new API format)
  //       return {
  //         'success': true,
  //         'message': data['message'] ?? 'Delete account  successfully',
  //         'data': null,
  //       };
  //     }
  //
  //     // Handle unexpected success codes
  //     return {
  //       'success': false,
  //       'error': 'Unexpected response from server',
  //     };
  //
  //   } on DioException catch (e) {
  //     // Handle specific error cases
  //     debugPrint(e.message);
  //     debugPrint(e.response.toString());
  //
  //     if (e.response != null) {
  //       final data = e.response!.data is String ? jsonDecode(e.response!.data) : e.response!.data;
  //
  //       // Handle 400 Bad Request - Email already registered
  //       if (e.response!.statusCode == 400) {
  //         return {
  //           'success': false,
  //           'error': data['error'] ?? 'Old password is incorrect',
  //         };
  //       }
  //
  //       // Handle other HTTP errors
  //       return {
  //         'success': false,
  //         'error': data['error'] ?? data['message'] ?? 'Deactivation failed',
  //       };
  //     }
  //
  //     // Handle network/connection errors
  //     return {
  //       'success': false,
  //       'error': _handleError(e),
  //     };
  //   } catch (e) {
  //     // Handle any other unexpected errors
  //     return {
  //       'success': false,
  //       'error': 'An unexpected error occurred during deactivation of account',
  //     };
  //   }
  // }








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




