import 'package:ev_charging_stations/features/screens/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 255, 255, 255)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("User Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 110),
              const Text(
                "Manage Your User Profile here.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 26, 26, 26),
                ),
              ),
              SizedBox(height: 20),
              buildProfileTextField("First Name", Icons.person),
              buildProfileTextField("Last Name", Icons.person),
              buildProfileTextField("Username", Icons.verified_user),
              buildProfileTextField("Email", Icons.mail_outline_rounded),
              buildProfileTextField("Location", Icons.location_on),
              buildProfileTextField("Password", Icons.lock),
              SizedBox(height: 24),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const SignupScreen()),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 22, 22, 22),
                    side: BorderSide(color: const Color.fromARGB(255, 20, 20, 20)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Update Profile",
                    style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 228, 228, 228)),
                  ),
                ),
              ),
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
}
