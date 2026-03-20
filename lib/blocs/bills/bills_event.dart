import 'package:equatable/equatable.dart';

abstract class BillsEvent extends Equatable {
  const BillsEvent();

  @override
  List<Object?> get props => [];
}

class LoadPendingBills extends BillsEvent {
  final int clientId;

  const LoadPendingBills(this.clientId);

  @override
  List<Object> get props => [clientId];
}

class PayBill extends BillsEvent {
  final int clientId;
  final String serviceType;
  final String billingPeriod;

  const PayBill({
    required this.clientId,
    required this.serviceType,
    required this.billingPeriod,
  });

  @override
  List<Object> get props => [clientId, serviceType, billingPeriod];
}
