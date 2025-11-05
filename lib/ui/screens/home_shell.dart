import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../core/models/business.dart';
import '../../core/models/slot.dart';
import '../../core/utils/formatters.dart';
import '../../state/app_state.dart';
import '../theme/colors.dart';
import '../widgets/category_chips.dart';
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
    final theme = Theme.of(context);
    final tabs = [
      _buildFeed(context),
      _buildMap(context),
    ];

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        appBar: AppBar(
          toolbarHeight: 96,
          titleSpacing: 0,
          flexibleSpace: Container(decoration: const BoxDecoration(gradient: AppColors.appBarGradient)),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Swift Slots Nearby',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Catch Austin\'s hottest last-minute openings before they disappear.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.78),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              tooltip: 'Favorites & Watchlist',
              onPressed: () => context.push('/favorites'),
              icon: const Icon(Icons.favorite_outline, color: Colors.white),
            ),
            IconButton(
              tooltip: 'Profile',
              onPressed: () => context.push('/settings'),
              icon: const Icon(Icons.person_outline, color: Colors.white),
            ),
            IconButton(
              tooltip: 'Debug',
              onPressed: () => context.push('/debug'),
              icon: const Icon(Icons.bug_report_outlined, color: Colors.white),
            ),
          ],
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: tabs[_selectedIndex],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: AppColors.cardGradient,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: NavigationBar(
                height: 72,
                backgroundColor: Colors.transparent,
                indicatorColor: AppColors.primary.withOpacity(0.15),
                elevation: 0,
                selectedIndex: _selectedIndex,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                onDestinationSelected: (index) => setState(() => _selectedIndex = index),
                destinations: const [
                  NavigationDestination(icon: Icon(Icons.view_list), label: 'Feed'),
                  NavigationDestination(icon: Icon(Icons.map_outlined), label: 'Map'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeed(BuildContext context) {
    final filteredSlots = ref.watch(filteredSlotsProvider);
    final businesses = ref.watch(businessesProvider);
    final watchlist = ref.watch(watchlistProvider);
    final filter = ref.watch(feedFilterProvider);
    final categories = ref.watch(categoriesProvider);
    final theme = Theme.of(context);

    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          ref.refresh(slotStreamProvider);
          await Future<void>.delayed(const Duration(milliseconds: 600));
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
          children: [
            _buildHeroBanner(context, filteredSlots.length),
            const SizedBox(height: 24),
            Text(
              'Personalize your feed',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.neutral,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ChoiceChip(
                  label: const Text('Soonest first'),
                  selected: filter.sortOption == FeedSortOption.soonest,
                  onSelected: (_) =>
                      ref.read(feedFilterProvider.notifier).updateSort(FeedSortOption.soonest),
                  labelStyle: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  selectedColor: AppColors.primary.withOpacity(0.18),
                  backgroundColor: Colors.white.withOpacity(0.85),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                ChoiceChip(
                  label: const Text('Biggest discount'),
                  selected: filter.sortOption == FeedSortOption.biggestDiscount,
                  onSelected: (_) => ref
                      .read(feedFilterProvider.notifier)
                      .updateSort(FeedSortOption.biggestDiscount),
                  labelStyle: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  selectedColor: AppColors.primary.withOpacity(0.18),
                  backgroundColor: Colors.white.withOpacity(0.85),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                InputChip(
                  label: Text('Within ${filter.maxDistance.toStringAsFixed(0)} mi'),
                  avatar: const Icon(Icons.near_me, size: 18),
                  onPressed: () async {
                    final value = await showModalBottomSheet<double>(
                      context: context,
                      backgroundColor: Colors.white,
                      showDragHandle: true,
                      builder: (context) {
                        var temp = filter.maxDistance;
                        return StatefulBuilder(
                          builder: (context, setState) => Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Show slots within ${temp.toStringAsFixed(0)} miles',
                                  style: theme.textTheme.titleMedium,
                                ),
                                Slider(
                                  value: temp,
                                  min: 1,
                                  max: 15,
                                  divisions: 14,
                                  onChanged: (value) => setState(() => temp = value),
                                  activeColor: AppColors.primary,
                                ),
                                PrimaryButton(
                                  label: 'Apply radius',
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
                  backgroundColor: Colors.white.withOpacity(0.85),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                InputChip(
                  label: Text('Next ${filter.timeWindowHours}h'),
                  avatar: const Icon(Icons.schedule, size: 18),
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
                  backgroundColor: Colors.white.withOpacity(0.85),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CategoryChips(
              categories: categories,
              selected: filter.selectedCategoryIds,
              onToggle: (id) => ref.read(feedFilterProvider.notifier).toggleCategory(id),
            ),
            const SizedBox(height: 24),
            if (filteredSlots.isEmpty)
              EmptyState(
                title: 'No last-minute slots right now',
                subtitle: 'Broaden your filters or tap the debug panel to spawn fresh cancellations.',
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
          ],
        ),
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    final businesses = ref.watch(businessesProvider);
    final slotsAsync = ref.watch(slotStreamProvider);

    return SafeArea(
      child: slotsAsync.when(
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
                icon: const Icon(Icons.location_on, color: AppColors.secondary, size: 32),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    builder: (context) => _MapSlotSheet(slot: slot, business: business),
                  );
                },
              ),
            );
          }).toList();

          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppColors.cardGradient,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: FlutterMap(
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
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(child: Text('Unable to load map: $err')),
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context, int resultCount) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Feel the rush of last-minute wins',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Fresh cancellations across fitness, beauty, and wellness drop here first. ${resultCount.clamp(0, 99)} options waiting for you.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.82),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.flash_on, color: Colors.white, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      '$resultCount live',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'View lightning map',
            icon: Icons.map_outlined,
            onPressed: () => setState(() => _selectedIndex = 1),
          ),
        ],
      ),
    );
  }
}

class _MapSlotSheet extends ConsumerWidget {
  const _MapSlotSheet({required this.slot, required this.business});

  final Slot slot;
  final Business business;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        business.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.neutral,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        business.tagline,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.neutral.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                TimeChip(duration: slot.startsIn),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.cardGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${formatCurrency(slot.discountedPrice)} (save ${slot.discountPercent}% from ${formatCurrency(slot.originalPrice)})',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.neutral,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${slot.seatsRemaining} spot(s) left · ${formatTimeRange(slot.startsAt, slot.endsAt)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.neutral.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'View slot details',
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
