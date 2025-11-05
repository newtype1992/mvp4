import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../core/models/business.dart';
import '../core/models/slot.dart';
import '../core/services/slot_service.dart';

final slotServiceProvider = Provider<SlotService>((ref) => const SlotService());

final businessesProvider = Provider<List<Business>>((ref) {
  final service = ref.watch(slotServiceProvider);
  return service.loadBusinesses();
});

class SlotFeedState {
  const SlotFeedState({
    required this.slots,
    required this.isDemoMode,
    required this.savedSlotIds,
  });

  final List<Slot> slots;
  final bool isDemoMode;
  final Set<String> savedSlotIds;

  SlotFeedState copyWith({
    List<Slot>? slots,
    bool? isDemoMode,
    Set<String>? savedSlotIds,
  }) {
    return SlotFeedState(
      slots: slots ?? this.slots,
      isDemoMode: isDemoMode ?? this.isDemoMode,
      savedSlotIds: savedSlotIds ?? this.savedSlotIds,
    );
  }

  static SlotFeedState initial(List<Slot> slots) => SlotFeedState(
        slots: slots,
        isDemoMode: false,
        savedSlotIds: <String>{},
      );
}

class SlotFeedController extends StateNotifier<SlotFeedState> {
  SlotFeedController(this._service)
      : super(SlotFeedState.initial(_service.loadSeededSlots()));

  final SlotService _service;

  void toggleDemoMode() {
    if (state.isDemoMode) {
      state = state.copyWith(
        isDemoMode: false,
        slots: _service.loadSeededSlots(),
      );
    } else {
      state = state.copyWith(
        isDemoMode: true,
        slots: _service.generateDemoSlots(),
      );
    }
  }

  void refreshDemoSlots() {
    if (!state.isDemoMode) return;
    state = state.copyWith(slots: _service.generateDemoSlots());
  }

  void toggleSaved(String slotId) {
    final next = {...state.savedSlotIds};
    if (!next.add(slotId)) {
      next.remove(slotId);
    }
    state = state.copyWith(savedSlotIds: next);
  }
}

final slotFeedProvider =
    StateNotifierProvider<SlotFeedController, SlotFeedState>((ref) {
  final service = ref.watch(slotServiceProvider);
  return SlotFeedController(service);
});

class SlotPresentation {
  SlotPresentation({
    required this.slot,
    required this.business,
  });

  final Slot slot;
  final Business business;

  String get discountLabel => '-${slot.discountPercent}%';

  String get priceLabel => '\$${slot.finalPrice.toStringAsFixed(0)}';

  String get originalPriceLabel => '\$${slot.originalPrice.toStringAsFixed(0)}';

  String get timeLabel {
    final timeFormat = DateFormat('EEE · h:mm a');
    return '${timeFormat.format(slot.startsAt)} · ${slot.durationMinutes} min';
  }
}

final slotPresentationProvider = Provider<List<SlotPresentation>>((ref) {
  final businesses = ref.watch(businessesProvider);
  final slots = ref.watch(slotFeedProvider).slots;
  return slots
      .map((slot) {
        final business = businesses.firstWhereOrNull((b) => b.id == slot.businessId);
        if (business == null) {
          return null;
        }
        return SlotPresentation(slot: slot, business: business);
      })
      .whereType<SlotPresentation>()
      .toList();
});

final savedSlotsProvider = Provider<Set<String>>(
  (ref) => ref.watch(slotFeedProvider).savedSlotIds,
);

Slot? slotById(WidgetRef ref, String slotId) {
  final slots = ref.watch(slotFeedProvider).slots;
  final service = ref.read(slotServiceProvider);
  return service.findSlotById(slotId, slots);
}

Business? businessById(WidgetRef ref, String businessId) {
  final businesses = ref.watch(businessesProvider);
  final service = ref.read(slotServiceProvider);
  return service.findBusinessById(businessId, businesses);
}
