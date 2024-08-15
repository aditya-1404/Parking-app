import 'package:flutter/material.dart';
import 'package:parking_app/pages/registervehiclesuccess.dart';

class RegisterVehiclePage extends StatefulWidget {

  final List<Map<String, String>> vehicles;

  RegisterVehiclePage({required this.vehicles});

  @override
  _RegisterVehiclePageState createState() => _RegisterVehiclePageState();
}

class _RegisterVehiclePageState extends State<RegisterVehiclePage> {
  final _formKey = GlobalKey<FormState>();

  String vehicleNumber = '';
  String model = '';
  String color = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff422669),
        title: Text('Register your vehicle'),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Vehicle Number'),
                onSaved: (value) => vehicleNumber = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vehicle number';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Model'),
                onSaved: (value) => model = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vehicle model';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Color'),
                onSaved: (value) => color = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vehicle color';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Create a vehicle map
                    Map<String, String> newVehicle = {
                      'number': vehicleNumber,
                      'model': model,
                      'color': color,
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
                  minimumSize: Size(double.infinity, 50),
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xff422669),
                ),
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
