import 'package:equatable/equatable.dart';

class Business extends Equatable {
  const Business({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.distanceMiles,
    required this.rating,
    required this.heroImage,
  });

  final String id;
  final String name;
  final String category;
  final String address;
  final double distanceMiles;
  final double rating;
  final String heroImage;

  @override
  List<Object?> get props => [id, name, category, address, distanceMiles, rating, heroImage];
}
