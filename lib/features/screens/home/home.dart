import 'package:ev_charging_stations/features/screens/home/grid_dashboard.dart';
import 'package:ev_charging_stations/features/screens/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // final user = FirebaseAuth.instance.currentUser!;

  void userSignOut() {
    
    FirebaseAuth.instance.signOut();
    printInfo(info: "Logged Out");
    // Show toast message
    Fluttertoast.showToast(
      msg: "Logged out successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    Get.offAll(() => LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Handle case when user is not logged in
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Show loading indicator
        ),
      );
    }

    return _buildHomeScreen(user);
  }

  Widget _buildHomeScreen(User user) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/blob-scene-haikei.png'), // Replace with your image asset path
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 110,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "EV - Charge Connect",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      user.email!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                // Buttons on homescreen
                IconButton(
                    onPressed: userSignOut,
                    alignment: Alignment.topCenter,
                    icon: const Icon(Icons.logout)),
              ],
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          GridDashboard(),
        ],
      ),
    ));
  }
}
