import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookingsPage extends StatefulWidget {
  @override
  _BookingsPageState createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  List<Map<String, dynamic>> bookings = []; // List to store booking data

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<String> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId') ?? '';
  }

  Future<void> fetchBookings() async {
    final userId = await _getUserId();
    final url = Uri.parse('https://spmps.onrender.com/getbookings');
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
            bookings = (responseData['data'] as List).map((booking) {
              return {
                'id': booking['booking_id'] as String,
                'carInfo': booking['car_info'] as String,
                'location': booking['location'] as String,
                'slot': booking['slot'] as String,
                'startTime': booking['start_time'] as String,
                'endTime': booking['end_time'] as String,
              };
            }).toList();
          });
        } else {
          showError('Failed to retrieve bookings');
        }
      } else {
        showError('Error ${response.statusCode}');
      }
    } catch (e) {
      showError('Failed to connect to the server');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Color(0xff422669),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: bookings.isEmpty
            ? Center(
                child: Text(
                  'No bookings found.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  var booking = bookings[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        'Booking ID: ${booking['id']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Car Info: ${booking['carInfo']}\nLocation: ${booking['location']}\nSlot: ${booking['slot']}\nStart: ${booking['startTime']}\nEnd: ${booking['endTime']}',
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
