import 'package:flutter/material.dart';
import 'package:parking_app/pages/menu.dart';

class HomePage extends StatefulWidget {
  final String userName;

  HomePage({required this.userName});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int vehicleCount = 0;
  int bookingCount = 0;
  String vehicleStatus = "Nothing to show..";
  String bookingStatus = "Nothing to show..";

  void registerVehicle() {
    setState(() {
      vehicleCount++;
      vehicleStatus = "Vehicle $vehicleCount registered";
    });
  }

  void bookParking() {
    setState(() {
      bookingCount++;
      bookingStatus = "Booking $bookingCount active";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: MenuPage(), // Use your MenuPage widget here
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Hi, ${widget.userName}!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your vehicles',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  '$vehicleCount',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              vehicleStatus,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Active bookings',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  '$bookingCount',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              bookingStatus,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: registerVehicle,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Color(0xff422669),
              ),
              child: Text('Register your vehicle',
                  style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: bookParking,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Color(0xff422669),
              ),
              child: Text('Search parking space',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
