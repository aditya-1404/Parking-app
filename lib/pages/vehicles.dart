import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VehiclesPage extends StatefulWidget {
  @override
  _VehiclesPageState createState() => _VehiclesPageState();

  then(Null Function(dynamic _) param0) {}
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        'Vehicle number: ${vehicle['number']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Model: ${vehicle['model']}\nType: ${vehicle['type']}',
                      ),
                      trailing: const Icon(Icons.edit),
                      onTap: () {
                        // Implement the edit functionality if needed
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
