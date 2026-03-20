import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  final String? filterServiceType;
  final String? orderBy;
  final ValueChanged<String?> onFilterChanged;
  final ValueChanged<String?> onOrderByChanged;
  final Map<String, String> orderByOptions;

  const FilterBar({
    super.key,
    required this.filterServiceType,
    required this.orderBy,
    required this.onFilterChanged,
    required this.onOrderByChanged,
    required this.orderByOptions,
  });

  static const _serviceTypes = ['Water', 'Electricity', 'Sewer'];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    Widget dropdown({
      required String label,
      required String? value,
      required List<DropdownMenuItem<String?>> items,
      required ValueChanged<String?> onChanged,
    }) {
      return InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
        child: DropdownButton<String?>(
          value: value,
          isExpanded: true,
          underline: const SizedBox.shrink(),
          style: tt.bodyMedium?.copyWith(color: cs.onSurface),
          items: items,
          onChanged: onChanged,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: dropdown(
              label: 'Service',
              value: filterServiceType,
              items: [
                const DropdownMenuItem(value: null, child: Text('All')),
                ..._serviceTypes.map(
                  (s) => DropdownMenuItem(value: s, child: Text(s)),
                ),
              ],
              onChanged: onFilterChanged,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: dropdown(
              label: 'Sort by',
              value: orderBy,
              items: [
                const DropdownMenuItem(value: null, child: Text('Default')),
                ...orderByOptions.entries.map(
                  (e) =>
                      DropdownMenuItem(value: e.key, child: Text(e.value)),
                ),
              ],
              onChanged: onOrderByChanged,
            ),
          ),
        ],
      ),
    );
  }
}
