import 'package:equatable/equatable.dart';

abstract class PaymentsEvent extends Equatable {
  const PaymentsEvent();

  @override
  List<Object?> get props => [];
}

class LoadPaymentHistory extends PaymentsEvent {
  final int clientId;
  final String? filterServiceType;
  final String? orderBy;

  const LoadPaymentHistory(this.clientId, {this.filterServiceType, this.orderBy});

  @override
  List<Object?> get props => [clientId, filterServiceType, orderBy];
}

class CreatePayment extends PaymentsEvent {
  final int clientId;
  final String serviceType;
  final String billingPeriod;

  const CreatePayment({
    required this.clientId,
    required this.serviceType,
    required this.billingPeriod,
  });

  @override
  List<Object> get props => [clientId, serviceType, billingPeriod];
}
