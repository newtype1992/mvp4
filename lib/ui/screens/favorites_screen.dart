import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/business.dart';
import '../../core/models/slot.dart';
import '../../core/utils/formatters.dart';
import '../../state/app_state.dart';
import '../widgets/empty_state.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final watchlist = ref.watch(watchlistProvider);
    final businesses = ref.watch(businessesProvider);
    final slotsAsync = ref.watch(slotStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites & Watchlist')),
      body: slotsAsync.when(
        data: (slots) {
          final favoriteBusinesses = businesses.where((biz) => favorites.contains(biz.id)).toList();
          final watchedSlots = slots.where((slot) => watchlist.contains(slot.id)).toList();
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text('Businesses you love',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              if (favoriteBusinesses.isEmpty)
                EmptyState(
                  title: 'No favorites yet',
                  subtitle: 'Tap the heart on any business to keep it handy.',
                )
              else
                ...favoriteBusinesses.map((business) => _FavoriteBusinessTile(business: business)),
              const SizedBox(height: 24),
              Text('Watched slots',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              if (watchedSlots.isEmpty)
                EmptyState(
                  title: 'No watched slots',
                  subtitle: 'Toggle “Watch slot” to get instant alerts for drops.',
                )
              else
                ...watchedSlots.map((slot) => _WatchedSlotTile(slot: slot)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Unable to load favorites: $err')),
      ),
    );
  }
}

class _FavoriteBusinessTile extends ConsumerWidget {
  const _FavoriteBusinessTile({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      leading: CircleAvatar(backgroundImage: NetworkImage(business.heroImage)),
      title: Text(business.name),
      subtitle: Text('${business.rating.toStringAsFixed(1)} • ${business.address}'),
      trailing: IconButton(
        icon: const Icon(Icons.chevron_right),
        onPressed: () => context.push('/business/${business.id}'),
      ),
    );
  }
}

class _WatchedSlotTile extends ConsumerWidget {
  const _WatchedSlotTile({required this.slot});

  final Slot slot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final businesses = ref.watch(businessesProvider);
    final business = businesses.firstWhere((biz) => biz.id == slot.businessId);
    return Card(
      child: ListTile(
        leading: const Icon(Icons.visibility),
        title: Text('${business.name} · ${formatTimeRange(slot.startsAt, slot.endsAt)}'),
        subtitle: Text('Starts ${formatStartsIn(slot.startsIn)} • ${formatCurrency(slot.discountedPrice)}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => ref.read(watchlistProvider.notifier).toggle(slot.id),
        ),
        onTap: () => context.push('/slot/${slot.id}'),
      ),
    );
  }
}
