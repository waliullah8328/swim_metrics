import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../../core/services/auth_error_handler.dart';
import '../../../../../../../core/services/token_storage.dart';
import '../model/payment_model.dart';



class PaymentRepository {

  late final Dio _dio;
  final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

  PaymentRepository() {
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


  Future<PaymentModel > getSubscriptionPackage() async {
    try {
      final endpoint = dotenv.env['SUBSCRIPTION_PLAN_DETAILS_ENDPOINT'] ?? '/plan/details/';

      debugPrint('🚀 API REQUEST - PLAN GET');
      debugPrint('📍 URL: $_baseUrl$endpoint');
      debugPrint('🔑 Headers: ${(await _authorizedHeader()).headers}');
      debugPrint('⏰ Timestamp: ${DateTime.now()}');

      final response = await _dio.get(
        endpoint,

      );

      debugPrint('✅ API RESPONSE - PLAN GET');
      debugPrint('📊 Status Code: ${response.statusCode}');
      debugPrint('📦 Response Data: ${response.data}');
      debugPrint('⏰ Response Time: ${DateTime.now()}');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        if (data is Map<String, dynamic>) {
          return PaymentModel .fromJson(data);
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to get payment list');
      }
    } on DioException catch (e) {
      debugPrint("Get payment DioException: $e");
      throw Exception(_handleError(e));
    } catch (e) {
      debugPrint("Get payment Exception: $e");
      throw Exception('Something went wrong. Please try again.');
    }
  }









  Future<Map<String, dynamic>> applyCupon({
    required String code,



    required String token
  }) async {
    try {
      final payload = {
        "code": code
      };

      final endpoint = dotenv.env['PLAN_PROMO_CODE_ENDPOINT']
          ?? '/plan/promo/apply/';


      // 🚀 Request Logs
      debugPrint('🚀 API REQUEST - USER CHANGE PASSWORD');
      debugPrint('📍 URL: $_baseUrl$endpoint');
      debugPrint('📦 Payload: ${jsonEncode(payload)}');
      debugPrint('🔑 Headers: ${_dio.options.headers}');
      debugPrint('⏰ Timestamp: ${DateTime.now()}');

      final response = await _dio.post(
        endpoint,
        data: payload, // ✅ Dio handles JSON

        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // ❌ Do NOT set Content-Type manually
          },
        ),
      );

      // ✅ Response Logs
      debugPrint('✅ API RESPONSE - USER CHANGE PASSWORD');
      debugPrint('📊 Status Code: ${response.statusCode}');
      debugPrint('📦 Response Data: ${response.data}');
      debugPrint('⏰ Response Time: ${DateTime.now()}');

      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': data['detail'] ?? 'Promo code applied successfully',
          'price': data["data"]["price"],
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


  Future<Map<String, dynamic>> paymentFunction({




    required String token
  }) async {
    try {
      final payload = {

      };

      final endpoint = '/plan/payment/create-checkout-session/';


      // 🚀 Request Logs
      debugPrint('🚀 API REQUEST - USER CHANGE PASSWORD');
      debugPrint('📍 URL: $_baseUrl$endpoint');
      debugPrint('📦 Payload: ${jsonEncode(payload)}');
      debugPrint('🔑 Headers: ${_dio.options.headers}');
      debugPrint('⏰ Timestamp: ${DateTime.now()}');

      final response = await _dio.post(
        endpoint,
        data: payload, // ✅ Dio handles JSON

        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // ❌ Do NOT set Content-Type manually
          },
        ),
      );

      // ✅ Response Logs
      debugPrint('✅ API RESPONSE - USER CHANGE PASSWORD');
      debugPrint('📊 Status Code: ${response.statusCode}');
      debugPrint('📦 Response Data: ${response.data}');
      debugPrint('⏰ Response Time: ${DateTime.now()}');

      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'url': data["checkout_url"],
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




