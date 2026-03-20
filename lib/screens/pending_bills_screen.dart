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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        context.read<BillsBloc>().add(LoadPendingBills(authState.clientId));
      }
    });
  }

  String _formatBillingPeriod(String period) {
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
          }
        },
        builder: (context, state) {
          if (state is BillsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BillsError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is BillsLoaded) {
            if (state.bills.isEmpty) {
              return const Center(child: Text('No pending bills'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.bills.length,
              itemBuilder: (context, index) {
                final bill = state.bills[index];
                final isPaying = _payingBillId == bill.id;
                final isAnyPaying = _payingBillId != null;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(_serviceIcon(bill.serviceType), size: 36),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bill.serviceType,
                                style:
                                    Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(_formatBillingPeriod(bill.billingPeriod)),
                              Text('\$${bill.amount.toStringAsFixed(2)}'),
                              const SizedBox(height: 4),
                              Chip(
                                label: Text(bill.status),
                                backgroundColor: Colors.orange.shade100,
                                labelStyle: TextStyle(
                                    color: Colors.orange.shade800),
                              ),
                            ],
                          ),
                        ),
                        if (isPaying)
                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          ElevatedButton(
                            onPressed: isAnyPaying || clientId == null
                                ? null
                                : () {
                                    setState(() => _payingBillId = bill.id);
                                    context.read<BillsBloc>().add(PayBill(
                                          clientId: clientId,
                                          serviceType: bill.serviceType,
                                          billingPeriod: bill.billingPeriod,
                                        ));
                                  },
                            child: const Text('Pay'),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
