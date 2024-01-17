
import 'package:ev_charging_stations/features/station/stationList.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const LatLng currentLocation = LatLng(18.507029, 73.804565);

class MapScreen extends StatefulWidget {
  final int stationID;

  const MapScreen({Key? key, required this.stationID}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MapScreenState createState() => _MapScreenState();

  Station fetchStationDetails(int stationID) {
    // Fetch the list of stations
    List<Station> stations = generateStations();

    // Find the station in the list based on the ID
    Station? foundStation = stations.firstWhere(
      (station) => station.stationID == stationID,
      orElse: () => Station(
        stationID: -1,
        name: 'Default Station',
        description: 'No description available',
        address: 'Unknown address',
        latitude: 0.0,
        longitude: 0.0,
        status: 'Unknown status',
      ),
    );

    // Return the found station or a default station if not found
    return foundStation;
  }
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
        title: Text('Station Details - ${widget.stationID}'), // Convert stationID to String
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: currentLocation,
                zoom: 14,
              ),
              onMapCreated: onMapCreated, // Pass the callback here
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
                      Marker tappedMarker = _markers[markerKey]!; // Convert markerId to String
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
                  onPressed: () {},
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

    void onMapCreated(GoogleMapController controller) {
    mapController = controller;

    // Fetch station details when the widget is created
    currentStation = widget.fetchStationDetails(widget.stationID);

    // Add a marker for the station
    addMarker(
      currentStation.name,
      LatLng(currentStation.latitude, currentStation.longitude),
      currentStation.description,
    );

    // Zoom to the location of the station
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(currentStation.latitude, currentStation.longitude),
        14.0, // You can adjust the zoom level as needed
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
              title: currentStation.name, // Use name as the title
              snippet: currentStation.address, // Use description as the snippet
            ),
          );
        });
      },
    );

    setState(() {
      _markers[id] = marker;
    });
  }

  @override
  void initState() {
    super.initState();
  }
}
