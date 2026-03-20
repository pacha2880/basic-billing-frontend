import 'package:bloc/bloc.dart';

import '../../repositories/payment_repository.dart';
import 'payments_event.dart';
import 'payments_state.dart';

class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  final PaymentRepository paymentRepository;

  PaymentsBloc({required this.paymentRepository}) : super(PaymentsInitial()) {
    on<LoadPaymentHistory>(_onLoadPaymentHistory);
    on<CreatePayment>(_onCreatePayment);
  }

  Future<void> _onLoadPaymentHistory(
      LoadPaymentHistory event, Emitter<PaymentsState> emit) async {
    emit(PaymentsLoading());
    try {
      final payments = await paymentRepository.getPaymentHistory(event.clientId);
      emit(PaymentsLoaded(payments));
    } catch (e) {
      emit(PaymentsError(e.toString()));
    }
  }

  Future<void> _onCreatePayment(
      CreatePayment event, Emitter<PaymentsState> emit) async {
    emit(PaymentsLoading());
    try {
      await paymentRepository.processPayment(
        event.clientId,
        event.serviceType,
        event.billingPeriod,
      );
      final payments = await paymentRepository.getPaymentHistory(event.clientId);
      emit(PaymentsLoaded(payments));
    } catch (e) {
      emit(PaymentsError(e.toString()));
    }
  }
}
