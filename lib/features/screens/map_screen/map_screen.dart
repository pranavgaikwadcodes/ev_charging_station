import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_charging_stations/features/screens/bookslot/bookslot.dart';

import '../../station/station.dart';

class MapScreen extends StatefulWidget {
  final int stationID;

  const MapScreen({Key? key, required this.stationID}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final Map<String, Marker> _markers = {};
  Marker? tappedMarker;
  Set<MarkerId> tappedMarkerIds = <MarkerId>{};
  late Station currentStation;

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
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
        title: Text('Station Details - ${widget.stationID}'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(0.0, 0.0), // Initial target, will be updated in onMapCreated
                zoom: 16,
              ),
              onMapCreated: onMapCreated,
              markers: _markers.values.toSet(),
              onTap: (LatLng location) {
                setState(() {
                  tappedMarkerIds.clear();
                });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (tappedMarkerIds.isNotEmpty)
                  Column(
                    children: tappedMarkerIds.map((markerId) {
                      String markerKey = markerId.value;
                      Marker tappedMarker = _markers[markerKey]!;
                      return Column(
                        children: [
                          Text(
                            tappedMarker.infoWindow.title!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            tappedMarker.infoWindow.snippet!,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: () async {
                    // Fetch station details when the button is pressed
                    currentStation = await fetchStationDetails(widget.stationID);
                    Get.to(() => BookSlot(stationID: currentStation.stationID));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 22, 22, 22),
                    side: const BorderSide(color: Color.fromARGB(255, 20, 20, 20)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Book Slot",
                    style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 228, 228, 228)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    // Fetch station details when the widget is created
    currentStation = await fetchStationDetails(widget.stationID);

    // Add a marker for the station
    addMarker(
      currentStation.name,
      LatLng(currentStation.latitude, currentStation.longitude),
      currentStation.description,
    );

    // Update the initial camera position with the lat/long from Firestore
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(currentStation.latitude, currentStation.longitude),
        14.0,
      ),
    );
  }

  void addMarker(String id, LatLng location, String description) async {
    var markerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/marker/ev_station.png');

    var marker = Marker(
      markerId: MarkerId(id),
      position: location,
      icon: markerIcon,
      infoWindow: InfoWindow(
        title: currentStation.name,
        snippet: currentStation.description,
      ),
      onTap: () {
        setState(() {
          tappedMarkerIds.add(MarkerId(id));
          _markers[id] = _markers[id]!.copyWith(
            infoWindowParam: InfoWindow(
              title: currentStation.name,
              snippet: currentStation.address,
            ),
          );
        });
      },
    );

    setState(() {
      _markers[id] = marker;
    });
  }

  // Fetch basic station details from Firestore
Future<Station> fetchStationDetails(int stationID) async {
  try {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('stations').doc(stationID.toString()).get();

    final data = snapshot.data();

    if (data != null) {
      return Station(
        stationID: int.parse(snapshot.id),
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        address: data['address'] ?? '',
        latitude: (data['latitude'] is double)
            ? data['latitude']
            : double.tryParse(data['latitude'].toString()) ?? 0.0,
        longitude: (data['longitude'] is double)
            ? data['longitude']
            : double.tryParse(data['longitude'].toString()) ?? 0.0,
        slots: [], // Empty list for slots
      );
    } else {
      throw Exception('Data is null');
    }
  } catch (error) {
    print('Error fetching station details: $error');
    rethrow;
  }
}


}
