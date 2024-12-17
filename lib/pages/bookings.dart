import 'package:flutter/material.dart';
import 'global_booking.dart'; // Import global bookings
import 'slotbookedpage.dart'; // Import SlotBookedPage

class BookingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
        backgroundColor: Color(0xff422669),
        centerTitle: true,
      ),
      body: globalBookings.isEmpty
          ? Center(
              child: Text(
                'No bookings available',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: globalBookings.length,
                itemBuilder: (context, index) {
                  final booking = globalBookings[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SlotBookedPage(
                              bookingId: booking.bookingId,
                              carInfo: booking.carInfo,
                              address: booking.address,
                              slotCode: booking.slotCode,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            colors: [Color(0xff422669), Color(0xff6A359C)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 24,
                            child: Icon(
                              Icons.book_online,
                              color: Color(0xff422669),
                              size: 28,
                            ),
                          ),
                          title: Text(
                            'Booking ID: ${booking.bookingId}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Address: ${booking.address}\nSlot: ${booking.slotCode}',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
