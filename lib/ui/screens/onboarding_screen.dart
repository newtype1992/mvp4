import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../state/app_state.dart';
import '../widgets/category_chips.dart';
import '../widgets/primary_button.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final selected = ref.watch(userPrefsProvider.select((value) => value.selectedCategoryIds));
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text('Swift Slots',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.primary,
                  )),
              const SizedBox(height: 12),
              Text(
                'Austin\'s real-time marketplace for discounted last-minute fitness, beauty, and wellness openings.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.secondary]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Last-minute cancellations? Swift Slots fills them fast.',
                        style: theme.textTheme.titleLarge
                            ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the categories you love to get hyper-relevant alerts and instant bookings.',
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('What are you into today?',
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      CategoryChips(
                        categories: categories,
                        selected: selected,
                        onToggle: (id) => ref.read(userPrefsProvider.notifier).toggleCategory(id),
                      ),
                      const SizedBox(height: 32),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Enable Demo Mode'),
                        subtitle: const Text('Auto-tailor interests and generate new cancellations for rich demos.'),
                        trailing: Switch(
                          value: ref.watch(userPrefsProvider.select((value) => value.demoMode)),
                          onChanged: (value) => ref.read(userPrefsProvider.notifier).setDemoMode(value),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'You can adjust notifications, payments, and legal settings anytime from your profile.',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                      ),
                    ],
                  ),
                ),
              ),
              PrimaryButton(
                label: 'Continue',
                onPressed: () => context.go('/permissions'),
                icon: Icons.arrow_forward,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
