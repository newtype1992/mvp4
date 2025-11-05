import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../state/slot_providers.dart';
import '../theme/colors.dart';
import '../widgets/slot_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slots = ref.watch(slotPresentationProvider);
    final feedState = ref.watch(slotFeedProvider);
    final saved = ref.watch(savedSlotsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.neutral025,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(
                'Swift Slots',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Claim the best last-minute deals nearby',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.neutral500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              _DemoModeToggle(isOn: feedState.isDemoMode),
              if (feedState.isDemoMode) ...[
                const SizedBox(height: 12),
                _DemoRefreshButton(onTap: () {
                  ref.read(slotFeedProvider.notifier).refreshDemoSlots();
                }),
              ],
              const SizedBox(height: 16),
              Expanded(
                child: slots.isEmpty
                    ? const _EmptyState()
                    : ListView.separated(
                        itemCount: slots.length,
                        padding: const EdgeInsets.only(bottom: 24),
                        separatorBuilder: (_, __) => const SizedBox(height: 18),
                        itemBuilder: (context, index) {
                          final slot = slots[index];
                          final isSaved = saved.contains(slot.slot.id);
                          return SlotCard(
                            data: slot,
                            isSaved: isSaved,
                            onSaveTap: () => ref
                                .read(slotFeedProvider.notifier)
                                .toggleSaved(slot.slot.id),
                            onTap: () => context.push('/slot/${slot.slot.id}'),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoModeToggle extends ConsumerWidget {
  const _DemoModeToggle({required this.isOn});

  final bool isOn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.neutral100),
      ),
      child: Row(
        children: [
          Icon(Icons.flash_on_rounded, color: AppColors.supportYellow),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Demo mode',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutral800,
                  ),
                ),
                Text(
                  'Generate fresh slots to simulate live inventory',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.neutral500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isOn,
            onChanged: (_) => ref.read(slotFeedProvider.notifier).toggleDemoMode(),
            activeColor: AppColors.cta500,
          ),
        ],
      ),
    );
  }
}

class _DemoRefreshButton extends StatelessWidget {
  const _DemoRefreshButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.highlight500,
          side: const BorderSide(color: AppColors.highlight200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        icon: const Icon(Icons.refresh_rounded),
        label: Text(
          'Shuffle available slots',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off_rounded, size: 48, color: AppColors.neutral300),
          const SizedBox(height: 16),
          Text(
            'No slots right now',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.neutral700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Toggle demo mode to generate sample openings.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.neutral500,
            ),
          ),
        ],
      ),
    );
  }
}
