import '../core/network/api_service.dart';
import '../models/bill_model.dart';

class BillRepository {
  BillRepository();

  Future<List<BillModel>> getPendingBills(int clientId) async {
    final data = await ApiService.getPendingBills(clientId);
    return data
        .whereType<Map<String, dynamic>>()
        .map((json) => BillModel.fromJson(json))
        .toList();
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

    final data = await ApiService.createBill(payload);
    if (data is Map<String, dynamic>) {
      return BillModel.fromJson(data);
    }

    throw StateError('Unexpected createBill response: $data');
  }
}
