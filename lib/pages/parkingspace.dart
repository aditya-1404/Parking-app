import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'slotbookingpage.dart';
import 'package:parking_app/models/parking_spot.dart';

class ParkingSpacePage extends StatefulWidget {
  @override
  _ParkingSpacePageState createState() => _ParkingSpacePageState();
}

class _ParkingSpacePageState extends State<ParkingSpacePage> {
  final TextEditingController _locationController = TextEditingController();
  String _selectedRadius = '1 km';
  GoogleMapController? _mapController;
  List<ParkingSpot> _parkingSpots = [];

  Future<void> _findParkingSpots() async {
    try {
      final locationName = _locationController.text;

      final locations = await locationFromAddress(locationName);

      if (locations.isNotEmpty) {
        final location = locations.first;
        final latLng = '${location.latitude},${location.longitude}';
        final radius = int.parse(_selectedRadius.split(' ')[0]) * 1000;

        final url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latLng&radius=$radius&type=parking&key=AIzaSyAMtI0X-3jyLGu0qO3UOb4UmymnZ50yJ68');

        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          setState(() {
            _parkingSpots.clear();
            if (data['results'].isNotEmpty) {
              for (var result in data['results']) {
                final parkingSpot = ParkingSpot(
                  placeId: result['place_id'],
                  name: result['name'],
                  vicinity: result['vicinity'],
                  location: LatLng(
                    result['geometry']['location']['lat'],
                    result['geometry']['location']['lng'],
                  ),
                );
                _parkingSpots.add(parkingSpot);
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('No parking spots found in this area.')),
              );
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load parking spots. Please try again later.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid location entered.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff422669),
        title: Text('Parking Space'),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField(
              value: _selectedRadius,
              items: [
                DropdownMenuItem(child: Text('1 km'), value: '1 km'),
                DropdownMenuItem(child: Text('5 km'), value: '5 km'),
                DropdownMenuItem(child: Text('10 km'), value: '10 km'),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedRadius = value.toString();
                });
              },
              decoration: InputDecoration(
                labelText: 'Discovery radius',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.map),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _findParkingSpots,
              child: Text('Find Parking Spots'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _parkingSpots.length,
                itemBuilder: (context, index) {
                  final spot = _parkingSpots[index];
                  return Card(
                    elevation: 4.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        Image.network(
                          'https://maps.googleapis.com/maps/api/staticmap?center=${spot.location.latitude},${spot.location.longitude}&zoom=15&size=600x300&maptype=roadmap&markers=color:red%7C${spot.location.latitude},${spot.location.longitude}&key=AIzaSyAMtI0X-3jyLGu0qO3UOb4UmymnZ50yJ68',
                          fit: BoxFit.cover,
                          height: 150.0,
                          width: double.infinity,
                        ),
                        ListTile(
                          title: Text(
                            spot.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(spot.vicinity),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('1.2km', style: TextStyle(color: Colors.grey[700])),
                                  Text('Rs. 20/hour', style: TextStyle(color: Colors.blue)),
                                ],
                              ),
                            ],
                          ),
                          trailing: Text(
                            'Available',
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SlotBookingPage(spot: spot),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle "See more" button press
              },
              child: Text('See more'),
            ),
          ],
        ),
      ),
    );
  }
}
