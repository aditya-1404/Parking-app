import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parking_app/pages/registervehicle.dart' as registervehicle;
import 'package:parking_app/pages/parkingspace.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> _getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId') ?? 'default_user_id';
}

class HomePage extends StatefulWidget {
  final List<Map<String, String>> activeBookings;

  HomePage({required this.activeBookings});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> vehicles = []; // Change type to `dynamic`

  @override
  void initState() {
    super.initState();
    fetchVehicles();
  }


  

  Future<void> fetchVehicles() async {
    final userId = await _getUserId();
    final url = Uri.parse('https://spmps.onrender.com/getvehicle');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 200) {
          setState(() {
            vehicles = (responseData['data'] as List).map((vehicle) {
              return {
                'number': vehicle['plate_number'] as String,
                'model': vehicle['vehicle_name'] as String,
                'type': vehicle['vehicle_type'] as String,
              };
            }).toList();
          });
        } else {
          showError('Failed to retrieve vehicles');
        }
      } else {
        showError('Error ${response.statusCode}');
      }
    } catch (e) {
      showError('Failed to connect to the server');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    int vehicleCount = vehicles.length;
    int activeBookingCount = widget.activeBookings.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xff1F1133), Color(0xff5D3299)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 15,
                    backgroundImage: AssetImage('assets/images/user.png'),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(height: 10),
                  // Text(
      
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 20,
                  //   ),
                  // ),
                  // Text(
                  //   userEmail,
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 14,
                  //   ),
                  // ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
            ),
            ListTile(
              leading: Icon(Icons.book), // Icon for My Bookings
              title: Text('My Bookings'),
            ),
            ListTile(
              leading: Icon(Icons.location_on), // Icon for Find My Parking
              title: Text('Find My Parking'),
            ),
            ListTile(
              leading: Icon(Icons.payment), // Icon for My Payment History
              title: Text('My Payment History'),
            ),
            ListTile(
              leading: Icon(Icons.directions_car),
              title: Text('My Vehicles'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
            Spacer(),
            ListTile(
              leading: Icon(Icons.logout), // Icon for Log Out
              title: Text('Log Out'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Hello!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your saved vehicles',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  '$vehicleCount',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: vehicleCount == 0
                  ? Center(
                      child: Text(
                        'Nothing to show',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: vehicleCount,
                      itemBuilder: (context, index) {
                        var vehicle = vehicles[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              'Vehicle number : ${vehicle['number']}',
                              style: const TextStyle(),
                            ),
                            subtitle: Text(
                              'Model: ${vehicle['model']}\nType: ${vehicle['type']}',
                            ),
                            trailing: const Icon(Icons.edit),
                            onTap: () {
                              // Navigate to the vehicle edit page
                            },
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your active bookings',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: activeBookingCount == 0
                  ? Center(
                      child: Text(
                        'Nothing to show..',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: activeBookingCount,
                      itemBuilder: (context, index) {
                        var booking = widget.activeBookings[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              'Booking ID: ${booking['id']}',
                              style: const TextStyle(),
                            ),
                            subtitle: Text(
                              'Car Info: ${booking['carInfo']}\nLocation: ${booking['location']}\nSlot: ${booking['slot']}\nStart: ${booking['startTime']}\nEnd: ${booking['endTime']}',
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => registervehicle.RegisterVehiclePage(
                      vehicles: vehicles
                          .map((vehicle) => vehicle.map(
                              (key, value) => MapEntry(key, value.toString())))
                          .toList(),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                foregroundColor: Colors.white,
                backgroundColor: Color(0xff422669),
              ),
              child: Text('Register your vehicle'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ParkingSpacePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                foregroundColor: Colors.white,
                backgroundColor: Color(0xff422669),
              ),
              child: Text('Search parking space'),
            ),
          ],
        ),
      ),
    );
  }
}
