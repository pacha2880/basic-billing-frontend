import 'package:dio/dio.dart';

import '../core/network/api_service.dart';
import '../models/payment_history_model.dart';

class PaymentRepository {
  PaymentRepository();

  Future<PaymentHistoryModel> processPayment(
    int clientId,
    String serviceType,
    String billingPeriod,
  ) async {
    final payload = {
      'clientId': clientId,
      'serviceType': serviceType,
      'billingPeriod': billingPeriod,
    };

    try {
      final data = await ApiService.processPayment(payload);
      if (data is Map<String, dynamic>) {
        return PaymentHistoryModel.fromJson(data);
      }
      throw Exception('Unexpected processPayment response: $data');
    } on DioException catch (e) {
      throw Exception(_extractDioMessage(e));
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  Future<List<PaymentHistoryModel>> getPaymentHistory(int clientId) async {
    try {
      final data = await ApiService.getPaymentHistory(clientId);
      return data
          .whereType<Map<String, dynamic>>()
          .map((json) => PaymentHistoryModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception(_extractDioMessage(e));
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  String _extractDioMessage(DioException e) {
    final data = e.response?.data;
    String message = 'An error occurred. Please try again.';

    if (data != null && data is Map) {
      message = data['error']
          ?? data['message']
          ?? data['title']
          ?? data['detail']
          ?? message;
    } else if (data is String && data.isNotEmpty) {
      message = data;
    }

    return message;
  }
}
