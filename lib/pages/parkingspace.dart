import 'package:flutter/material.dart';

class ParkingSpacePage extends StatelessWidget {
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
            TextField(
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField(
              items: [
                DropdownMenuItem(child: Text('1 km'), value: '1 km'),
                DropdownMenuItem(child: Text('5 km'), value: '5 km'),
                DropdownMenuItem(child: Text('10 km'), value: '10 km'),
              ],
              onChanged: (value) {},
              decoration: InputDecoration(
                labelText: 'Discovery radius',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.map),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
