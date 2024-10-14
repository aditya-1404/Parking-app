import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_app/models/parking_spot.dart';
import 'package:parking_app/pages/bookingreviewpage.dart';

class SlotBookingPage extends StatefulWidget {
  final ParkingSpot spot;

  SlotBookingPage({required this.spot});

  @override
  _SlotBookingPageState createState() => _SlotBookingPageState();
}

class _SlotBookingPageState extends State<SlotBookingPage> {
  DateTime? _selectedDate;
  String _startTime = '17:00';
  String _endTime = '18:00';

  void _selectToday() {
    setState(() {
      _selectedDate = DateTime.now();
    });
  }

  void _selectTomorrow() {
    setState(() {
      _selectedDate = DateTime.now().add(Duration(days: 1));
    });
  }

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
                'https://maps.googleapis.com/maps/api/staticmap?center=${widget.spot.latitude},${widget.spot.longitude}&zoom=15&size=600x300&maptype=roadmap&markers=color:red%7C${widget.spot.latitude},${widget.spot.longitude}&key=AIzaSyAMtI0X-3jyLGu0qO3UOb4UmymnZ50yJ68',
                fit: BoxFit.cover,
                height: 150.0,
                width: double.infinity,
              ),
              SizedBox(height: 8),
              Text(
                widget.spot.locationName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Address: ${widget.spot.address}'),
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
                    onPressed: _selectToday,
                    child: Text('Today'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedDate?.day == DateTime.now().day
                          ? Color.fromARGB(255, 3, 9, 70)
                          : Color(0xff422669),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _selectTomorrow,
                    child: Text('Tomorrow'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedDate?.day ==
                              DateTime.now().add(Duration(days: 1)).day
                          ? Color.fromARGB(255, 3, 9, 70)
                          : Color(0xff422669),
                    ),
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
                      initialValue: _startTime,
                      onChanged: (value) {
                        setState(() {
                          _startTime = value;
                        });
                      },
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
                      initialValue: _endTime,
                      onChanged: (value) {
                        setState(() {
                          _endTime = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedDate != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingReviewPage(
                            carInfo: 'Maruti Suzuki PB 11 AG 7080',
                            startTime: DateTime(
                              _selectedDate!.year,
                              _selectedDate!.month,
                              _selectedDate!.day,
                              int.parse(_startTime.split(':')[0]),
                              int.parse(_startTime.split(':')[1]),
                            ),
                            endTime: DateTime(
                              _selectedDate!.year,
                              _selectedDate!.month,
                              _selectedDate!.day,
                              int.parse(_endTime.split(':')[0]),
                              int.parse(_endTime.split(':')[1]),
                            ),
                            locationAddress: widget.spot.address,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select a date')),
                      );
                    }
                  },
                  child: Text(
                    'Book This Slot',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff422669),
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
