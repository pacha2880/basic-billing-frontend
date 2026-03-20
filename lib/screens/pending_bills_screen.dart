import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/bills/bills_bloc.dart';
import '../blocs/bills/bills_event.dart';
import '../blocs/bills/bills_state.dart';
import '../models/client_model.dart';

class PendingBillsScreen extends StatefulWidget {
  const PendingBillsScreen({super.key});

  @override
  State<PendingBillsScreen> createState() => _PendingBillsScreenState();
}

class _PendingBillsScreenState extends State<PendingBillsScreen> {
  int? _payingBillId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<BillsBloc>().add(LoadPendingBills(authState.clientId));
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
    final clientId =
        authState is AuthAuthenticated ? authState.clientId : null;
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
        title: const Text('Pending Bills'),
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
      body: BlocConsumer<BillsBloc, BillsState>(
        listener: (context, state) {
          if (state is BillPaymentSuccess) {
            setState(() => _payingBillId = null);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment successful')),
            );
          } else if (state is BillsError) {
            setState(() => _payingBillId = null);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: cs.error,
                duration: const Duration(seconds: 6),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is BillsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BillsLoaded) {
            if (state.bills.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_outline,
                        size: 72, color: cs.primary),
                    const SizedBox(height: 16),
                    Text(
                      'No pending bills',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'All caught up!',
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
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.bills.length,
                    itemBuilder: (context, index) {
                      final bill = state.bills[index];
                      final isPaying = _payingBillId == bill.id;
                      final isAnyPaying = _payingBillId != null;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: cs.primaryContainer,
                            child: Icon(_serviceIcon(bill.serviceType),
                                color: cs.primary),
                          ),
                          title: Text(bill.serviceType),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_formatPeriod(bill.billingPeriod)),
                              const SizedBox(height: 4),
                              Chip(
                                label: Text(bill.status),
                                visualDensity: VisualDensity.compact,
                                backgroundColor: cs.tertiaryContainer,
                                labelStyle:
                                    TextStyle(color: cs.onTertiaryContainer),
                              ),
                            ],
                          ),
                          trailing: SizedBox(
                            width: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$${bill.amount.toStringAsFixed(2)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(color: cs.primary),
                                ),
                                const SizedBox(height: 8),
                                if (isPaying)
                                  const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                else
                                  FilledButton.tonal(
                                    onPressed: isAnyPaying || clientId == null
                                        ? null
                                        : () {
                                            setState(
                                                () => _payingBillId = bill.id);
                                            context.read<BillsBloc>().add(
                                                  PayBill(
                                                    clientId: clientId,
                                                    serviceType:
                                                        bill.serviceType,
                                                    billingPeriod:
                                                        bill.billingPeriod,
                                                  ),
                                                );
                                          },
                                    child: const Text('Pay'),
                                  ),
                              ],
                            ),
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
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
