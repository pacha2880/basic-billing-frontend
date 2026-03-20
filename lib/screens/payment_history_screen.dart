import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/payments/payments_bloc.dart';
import '../blocs/payments/payments_event.dart';
import '../blocs/payments/payments_state.dart';
import '../models/client_model.dart';
import '../widgets/filter_bar.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  String? _filterServiceType;
  String? _orderBy;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<PaymentsBloc>().add(LoadPaymentHistory(
            authState.clientId,
            filterServiceType: _filterServiceType,
            orderBy: _orderBy,
          ));
    }
  }

  String _formatPeriod(String period) {
    if (period.length < 6) return period;
    final year = period.substring(0, 4);
    final month = int.tryParse(period.substring(4, 6)) ?? 0;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    if (month < 1 || month > 12) return period;
    return '${months[month - 1]} $year';
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  IconData _serviceIcon(String serviceType) {
    switch (serviceType) {
      case 'Water':
        return Icons.water_drop;
      case 'Electricity':
        return Icons.bolt;
      case 'Sewer':
        return Icons.waves;
      default:
        return Icons.receipt_long;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final authState = context.watch<AuthBloc>().state;
    final clientName = authState is AuthAuthenticated
        ? kClients
            .firstWhere(
              (c) => c.id == authState.clientId,
              orElse: () => const ClientModel(id: 0, name: 'Unknown'),
            )
            .name
        : 'Not authenticated';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment History'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              clientName,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ),
      body: BlocBuilder<PaymentsBloc, PaymentsState>(
        builder: (context, state) {
          if (state is PaymentsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PaymentsError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48, color: cs.error),
                  const SizedBox(height: 12),
                  Text(state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: cs.error)),
                ],
              ),
            );
          }

          if (state is PaymentsLoaded) {
            if (state.payments.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.history, size: 72, color: cs.outlineVariant),
                    const SizedBox(height: 16),
                    Text(
                      'No payment history',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Payments will appear here once made.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => _load(),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    children: [
                      FilterBar(
                        filterServiceType: _filterServiceType,
                        orderBy: _orderBy,
                        onFilterChanged: (value) {
                          setState(() => _filterServiceType = value);
                          _load();
                        },
                        onOrderByChanged: (value) {
                          setState(() => _orderBy = value);
                          _load();
                        },
                        orderByOptions: const {
                          'paidAt desc': 'Date (newest first)',
                          'paidAt asc': 'Date (oldest first)',
                          'amountPaid desc': 'Amount (high → low)',
                          'amountPaid asc': 'Amount (low → high)',
                        },
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 16),
                          itemCount: state.payments.length,
                          itemBuilder: (context, index) {
                            final payment = state.payments[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: cs.secondaryContainer,
                                      child: Icon(
                                          _serviceIcon(payment.serviceType),
                                          color: cs.secondary),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            payment.serviceType,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(_formatPeriod(
                                              payment.billingPeriod)),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Paid on ${_formatDate(payment.paidAt)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                    color:
                                                        cs.onSurfaceVariant),
                                          ),
                                          const SizedBox(height: 6),
                                          Chip(
                                            label: Text(payment.status),
                                            visualDensity:
                                                VisualDensity.compact,
                                            backgroundColor:
                                                cs.secondaryContainer,
                                            labelStyle: TextStyle(
                                                color:
                                                    cs.onSecondaryContainer),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '\$${payment.amountPaid.toStringAsFixed(2)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: cs.secondary),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
