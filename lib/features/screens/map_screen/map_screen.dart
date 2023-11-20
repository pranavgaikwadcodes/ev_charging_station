import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const LatLng currentLocation = LatLng(18.507029, 73.804565);

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Map<String, Marker> _markers = {};

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
        title: const Text(""),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLocation,
                zoom: 14,
              ),
              onMapCreated: (controller) {
                mapController = controller;
                addMarker('test', currentLocation);
              },
              markers: _markers.values.toSet(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 22, 22, 22),
                    side: const BorderSide(color: Color.fromARGB(255, 20, 20, 20)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Confirm And Go To Payment",
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

  void addMarker(String id, LatLng location) async {
    var markerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/marker/ev_station.png');

    var marker = Marker(
        markerId: MarkerId(id),
        position: location,
        infoWindow: InfoWindow(
            title: 'Demo Station Name', snippet: 'Description Of Station'),
        icon: markerIcon);
    _markers[id] = marker;
    setState(() {});
  }
}
