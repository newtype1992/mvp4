import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../state/slot_providers.dart';
import '../theme/colors.dart';

class ConfirmBookingScreen extends ConsumerWidget {
  const ConfirmBookingScreen({super.key, required this.slotId});

  final String slotId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slot = slotById(ref, slotId);
    final business = slot != null ? businessById(ref, slot.businessId) : null;
    if (slot == null || business == null) {
      return const Scaffold(
        body: Center(child: Text('Slot unavailable')),
      );
    }
    final theme = Theme.of(context);
    final when = slot.startsAt.toLocal();
    final dateFormatter = DateFormat('EEE, MMM d');
    final timeFormatter = DateFormat('h:mm a');

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm booking')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              business.name,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.neutral900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              slot.service,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.neutral600,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.neutral100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SummaryRow(
                    label: 'When',
                    value: '${dateFormatter.format(when)} · ${timeFormatter.format(when)}',
                  ),
                  const Divider(height: 24),
                  _SummaryRow(
                    label: 'Duration',
                    value: '${slot.durationMinutes} minutes',
                  ),
                  const Divider(height: 24),
                  _SummaryRow(
                    label: 'Total due today',
                    value: '\$${slot.finalPrice.toStringAsFixed(0)}',
                    highlight: true,
                  ),
                ],
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () => context.pushReplacement('/slot/$slotId/confirmation'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              child: const Text('Confirm and book'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Back to details'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.neutral500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: highlight ? AppColors.cta500 : AppColors.neutral800,
            fontWeight: highlight ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
