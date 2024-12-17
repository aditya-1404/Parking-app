import 'package:flutter/material.dart';
import 'package:parking_app/pages/registervehiclesuccess.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // To encode the body
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class RegisterVehiclePage extends StatefulWidget {
  final List<Map<String, String>> vehicles;

  RegisterVehiclePage({required this.vehicles});

  @override
  _RegisterVehiclePageState createState() => _RegisterVehiclePageState();
}

class _RegisterVehiclePageState extends State<RegisterVehiclePage> {
  final _formKey = GlobalKey<FormState>();

  String vehicleNumber = '';
  String vehicleName = '';
  String vehicleType = 'SUV'; // Default dropdown value
  String userId = ''; // To store userId fetched from SharedPreferences

  @override
  void initState() {
    super.initState();
    _getUserId(); // Fetch userId when the widget is initialized
  }

  // Function to get userId from SharedPreferences
  Future<void> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? ''; // Set userId from SharedPreferences
    });
  }

  // Function to send POST request to the API
  Future<void> _registerVehicle(
      String plateNumber, String name, String type, String userId) async {
    final url = Uri.parse('https://spmps.onrender.com/addvehicle');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'plateNumber': plateNumber,
          'vehicleName': name,
          'vehicleType': type,
          'userId': userId,
        }),
      );

      if (response.statusCode == 200) {
        print('Vehicle registered successfully!');
      } else {
        print('Failed to register vehicle. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while registering vehicle: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with Back Button
      appBar: AppBar(
        backgroundColor: const Color(0xff422669),
        elevation: 0, // Flat look
        title: const Text(
          'Register Vehicle',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Container(
        color: const Color(0xff422669), // Full purple background
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Vehicle Number Input
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Vehicle Number',
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.directions_car, color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white70),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onSaved: (value) => vehicleNumber = value ?? '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter vehicle number';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Vehicle Name Input
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Vehicle Name',
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.drive_eta, color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white70),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onSaved: (value) => vehicleName = value ?? '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter vehicle name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Vehicle Type Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Vehicle Type',
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.local_taxi, color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white70),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  dropdownColor: const Color(0xff422669), // Dropdown background color
                  value: vehicleType,
                  style: const TextStyle(color: Colors.white),
                  items: ['SUV', 'SEDAN', 'HATCHBACK', 'OTHERS']
                      .map((type) => DropdownMenuItem<String>(
                            value: type,
                            child: Text(type, style: const TextStyle(color: Colors.white)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      vehicleType = value ?? 'SUV';
                    });
                  },
                ),

                const SizedBox(height: 40),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        // Send the POST request
                        _registerVehicle(vehicleNumber, vehicleName, vehicleType, userId);

                        // Add vehicle and navigate
                        Map<String, String> newVehicle = {
                          'number': vehicleNumber,
                          'name': vehicleName,
                          'type': vehicleType,
                        };

                        List<Map<String, String>> updatedVehicles =
                            List.from(widget.vehicles)..add(newVehicle);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SuccessfulPage(vehicles: updatedVehicles),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Button color
                      foregroundColor: const Color(0xff422669), // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
