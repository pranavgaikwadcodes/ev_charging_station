import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final db = FirebaseFirestore.instance;

  late TextEditingController nameController;
  late TextEditingController mobileController;
  late TextEditingController ageController;
  late TextEditingController vehicleRegistrationPlate;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    mobileController = TextEditingController();
    ageController = TextEditingController();
    vehicleRegistrationPlate = TextEditingController();

    // Fetch user data from Firestore
    fetchUserData();
  }

  void fetchUserData() async {
    try {
      final docRef = db.collection("users").doc(user.email!);
      DocumentSnapshot doc = await docRef.get();

      if (doc.exists) {
        // If document exists, update text controllers with data
        final userData = doc.data() as Map<String, dynamic>;
        nameController.text = userData['name'] ?? '';
        mobileController.text = userData['mobile'] ?? '';
        ageController.text = userData['age'] ?? '';
        vehicleRegistrationPlate.text = userData['vehicleRegistrationPlateNumber'] ?? '';

        // Print the user data for debugging purposes
        print("User Data: $userData");
      } else {
        print("Document does not exist");
      }
    } catch (e) {
      print("Error getting document: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 255, 255, 255)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "User Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
        
            Positioned(
              top: 200,
              right: 0,
              left: 0,
              child: Image.asset(
                'assets/Profile Interface.gif',
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
            ),
        
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Manage Your User Profile here.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 26, 26, 26),
                      ),
                    ),
                    Text(
                      user.email!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    buildProfileTextField("Name", Icons.person, nameController),
                    buildProfileTextField("Mobile", Icons.call, mobileController),
                    buildProfileTextField("Age", Icons.handshake, ageController),
                    buildProfileTextField("vehicle Registration Plate", Icons.handshake, vehicleRegistrationPlate),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          updateProfile(); // Add the currently entered vehicle
                          // Navigate or perform additional actions if needed
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 22, 22, 22),
                          side: const BorderSide(
                              color: Color.fromARGB(255, 20, 20, 20)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Update",
                          style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 228, 228, 228)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          ],
        ),
      ),
    );
  }

  Widget buildProfileTextField(
      String label, IconData prefixIcon, TextEditingController controller) {
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

  void updateProfile() async {
    try {
      final docRef = db.collection("users").doc(user.email!);

      // Check if the document exists
      DocumentSnapshot doc = await docRef.get();

      if (doc.exists) {
        // If the document exists, update the fields
        await docRef.update({
          'name': nameController.text,
          'mobile': mobileController.text,
          'age': ageController.text,
        });
        print("Profile updated successfully!");
      } else {
        // If the document does not exist, create a new one
        await docRef.set({
          'name': nameController.text,
          'mobile': mobileController.text,
          'age': ageController.text,
        });
        print("New profile created successfully!");
      }
    } catch (e) {
      print("Error updating profile: $e");
    }
  }
}
