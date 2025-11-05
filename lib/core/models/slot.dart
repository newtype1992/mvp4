class Slot {
  Slot({
    required this.id,
    required this.businessId,
    required this.categoryId,
    required this.startsAt,
    required this.endsAt,
    required this.discountPercent,
    required this.originalPrice,
    required this.seatsRemaining,
    required this.cancelPolicy,
    required this.createdAt,
  });

  final String id;
  final String businessId;
  final String categoryId;
  final DateTime startsAt;
  final DateTime endsAt;
  final int discountPercent;
  final double originalPrice;
  final int seatsRemaining;
  final String cancelPolicy;
  final DateTime createdAt;

  double get discountedPrice => originalPrice * (1 - discountPercent / 100);

  Duration get startsIn => startsAt.difference(DateTime.now());
}
