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
  final AuthBloc authBloc;

  const App({super.key, required this.authBloc});

  static Page<void> _fade(GoRouterState state, Widget child) =>
      CustomTransitionPage<void>(
        key: state.pageKey,
        child: child,
        transitionsBuilder: (context, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      );

  static final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => _fade(state, const HomeScreen()),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/pending-bills',
            pageBuilder: (context, state) =>
                _fade(state, const PendingBillsScreen()),
          ),
          GoRoute(
            path: '/pay-bill',
            pageBuilder: (context, state) =>
                _fade(state, const PayBillScreen()),
          ),
          GoRoute(
            path: '/create-bill',
            pageBuilder: (context, state) =>
                _fade(state, const CreateBillScreen()),
          ),
          GoRoute(
            path: '/payment-history',
            pageBuilder: (context, state) =>
                _fade(state, const PaymentHistoryScreen()),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authBloc),
        BlocProvider(
          create: (_) => BillsBloc(
            billRepository: BillRepository(),
            paymentRepository: PaymentRepository(),
          ),
        ),
        BlocProvider(
          create: (_) => PaymentsBloc(paymentRepository: PaymentRepository()),
        ),
      ],
      child: MaterialApp.router(
        title: 'BasicBilling',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: _router,
      ),
    );
  }
}

class AppShell extends StatelessWidget {
  final String location;
  final Widget child;

  const AppShell({super.key, required this.location, required this.child});

  static const _paths = [
    '/',
    '/pending-bills',
    '/pay-bill',
    '/create-bill',
    '/payment-history',
  ];
  static const _labels = [
    'Home',
    'Pending Bills',
    'Pay Bill',
    'Create Bill',
    'History',
  ];
  static const _icons = [
    Icons.home_outlined,
    Icons.receipt_long_outlined,
    Icons.payment_outlined,
    Icons.add_circle_outline,
    Icons.history_outlined,
  ];
  static const _selectedIcons = [
    Icons.home,
    Icons.receipt_long,
    Icons.payment,
    Icons.add_circle,
    Icons.history,
  ];

  int get _selectedIndex {
    final idx = _paths.indexWhere((p) => p != '/' && location.startsWith(p));
    return idx < 0 ? 0 : idx;
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width > 600;
    final selected = _selectedIndex;

    void onTap(int i) => context.go(_paths[i]);

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: selected,
              onDestinationSelected: onTap,
              labelType: NavigationRailLabelType.all,
              destinations: List.generate(
                _paths.length,
                (i) => NavigationRailDestination(
                  icon: Icon(_icons[i]),
                  selectedIcon: Icon(_selectedIcons[i]),
                  label: Text(_labels[i]),
                ),
              ),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: onTap,
        destinations: List.generate(
          _paths.length,
          (i) => NavigationDestination(
            icon: Icon(_icons[i]),
            selectedIcon: Icon(_selectedIcons[i]),
            label: _labels[i],
          ),
        ),
      ),
    );
  }
}
