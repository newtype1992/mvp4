import 'dart:math';

import '../models/business.dart';
import '../models/slot.dart';

final List<Business> seededBusinesses = [
  const Business(
    id: 'b1',
    name: 'Pulse Fit Studio',
    category: 'Fitness',
    address: '221 Barton Springs Rd',
    distanceMiles: 1.2,
    rating: 4.8,
    heroImage: 'https://images.unsplash.com/photo-1558611848-73f7eb4001a1?auto=format&fit=crop&w=800&q=80',
  ),
  const Business(
    id: 'b2',
    name: 'Glow & Go Spa',
    category: 'Wellness',
    address: '88 Rainey Street',
    distanceMiles: 2.5,
    rating: 4.6,
    heroImage: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?auto=format&fit=crop&w=800&q=80',
  ),
  const Business(
    id: 'b3',
    name: 'Align Physical Therapy',
    category: 'Physiotherapy',
    address: '500 Congress Ave',
    distanceMiles: 1.8,
    rating: 4.9,
    heroImage: 'https://images.unsplash.com/photo-1558611848-013bae4c1f86?auto=format&fit=crop&w=800&q=80',
  ),
  const Business(
    id: 'b4',
    name: 'Sunset Dental',
    category: 'Dental',
    address: '1333 South Lamar Blvd',
    distanceMiles: 3.1,
    rating: 4.7,
    heroImage: 'https://images.unsplash.com/photo-1588776814546-1ffcf47267a5?auto=format&fit=crop&w=800&q=80',
  ),
];

final List<Slot> seededSlots = [
  Slot(
    id: 's1',
    businessId: 'b1',
    service: 'HIIT Express Class',
    startsAt: DateTime.now().add(const Duration(hours: 2)),
    durationMinutes: 45,
    originalPrice: 35,
    discountPercent: 40,
    notes: 'Small group class · Equipment provided',
  ),
  Slot(
    id: 's2',
    businessId: 'b2',
    service: '30-min Glow Facial',
    startsAt: DateTime.now().add(const Duration(hours: 3, minutes: 30)),
    durationMinutes: 30,
    originalPrice: 80,
    discountPercent: 45,
    notes: 'Includes LED boost and hydration mask',
  ),
  Slot(
    id: 's3',
    businessId: 'b3',
    service: 'Sports Recovery Session',
    startsAt: DateTime.now().add(const Duration(hours: 5)),
    durationMinutes: 60,
    originalPrice: 110,
    discountPercent: 35,
    notes: 'Targeted mobility work + Normatec boots',
  ),
  Slot(
    id: 's4',
    businessId: 'b4',
    service: 'Teeth Whitening Touch-up',
    startsAt: DateTime.now().add(const Duration(hours: 6, minutes: 15)),
    durationMinutes: 50,
    originalPrice: 150,
    discountPercent: 30,
    notes: 'Includes follow-up care kit',
  ),
];

final _random = Random();

Slot randomSlotForBusiness(Business business, int index) {
  final baseStart = DateTime.now().add(Duration(hours: 1 + index));
  final durationOptions = [30, 45, 50, 60];
  final discounts = [30, 35, 40, 45, 50];
  final services = [
    'Express',
    'Premium',
    'Signature',
    'Focus',
  ];
  final serviceName = '${business.category} ${services[_random.nextInt(services.length)]}';
  final duration = durationOptions[_random.nextInt(durationOptions.length)];
  final originalPrice = 40 + _random.nextInt(90);
  final discountPercent = discounts[_random.nextInt(discounts.length)];
  return Slot(
    id: 'demo-${business.id}-$index-${DateTime.now().millisecondsSinceEpoch}',
    businessId: business.id,
    service: serviceName,
    startsAt: baseStart.add(Duration(minutes: _random.nextInt(180))),
    durationMinutes: duration,
    originalPrice: originalPrice.toDouble(),
    discountPercent: discountPercent,
    notes: 'Auto-generated demo slot',
  );
}
