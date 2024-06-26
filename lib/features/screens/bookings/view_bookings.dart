import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_charging_stations/features/screens/bookings/booking_details.dart';
import 'package:ev_charging_stations/features/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

late int stationID_toPass;

class ViewBookingsScreen extends StatelessWidget {
  const ViewBookingsScreen({
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 255, 255, 255)),
            onPressed: () {
              Get.offAll(HomeScreen());
            },
          ),
          title: const Text(
            "View Bookings",
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Ongoing Booking"),
              Tab(text: "Booking History"),
            ],
            indicatorColor: Color.fromARGB(255, 170, 252, 149),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 5,
            labelStyle: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: TabBarView(
            children: [
              // Tab 1: Ongoing Booking
              SingleChildScrollView(
                child: FutureBuilder(
                  future: fetchUserBookings(bookingsField: 'bookings'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<BookingData> bookings = snapshot.data ?? [];

                      if (bookings.isEmpty) {
                        return const Center(
                          child: Text(
                            "No Ongoing Bookings",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 26, 26, 26),
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: [
                          const SizedBox(height: 150),
                          for (var booking in bookings)
                            BookingCard(
                              slotID: booking.slotID,
                              stationid: booking.stationid,
                              stationName: booking.stationName,
                              date: booking.date,
                              time: booking.time,
                              port: booking.port,
                              stationAddress: booking.stationAddress,
                              lat: booking.latitude,
                              long: booking.longitude,
                            ),
                        ],
                      );
                    }
                  },
                ),
              ),

              // Tab 2: Booking History
              SingleChildScrollView(
                child: FutureBuilder(
                  future: fetchUserBookings(bookingsField: 'bookingHistory'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<BookingData> bookings = snapshot.data ?? [];

                      if (bookings.isEmpty) {
                        return const Center(
                          child: Text(
                            "No Booking History",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 26, 26, 26),
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: [
                          const SizedBox(height: 150),
                          for (var booking in bookings)
                            BookingCard(
                              slotID: booking.slotID,
                              stationid: booking.stationid,
                              stationName: booking.stationName,
                              date: booking.date,
                              time: booking.time,
                              port: booking.port,
                              stationAddress: booking.stationAddress,
                              lat: booking.latitude,
                              long: booking.longitude,
                              showButton: false,
                            ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<BookingData>> fetchUserBookings({required String bookingsField}) async {
    final user = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(user.email).get();

    List<BookingData> bookings = [];

    if (userSnapshot.exists) {
      List<dynamic> bookingList = userSnapshot.data()?['$bookingsField'] ?? [];

      for (var bookingData in bookingList) {
        try {
          int stationID = bookingData['stationID'];
          print("stationID = $stationID");

          stationID_toPass = stationID;
          // Fetch station details from the 'stations' collection
          DocumentSnapshot<Map<String, dynamic>> stationSnapshot =
              await FirebaseFirestore.instance.collection('stations').doc(stationID.toString()).get();

          // Check if the station details exist
          if (stationSnapshot.exists) {
            print("station snapshot: ${stationSnapshot.data()}");
            BookingData booking = BookingData(
              slotID: bookingData['slotID'],
              stationid: stationID_toPass,
              stationName: stationSnapshot.data()?['name'] ?? 'Unknown Station',
              date: bookingData['date'] ?? 'Unknown Date',
              time: bookingData['time'] ?? 'Unknown Time',
              latitude: double.tryParse(stationSnapshot['latitude']?.toString() ?? '') ?? 0.0,
              longitude: double.tryParse(stationSnapshot['longitude']?.toString() ?? '') ?? 0.0,
              stationAddress: stationSnapshot.data()?['address'] ?? 'Unknown Address',
              port: (bookingData['port'].toString()) ?? '1',
            );
            printInfo(info: 'booking data : $booking');

            printInfo(info: "LAT LONG : ${stationSnapshot['latitude']}, ${stationSnapshot['longitude']}");
            bookings.add(booking);
          } else {
            print("Station details do not exist for stationID: $stationID");
          }
        } catch (e) {
          print("Error processing booking data: $e");
        }
      }
    }

    print(bookings);

    return bookings;
  }
}

class BookingData {
  final String stationName;
  final String date;
  final String time;
  final String port;
  final String stationAddress;
  final double latitude;
  final double longitude;
  final int stationid;
  final int slotID;

  BookingData({
    required this.stationName,
    required this.date,
    required this.time,
    required this.port,
    required this.stationAddress,
    required this.latitude,
    required this.longitude,
    required this.stationid,
    required this.slotID,
  });
}
class BookingCard extends StatelessWidget {
  const BookingCard({
    Key? key,
    required this.slotID,
    required this.stationid,
    required this.stationName,
    required this.date,
    required this.time,
    required this.port,
    required this.stationAddress,
    required this.lat,
    required this.long,
    this.showButton = true, // Added a parameter to conditionally show the button
  }) : super(key: key);

  final int slotID;
  final int stationid;
  final String stationName;
  final String date;
  final String time;
  final String port;
  final String stationAddress;
  final double lat;
  final double long;
  final bool showButton; // New parameter

  @override
  Widget build(BuildContext context) {
    printInfo(info: 'portInfo: $port');

    return Card(
      elevation: 5,
      shadowColor: const Color.fromARGB(255, 34, 34, 34),
      color: (showButton == true) ? const Color.fromARGB(255, 0, 0, 0) : Color.fromARGB(255, 92, 92, 92),
      child: SizedBox(
        height: (showButton == true) ? 150 : 120,
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Column(
                    children: [
                      Icon(
                        Icons.ev_station,
                        color: Color.fromARGB(255, 216, 243, 118),
                        size: 80,
                      ),
                    ],
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stationName,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "$date, $time",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          stationAddress,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              if (showButton) // Conditionally show the button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(const Size(150, 40)),
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 176, 255, 144)),
                          textStyle: MaterialStateProperty.all(
                              const TextStyle(color: Colors.black)),
                        ),
                        onPressed: () {
                          Get.to(
                            () => BookingDetailsScreen(
                              slotID: slotID,
                              stationID: stationid,
                              stationName: stationName,
                              date: date,
                              time: time,
                              port: port,
                              stationAddress: stationAddress,
                              latitude: lat.toString(),
                              longitude: long.toString(),
                            ),
                          );
                        },
                        child: const Text(
                          "View Details",
                          style: TextStyle(
                            color: Colors.black,
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
      ),
    );
  }
}
