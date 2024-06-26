import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_charging_stations/features/screens/map_screen/map_screen.dart';
import 'package:ev_charging_stations/features/screens/payment/razorpay_payment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:core';

import '../../station/station.dart';

late String slotTime;
late int slotID;
late int slotClickedID;

class BookSlot extends StatefulWidget {
  final int stationID;

  const BookSlot({super.key, required this.stationID});

  @override
  State<BookSlot> createState() => _BookSlotState();
}

// Add a method to get the current time
DateTime getCurrentTime() {
  return DateTime.now();
}

class _BookSlotState extends State<BookSlot> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('stations')
          .doc(widget.stationID.toString())
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error loading data: ${snapshot.error}'),
            ),
          );
        } else if (!snapshot.hasData ||
            snapshot.data == null ||
            !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(
              child: Text('No data available'),
            ),
          );
        } else {
          // Data has been successfully loaded
          Station station = Station.fromFirestore(snapshot.data!);

          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: Color.fromARGB(255, 255, 255, 255)),
                onPressed: () {
                  Get.offAll(() => MapScreen(stationID: widget.stationID));
                },
              ),
              title: const Text(
                "Slot Booking",
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Station ID',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                width: 14,
                              ),
                              Text(
                                station.stationID.toString() ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Station',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                width: 14,
                              ),
                              Text(
                                station.name ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Address',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                width: 14,
                              ),
                              Text(
                                station.address ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "Select Slot",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(left: 4),
                        child: const Text(
                          "Orange: Already Booked\nGreen: Available\nDark Green: Selected",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    const Text("Port 1"),

                    const SizedBox(
                      height: 16,
                    ),
                    GridView.builder(
                      padding: const EdgeInsets.all(0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: station.slots.length,
                      itemBuilder: (context, index) {
                        var slot = station.slots[index];
                        String status =
                            slot.containsKey('status') ? slot['status'] : '';
                        Color defaultColor =
                            const Color.fromARGB(255, 0, 170, 14);
                        Color selectedColor =
                            const Color.fromARGB(255, 0, 80, 4) ??
                                const Color.fromARGB(255, 0, 170, 14);
                        Color cardColor = selectedSlots.contains(index)
                            ? ((slotClickedID == 1)
                                ? selectedColor
                                : defaultColor)
                            : (status == 'booked'
                                ? Colors.orange
                                : defaultColor);

                        return GestureDetector(
                          onTap: () {
                            var slot = station.slots[index];
                            String status = slot.containsKey('status')
                                ? slot['status']
                                : '';

                            DateTime currentTime =
                                DateTime.now(); // Get current time
                            
                            // Convert slot time string to DateTime
                            DateTime selectedSlotTime =
                                convertTimeStringToDateTime(slot['time']);
                            printError(info: "This is where error is bro");
                            // Check if slot time is in the past
                            if (selectedSlotTime.isBefore(currentTime)) {
                              showToast('Cannot select past slots');
                              return;
                            }

                            // Check if the slot is booked
                            if (status == 'booked') {
                              // Show a toast message indicating that the slot is already booked
                              showToast('Slot already booked');

                              // You can choose to return early or perform other actions as needed
                              return;
                            }

                            print('Clicked slot ID: $index, SLOT: $slot');
                            slotTime = slot['time'];
                            slotID = index;

                            // Change card color to dark green when clicked
                            setState(() {
                              cardColor = const Color.fromARGB(255, 0, 80, 4) ??
                                  const Color.fromARGB(255, 0, 170, 14);
                            });

                            // You can store the clicked slot time in a state variable or perform other actions here
                            handleSlotSelection(index);
                          },
                          child: Card(
                            color: selectedSlots.contains(index)
                                ? selectedColor
                                : cardColor,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(
                                  0), // Set contentPadding to zero
                              title: Center(
                                // Center the text
                                child: Text(
                                  '${slot['time']}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),

                    // if station slot_2 is not present dont show this section
                    if (station.slots_2.isNotEmpty) const Text("Port 2"),

                    // slot section 2
                    const SizedBox(
                      height: 16,
                    ),
                    GridView.builder(
                      padding: const EdgeInsets.all(0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: station.slots_2.length,
                      itemBuilder: (context, index2) {
                        var slot2 = station.slots_2[index2];
                        // printInfo(info: "Slots_2 : ${slot}");
                        String status =
                            slot2.containsKey('status') ? slot2['status'] : '';
                        Color defaultColor =
                            const Color.fromARGB(255, 0, 170, 14);
                        Color selectedColor =
                            const Color.fromARGB(255, 0, 80, 4);
                        Color cardColor = selectedSlots.contains(index2)
                            ? ((slotClickedID == 2)
                                ? selectedColor
                                : defaultColor)
                            : (status == 'booked'
                                ? Colors.orange
                                : defaultColor);

                        return GestureDetector(
                          onTap: () {
                            var slot2 = station.slots_2[index2];
                            String status = slot2.containsKey('status')
                                ? slot2['status']
                                : '';

                            DateTime currentTime = DateTime.now(); // Get current time
                            
                            // Convert slot time string to DateTime
                            DateTime selectedSlotTime =
                                convertTimeStringToDateTime(slot2['time']);
                            printError(info: "This is where error is bro");
                            // Check if slot time is in the past
                            if (selectedSlotTime.isBefore(currentTime)) {
                              showToast('Cannot select past slots');
                              return;
                            }

                            if (status == 'booked') {
                              // Show a toast message indicating that the slot is already booked
                              showToast('Slot already booked');

                              // You can choose to return early or perform other actions as needed
                              return;
                            }

                            print('Clicked slot2 ID: $index2, SLOT: $slot2');
                            slotTime = slot2['time'];
                            slotID = index2;

                            // Change card color to dark green when clicked
                            setState(() {
                              cardColor = const Color.fromARGB(255, 0, 80, 4) ??
                                  const Color.fromARGB(255, 0, 170, 14);
                            });

                            // You can store the clicked slot time in a state variable or perform other actions here
                            handleSlot2Selection(index2);
                          },
                          child: Card(
                            color: selectedSlots2.contains(index2)
                                ? selectedColor
                                : cardColor,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(
                                  0), // Set contentPadding to zero
                              title: Center(
                                // Center the text
                                child: Text(
                                  '${slot2['time']}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    // Conditionally show selected slots
                    if (selectedSlots.isNotEmpty || selectedSlots2.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Selected Slots:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Wrap(
                                spacing: 8,
                                children: (selectedSlots.isNotEmpty)
                                    ? selectedSlots.map((index2) {
                                        var slot = station.slots[index2];
                                        return Chip(
                                          label: Text(
                                            '${slot['time']}, Port 1',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      }).toList()
                                    : (selectedSlots2.isNotEmpty)
                                        ? selectedSlots2.map((index2) {
                                            var slot2 = station.slots_2[index2];
                                            return Chip(
                                              label: Text(
                                                '${slot2['time']}, Port 2',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            );
                                          }).toList()
                                        : [const Text('No slots selected')],
                              ),
                            ],
                          )
                        ],
                      ),

                    const SizedBox(
                      height: 16,
                    ),

                    ElevatedButton(
                      onPressed:
                          selectedSlots.isNotEmpty || selectedSlots2.isNotEmpty
                              ? () {
                                  // Handle the Confirm and Pay action
                                  Get.offAll(() => RazorPayPaymentScreen(
                                      stationID: widget.stationID,
                                      slotTime: slotTime,
                                      slotID: slotID,
                                      slotSelected: slotClickedID));
                                }
                              : () {
                                  // Show a toast message indicating that a slot should be selected
                                  showToast('Please select a slot first');
                                },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedSlots.isNotEmpty ||
                                selectedSlots2.isNotEmpty
                            ? const Color.fromARGB(255, 22, 22, 22)
                            : const Color.fromARGB(
                                255, 56, 56, 56), // Disabled color
                        side: const BorderSide(
                            color: Color.fromARGB(255, 20, 20, 20)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Confirm and Pay",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  List<int> selectedSlots = [];
  List<int> selectedSlots2 = [];

  // Add a method to handle the selection of slots
  void handleSlotSelection(int index) {
    if (selectedSlots.contains(index)) {
      selectedSlots.remove(index);
    } else {
      slotClickedID = 1;
      selectedSlots.clear();
      selectedSlots2.clear();
      selectedSlots.add(index);
    }
  }

  void handleSlot2Selection(int index) {
    if (selectedSlots2.contains(index)) {
      selectedSlots2.remove(index);
    } else {
      slotClickedID = 2;
      selectedSlots.clear();
      selectedSlots2.clear();
      selectedSlots2.add(index);
    }
  }

// Add a method to show a toast message
  void showToast(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  DateTime convertTimeStringToDateTime(String timeString) {
    // Split the timeString into hours, minutes, and period (AM/PM)
    List<String> parts = timeString.split(' ');
    if (parts.length != 2) {
      throw ArgumentError("Invalid time format: $timeString");
    }

    // Extract hours, minutes, and period (AM/PM)
    int hours = int.parse(parts[0]);
    String period = parts[1].toUpperCase();

    // Check if hours and period are within valid ranges
    if ((hours < 1 || hours > 12) ||
        (period != 'AM' && period != 'PM')) {
      throw ArgumentError("Invalid time format: $timeString");
    }

    // Adjust hours if necessary
    if (period == 'PM' && hours < 12) {
      hours += 12;
    } else if (period == 'AM' && hours == 12) {
      hours = 0;
    }

    // Create a DateTime object with today's date and the parsed time
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hours, 0);
  }

}
