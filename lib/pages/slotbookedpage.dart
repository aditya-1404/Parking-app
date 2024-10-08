import 'package:flutter/material.dart';
import 'package:parking_app/pages/homepage.dart';

class SlotBookedPage extends StatelessWidget {
  final String bookingId;
  final String carInfo;
  final String address;
  final String slotCode;

  SlotBookedPage({
    required this.bookingId,
    required this.carInfo,
    required this.address,
    required this.slotCode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff422669),
        title: Text('Slot Booked'),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 80,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'BOOKED',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            _buildInfoRow('Booking Id', bookingId),
            _buildInfoRow('Car Info', carInfo),
            _buildInfoRow('Address', trimAddress(address, 35)),
            _buildInfoRow('Slot Code', slotCode),
            SizedBox(height: 24),
            Center(
              child: Text(
                'Scan at the exit',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 24),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/homepage');
                    },
                    child: Text('Go to Home page'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff422669), // Button color
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle slot cancellation
                      _cancelSlot(context);
                    },
                    child: Text('Cancel Slot'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Button color
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String trimAddress(String address, int charLimit) {
    if (address.length <= charLimit) {
      return address;
    }
    return address.substring(0, charLimit) + '...';
  }

  void _cancelSlot(BuildContext context) {
    // Implement your slot cancellation logic here

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Slot booking cancelled')),
    );

    Navigator.of(context).pushNamed('/homepage');
  }
}
