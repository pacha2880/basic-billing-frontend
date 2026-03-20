import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/bills/bills_bloc.dart';
import '../blocs/bills/bills_event.dart';
import '../blocs/bills/bills_state.dart';
import '../models/client_model.dart';

class CreateBillScreen extends StatefulWidget {
  const CreateBillScreen({super.key});

  @override
  State<CreateBillScreen> createState() => _CreateBillScreenState();
}

class _CreateBillScreenState extends State<CreateBillScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedClientId;
  String? _serviceType;
  final _billingPeriodController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _selectedClientId = authState.clientId;
    }
  }

  @override
  void dispose() {
    _billingPeriodController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _clearForm() {
    final authState = context.read<AuthBloc>().state;
    setState(() {
      _selectedClientId =
          authState is AuthAuthenticated ? authState.clientId : null;
      _serviceType = null;
      _billingPeriodController.clear();
      _amountController.clear();
    });
    _formKey.currentState?.reset();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(_amountController.text.trim()) ?? 0;
      setState(() => _isSubmitting = true);
      context.read<BillsBloc>().add(CreateBillEvent(
            clientId: _selectedClientId!,
            serviceType: _serviceType!,
            billingPeriod: _billingPeriodController.text.trim(),
            amount: amount,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Create Bill'),
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
          if (state is BillCreatedSuccess) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Bill created successfully')),
            );
            _clearForm();
          } else if (state is BillsError) {
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
                  DropdownButtonFormField<int>(
                    initialValue: _selectedClientId,
                    decoration: const InputDecoration(
                      labelText: 'Client',
                      border: OutlineInputBorder(),
                    ),
                    items: kClients
                        .map((client) => DropdownMenuItem<int>(
                              value: client.id,
                              child: Text('${client.id} - ${client.name}'),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedClientId = value),
                    validator: (value) =>
                        value == null ? 'Please select a client' : null,
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      hintText: '0.00',
                      prefixText: '\$',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Amount is required';
                      }
                      final amount = double.tryParse(value.trim());
                      if (amount == null) {
                        return 'Enter a valid number';
                      }
                      if (amount <= 0) {
                        return 'Amount must be greater than 0';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Create Bill'),
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
