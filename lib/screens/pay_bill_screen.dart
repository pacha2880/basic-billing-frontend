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

  @override
  void dispose() {
    _billingPeriodController.dispose();
    super.dispose();
  }

  void _clearForm() {
    setState(() {
      _serviceType = null;
      _billingPeriodController.clear();
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
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment successful')),
            );
            _clearForm();
          } else if (state is BillsError) {
            setState(() => _isSubmitting = false);
          } else if (state is BillsLoaded) {
            setState(() => _isSubmitting = false);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _serviceType,
                    decoration: const InputDecoration(
                      labelText: 'Service Type',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'Water', child: Text('Water')),
                      DropdownMenuItem(
                          value: 'Electricity', child: Text('Electricity')),
                      DropdownMenuItem(
                          value: 'Sewer', child: Text('Sewer')),
                    ],
                    onChanged: (value) =>
                        setState(() => _serviceType = value),
                    validator: (value) =>
                        value == null ? 'Please select a service type' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _billingPeriodController,
                    decoration: const InputDecoration(
                      labelText: 'Billing Period',
                      hintText: 'YYYYMM',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Billing period is required';
                      }
                      if (!RegExp(r'^\d{6}$').hasMatch(value.trim())) {
                        return 'Must be 6 digits in YYYYMM format';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isSubmitting || clientId == null
                        ? null
                        : () => _submit(clientId),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Pay Bill'),
                  ),
                  if (state is BillsError) ...[
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
