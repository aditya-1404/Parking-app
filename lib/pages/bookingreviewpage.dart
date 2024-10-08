import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parking_app/pages/slotbookedpage.dart';

class BookingReviewPage extends StatelessWidget {
  final String carInfo;
  final DateTime startTime;
  final DateTime endTime;
  final double spotPrice;
  final double serviceCharge;
  final String locationAddress;

  BookingReviewPage({
    required this.carInfo,
    required this.startTime,
    required this.endTime,
    this.spotPrice = 20.0,
    this.serviceCharge = 0.0,
    required this.locationAddress,
  });

  @override
  Widget build(BuildContext context) {
    final totalCost = spotPrice + serviceCharge;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff422669),
        title: Text('Booking Review'),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please review your booking details below. Click once you’re done to book this slot.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Car info'),
                Text(carInfo, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Starts'),
                Text(DateFormat('dd-MM-yyyy HH:mm').format(startTime)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ends'),
                Text(DateFormat('dd-MM-yyyy HH:mm').format(endTime)),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Spot Price'),
                Text('₹ ${spotPrice.toStringAsFixed(2)}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Service Charge'),
                Text('₹ ${serviceCharge.toStringAsFixed(2)}'),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Cost'),
                Text('₹ ${totalCost.toStringAsFixed(2)}'),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final bookingDetails = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SlotBookedPage(
                        bookingId: '#7644425480',
                        carInfo: carInfo,
                        address: locationAddress,
                        slotCode: 'B102',
                      ),
                    ),
                  );
                  
                  if (bookingDetails != null) {
                    Navigator.pop(context, bookingDetails);
                  }
                },
                child: Text('BOOK', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff422669),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
