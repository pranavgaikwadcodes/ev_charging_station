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
  List<String> addedVehicles = [];
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _vehicleNameController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
  }

  Future<void> _fetchVehicles() async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(user.email!).get();

      List<dynamic> vehicles = userDoc['vehicles'] ?? [];

      setState(() {
        addedVehicles = List<String>.from(vehicles.map((vehicle) {
          if (vehicle is Map<String, dynamic> && vehicle.isNotEmpty) {
            return '${vehicle['name']} - ${vehicle['brand']} (${vehicle['type']})';
          } else {
            return '';
          }
        }));
      });
    } catch (e) {
      print('Error fetching vehicles from Firestore: $e');
    }
  }

  Future<void> _addVehicle() async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.email!);

      String vehicleName = _vehicleNameController.text;
      String brand = _brandController.text;
      String selectedType = selectedVehicleType;

      await userDocRef.update({
        'vehicles': FieldValue.arrayUnion([
          {
            'name': vehicleName,
            'brand': brand,
            'type': selectedType,
          }
        ]),
      });

      _vehicleNameController.clear();
      _brandController.clear();

      await _fetchVehicles();

      print('Vehicle updated successfully in Firestore');
    } catch (e) {
      print('Error updating vehicle in Firestore: $e');
    }
  }

  void _deleteVehicle(String vehicle) {
    int index = addedVehicles.indexOf(vehicle);
    if (index != -1) {
      setState(() {
        addedVehicles.removeAt(index);
      });
      _updateFirestoreAfterDelete(index);
    }
  }

  Future<void> _updateFirestoreAfterDelete(int deletedIndex) async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.email!);

      DocumentSnapshot<Object?> userDoc = await userDocRef.get();

      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>? ?? {};
      List<dynamic> currentVehicles = data['vehicles'] ?? [];

      currentVehicles.removeAt(deletedIndex);

      await userDocRef.update({'vehicles': currentVehicles});

      print('Vehicle deleted successfully in Firestore');
    } catch (e) {
      print('Error deleting vehicle in Firestore: $e');
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
        title: const Text("Manage Vehicles", style: TextStyle(color: Colors.white)),
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
              ),
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
              ..._buildAddedVehiclesList(),
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
        value: '2 Wheeler',
      ),
    );
  }

  IconData _getIconForVehicleType(String vehicleType) {
    return vehicleType == '2 Wheeler' ? Icons.motorcycle : Icons.directions_car;
  }

  // List<ListTile> _buildAddedVehiclesList() {
  //   return addedVehicles.map((vehicle) => ListTile(
  //     tileColor: Colors.blueGrey[50],
  //     title: Text(
  //       vehicle,
  //       style: const TextStyle(
  //         fontSize: 18,
  //         fontWeight: FontWeight.bold,
  //         color: Colors.black,
  //       ),
  //     ),
  //     trailing: IconButton(
  //       icon: const Icon(Icons.delete),
  //       onPressed: () {
  //         _deleteVehicle(vehicle);
  //         print(vehicle);
  //       },
  //     ),
  //   )).toList();
  // }

  List<Widget> _buildAddedVehiclesList() {
  return addedVehicles.asMap().entries.map((entry) {
    int index = entry.key;
    String vehicle = entry.value;

    return Column(
      children: [
        ListTile(
          tileColor: Colors.blueGrey[50],
          title: Text(
            vehicle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _deleteVehicle(vehicle);
              print(vehicle);
            },
          ),
        ),
        if (index != addedVehicles.length - 1) SizedBox(height: 5), // Add a gap of 5 except for the last item
      ],
    );
  }).toList();
}

}
