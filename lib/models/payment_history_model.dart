class PaymentHistoryModel {
  final int billId;
  final String serviceType;
  final String billingPeriod;
  final double amountPaid;
  final DateTime paidAt;
  final String status;

  const PaymentHistoryModel({
    required this.billId,
    required this.serviceType,
    required this.billingPeriod,
    required this.amountPaid,
    required this.paidAt,
    required this.status,
  });

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryModel(
      billId: json['billId'] as int,
      serviceType: json['serviceType'] as String,
      billingPeriod: json['billingPeriod'] as String,
      amountPaid: (json['amountPaid'] as num).toDouble(),
      paidAt: DateTime.parse(json['paidAt'] as String),
      status: json['status'] as String,
    );
  }
}
