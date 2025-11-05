import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/app_state.dart';
import '../widgets/category_chips.dart';

class ProfileSettingsScreen extends ConsumerWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final prefs = ref.watch(userPrefsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Taylor Morgan',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('taylor@swiftslots.demo', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Interests',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  CategoryChips(
                    categories: categories,
                    selected: prefs.selectedCategoryIds,
                    onToggle: (id) => ref.read(userPrefsProvider.notifier).toggleCategory(id),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                SwitchListTile.adaptive(
                  title: const Text('Notifications'),
                  subtitle: const Text('Get alerted when watched categories drop new cancellations'),
                  value: prefs.allowNotifications,
                  onChanged: (value) => ref.read(userPrefsProvider.notifier).setNotifications(value),
                ),
                const Divider(),
                SwitchListTile.adaptive(
                  title: const Text('Use demo mode'),
                  subtitle: const Text('Auto-fill interests, location, and simulate activity instantly'),
                  value: prefs.demoMode,
                  onChanged: (value) => ref.read(userPrefsProvider.notifier).setDemoMode(value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Payment methods'),
              subtitle: const Text('Apple Pay • **** 4242'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: const Text('Privacy Policy'),
            subtitle: const Text('swiftslots.app/privacy'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('Terms of Service'),
            subtitle: const Text('swiftslots.app/terms'),
            onTap: () {},
          ),
          const SizedBox(height: 24),
          FilledButton.tonal(
            onPressed: () => showAboutDialog(
              context: context,
              applicationName: 'Swift Slots',
              applicationVersion: '1.0.0',
              children: const [
                Text('Swift Slots is a demo marketplace for last-minute wellness deals in Austin, TX.'),
              ],
            ),
            child: const Text('About Swift Slots'),
          ),
        ],
      ),
    );
  }
}
