import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/bills/bills_bloc.dart';
import 'blocs/payments/payments_bloc.dart';
import 'core/theme/app_theme.dart';
import 'repositories/bill_repository.dart';
import 'repositories/payment_repository.dart';
import 'screens/create_bill_screen.dart';
import 'screens/home_screen.dart';
import 'screens/payment_history_screen.dart';
import 'screens/pending_bills_screen.dart';
import 'screens/pay_bill_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  static final _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/pending-bills', builder: (context, state) => const PendingBillsScreen()),
      GoRoute(path: '/pay-bill', builder: (context, state) => const PayBillScreen()),
      GoRoute(path: '/create-bill', builder: (context, state) => const CreateBillScreen()),
      GoRoute(path: '/payment-history', builder: (context, state) => const PaymentHistoryScreen()),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => BillsBloc(
          billRepository: BillRepository(),
          paymentRepository: PaymentRepository(),
        )),
        BlocProvider(create: (context) => PaymentsBloc(paymentRepository: PaymentRepository())),
      ],
      child: MaterialApp.router(
        title: 'BasicBilling Frontend',
        theme: AppTheme.lightTheme,
        routerConfig: _router,
      ),
    );
  }
}
