import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VehiclesPage extends StatefulWidget {
  @override
  _VehiclesPageState createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  List<Map<String, dynamic>> vehicles = []; // List to store vehicle data

  @override
  void initState() {
    super.initState();
    fetchVehicles();
  }

  Future<String> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId') ?? 'default_user_id';
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vehicles'),
        backgroundColor: Color(0xff422669),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: vehicles.isEmpty
            ? Center(
                child: Text(
                  'No vehicles registered.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  var vehicle = vehicles[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: InkWell(
                      onTap: () {
                        // Implement the edit functionality if needed
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
                              Icons.directions_car,
                              color: Color(0xff422669),
                              size: 28,
                            ),
                          ),
                          title: Text(
                            'Vehicle number: ${vehicle['number']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Model: ${vehicle['model']}\nType: ${vehicle['type']}',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          trailing: Icon(
                            Icons.edit,
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
