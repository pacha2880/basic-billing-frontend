import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

class ApiService {
  ApiService._();

  static String? token;

  static final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl))
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (token != null && token!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

  /// Stores the JWT token used for authenticated requests.
  static void setToken(String newToken) {
    token = newToken;
  }

  /// Clears the stored token.
  static void clearToken() {
    token = null;
  }

  /// Requests a token for the given clientId.
  static Future<String> getToken(int clientId) async {
    final response = await _dio.post(ApiConstants.authToken, data: {
      'clientId': clientId,
    });

    final data = response.data;
    if (data is Map<String, dynamic> && data.containsKey('token')) {
      return data['token'] as String;
    }

    throw StateError('Unexpected token response: ${response.data}');
  }

  static Future<List<dynamic>> getPendingBills(int clientId) async {
    final response = await _dio.get(
      '${ApiConstants.pendingBills}/$clientId/pending-bills',
    );

    return (response.data is List) ? (response.data as List<dynamic>) : <dynamic>[];
  }

  static Future<List<dynamic>> getPaymentHistory(int clientId) async {
    final response = await _dio.get(
      '${ApiConstants.paymentHistory}/$clientId/payment-history',
    );

    return (response.data is List) ? (response.data as List<dynamic>) : <dynamic>[];
  }

  static Future<dynamic> createBill(Map<String, dynamic> body) async {
    final response = await _dio.post(ApiConstants.bills, data: body);
    return response.data;
  }

  static Future<dynamic> processPayment(Map<String, dynamic> body) async {
    final response = await _dio.post(ApiConstants.payments, data: body);
    return response.data;
  }
}
