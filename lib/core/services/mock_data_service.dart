import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../models/business.dart';
import '../models/category.dart';
import '../models/slot.dart';

class MockDataService {
  MockDataService() {
    _seed();
    _ticker = Timer.periodic(const Duration(minutes: 5), (_) => _spawnNewSlots());
  }

  final _uuid = const Uuid();
  final _random = Random(42);
  late Timer _ticker;

  final List<Category> categories = [];
  final List<Business> businesses = [];
  final StreamController<List<Slot>> _slotStreamController =
      StreamController<List<Slot>>.broadcast();
  List<Slot> _slots = [];

  Stream<List<Slot>> get slotStream => _slotStreamController.stream;

  void _seed() {
    categories.addAll(_seedCategories());
    businesses.addAll(_seedBusinesses());
    _slots = _seedSlots();
    _slotStreamController.add(_slots);
  }

  List<Category> _seedCategories() {
    return [
      Category(
        id: 'strength',
        name: 'Strength Lab',
        emoji: '🏋️‍♀️',
        primaryColor: const Color(0xFF6C63FF),
      ),
      Category(
        id: 'hot_yoga',
        name: 'Hot Yoga',
        emoji: '🧘',
        primaryColor: const Color(0xFFFF8A65),
      ),
      Category(
        id: 'spin',
        name: 'Spin Studio',
        emoji: '🚴',
        primaryColor: const Color(0xFF1DE9B6),
      ),
      Category(
        id: 'blowout',
        name: 'Salon Blowout',
        emoji: '💇‍♀️',
        primaryColor: const Color(0xFFF06292),
      ),
      Category(
        id: 'sports_massage',
        name: 'Sports Massage',
        emoji: '💆',
        primaryColor: const Color(0xFF9575CD),
      ),
      Category(
        id: 'dental',
        name: 'Dental Cleaning',
        emoji: '🦷',
        primaryColor: const Color(0xFF64B5F6),
      ),
      Category(
        id: 'physio',
        name: 'Physio Reset',
        emoji: '🩺',
        primaryColor: const Color(0xFF26A69A),
      ),
    ];
  }

  List<Business> _seedBusinesses() {
    const baseLat = 30.2672;
    const baseLng = -97.7431;
    final df = NumberFormat('00');
    return List.generate(categories.length, (index) {
      final category = categories[index];
      final offsetLat = (_random.nextDouble() - 0.5) / 100;
      final offsetLng = (_random.nextDouble() - 0.5) / 100;
      return Business(
        id: 'biz_${category.id}',
        name: '${category.name} ${df.format(index + 1)}',
        tagline: 'Last-minute ${category.name.toLowerCase()} magic',
        address: '${180 + index} Rainey St',
        city: 'Austin',
        latitude: baseLat + offsetLat,
        longitude: baseLng + offsetLng,
        rating: 4.3 + _random.nextDouble() * 0.6,
        reviewCount: 80 + _random.nextInt(120),
        categories: [category.id],
        heroImage:
            'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=1200&q=80&sig=$index',
        distanceMiles: 0.5 + _random.nextDouble() * 4,
      );
    });
  }

  List<Slot> _seedSlots() {
    final now = DateTime.now();
    return businesses.expand((business) {
      return List.generate(4, (index) {
        final start = now
            .add(Duration(hours: _random.nextInt(12), minutes: _random.nextInt(55)))
            .add(Duration(minutes: index * 15));
        final durationMinutes = [30, 45, 60][_random.nextInt(3)];
        final end = start.add(Duration(minutes: durationMinutes));
        final discount = _discountForStart(start.difference(now));
        final price = 55 + _random.nextInt(90);
        return Slot(
          id: _uuid.v4(),
          businessId: business.id,
          categoryId: business.categories.first,
          startsAt: start,
          endsAt: end,
          discountPercent: discount,
          originalPrice: price.toDouble(),
          seatsRemaining: max(1, 4 - index),
          cancelPolicy: 'Free cancellation up to 2h before start.',
          createdAt: now.subtract(Duration(minutes: _random.nextInt(120))),
        );
      });
    }).sortedBy<DateTime>((slot) => slot.startsAt).toList();
  }

  int _discountForStart(Duration delta) {
    final minutes = delta.inMinutes;
    if (minutes <= 120) return 50;
    if (minutes <= 360) return 35;
    if (minutes <= 720) return 20;
    return 10;
  }

  void _spawnNewSlots() {
    final now = DateTime.now();
    final business = businesses[_random.nextInt(businesses.length)];
    final start = now.add(Duration(minutes: 30 + _random.nextInt(240)));
    final end = start.add(Duration(minutes: 45 + _random.nextInt(30)));
    final slot = Slot(
      id: _uuid.v4(),
      businessId: business.id,
      categoryId: business.categories.first,
      startsAt: start,
      endsAt: end,
      discountPercent: _discountForStart(start.difference(now)),
      originalPrice: 65 + _random.nextInt(65),
      seatsRemaining: 1 + _random.nextInt(3),
      cancelPolicy: 'Non-refundable within 1h of start.',
      createdAt: now,
    );
    _slots = [..._slots, slot]
        .where((element) => element.startsAt.isAfter(now.subtract(const Duration(hours: 1))))
        .sortedBy<DateTime>((e) => e.startsAt)
        .toList();
    _slotStreamController.add(_slots);
  }

  void triggerDemoDrop() {
    _spawnNewSlots();
  }

  void dispose() {
    _ticker.cancel();
    _slotStreamController.close();
  }
}
