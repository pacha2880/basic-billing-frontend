import 'package:equatable/equatable.dart';

import '../../models/bill_model.dart';

abstract class BillsState extends Equatable {
  const BillsState();

  @override
  List<Object?> get props => [];
}

class BillsInitial extends BillsState {}

class BillsLoading extends BillsState {}

class BillsLoaded extends BillsState {
  final List<BillModel> bills;

  const BillsLoaded(this.bills);

  @override
  List<Object> get props => [bills];
}

class BillsError extends BillsState {
  final String message;

  const BillsError(this.message);

  @override
  List<Object> get props => [message];
}

class BillPaymentSuccess extends BillsState {}
