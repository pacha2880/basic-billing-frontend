import 'package:bloc/bloc.dart';

import '../../repositories/bill_repository.dart';
import '../../repositories/payment_repository.dart';
import 'bills_event.dart';
import 'bills_state.dart';

class BillsBloc extends Bloc<BillsEvent, BillsState> {
  final BillRepository billRepository;
  final PaymentRepository paymentRepository;

  BillsBloc({
    required this.billRepository,
    required this.paymentRepository,
  }) : super(BillsInitial()) {
    on<LoadPendingBills>(_onLoadPendingBills);
    on<PayBill>(_onPayBill);
  }

  Future<void> _onLoadPendingBills(
      LoadPendingBills event, Emitter<BillsState> emit) async {
    emit(BillsLoading());
    try {
      final bills = await billRepository.getPendingBills(event.clientId);
      emit(BillsLoaded(bills));
    } catch (e) {
      emit(BillsError(e.toString()));
    }
  }

  Future<void> _onPayBill(PayBill event, Emitter<BillsState> emit) async {
    emit(BillsLoading());
    try {
      await paymentRepository.processPayment(
        event.clientId,
        event.serviceType,
        event.billingPeriod,
      );
      emit(BillPaymentSuccess());
      final bills = await billRepository.getPendingBills(event.clientId);
      emit(BillsLoaded(bills));
    } catch (e) {
      emit(BillsError(e.toString()));
    }
  }
}
