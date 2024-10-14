import 'package:flutter/material.dart';
import 'package:parking_app/pages/registervehiclesuccess.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // To encode the body

class RegisterVehiclePage extends StatefulWidget {
  final List<Map<String, String>> vehicles;
  final String userId; // Add userId (phone number)

  RegisterVehiclePage({required this.vehicles, required this.userId}); // Pass userId

  @override
  _RegisterVehiclePageState createState() => _RegisterVehiclePageState();
}

class _RegisterVehiclePageState extends State<RegisterVehiclePage> {
  final _formKey = GlobalKey<FormState>();

  String vehicleNumber = '';
  String vehicleName = '';
  String vehicleType = 'SUV'; // Default dropdown value

  // Function to send POST request to the API
  Future<void> _registerVehicle(String plateNumber, String name, String type, String userId) async {
    final url = Uri.parse('https://spmps.onrender.com/addvehicle');

    try {
      // Send the post request
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'plateNumber': plateNumber,
          'vehicleName': name,
          'vehicleType': type,
          'userId': userId, // Include userId in the request body
        }),
      );

      if (response.statusCode == 200) {
        // Handle success (e.g., navigate to success page)
        print('Vehicle registered successfully!');
      } else {
        // Handle failure (show an error message)
        print('Failed to register vehicle. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while registering vehicle: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff422669),
        title: const Text('Register your vehicle'),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Vehicle Number'),
                onSaved: (value) => vehicleNumber = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vehicle number';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Vehicle Name'),
                onSaved: (value) => vehicleName = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vehicle name';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Vehicle Type'),
                value: vehicleType,
                items: ['SUV', 'SEDAN', 'HATCHBACK', 'OTHERS']
                    .map((type) => DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    vehicleType = value ?? 'SUV';
                  });
                },
                onSaved: (value) => vehicleType = value ?? 'SUV',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a vehicle type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Send the POST request to the API with the userId (phone number)
                    _registerVehicle(vehicleNumber, vehicleName, vehicleType, widget.userId);

                    // Create a vehicle map
                    Map<String, String> newVehicle = {
                      'number': vehicleNumber,
                      'name': vehicleName,
                      'type': vehicleType,
                    };

                    // Add the new vehicle to the list
                    List<Map<String, String>> updatedVehicles =
                        List.from(widget.vehicles)..add(newVehicle);

                    // Navigate to the SuccessfulPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SuccessfulPage(
                          vehicles: updatedVehicles,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xff422669),
                ),
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
