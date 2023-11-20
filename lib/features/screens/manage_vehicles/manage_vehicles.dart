import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageVehiclesScreen extends StatefulWidget {
  const ManageVehiclesScreen({Key? key}) : super(key: key);

  @override
  _ManageVehiclesScreenState createState() => _ManageVehiclesScreenState();
}

class _ManageVehiclesScreenState extends State<ManageVehiclesScreen> {
  String selectedVehicleType = '2 Wheeler';
  List<String> addedVehicles = ['Car Model X', 'Scooter A']; // List to store currently added vehicles

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 255, 255, 255)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Manage Vehicles"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 110),
              const Text(
                "Add or Remove your vehicles here.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 26, 26, 26),
                ),
              ),
              const SizedBox(height: 20),
              buildProfileTextField("Vehicle Name", Icons.car_repair),
              buildProfileTextField("Brand", Icons.person),
              buildDropdownField(),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _addVehicle(); // Add the currently entered vehicle
                    // Navigate or perform additional actions if needed
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 22, 22, 22),
                    side: const BorderSide(color: Color.fromARGB(255, 20, 20, 20)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Add Vehicle",
                    style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 228, 228, 228)),
                  ),
                ),
              ),
              const Divider(), // Divider after "Add Vehicle" button
              const SizedBox(height: 16),
              const Text(
                "Currently Added Vehicles",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 26, 26, 26),
                ),
              ),
              ..._buildAddedVehiclesList(), // List of currently added vehicles
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileTextField(String label, IconData prefixIcon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          prefixIcon: Icon(_getIconForVehicleType(selectedVehicleType)),
          labelText: 'Vehicle Type',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        items: ['2 Wheeler', '4 Wheeler']
            .map((String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ))
            .toList(),
        onChanged: (String? value) {
          setState(() {
            selectedVehicleType = value!;
          });
        },
        // You can set an initial value if needed
        value: '2 Wheeler',
      ),
    );
  }

  IconData _getIconForVehicleType(String vehicleType) {
    return vehicleType == '2 Wheeler' ? Icons.motorcycle : Icons.directions_car;
  }

  void _addVehicle() {
    // Get the currently entered vehicle name and add it to the list
    final TextEditingController vehicleNameController = TextEditingController();
    addedVehicles.add(vehicleNameController.text);
  }

  List<Widget> _buildAddedVehiclesList() {
    return addedVehicles.map((vehicle) => ListTile(title: Text(vehicle))).toList();
  }
}
