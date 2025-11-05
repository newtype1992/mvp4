import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../core/models/business.dart';
import '../../core/models/slot.dart';
import '../../core/utils/formatters.dart';
import '../../state/app_state.dart';
import '../widgets/empty_state.dart';
import '../widgets/primary_button.dart';
import '../widgets/slot_card.dart';
import '../widgets/time_chip.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _buildFeed(context),
      _buildMap(context),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swift Slots Nearby'),
        actions: [
          IconButton(
            tooltip: 'Favorites & Watchlist',
            onPressed: () => context.push('/favorites'),
            icon: const Icon(Icons.favorite_outline),
          ),
          IconButton(
            tooltip: 'Profile',
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.person_outline),
          ),
          IconButton(
            tooltip: 'Debug',
            onPressed: () => context.push('/debug'),
            icon: const Icon(Icons.bug_report_outlined),
          ),
        ],
      ),
      body: tabs[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.view_list), label: 'Feed'),
          NavigationDestination(icon: Icon(Icons.map_outlined), label: 'Map'),
        ],
      ),
    );
  }

  Widget _buildFeed(BuildContext context) {
    final filteredSlots = ref.watch(filteredSlotsProvider);
    final businesses = ref.watch(businessesProvider);
    final watchlist = ref.watch(watchlistProvider);
    final filter = ref.watch(feedFilterProvider);
    final categories = ref.watch(categoriesProvider);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(slotStreamProvider);
          await Future<void>.delayed(const Duration(milliseconds: 600));
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ChoiceChip(
                  label: const Text('Soonest first'),
                  selected: filter.sortOption == FeedSortOption.soonest,
                  onSelected: (_) =>
                      ref.read(feedFilterProvider.notifier).updateSort(FeedSortOption.soonest),
                ),
                ChoiceChip(
                  label: const Text('Biggest discount'),
                  selected: filter.sortOption == FeedSortOption.biggestDiscount,
                  onSelected: (_) => ref
                      .read(feedFilterProvider.notifier)
                      .updateSort(FeedSortOption.biggestDiscount),
                ),
                InputChip(
                  label: Text('Within ${filter.maxDistance.toStringAsFixed(0)} mi'),
                  avatar: const Icon(Icons.near_me),
                  onPressed: () async {
                    final value = await showModalBottomSheet<double>(
                      context: context,
                      builder: (context) {
                        var temp = filter.maxDistance;
                        return StatefulBuilder(
                          builder: (context, setState) => Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Show slots within ${temp.toStringAsFixed(0)} miles'),
                                Slider(
                                  value: temp,
                                  min: 1,
                                  max: 15,
                                  divisions: 14,
                                  onChanged: (value) => setState(() => temp = value),
                                ),
                                PrimaryButton(
                                  label: 'Apply',
                                  onPressed: () => Navigator.of(context).pop(temp),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                    if (value != null) {
                      ref.read(feedFilterProvider.notifier).updateDistance(value);
                    }
                  },
                ),
                InputChip(
                  label: Text('Next ${filter.timeWindowHours}h'),
                  avatar: const Icon(Icons.schedule),
                  onPressed: () async {
                    final value = await showMenu<int>(
                      context: context,
                      position: const RelativeRect.fromLTRB(16, 200, 16, 0),
                      items: [4, 8, 12, 24]
                          .map((hours) => PopupMenuItem(value: hours, child: Text('Within $hours hours')))
                          .toList(),
                    );
                    if (value != null) {
                      ref.read(feedFilterProvider.notifier).updateTimeWindow(value);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: categories
                  .map(
                    (category) => FilterChip(
                      label: Text('${category.emoji} ${category.name}'),
                      selected: filter.selectedCategoryIds.contains(category.id),
                      onSelected: (_) =>
                          ref.read(feedFilterProvider.notifier).toggleCategory(category.id),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            if (filteredSlots.isEmpty)
              EmptyState(
                title: 'No last-minute slots right now',
                subtitle: 'Broaden your filters or check the debug panel to spawn fresh cancellations.',
                action: PrimaryButton(
                  label: 'Reset filters',
                  onPressed: () => ref.read(feedFilterProvider.notifier).reset([]),
                ),
              ),
            for (final slot in filteredSlots)
              SlotCard(
                slot: slot,
                business: businesses.firstWhere((biz) => biz.id == slot.businessId),
                isWatched: watchlist.contains(slot.id),
                onWatchToggle: () => ref.read(watchlistProvider.notifier).toggle(slot.id),
                onTap: () => context.push('/slot/${slot.id}'),
              ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    final businesses = ref.watch(businessesProvider);
    final slotsAsync = ref.watch(slotStreamProvider);

    return slotsAsync.when(
      data: (slots) {
        final markers = slots.map((slot) {
          final business = businesses.firstWhere((b) => b.id == slot.businessId);
          return Marker(
            point: LatLng(business.latitude, business.longitude),
            width: 60,
            height: 60,
            builder: (context) => IconButton(
              tooltip:
                  '${business.name} · ${formatCurrency(slot.discountedPrice)} · ${formatStartsIn(slot.startsIn)}',
              icon: const Icon(Icons.location_on, color: Colors.redAccent, size: 32),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  showDragHandle: true,
                  isScrollControlled: true,
                  builder: (context) => _MapSlotSheet(slot: slot, business: business),
                );
              },
            ),
          );
        }).toList();

        return FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(businesses.first.latitude, businesses.first.longitude),
            initialZoom: 12.5,
            interactionOptions: const InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.swift_slots',
            ),
            MarkerLayer(markers: markers),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Unable to load map: $err')),
    );
  }
}

class _MapSlotSheet extends ConsumerWidget {
  const _MapSlotSheet({required this.slot, required this.business});

  final Slot slot;
  final Business business;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(business.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                TimeChip(duration: slot.startsIn),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              business.tagline,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              '${formatCurrency(slot.discountedPrice)} (save ${slot.discountPercent}% from ${formatCurrency(slot.originalPrice)})',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: 'View slot',
              icon: Icons.arrow_forward,
              onPressed: () {
                Navigator.of(context).pop();
                GoRouter.of(context).push('/slot/${slot.id}');
              },
            ),
          ],
        ),
      ),
    );
  }
}
