import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ManageVehiclesScreen extends StatefulWidget {
  const ManageVehiclesScreen({super.key});

  @override
  _ManageVehiclesScreenState createState() => _ManageVehiclesScreenState();
}

class _ManageVehiclesScreenState extends State<ManageVehiclesScreen> {
  String selectedVehicleType = '2 Wheeler';
  List<String> addedVehicles = []; // List to store currently added vehicles as strings
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _vehicleNameController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    // Fetch and display the existing vehicles when the screen is initialized
    _fetchVehicles();
  }

  Future<void> _fetchVehicles() async {
    try {
      // Get the reference to the user's document
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(user.email!).get();

      // Get the 'vehicles' field from the document
      List<dynamic> vehicles = userDoc['vehicles'] ?? [];

      setState(() {
        // Update the addedVehicles list with the fetched vehicles
        addedVehicles = List<String>.from(vehicles.map((vehicle) {
          if (vehicle is Map<String, dynamic> && vehicle.isNotEmpty) {
            return '${vehicle['name']} - ${vehicle['brand']} (${vehicle['type']})';
          } else {
            return ''; // Replace with your default value or handle the case as needed
          }
        }));
      });
    } catch (e) {
      print('Error fetching vehicles from Firestore: $e');
      // Handle the error as needed
    }
  }

  Future<void> _addVehicle() async {
    try {
      // Get the reference to the user's document
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.email!);

      // Get the currently entered vehicle details
      String vehicleName = _vehicleNameController.text;
      String brand = _brandController.text;
      String selectedType = selectedVehicleType;

      // Update Firestore with the new vehicle
      await userDocRef.update({
        'vehicles': FieldValue.arrayUnion([
          {
            'name': vehicleName,
            'brand': brand,
            'type': selectedType,
          }
        ]),
      });

      // Clear the text fields after adding the vehicle
      _vehicleNameController.clear();
      _brandController.clear();

      // Fetch and display the updated list of vehicles
      await _fetchVehicles();

      print('Vehicle updated successfully in Firestore');
    } catch (e) {
      print('Error updating vehicle in Firestore: $e');
      // Handle the error as needed
    }
  }

void _deleteVehicle(String vehicle) {
  int index = addedVehicles.indexOf(vehicle);
  if (index != -1) {
    setState(() {
      addedVehicles.removeAt(index);
    });
    // Now you can also update Firestore to remove the deleted vehicle if needed
    _updateFirestoreAfterDelete(index);
  }
}

Future<void> _updateFirestoreAfterDelete(int deletedIndex) async {
  try {
    // Get the reference to the user's document
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user.email!);

    // Fetch the current list of vehicles
    DocumentSnapshot<Object?> userDoc = await userDocRef.get();
    
    // Cast to the correct type
    Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>? ?? {};
    List<dynamic> currentVehicles = data['vehicles'] ?? [];

    // Remove the deleted vehicle from Firestore
    currentVehicles.removeAt(deletedIndex);

    // Update Firestore with the modified list
    await userDocRef.update({'vehicles': currentVehicles});

    print('Vehicle deleted successfully in Firestore');
  } catch (e) {
    print('Error deleting vehicle in Firestore: $e');
    // Handle the error as needed
  }
}




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
              buildProfileTextField("Vehicle Name", Icons.car_repair, _vehicleNameController),
              buildProfileTextField("Brand", Icons.person, _brandController),
              buildDropdownField(),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await _addVehicle();
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
              const SizedBox(height: 10),
              const Divider(
                color: Color.fromARGB(255, 0, 0, 0),
                thickness: 1,
              ), // Divider after "Add Vehicle" button
              const SizedBox(height: 16),
              const Text(
                "Currently Added Vehicles",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 26, 26, 26),
                ),
              ),
              const SizedBox(height: 16),
              ..._buildAddedVehiclesList(), // List of currently added vehicles
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileTextField(String label, IconData prefixIcon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
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

  List<ListTile> _buildAddedVehiclesList() {
    return addedVehicles.map((vehicle) => ListTile(
      title: Text(vehicle),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          _deleteVehicle(vehicle);
          print(vehicle);
        },
      ),
    )).toList();
  }

  

}
