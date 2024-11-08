import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Page"),
        backgroundColor: Color(0xff1F1133),
      ),
      body: Center(
        child: Text("Main Content Here"), // Placeholder for main content
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            // Simplified Drawer Header
            Container(
              color: Color(0xff1F1133),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/user.png'),
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Your Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'email@gmail.com',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Menu options (no Expanded/Flexible)
            ListTile(
              leading: Icon(Icons.book),
              title: Text('My Bookings'),
              onTap: () {
                Navigator.pop(context); // Close drawer after tapping
                // Add navigation or functionality for "My Bookings"
              },
            ),
            ListTile(
              leading: Icon(Icons.directions_car),
              title: Text('My Cars'),
              onTap: () {
                Navigator.pop(context); // Close drawer after tapping
                // Add navigation or functionality for "My Cars"
              },
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Find My Parking'),
              onTap: () {
                Navigator.pop(context); // Close drawer after tapping
                // Add navigation or functionality for "Find My Parking"
              },
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('My Payment History'),
              onTap: () {
                Navigator.pop(context); // Close drawer after tapping
                // Add navigation or functionality for "My Payment History"
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear(); // Clear stored preferences
                Navigator.of(context).pushReplacementNamed('/signin');
              },
            ),
          ],
        ),
      ),
    );
  }
}
