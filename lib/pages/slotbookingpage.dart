import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_app/models/parking_spot.dart';
import 'package:parking_app/pages/bookingreviewpage.dart';

class SlotBookingPage extends StatelessWidget {
  final ParkingSpot spot;

  SlotBookingPage({required this.spot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff422669),
        title: Text('Slot Booking'),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                'https://maps.googleapis.com/maps/api/staticmap?center=${spot.location.latitude},${spot.location.longitude}&zoom=15&size=600x300&maptype=roadmap&markers=color:red%7C${spot.location.latitude},${spot.location.longitude}&key=AIzaSyAMtI0X-3jyLGu0qO3UOb4UmymnZ50yJ68',
                fit: BoxFit.cover,
                height: 150.0,
                width: double.infinity,
              ),
              SizedBox(height: 8),
              Text(
                spot.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Address: ${spot.vicinity}'),
              Text('Availability: Available'),
              Text('Distance from your destination: 1.2km'),
              Text('Price as per hour: Rs. 20/hour'),
              SizedBox(height: 16),
              Text(
                'Select Date',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Today'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Tomorrow'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Select Duration',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'From',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: '17:00',
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_right_alt),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'To',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: '18:00',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                     Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingReviewPage(
            carInfo: 'Maruti Suzuki PB 11 AG 7080', // Pass actual data here
            startTime: DateTime(2024, 9, 2, 17, 0), // Use selected times
            endTime: DateTime(2024, 9, 2, 18, 0),
          ),
        ),
      );
                  },
                  child: Text(
                    'Book This Slot',
                    style: TextStyle(color: Colors.white), // Make text white
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff422669), // Button color
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
