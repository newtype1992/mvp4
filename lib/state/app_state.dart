import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/business.dart';
import '../core/models/category.dart';
import '../core/models/slot.dart';
import '../core/models/user_prefs.dart';
import '../core/services/mock_data_service.dart';
import '../core/services/notification_service.dart';
import '../core/services/pay_service.dart';

final mockDataServiceProvider = Provider<MockDataService>((ref) {
  final service = MockDataService();
  ref.onDispose(service.dispose);
  return service;
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final service = NotificationService();
  service.initialize();
  return service;
});

final payServiceProvider = Provider((ref) => PayService());

final categoriesProvider = Provider<List<Category>>(
  (ref) => ref.watch(mockDataServiceProvider).categories,
);

final businessesProvider = Provider<List<Business>>(
  (ref) => ref.watch(mockDataServiceProvider).businesses,
);

final slotStreamProvider = StreamProvider<List<Slot>>(
  (ref) => ref.watch(mockDataServiceProvider).slotStream,
);

enum FeedSortOption { soonest, biggestDiscount }

class FeedFilter {
  FeedFilter({
    this.selectedCategoryIds = const [],
    this.maxDistance = 10,
    this.timeWindowHours = 12,
    this.sortOption = FeedSortOption.soonest,
  });

  final List<String> selectedCategoryIds;
  final double maxDistance;
  final int timeWindowHours;
  final FeedSortOption sortOption;

  FeedFilter copyWith({
    List<String>? selectedCategoryIds,
    double? maxDistance,
    int? timeWindowHours,
    FeedSortOption? sortOption,
  }) {
    return FeedFilter(
      selectedCategoryIds: selectedCategoryIds ?? this.selectedCategoryIds,
      maxDistance: maxDistance ?? this.maxDistance,
      timeWindowHours: timeWindowHours ?? this.timeWindowHours,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}

class FeedFilterNotifier extends StateNotifier<FeedFilter> {
  FeedFilterNotifier() : super(FeedFilter());

  void toggleCategory(String categoryId) {
    final current = [...state.selectedCategoryIds];
    if (current.contains(categoryId)) {
      current.remove(categoryId);
    } else {
      current.add(categoryId);
    }
    state = state.copyWith(selectedCategoryIds: current);
  }

  void updateDistance(double value) => state = state.copyWith(maxDistance: value);

  void updateTimeWindow(int hours) =>
      state = state.copyWith(timeWindowHours: hours);

  void updateSort(FeedSortOption option) =>
      state = state.copyWith(sortOption: option);

  void reset(List<String> categories) {
    state = FeedFilter(selectedCategoryIds: categories);
  }
}

final feedFilterProvider =
    StateNotifierProvider<FeedFilterNotifier, FeedFilter>((ref) {
  final selected = ref.watch(userPrefsProvider.select((value) => value.selectedCategoryIds));
  return FeedFilterNotifier()..reset(selected);
});

class UserPrefsNotifier extends StateNotifier<UserPrefs> {
  UserPrefsNotifier()
      : super(const UserPrefs(
          selectedCategoryIds: [],
          allowNotifications: false,
          allowLocation: false,
          sampleCity: 'Austin',
          demoMode: true,
        ));

  void toggleCategory(String categoryId) {
    final next = [...state.selectedCategoryIds];
    if (next.contains(categoryId)) {
      next.remove(categoryId);
    } else {
      next.add(categoryId);
    }
    state = state.copyWith(selectedCategoryIds: next);
  }

  void setNotifications(bool value) =>
      state = state.copyWith(allowNotifications: value);

  void setLocation(bool value) => state = state.copyWith(allowLocation: value);

  void setDemoMode(bool value) => state = state.copyWith(demoMode: value);

  void loadDemoDefaults(List<String> categories) {
    state = state.copyWith(
      selectedCategoryIds: categories.take(4).toList(),
      allowLocation: true,
      allowNotifications: true,
    );
  }
}

final userPrefsProvider =
    StateNotifierProvider<UserPrefsNotifier, UserPrefs>((ref) {
  final categories = ref.watch(categoriesProvider);
  return UserPrefsNotifier()
    ..loadDemoDefaults(categories.map((e) => e.id).toList());
});

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super(SplayTreeSet());

  void toggle(String businessId) {
    final next = SplayTreeSet<String>.from(state);
    if (next.contains(businessId)) {
      next.remove(businessId);
    } else {
      next.add(businessId);
    }
    state = next;
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier();
});

class WatchlistNotifier extends StateNotifier<Set<String>> {
  WatchlistNotifier() : super(SplayTreeSet());

  void toggle(String slotId) {
    final next = SplayTreeSet<String>.from(state);
    if (next.contains(slotId)) {
      next.remove(slotId);
    } else {
      next.add(slotId);
    }
    state = next;
  }
}

final watchlistProvider =
    StateNotifierProvider<WatchlistNotifier, Set<String>>((ref) {
  return WatchlistNotifier();
});

class CheckoutState {
  const CheckoutState({
    required this.activeSlot,
    required this.isProcessing,
    required this.isSuccess,
  });

  final Slot? activeSlot;
  final bool isProcessing;
  final bool isSuccess;

  CheckoutState copyWith({
    Slot? activeSlot,
    bool? isProcessing,
    bool? isSuccess,
  }) {
    return CheckoutState(
      activeSlot: activeSlot ?? this.activeSlot,
      isProcessing: isProcessing ?? this.isProcessing,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class CheckoutNotifier extends StateNotifier<CheckoutState> {
  CheckoutNotifier() : super(const CheckoutState(activeSlot: null, isProcessing: false, isSuccess: false));

  void setSlot(Slot slot) {
    state = CheckoutState(activeSlot: slot, isProcessing: false, isSuccess: false);
  }

  void setProcessing(bool value) {
    state = state.copyWith(isProcessing: value);
  }

  void markSuccess() {
    state = state.copyWith(isProcessing: false, isSuccess: true);
  }

  void reset() {
    state = const CheckoutState(activeSlot: null, isProcessing: false, isSuccess: false);
  }
}

final checkoutProvider =
    StateNotifierProvider<CheckoutNotifier, CheckoutState>((ref) {
  return CheckoutNotifier();
});

final filteredSlotsProvider = Provider<List<Slot>>((ref) {
  final slotsAsync = ref.watch(slotStreamProvider);
  final businesses = ref.watch(businessesProvider);
  final filter = ref.watch(feedFilterProvider);

  return slotsAsync.maybeWhen(
    data: (slots) {
      var filtered = slots.where((slot) {
        final business =
            businesses.firstWhere((element) => element.id == slot.businessId);
        final matchesCategory = filter.selectedCategoryIds.isEmpty ||
            filter.selectedCategoryIds.contains(slot.categoryId);
        final matchesDistance = business.distanceMiles <= filter.maxDistance;
        final withinWindow =
            slot.startsAt.isBefore(DateTime.now().add(Duration(hours: filter.timeWindowHours)));
        return matchesCategory && matchesDistance && withinWindow;
      }).toList();
      filtered.sort((a, b) {
        if (filter.sortOption == FeedSortOption.biggestDiscount) {
          return b.discountPercent.compareTo(a.discountPercent);
        }
        return a.startsAt.compareTo(b.startsAt);
      });
      return filtered;
    },
    orElse: () => const [],
  );
});
