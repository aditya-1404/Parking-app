import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
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
                  CircleAvatar(
                    radius: 15,
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
            ListTile(
              title: Text('My Bookings'),
              onTap: () {
                // Navigate to bookings page or perform action
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('My Cars'),
              onTap: () {
                // Navigate to cars page or perform action
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Find My Parking'),
              onTap: () {
                // Navigate to parking page or perform action
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('My Payment History'),
              onTap: () {
                // Navigate to payment history page or perform action
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Log Out'),
              onTap: () {
                // Perform log out action
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
    );
  }
}
