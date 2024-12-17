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
  // final userIdd = await _getUserId();
  // print(userIdd);
  // Navigate to Sign In page after logout
  Navigator.pushReplacementNamed(
      context, '/signin'); // Adjust route name to match your app's routing
}

class HomePage extends StatefulWidget {
  final List<Map<String, String>> activeBookings;

  HomePage({required this.activeBookings});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> vehicles = []; // Change type to `dynamic`
  String userEmail = '';
  @override
  void initState() {
    super.initState();
    fetchUserEmail();
    fetchVehicles();
  }

  Future<void> fetchUserEmail() async {
    String email = await _getUserEmail(); // Get email from SharedPreferences
    setState(() {
      userEmail = email; // Set the email in the state
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(
                        'assets/images/5927577__1_-removebg-preview.png'),
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userEmail, // Display the user email
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      activeBookings: [],
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('My Bookings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingsPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Real-time monitoring'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoFeedPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.directions_car),
              title: Text('My Vehicles'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VehiclesPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/3161254-ai-brush-removebg-pou1w3n5 (1).png',
              height: 300,
              width: 300,
            ),

            const SizedBox(height: 40),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     const Text(
            //       'Your saved vehicles',
            //       style: TextStyle(
            //         fontSize: 18,
            //       ),
            //     ),
            //     Text(
            //       '$vehicleCount',
            //       style: const TextStyle(
            //         fontSize: 18,
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 8),
            // Expanded(
            //   child: vehicleCount == 0
            //       ? Center(
            //           child: Text(
            //             'Nothing to show',
            //             style: TextStyle(
            //               color: Colors.grey,
            //               fontSize: 16,
            //             ),
            //           ),
            //         )
            //       : ListView.builder(
            //           itemCount: vehicleCount,
            //           itemBuilder: (context, index) {
            //             var vehicle = vehicles[index];
            //             return Card(
            //               margin: const EdgeInsets.symmetric(vertical: 8.0),
            //               child: ListTile(
            //                 title: Text(
            //                   'Vehicle number : ${vehicle['number']}',
            //                   style: const TextStyle(),
            //                 ),
            //                 subtitle: Text(
            //                   'Model: ${vehicle['model']}\nType: ${vehicle['type']}',
            //                 ),
            //                 trailing: const Icon(Icons.edit),
            //                 onTap: () {
            //                   // Navigate to the vehicle edit page
            //                 },
            //               ),
            //             );
            //           },
            //         ),
            // ),
            // const SizedBox(height: 20),
            // const Text(
            //   'Your active bookings',
            //   style: TextStyle(
            //     fontSize: 18,
            //   ),
            // ),
            // const SizedBox(height: 8),
            // Expanded(
            //   child: activeBookingCount == 0
            //       ? Center(
            //           child: Text(
            //             'Nothing to show..',
            //             style: TextStyle(
            //               color: Colors.grey,
            //               fontSize: 16,
            //             ),
            //           ),
            //         )
            //       : ListView.builder(
            //           itemCount: activeBookingCount,
            //           itemBuilder: (context, index) {
            //             var booking = widget.activeBookings[index];
            //             return Card(
            //               margin: const EdgeInsets.symmetric(vertical: 8.0),
            //               child: ListTile(
            //                 title: Text(
            //                   'Booking ID: ${booking['id']}',
            //                   style: const TextStyle(),
            //                 ),
            //                 subtitle: Text(
            //                   'Car Info: ${booking['carInfo']}\nLocation: ${booking['location']}\nSlot: ${booking['slot']}\nStart: ${booking['startTime']}\nEnd: ${booking['endTime']}',
            //                 ),
            //               ),
            //             );
            //           },
            //         ),
            // ),
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
