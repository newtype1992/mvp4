class Business {
  Business({
    required this.id,
    required this.name,
    required this.tagline,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.reviewCount,
    required this.categories,
    required this.heroImage,
    required this.distanceMiles,
  });

  final String id;
  final String name;
  final String tagline;
  final String address;
  final String city;
  final double latitude;
  final double longitude;
  final double rating;
  final int reviewCount;
  final List<String> categories;
  final String heroImage;
  final double distanceMiles;
}
