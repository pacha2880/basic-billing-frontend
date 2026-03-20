import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../models/client_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _selectedClientId;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _selectedClientId = authState.clientId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(Icons.receipt_long, size: 72, color: cs.primary),
                    const SizedBox(height: 16),
                    Text(
                      'BasicBilling',
                      style: tt.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manage your utility bill payments',
                      style: tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('Select Client', style: tt.titleMedium),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<int>(
                              initialValue: _selectedClientId,
                              decoration: const InputDecoration(
                                labelText: 'Client',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              items: kClients
                                  .map((c) => DropdownMenuItem<int>(
                                        value: c.id,
                                        child: Text('${c.id} — ${c.name}'),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _selectedClientId = value);
                                  context
                                      .read<AuthBloc>()
                                      .add(AuthLoginRequested(value));
                                }
                              },
                            ),
                            if (authState is AuthLoading) ...[
                              const SizedBox(height: 16),
                              const LinearProgressIndicator(),
                            ],
                            if (authState is AuthError) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: cs.errorContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  authState.message,
                                  style:
                                      TextStyle(color: cs.onErrorContainer),
                                ),
                              ),
                            ],
                            if (authState is AuthAuthenticated) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: cs.primaryContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.check_circle_outline,
                                        color: cs.primary, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Authenticated as ${kClients.firstWhere((c) => c.id == authState.clientId).name}',
                                        style: TextStyle(
                                            color: cs.onPrimaryContainer),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (authState is AuthAuthenticated) ...[
                      FilledButton.icon(
                        onPressed: () => context.go('/pending-bills'),
                        icon: const Icon(Icons.receipt_long),
                        label: const Text('View Pending Bills'),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.tonal(
                        onPressed: () => context.go('/pay-bill'),
                        child: const Text('Pay a Bill'),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.tonal(
                        onPressed: () => context.go('/create-bill'),
                        child: const Text('Create Bill'),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.tonal(
                        onPressed: () => context.go('/payment-history'),
                        child: const Text('Payment History'),
                      ),
                    ] else ...[
                      FilledButton(
                        onPressed: null,
                        child: const Text('Select a client to continue'),
                      ),
                    ],
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
