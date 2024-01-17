import 'package:ev_charging_stations/features/screens/map_screen/map_screen.dart';
import 'package:ev_charging_stations/features/station/stationList.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import 'package:get/get_core/src/get_main.dart';

class StationFinderScreen extends StatefulWidget {
  const StationFinderScreen({Key? key}) : super(key: key);

  @override
  _StationFinderScreenState createState() => _StationFinderScreenState();
}

class _StationFinderScreenState extends State<StationFinderScreen> {
  String? locationValue;
  String? vehicleTypeValue;

  // Use the generateStations function to get the list of stations
  List<Station> stations = generateStations();

  Widget buildDropdownField(String labelText, List<String> items,
      String? selectedValue, void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.location_on),
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        items: items
            .map((String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ))
            .toList(),
        onChanged: onChanged,
        value: selectedValue,
      ),
    );
  }

  List<Station> filteredStations = [];

  // Function to filter stations based on the selected location criteria
  void filterStations() {
    if (locationValue == 'Nearby') {
      filteredStations = stations
          .where((station) =>
              calculateDistance(station.latitude, station.longitude,
                  currentLocation.latitude, currentLocation.longitude) <=
              2.5)
          .toList();
    } else if (locationValue == 'Less than 5 Km') {
      filteredStations = stations
          .where((station) =>
              calculateDistance(station.latitude, station.longitude,
                  currentLocation.latitude, currentLocation.longitude) <=
              5.0)
          .toList();
    } else if (locationValue == 'Greater than 5 Km') {
      filteredStations = stations
          .where((station) =>
              calculateDistance(station.latitude, station.longitude,
                  currentLocation.latitude, currentLocation.longitude) >
              5.0)
          .toList();
    } else {
      // Show all stations if no location criteria is selected
      filteredStations = List.from(stations);
    }
  }

  // Function to calculate the distance between two coordinates using Haversine formula
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0; // Radius of the Earth in kilometers
    var dLat = _toRadians(lat2 - lat1);
    var dLon = _toRadians(lon2 - lon1);
    var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    var distance = R * c; // Distance in kilometers
    return distance;
  }

  // Helper function to convert degrees to radians
  double _toRadians(double degree) {
    return degree * (math.pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    filterStations(); // Call filterStations to update the filtered list

    return Scaffold(
      extendBodyBehindAppBar: true,
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
        title: const Text("Station Finder"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 110,
            ),
            buildDropdownField(
              'Select Location',
              ['Nearby', 'Less than 5 Km', 'Greater than 5 Km'],
              locationValue,
              (String? value) {
                setState(() {
                  locationValue = value;
                });
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle search button press
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
                      'Search',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        locationValue = null;
                        vehicleTypeValue = null;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(
                          color: Color.fromARGB(255, 137, 174, 223)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 253, 253, 253)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            const Text("Stations",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black)),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero, // Set padding to zero
                itemCount: stations
                    .length, // Change this to the number of demo stations you want
                itemBuilder: (context, index) {
                  if (index < filteredStations.length) {
                    // Station station = stations[index];
                    Station station = filteredStations[index];

                    // Calculate distance
                    double distance = calculateDistance(
                      station.latitude,
                      station.longitude,
                      currentLocation.latitude,
                      currentLocation.longitude,
                    );
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => MapScreen(stationID: station.stationID,), arguments: station.stationID);
                      },
                      child: Card(
                        color: const Color.fromARGB(221, 228, 228, 228),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: 169,
                                        child: Column(children: [
                                          Text(
                                            stations[index].name,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                          Text(stations[index].description,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.ellipsis),
                                        ]),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: Column(children: [
                                          const Text('Distance',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black),
                                              overflow: TextOverflow.ellipsis),
                                          Text(
                                              '${distance.toStringAsFixed(2)} km',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.ellipsis),
                                        ]),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Column(
                                    children: [
                                      SizedBox(
                                        width: 60,
                                        child: Column(
                                          children: [
                                            Text('Status',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black),
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            Text('Active',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color.fromARGB(
                                                        255, 16, 156, 21),
                                                    fontWeight:
                                                        FontWeight.w500),
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    // Handle the case where index is out of bounds
                    return Container(); // You can return an empty container or a placeholder widget
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
