import 'dart:ui';

import 'package:ev_charging_stations/features/screens/bookings/view_bookings.dart';
import 'package:ev_charging_stations/features/screens/manage_vehicles/manage_vehicles.dart';
import 'package:ev_charging_stations/features/screens/profile/profile.dart';
import 'package:ev_charging_stations/features/screens/station_finder/station_finder.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GridDashboard extends StatelessWidget {
  Items item1 = Items(
    title: "Profile",
    destinationPage: const UserProfilePage(),
    backgroundImage: 'assets/profile.png', // Add the image asset path
  );

  Items item2 = Items(
    title: "Manage Vehicles",
    destinationPage: const ManageVehiclesScreen(),
    backgroundImage: 'assets/vehicles.png', // Add the image asset path
  );

  Items item3 = Items(
    title: "View Bookings",
    destinationPage: const ViewBookingsScreen(),
    backgroundImage: 'assets/bookings.png', // Add the image asset path
  );

  Items item4 = Items(
    title: "Station Finder",
    destinationPage: const StationFinderScreen(),
    backgroundImage: 'assets/searchStation.png', // Add the image asset path
  );

  GridDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    List<Items> list = [item1, item2, item3, item4];
    var bgColor = const Color.fromARGB(255, 255, 255, 255);

    return Flexible(
      child: GridView.count(
        childAspectRatio: 1.0,
        padding: const EdgeInsets.only(left: 16, right: 16),
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        children: list.map((data) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => data.destinationPage),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(193, 0, 0, 0).withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 11,
                    offset: const Offset(
                        0, 2),
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(data.backgroundImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    color: Color.fromARGB(255, 205, 255, 251)
                        .withOpacity(0.1), // Adjust the opacity as needed
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    15), // Adjust the radius as needed
                              ),
                              child: Text(
                                data.title,
                                style: const TextStyle(
                                  color: Colors.black, // Black text color
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.white,
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class Items {
  String title;
  Widget destinationPage;
  String backgroundImage;

  Items({
    required this.title,
    required this.destinationPage,
    required this.backgroundImage,
  });
}
