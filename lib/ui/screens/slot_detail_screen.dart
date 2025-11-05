import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/models/business.dart';
import '../../state/slot_providers.dart';
import '../theme/colors.dart';

class SlotDetailScreen extends ConsumerWidget {
  const SlotDetailScreen({super.key, required this.slotId});

  final String slotId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slot = slotById(ref, slotId);
    if (slot == null) {
      return const _SlotNotFound();
    }
    final business = businessById(ref, slot.businessId);
    if (business == null) {
      return const _SlotNotFound();
    }
    final saved = ref.watch(savedSlotsProvider).contains(slot.id);
    final theme = Theme.of(context);
    final dateFormat = DateFormat('EEEE, MMM d');
    final timeFormat = DateFormat('h:mm a');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Slot details'),
        actions: [
          IconButton(
            onPressed: () => ref.read(slotFeedProvider.notifier).toggleSaved(slot.id),
            icon: Icon(
              saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: FilledButton(
          onPressed: () => context.push('/slot/$slotId/confirm'),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          child: const Text('Book now'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.network(
                business.heroImage,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              business.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.neutral900,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.place_outlined, color: AppColors.highlight400, size: 18),
                const SizedBox(width: 6),
                Text(
                  business.address,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.neutral500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.neutral100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _InfoBadge(
                        icon: Icons.calendar_today_rounded,
                        label: dateFormat.format(slot.startsAt),
                      ),
                      const SizedBox(width: 12),
                      _InfoBadge(
                        icon: Icons.access_time_filled,
                        label: timeFormat.format(slot.startsAt),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    slot.service,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.neutral800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    slot.notes,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.neutral500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        '\$${slot.finalPrice.toStringAsFixed(0)}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: AppColors.cta500,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '\$${slot.originalPrice.toStringAsFixed(0)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.neutral400,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.supportPink,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '-${slot.discountPercent}%',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _BusinessHighlights(business: business),
          ],
        ),
      ),
    );
  }
}

class _BusinessHighlights extends StatelessWidget {
  const _BusinessHighlights({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.neutral025,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.star_rounded, color: AppColors.supportYellow),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${business.rating.toStringAsFixed(1)} rating',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutral800,
                  ),
                ),
                Text(
                  business.category,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.neutral500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  const _InfoBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.neutral050,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.highlight400, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.neutral600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SlotNotFound extends StatelessWidget {
  const _SlotNotFound();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Slot not found'),
      ),
    );
  }
}
