import 'package:flutter/material.dart';
import 'package:parking_app/pages/registervehicle.dart';
import 'package:parking_app/pages/parkingspace.dart';

class HomePage extends StatefulWidget {
  final List<Map<String, String>> vehicles;
  final List<Map<String, String>> activeBookings;

  HomePage({required this.vehicles, required this.activeBookings});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    int vehicleCount = widget.vehicles.length;
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
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xff422669),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
            ),
            ListTile(
              leading: Icon(Icons.directions_car),
              title: Text('My Vehicles'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
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
                        var vehicle = widget.vehicles[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              'Vehicle number : ${vehicle['number']}',
                              style: const TextStyle(),
                            ),
                            subtitle: Text(
                              'Model type: ${vehicle['model']}\nColor: ${vehicle['color']}',
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
                    builder: (context) => RegisterVehiclePage(
                      vehicles: widget.vehicles,
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
