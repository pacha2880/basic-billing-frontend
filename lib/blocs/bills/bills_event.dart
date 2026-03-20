import 'package:equatable/equatable.dart';

abstract class BillsEvent extends Equatable {
  const BillsEvent();

  @override
  List<Object?> get props => [];
}

class LoadPendingBills extends BillsEvent {
  final int clientId;
  final String? filterServiceType;
  final String? orderBy;

  const LoadPendingBills(this.clientId, {this.filterServiceType, this.orderBy});

  @override
  List<Object?> get props => [clientId, filterServiceType, orderBy];
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

class CreateBillEvent extends BillsEvent {
  final int clientId;
  final String serviceType;
  final String billingPeriod;
  final double amount;

  const CreateBillEvent({
    required this.clientId,
    required this.serviceType,
    required this.billingPeriod,
    required this.amount,
  });

  @override
  List<Object> get props => [clientId, serviceType, billingPeriod, amount];
}
