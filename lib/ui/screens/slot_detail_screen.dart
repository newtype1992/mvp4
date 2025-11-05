import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/business.dart';
import '../../core/models/slot.dart';
import '../../core/utils/formatters.dart';
import '../../state/app_state.dart';
import '../widgets/discount_badge.dart';
import '../widgets/primary_button.dart';
import '../widgets/time_chip.dart';

class SlotDetailScreen extends ConsumerWidget {
  const SlotDetailScreen({super.key, required this.slotId});

  final String slotId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slotsAsync = ref.watch(slotStreamProvider);
    final businesses = ref.watch(businessesProvider);
    final watchlist = ref.watch(watchlistProvider);

    return slotsAsync.when(
      data: (slots) {
        final slot = slots.firstWhere((s) => s.id == slotId);
        final business = businesses.firstWhere((b) => b.id == slot.businessId);
        final isWatched = watchlist.contains(slot.id);
        return Scaffold(
          appBar: AppBar(
            title: Text(business.name),
            actions: [
              IconButton(
                onPressed: () => ref.read(watchlistProvider.notifier).toggle(slot.id),
                icon: Icon(isWatched ? Icons.visibility : Icons.visibility_outlined),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: business.heroImage,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: DiscountBadge(discountPercent: slot.discountPercent),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        business.tagline,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      TimeChip(duration: slot.startsIn),
                      const SizedBox(height: 12),
                      Text(
                        '${formatCurrency(slot.discountedPrice)} today (save ${slot.discountPercent}% off ${formatCurrency(slot.originalPrice)})',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Session window: ${formatTimeRange(slot.startsAt, slot.endsAt)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${slot.seatsRemaining} spot(s) left · Free cancellation up to 2h before start',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'What to know',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Arrive 10 minutes early to sign in. Bring water and a towel. Smart locks unlock using the confirmation QR code you receive at checkout.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      const Text('Cancellation policy',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text(slot.cancelPolicy, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 16),
                      const Text('Share the hype',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 12,
                        children: [
                          ActionChip(
                            avatar: const Icon(Icons.ios_share),
                            label: const Text('Share'),
                            onPressed: () {},
                          ),
                          ActionChip(
                            avatar: const Icon(Icons.calendar_today),
                            label: const Text('Add to calendar'),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: isWatched ? 'Watching' : 'Watch slot',
                    icon: Icons.visibility,
                    onPressed: () => ref.read(watchlistProvider.notifier).toggle(slot.id),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: 'Book now',
                    icon: Icons.lock_clock,
                    onPressed: () {
                      ref.read(checkoutProvider.notifier).setSlot(slot);
                      context.push('/checkout');
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Slot not found: $err'))),
    );
  }
}
