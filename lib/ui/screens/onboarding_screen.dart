import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../state/app_state.dart';
import '../theme/colors.dart';
import '../widgets/category_chips.dart';
import '../widgets/primary_button.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final selected = ref.watch(userPrefsProvider.select((value) => value.selectedCategoryIds));
    final theme = Theme.of(context);
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Swift Slots',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Curated last-minute wins, tailored to you',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.neutral,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Austin\'s real-time marketplace for discounted last-minute fitness, beauty, and wellness openings.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.neutral.withOpacity(0.75),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: AppColors.heroGradient,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 30,
                        offset: const Offset(0, 18),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last-minute cancellations? We fill them fast.',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Tap the categories you love to unlock hyper-relevant alerts and instant bookings.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.85),
                          fontWeight: FontWeight.w500,
                        ),
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
                        Text(
                          'What are you into today?',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.neutral,
                          ),
                        ),
                        const SizedBox(height: 12),
                        CategoryChips(
                          categories: categories,
                          selected: selected,
                          onToggle: (id) => ref.read(userPrefsProvider.notifier).toggleCategory(id),
                        ),
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: AppColors.cardGradient,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Enable Demo Mode',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.neutral,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Auto-tailor interests and generate fresh cancellations for rich demos.',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: AppColors.neutral.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: ref.watch(userPrefsProvider.select((value) => value.demoMode)),
                                onChanged: (value) => ref.read(userPrefsProvider.notifier).setDemoMode(value),
                                activeColor: Colors.white,
                                activeTrackColor: AppColors.secondary,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'You can adjust notifications, payments, and legal settings anytime from your profile.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.neutral.withOpacity(0.6),
                          ),
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
      ),
    );
  }
}
