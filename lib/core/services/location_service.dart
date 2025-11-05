import 'package:latlong2/latlong.dart';

class LocationService {
  Future<LatLng> getCurrentLocation() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return LatLng(30.2672, -97.7431);
  }
}
