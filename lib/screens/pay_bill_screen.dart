import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/bills/bills_bloc.dart';
import '../blocs/bills/bills_event.dart';
import '../blocs/bills/bills_state.dart';
import '../models/client_model.dart';

class PayBillScreen extends StatefulWidget {
  const PayBillScreen({super.key});

  @override
  State<PayBillScreen> createState() => _PayBillScreenState();
}

class _PayBillScreenState extends State<PayBillScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _serviceType;
  final _billingPeriodController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _billingPeriodController.dispose();
    super.dispose();
  }

  void _clearForm() {
    setState(() {
      _serviceType = null;
      _billingPeriodController.clear();
      _errorMessage = null;
    });
    _formKey.currentState?.reset();
  }

  void _submit(int clientId) {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      context.read<BillsBloc>().add(PayBill(
            clientId: clientId,
            serviceType: _serviceType!,
            billingPeriod: _billingPeriodController.text.trim(),
          ));
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
        title: const Text('Pay Bill'),
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
            setState(() { _isSubmitting = false; _errorMessage = null; });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Payment successful'),
                backgroundColor: cs.secondary,
              ),
            );
            _clearForm();
          } else if (state is BillsError) {
            setState(() { _isSubmitting = false; _errorMessage = state.message; });
          } else if (state is BillsLoaded) {
            setState(() => _isSubmitting = false);
          }
        },
        builder: (context, state) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Pay a Bill',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 24),
                          DropdownButtonFormField<String>(
                            initialValue: _serviceType,
                            decoration: const InputDecoration(
                              labelText: 'Service Type',
                              prefixIcon: Icon(Icons.category_outlined),
                            ),
                            items: const [
                              DropdownMenuItem(
                                  value: 'Water', child: Text('Water')),
                              DropdownMenuItem(
                                  value: 'Electricity',
                                  child: Text('Electricity')),
                              DropdownMenuItem(
                                  value: 'Sewer', child: Text('Sewer')),
                            ],
                            onChanged: (value) =>
                                setState(() => _serviceType = value),
                            validator: (value) => value == null
                                ? 'Please select a service type'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _billingPeriodController,
                            decoration: const InputDecoration(
                              labelText: 'Billing Period',
                              hintText: 'YYYYMM',
                              prefixIcon: Icon(Icons.calendar_month_outlined),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Billing period is required';
                              }
                              if (!RegExp(r'^\d{6}$')
                                  .hasMatch(value.trim())) {
                                return 'Must be 6 digits in YYYYMM format';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          if (_errorMessage != null) ...[
                            Container(
                              padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
                              decoration: BoxDecoration(
                                color: cs.errorContainer,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline,
                                      color: cs.onErrorContainer, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: TextStyle(
                                          color: cs.onErrorContainer),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close,
                                        color: cs.onErrorContainer, size: 18),
                                    onPressed: () =>
                                        setState(() => _errorMessage = null),
                                    visualDensity: VisualDensity.compact,
                                    padding: EdgeInsets.zero,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          FilledButton(
                            onPressed: _isSubmitting || clientId == null
                                ? null
                                : () => _submit(clientId),
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white),
                                  )
                                : const Text('Pay Bill'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
