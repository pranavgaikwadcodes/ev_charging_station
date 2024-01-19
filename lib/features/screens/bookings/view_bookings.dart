import 'package:ev_charging_stations/features/screens/bookings/booking_details.dart';
import 'package:ev_charging_stations/features/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({
    Key? key,
    required this.stationName,
    required this.dateTime,
    required this.stationAddress,
  }) : super(key: key);

  final String stationName;
  final String dateTime;
  final String stationAddress;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: const Color.fromARGB(255, 34, 34, 34),
      color: const Color.fromARGB(255, 26, 26, 26),
      child: SizedBox(
        height: 170,
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
                        color: Colors.white,
                        size: 100,
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
                            color: Color.fromARGB(255, 130, 192, 250),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox( height: 5, ),
                        Text(
                          dateTime,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox( height: 5, ),
                        Text(
                          stationAddress,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
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
                        minimumSize: MaterialStateProperty.all(const Size(150, 40)),
                        backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 130, 192, 250)),
                        textStyle: MaterialStateProperty.all(const TextStyle(color: Colors.black)),
                      ),
                      onPressed: () {
                        Get.to( () => const BookingDetailsScreen());
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
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(const Size(20, 40)),
                      backgroundColor: MaterialStateProperty.all(Colors.white30),
                      textStyle: MaterialStateProperty.all(const TextStyle(color: Colors.black)),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Cancel Booking",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
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
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: TabBarView(
            children: [
              // Tab 1: Ongoing Booking
              Column(
                children: [
                  SizedBox(height: 150),
                  BookingCard(
                    stationName: "Station Name",
                    dateTime: "19 Nov, 2023 at 12:25 AM",
                    stationAddress: "Station Address",
                  ),
                  BookingCard(
                    stationName: "Another Station Name",
                    dateTime: "Date and time here 12:25 AM",
                    stationAddress: "Address of this station",
                  ),
                ],
              ),

              // Tab 2: Booking History
              Center(
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
}
