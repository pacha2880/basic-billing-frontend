import 'package:dio/dio.dart';

import '../core/network/api_service.dart';
import '../models/bill_model.dart';

class BillRepository {
  BillRepository();

  Future<List<BillModel>> getPendingBills(int clientId) async {
    try {
      final data = await ApiService.getPendingBills(clientId);
      return data
          .whereType<Map<String, dynamic>>()
          .map((json) => BillModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'An error occurred. Please try again.';

      if (data != null && data is Map) {
        message = data['error']
            ?? data['message']
            ?? data['detail']
            ?? data['title']
            ?? message;
      } else if (data is String && data.isNotEmpty) {
        message = data;
      }

      throw Exception(message);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  Future<BillModel> createBill(
    int clientId,
    String serviceType,
    String billingPeriod,
    double amount,
  ) async {
    final payload = {
      'clientId': clientId,
      'serviceType': serviceType,
      'billingPeriod': billingPeriod,
      'amount': amount,
    };

    try {
      final data = await ApiService.createBill(payload);
      if (data is Map<String, dynamic>) {
        return BillModel.fromJson(data);
      }
      throw Exception('Unexpected createBill response: $data');
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'An error occurred. Please try again.';

      if (data != null && data is Map) {
        message = data['error']
            ?? data['message']
            ?? data['detail']
            ?? data['title']
            ?? message;
      } else if (data is String && data.isNotEmpty) {
        message = data;
      }

      throw Exception(message);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }
}
