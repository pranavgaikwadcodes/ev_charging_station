import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_charging_stations/features/screens/bookings/booking_details.dart';
import 'package:ev_charging_stations/features/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

late int stationID_toPass ;
class ViewBookingsScreen extends StatelessWidget {
  const ViewBookingsScreen({
    super.key,
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
            icon: const Icon(Icons.arrow_back,
                color: Color.fromARGB(255, 255, 255, 255)),
            onPressed: () {
              Get.offAll(HomeScreen());
            },
          ),
          title: const Text("View Bookings"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Ongoing Booking"),
              Tab(text: "Booking History"),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: TabBarView(
            children: [
              // Tab 1: Ongoing Booking
              SingleChildScrollView(
                child: FutureBuilder(
                  future: fetchUserBookings(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
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
                              stationName: booking.stationName,
                              date: booking.date,
                              time: booking.time,
                              stationAddress: booking.stationAddress,
                            ),
                        ],
                      );
                    }
                  },
                ),
              ),

              // Tab 2: Booking History
              const Center(
                child: Text(
                  "No Booking History",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 26, 26, 26),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<BookingData>> fetchUserBookings() async {
  final user = FirebaseAuth.instance.currentUser!;
  DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(user.email).get();

  List<BookingData> bookings = [];

  if (userSnapshot.exists) {
    List<dynamic> bookingList = userSnapshot.data()?['bookings'] ?? [];

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
            stationName: stationSnapshot.data()?['name'] ?? 'Unknown Station',
            date: bookingData['date'] ?? 'Unknown Date',
            time: bookingData['time'] ?? 'Unknown Time',
            stationAddress: stationSnapshot.data()?['address'] ?? 'Unknown Address',
          );
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
  final String stationAddress;

  BookingData({
    required this.stationName,
    required this.date,
    required this.time,
    required this.stationAddress,
  });
}

class BookingCard extends StatelessWidget {
  const BookingCard({
    Key? key,
    required this.stationName,
    required this.date,
    required this.time,
    required this.stationAddress,
  }) : super(key: key);

  final String stationName;
  final String date;
  final String time;
  final String stationAddress;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: const Color.fromARGB(255, 34, 34, 34),
      color: Color.fromARGB(255, 0, 0, 0),
      child: SizedBox(
        height: 150,
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
                          "${date}, ${time}",
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(const Size(150, 40)),
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 176, 255, 144)),
                        textStyle: MaterialStateProperty.all(
                            const TextStyle(color: Colors.black)),
                      ),
                      onPressed: () {
                        Get.to(
                          () => BookingDetailsScreen(
                            stationID: stationID_toPass,
                            stationName: stationName,
                            date: date,
                            time: time,
                            stationAddress: stationAddress,
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
