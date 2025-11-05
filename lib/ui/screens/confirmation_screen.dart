import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/formatters.dart';
import '../../state/app_state.dart';
import '../widgets/primary_button.dart';

class ConfirmationScreen extends ConsumerWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutState = ref.watch(checkoutProvider);
    final slot = checkoutState.activeSlot;
    final businesses = ref.watch(businessesProvider);
    if (slot == null) {
      return const Scaffold(body: Center(child: Text('No booking found.')));
    }
    final business = businesses.firstWhere((biz) => biz.id == slot.businessId);

    return Scaffold(
      appBar: AppBar(title: const Text('You\'re all set!')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.verified, color: Colors.green, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Booked ${business.name} for ${formatTimeRange(slot.startsAt, slot.endsAt)}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Column(
                children: [
                  const Icon(Icons.qr_code_2, size: 120),
                  const SizedBox(height: 12),
                  Text(
                    'Show this QR code at check-in',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Booking ID: SWIFT-${slot.id.substring(0, 6).toUpperCase()}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Next steps',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Add to calendar'),
              subtitle: const Text('Sends an .ics file download (stubbed)'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.navigation),
              title: const Text('Get directions'),
              subtitle: Text('${business.address}, ${business.city}'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text('Share booking'),
              subtitle: const Text('Invite a friend to join you'),
              onTap: () {},
            ),
            const Spacer(),
            PrimaryButton(
              label: 'Back to home',
              icon: Icons.home,
              onPressed: () {
                ref.read(checkoutProvider.notifier).reset();
                context.go('/home');
              },
            ),
          ],
        ),
      ),
    );
  }
}
