import 'package:ev_charging_stations/features/screens/home/grid_dashboard.dart';
import 'package:ev_charging_stations/features/screens/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  void userSignOut() {
    FirebaseAuth.instance.signOut();
    Get.offAll(() => LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/blob-scene-haikei.png'), // Replace with your image asset path
            fit: BoxFit.cover,
          ),
        ),
      child:
        Column(
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
                  icon: const Icon(Icons.logout)
                ),
              ],
            ),
          ),
          const SizedBox(height: 100,),

          GridDashboard(),

        ],
      ),
      )
    );
  }
}
