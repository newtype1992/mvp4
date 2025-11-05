import 'package:collection/collection.dart';

import '../data/mock_data.dart';
import '../models/business.dart';
import '../models/slot.dart';

class SlotService {
  const SlotService();

  List<Business> loadBusinesses() => List.unmodifiable(seededBusinesses);

  List<Slot> loadSeededSlots() => List.unmodifiable(seededSlots);

  List<Slot> generateDemoSlots() {
    final businesses = loadBusinesses();
    final generated = <Slot>[];
    for (var i = 0; i < businesses.length; i++) {
      generated.addAll(List.generate(2, (index) => randomSlotForBusiness(businesses[i], index)));
    }
    generated.sort((a, b) => a.startsAt.compareTo(b.startsAt));
    return generated;
  }

  Slot? findSlotById(String id, List<Slot> slots) => slots.firstWhereOrNull((slot) => slot.id == id);

  Business? findBusinessById(String id, List<Business> businesses) =>
      businesses.firstWhereOrNull((business) => business.id == id);
}
