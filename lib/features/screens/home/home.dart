import 'package:ev_charging_stations/features/screens/home/grid_dashboard.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 110,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "EV - Charge Connect",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Locate and Plan Your EV Charge!",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // Buttons on homescreen
                IconButton(
                  onPressed: () {}, 
                  alignment: Alignment.topCenter,
                  icon: const Icon(Icons.home)
                ),
              ],
            ),
          ),
          const SizedBox(height: 40,),

          GridDashboard()
        ],
      ),
    );
  }
}
