import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parking_app/pages/signin.dart';
import 'package:parking_app/pages/registervehicle.dart' as registervehicle;
import 'package:parking_app/pages/parkingspace.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parking_app/pages/vehicles.dart';
import 'package:parking_app/pages/bookings.dart';
import 'videofeedpage.dart';

Future<String> _getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId') ?? '';
}

Future<String> _getUserEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userEmail') ?? 'No Email';
}

Future<void> _logout(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // Clears all shared preferences data
  Navigator.pushReplacementNamed(context, '/signin');
}

class HomePage extends StatefulWidget {
  final List<Map<String, String>> activeBookings;

  HomePage({required this.activeBookings});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> vehicles = [];
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    fetchUserEmail();
    fetchVehicles();
  }

  Future<void> fetchUserEmail() async {
    String email = await _getUserEmail();
    setState(() {
      userEmail = email;
    });
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
            icon: const Icon(Icons.menu, color: Color(0xff422669)),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/5927577__1_-removebg-preview.png'),
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userEmail,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.home, 'Home', () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(activeBookings: [])));
            }),
            _buildDrawerItem(Icons.book, 'My Bookings', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => BookingsPage()));
            }),
            _buildDrawerItem(Icons.camera_alt, 'Real-time Monitoring', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => VideoFeedPage()));
            }),
            _buildDrawerItem(Icons.directions_car, 'My Vehicles', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => VehiclesPage()));
            }),
            _buildDrawerItem(Icons.settings, 'Settings', () {}),
            _buildDrawerItem(Icons.logout, 'Log Out', () => _logout(context)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/3161254-ai-brush-removebg-pou1w3n5 (1).png',
              height: 300,
              width: 300,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => registervehicle.RegisterVehiclePage(
                      vehicles: vehicles.map((vehicle) {
                        return vehicle.map((key, value) => MapEntry(key, value.toString()));
                      }).toList(),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                foregroundColor: Colors.white,
                backgroundColor: Color(0xff422669),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                elevation: 5,
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                elevation: 5,
              ),
              child: Text('Search parking space'),
            ),
          ],
        ),
      ),
    );
  }

  ListTile _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Color(0xff422669)),
      title: Text(title, style: TextStyle(color: Color(0xff422669))),
      onTap: onTap,
    );
  }
}
