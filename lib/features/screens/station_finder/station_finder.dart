import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_charging_stations/features/screens/home/home.dart';
import 'package:ev_charging_stations/features/screens/map_screen/map_screen.dart';
import 'package:ev_charging_stations/features/station/location_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Slot {
  final String time;
  final String status;
  final String? bookedBy;

  Slot({
    required this.time,
    required this.status,
    this.bookedBy,
  });
}

class Station {
  final String stationID;
  final String name;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final String status;
  final List<Slot> slots;

  Station({
    required this.stationID,
    required this.name,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.slots,
  });
}

class StationFinderScreen extends StatefulWidget {
  const StationFinderScreen({super.key});

  @override
  _StationFinderScreenState createState() => _StationFinderScreenState();
}

class _StationFinderScreenState extends State<StationFinderScreen> {
  String? locationValue;
  String? vehicleTypeValue;
  List<Station> stations = [];

  LocationService _locationService = LocationService();

  LatLng currentLocation = const LatLng(0, 0);

  bool isLoadingLocation = true;

  @override
  void initState() {
    super.initState();

    // Initialize location service
    _locationService = LocationService();

    // Set loading to true initially
    isLoadingLocation = true;

    // Fetch stations data from Firestore when the screen initializes
    fetchStations();

    // Check if location permissions are granted before listening to updates
    _locationService.requestPermission().then((LocationPermission permission) {
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        // Update loading when permission is denied
        setState(() {
          isLoadingLocation = false;
        });
      } else if (permission == LocationPermission.deniedForever) {
        print(
            'Location permissions are permanently denied, we cannot request permissions.');
        // Update loading when permission is permanently denied
        setState(() {
          isLoadingLocation = false;
        });
      } else {
        print('Location permissions granted');
        // Listen to location updates
        _locationService.locationStream.listen((Position newPosition) {
          print(
              "New location: ${newPosition.latitude}, ${newPosition.longitude}");

          setState(() {
            currentLocation =
                LatLng(newPosition.latitude, newPosition.longitude);
            // Update loading when location is received
            isLoadingLocation = false;
          });
        });
      }
    });
  }

  Future<void> fetchStations() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('stations').get();

      setState(() {
        // Map the Firestore data to the Station class
        stations = snapshot.docs.map((doc) {
          final data = doc.data();

          // Use null-aware operators to handle possible null values
          final List<dynamic> slotsData = data['slots'] ?? [];
          final List<Slot> slots = slotsData.map((slotData) {
            return Slot(
              time: slotData['time'] ?? '',
              status: slotData['status'] ?? '',
              bookedBy: slotData['bookedBy'],
            );
          }).toList();

          return Station(
            stationID: doc.id,
            name: data['name'] ?? '',
            description: data['description'] ?? '',
            address: data['address'] ?? '',
            latitude:
                double.tryParse(data['latitude']?.toString() ?? '') ?? 0.0,
            longitude:
                double.tryParse(data['longitude']?.toString() ?? '') ?? 0.0,
            status: data['status'] ?? '',
            slots: slots,
          );
        }).toList();
      });
    } catch (error) {
      print('Error fetching stations: $error');
    }
  }

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
            Get.offAll(() => HomeScreen());
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
                      backgroundColor: const Color.fromARGB(255, 79, 156, 255),
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
                          color: Color.fromARGB(255, 255, 255, 255)),
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
            _buildMainContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    if (isLoadingLocation) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: filteredStations.length,
          itemBuilder: (context, index) {
            Station station = filteredStations[index];

            double distance = calculateDistance(
              station.latitude,
              station.longitude,
              currentLocation.latitude,
              currentLocation.longitude,
            );

            return GestureDetector(
              onTap: () {
                Get.to(
                  () => MapScreen(
                    stationID: int.parse(station.stationID),
                  ),
                  arguments: station.stationID,
                );
              },
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Colors.transparent,
                elevation: 0,
                child: Stack(
                  children: [
                    SizedBox(
                      width: 371.4,
                      height: 105,
                      child: Image.asset(
                        'assets/evstation_charging.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        color: Colors.black.withOpacity(0.4),
                        width: 371.4,
                        height: 105,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Star Rating
                                      RatingBar.builder(
                                        initialRating:
                                            4, // You can set the initial rating here
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 20,
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          // Handle rating updates
                                        },
                                      ),
                                      SizedBox(height: 5,),

                                      const Text(
                                        'Distance',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white70,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${distance.toStringAsFixed(2)} km',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontWeight: FontWeight.w900,
                                          shadows: [
                                            Shadow(
                                              color: Color.fromARGB(255, 0, 0, 0),
                                              offset: Offset(-2, 2),
                                              blurRadius: 5,
                                            ),
                                          ],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        station.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color: Color.fromARGB(255, 0, 0, 0),
                                              offset: Offset(-2, 2),
                                              blurRadius: 5,
                                            ),
                                          ],
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        station.description,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                // Dummy Rating (can be replaced by actual data)
                                const Text(
                                  'Rating: 4.5', // Dummy rating, replace with actual data
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
