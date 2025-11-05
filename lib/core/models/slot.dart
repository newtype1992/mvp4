import 'package:equatable/equatable.dart';

class Slot extends Equatable {
  const Slot({
    required this.id,
    required this.businessId,
    required this.service,
    required this.startsAt,
    required this.durationMinutes,
    required this.originalPrice,
    required this.discountPercent,
    required this.notes,
  });

  final String id;
  final String businessId;
  final String service;
  final DateTime startsAt;
  final int durationMinutes;
  final double originalPrice;
  final int discountPercent;
  final String notes;

  double get finalPrice => originalPrice * (1 - discountPercent / 100);

  DateTime get endsAt => startsAt.add(Duration(minutes: durationMinutes));

  @override
  List<Object?> get props => [id, businessId, service, startsAt, durationMinutes, originalPrice, discountPercent, notes];
}
