import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/business.dart';
import '../../state/app_state.dart';
import '../widgets/kpi_chip.dart';
import '../widgets/mini_chart.dart';
import '../widgets/primary_button.dart';
import '../widgets/rating_stars.dart';
import '../widgets/slot_card.dart';

class BusinessDetailScreen extends ConsumerWidget {
  const BusinessDetailScreen({super.key, required this.businessId});

  final String businessId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final business = ref.watch(businessesProvider).firstWhere((biz) => biz.id == businessId);
    final slotsAsync = ref.watch(slotStreamProvider);
    final favorites = ref.watch(favoritesProvider);
    final watchlist = ref.watch(watchlistProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(business.name),
        actions: [
          IconButton(
            icon: Icon(
              favorites.contains(business.id) ? Icons.favorite : Icons.favorite_border,
            ),
            onPressed: () => ref.read(favoritesProvider.notifier).toggle(business.id),
          ),
        ],
      ),
      body: slotsAsync.when(
        data: (slots) {
          final businessSlots = slots.where((slot) => slot.businessId == business.id).toList();
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: business.heroImage,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        business.tagline,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      RatingStars(rating: business.rating, reviewCount: business.reviewCount),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: const [
                          KPIChip(label: 'Avg. Fill Time', value: '17m', icon: Icons.flash_on),
                          KPIChip(label: 'Repeat guests', value: '63%', icon: Icons.repeat),
                          KPIChip(label: 'Satisfaction', value: '4.8', icon: Icons.emoji_emotions),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Why locals love this spot',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Meticulously sanitized stations, upbeat coaches, and dynamic classes keep Austin regulars coming back. Last-minute cancellations unlock deep savings, so you can be spontaneous without the guilt.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Capacity trends',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      const MiniChart(points: [4, 3.5, 4.2, 3.8, 4.8, 4.6, 4.9]),
                      const SizedBox(height: 24),
                      Text('Upcoming flash deals',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      for (final slot in businessSlots)
                        SlotCard(
                          slot: slot,
                          business: business,
                          isWatched: watchlist.contains(slot.id),
                          onWatchToggle: () => ref.read(watchlistProvider.notifier).toggle(slot.id),
                          onTap: () => context.push('/slot/${slot.id}'),
                        ),
                      if (businessSlots.isEmpty)
                        const Text('No active deals. Tap Watch to get notified when cancellations appear.'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        error: (err, stack) => Center(child: Text('Error loading business: $err')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: PrimaryButton(
          label: favorites.contains(business.id) ? 'Favorited' : 'Add to favorites',
          icon: Icons.favorite,
          onPressed: () => ref.read(favoritesProvider.notifier).toggle(business.id),
        ),
      ),
    );
  }
}
