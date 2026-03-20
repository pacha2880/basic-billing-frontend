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
    on<CreateBillEvent>(_onCreateBill);
  }

  Future<void> _onLoadPendingBills(
      LoadPendingBills event, Emitter<BillsState> emit) async {
    emit(BillsLoading());
    try {
      final bills = await billRepository.getPendingBills(
        event.clientId,
        filterServiceType: event.filterServiceType,
        orderBy: event.orderBy,
      );
      emit(BillsLoaded(bills));
    } catch (e) {
      emit(BillsError(_extractMessage(e)));
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
      emit(BillsLoading());
      final bills = await billRepository.getPendingBills(event.clientId);
      emit(BillsLoaded(bills));
    } catch (e) {
      emit(BillsError(_extractMessage(e)));
      try {
        final bills = await billRepository.getPendingBills(event.clientId);
        emit(BillsLoaded(bills));
      } catch (_) {
        // keep error state if reload also fails
      }
    }
  }

  String _extractMessage(Object e) {
    final s = e.toString();
    return s.startsWith('Exception: ') ? s.substring(11) : s;
  }

  Future<void> _onCreateBill(
      CreateBillEvent event, Emitter<BillsState> emit) async {
    emit(BillsLoading());
    try {
      await billRepository.createBill(
        event.clientId,
        event.serviceType,
        event.billingPeriod,
        event.amount,
      );
      emit(BillCreatedSuccess());
    } catch (e) {
      emit(BillsError(_extractMessage(e)));
    }
  }
}
