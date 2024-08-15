import 'package:google_maps_flutter/google_maps_flutter.dart';
class ParkingSpot {
  final String placeId;
  final String name;
  final String vicinity;
  final LatLng location;

  ParkingSpot({
    required this.placeId,
    required this.name,
    required this.vicinity,
    required this.location,
  });
}