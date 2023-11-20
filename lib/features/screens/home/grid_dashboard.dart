import 'package:ev_charging_stations/features/screens/bookings/view_bookings.dart';
import 'package:ev_charging_stations/features/screens/manage_vehicles/manage_vehicles.dart';
import 'package:ev_charging_stations/features/screens/profile/profile.dart';
import 'package:ev_charging_stations/features/screens/station_finder/station_finder.dart';
import 'package:flutter/material.dart';

class GridDashboard extends StatelessWidget {
  Items item1 = Items(
    title: "Profile",
    description: "Manage your profile.",
    destinationPage: UserProfilePage(),
  );

  Items item2 = Items(
    title: "Manage Vehicles",
    description: "Manage your Vehicles.",
    destinationPage: ManageVehiclesScreen(),
  );

  Items item3 = Items(
    title: "View Bookings",
    description: "View Your Bookings.",
    destinationPage: ViewBookingsScreen(),
  );

  Items item4 = Items(
    title: "Station Finder",
    description: "Find Nearby EV Station.",
    destinationPage: StationFinderScreen(),
  );

  GridDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    List<Items> list = [item1, item2, item3, item4];
    var bgColor = const Color.fromARGB(255, 39, 39, 39);

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
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    data.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data.description,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 190, 190, 190),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
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
  String description;
  Widget destinationPage;

  Items(
      {required this.title,
      required this.description,
      required this.destinationPage});
}
