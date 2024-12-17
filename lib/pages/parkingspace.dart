import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:parking_app/models/parking_spot.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:parking_app/pages/slotbookingpage.dart';


class ParkingSpacePage extends StatefulWidget {
  @override
  _ParkingSpacePageState createState() => _ParkingSpacePageState();
}

class _ParkingSpacePageState extends State<ParkingSpacePage> {
  final TextEditingController _locationController = TextEditingController();
  int? _selectedRadius = 1000;
  GoogleMapController? _mapController;
  List<ParkingSpot> _parkingSpots = [];
  String _slotData = '';

  Future<void> _findParkingSpots() async {
    try {
      final locationName = _locationController.text;

      // Get locations from the entered address
      final locations = await locationFromAddress(locationName);

      if (locations.isNotEmpty) {
        final location = locations.first;

        // Extract the pincode using the postal code field from geocoding
        final placemarks = await placemarkFromCoordinates(location.latitude, location.longitude);
        final pincode = placemarks.first.postalCode;

        // Make the request to your API with the pincode
        final url = Uri.parse(
          'https://spmps.onrender.com/get_slot_by_location?pincode=${pincode}&radius=${_selectedRadius}&latitude=${location.latitude}&longitude=${location.longitude}',
        );
        final response = await http.get(
          url,
          headers: {'Content-Type': 'application/json'},
        );
        print(response.body);

        if (response.statusCode == 200) {
          // Parse the response body
          final data = json.decode(response.body)['data'] as List;

          // Convert the response data into ParkingSpot objects
          List<ParkingSpot> spots = data.map((json) {
            return ParkingSpot(
              locationId: json['location_id'],
              locationName: json['location_name'],
              pincode: json['pincode'],
              address: json['address'],
              city: json['city'],
              totalParkingLots: int.parse(json['total_parking_lots']),
              totalRevenue: json['total_revenue'],
              isOpen: json['isopen'],
              availableSlots: int.parse(json['available_slots']),
              latitude: json['latitude'],
              longitude: json['longitude'],
              distanceKm: json['distance_km'],
            );
          }).toList();

          // Sort spots by distance
          spots.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

          // Update state with sorted parking spots
          setState(() {
            _parkingSpots = spots;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Parking slots found for pincode: $pincode')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch slots for pincode $pincode')),
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

  Future<List<String>> _getLocationSuggestions(String query) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=AIzaSyCi3svuYUNITa7NvsxzrohVx_v0QYyGhkY',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final suggestions = (data['predictions'] as List)
          .map((prediction) => prediction['description'] as String)
          .toList();
      return suggestions;
    } else {
      throw Exception('Failed to load suggestions');
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
            TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              suggestionsCallback: _getLocationSuggestions,
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSuggestionSelected: (suggestion) {
                _locationController.text = suggestion;
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField(
              value: _selectedRadius,
              items: [
                DropdownMenuItem(child: Text('1 km'), value: 1000),
                DropdownMenuItem(child: Text('5 km'), value: 5000),
                DropdownMenuItem(child: Text('10 km'), value: 10000),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedRadius = value;
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
                          'https://maps.googleapis.com/maps/api/staticmap?center=${spot.latitude},${spot.longitude}&zoom=18&size=600x300&maptype=roadmap&markers=color:red%7C${spot.latitude},${spot.longitude}&key=AIzaSyCi3svuYUNITa7NvsxzrohVx_v0QYyGhkY',
                          fit: BoxFit.cover,
                          height: 150.0,
                          width: double.infinity,
                        ),
                        ListTile(
                          title: Text(
                            spot.locationName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(spot.address),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${spot.distanceKm.toStringAsFixed(2)} km',
                                      style: TextStyle(color: Colors.grey[700])),
                                  Text('Rs. 20/hour', style: TextStyle(color: Colors.blue)),
                                ],
                              ),
                            ],
                          ),
                          trailing: Text(
                            spot.isOpen ? 'Available Slots:${spot.availableSlots}' : 'Full',
                            style: TextStyle(
                                color: spot.isOpen ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold),
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

