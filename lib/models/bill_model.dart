class BillModel {
  final int id;
  final int clientId;
  final String serviceType;
  final String billingPeriod;
  final double amount;
  final String status;
  final DateTime createdAt;

  const BillModel({
    required this.id,
    required this.clientId,
    required this.serviceType,
    required this.billingPeriod,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      id: json['id'] as int,
      clientId: json['clientId'] as int,
      serviceType: json['serviceType'] as String,
      billingPeriod: json['billingPeriod'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
