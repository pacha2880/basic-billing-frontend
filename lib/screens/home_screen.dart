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
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final selectedName = authState is AuthAuthenticated
        ? kClients.firstWhere((c) => c.id == authState.clientId).name
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('BasicBilling Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Client'),
            const SizedBox(height: 8),
            DropdownButton<int>(
              value: _selectedClientId,
              hint: const Text('Choose a client'),
              items: kClients
                  .map((client) => DropdownMenuItem<int>(
                        value: client.id,
                        child: Text('${client.id} - ${client.name}'),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedClientId = value;
                  });
                  context.read<AuthBloc>().add(AuthLoginRequested(value));
                }
              },
            ),
            const SizedBox(height: 16),
            if (selectedName != null) ...[
              Text('Authenticated as $selectedName'),
              const SizedBox(height: 16),
            ],
            ElevatedButton(
              onPressed: () => context.go('/pending-bills'),
              child: const Text('Pending Bills'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/pay-bill'),
              child: const Text('Pay Bill'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/create-bill'),
              child: const Text('Create Bill'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/payment-history'),
              child: const Text('Payment History'),
            ),
            const SizedBox(height: 8),
            if (authState is AuthLoading) const CircularProgressIndicator(),
            if (authState is AuthError) Text('Error: ${authState.message}'),
          ],
        ),
      ),
    );
  }
}
