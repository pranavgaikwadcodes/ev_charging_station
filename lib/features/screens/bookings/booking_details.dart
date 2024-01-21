import 'package:ev_charging_stations/features/screens/map_screen/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingDetailsScreen extends StatelessWidget {
  final String stationName, date, time, stationAddress, latitude, longitude, port;
  final int stationID;

  const BookingDetailsScreen({
    super.key,
    required this.stationName,
    required this.date,
    required this.time,
    required this.port,
    required this.stationAddress,
    required this.stationID,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    printInfo(info: 'port: $port');
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
        title: const Text(
          "Station Booking Details",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(
                  height: 110,
                ),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: Image.asset(
                          'assets/evAPP.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        child: Container(
                          color: const Color.fromRGBO(255, 255, 255, 1)
                              .withOpacity(0.8),
                          width: 371.4,
                          height: 145,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Station Details",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 70,
                            child: Text(
                              'Name: $stationName\nAddress: $stationAddress',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Row(
                            children: [
                              Text(
                                "Station Rating",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black,
                                      offset: Offset(-2, 2),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        offset: Offset(-2, 2),
                                        blurRadius: 25,
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        offset: Offset(-2, 2),
                                        blurRadius: 25,
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        offset: Offset(-2, 2),
                                        blurRadius: 25,
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.star_half,
                                    color: Colors.yellow,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        offset: Offset(-2, 2),
                                        blurRadius: 25,
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.star_outline,
                                    color: Colors.yellow,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        offset: Offset(-2, 2),
                                        blurRadius: 25,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                        width: double.infinity,
                        height: 230,
                        child: Image.asset(
                          'assets/evcharg.jpeg',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        color: Colors.white.withOpacity(0.4),
                        width: 371.4,
                        height: 230,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Booking Details",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Date: $date",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Time: $time",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Paid ✅, PORT: $port',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Button named locae station

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(150, 40)),
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color.fromARGB(
                                            255, 255, 255, 255)),
                                    textStyle: MaterialStateProperty.all(
                                        const TextStyle(color: Colors.black)),
                                  ),
                                  onPressed: () {
                                    openMaps(latitude, longitude);
                                  },
                                  child: const Text(
                                    "Get Directions",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            )),
      ),
    );
  }

  void openMaps(String latitude, String longitude) {
    try {
      var url =
          'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
      final Uri url0 = Uri.parse(url);
      print('mapsURL: $url0');
      launchUrl(url0);
    } catch (e) {
      print('Error Launching Maps: $e');
    }
  }
}
