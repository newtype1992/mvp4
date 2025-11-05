import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../state/app_state.dart';
import '../widgets/primary_button.dart';

class PermissionsScreen extends ConsumerWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(userPrefsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Stay in the know')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Swift Slots works best with your location and notification preferences. Everything is simulated and opt-in.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SwitchListTile.adaptive(
                      title: const Text('Share approximate location'),
                      subtitle: const Text('We\'ll surface deals within a few miles of you in Austin.'),
                      value: prefs.allowLocation,
                      onChanged: (value) {
                        ref.read(userPrefsProvider.notifier).setLocation(value);
                      },
                    ),
                    const Divider(),
                    SwitchListTile.adaptive(
                      title: const Text('Send heads-up notifications'),
                      subtitle: const Text('Opt-in to get pinged when watched categories drop new cancellations.'),
                      value: prefs.allowNotifications,
                      onChanged: (value) async {
                        ref.read(userPrefsProvider.notifier).setNotifications(value);
                        if (value) {
                          await ref.read(notificationServiceProvider).requestPermission();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            PrimaryButton(
              label: 'Launch marketplace',
              icon: Icons.rocket_launch,
              onPressed: () => context.go('/home'),
            ),
          ],
        ),
      ),
    );
  }
}
