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

    final data = await ApiService.processPayment(payload);
    if (data is Map<String, dynamic>) {
      return PaymentHistoryModel.fromJson(data);
    }

    throw StateError('Unexpected processPayment response: $data');
  }

  Future<List<PaymentHistoryModel>> getPaymentHistory(int clientId) async {
    final data = await ApiService.getPaymentHistory(clientId);
    return data
        .whereType<Map<String, dynamic>>()
        .map((json) => PaymentHistoryModel.fromJson(json))
        .toList();
  }
}
