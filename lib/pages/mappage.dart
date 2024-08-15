import 'package:flutter/material.dart';
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

class MapPage extends StatelessWidget {
  final ParkingSpot spot;

  MapPage({required this.spot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(spot.name),
        backgroundColor: Color(0xff422669),
        foregroundColor: Colors.white,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: spot.location,
          zoom: 14,
        ),
        markers: {
          Marker(
            markerId: MarkerId(spot.placeId),
            position: spot.location,
            infoWindow: InfoWindow(
              title: spot.name,
              snippet: spot.vicinity,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        },
      ),
    );
  }
}
