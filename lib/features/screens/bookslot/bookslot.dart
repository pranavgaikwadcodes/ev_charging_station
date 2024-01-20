import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_charging_stations/features/screens/map_screen/map_screen.dart';
import 'package:ev_charging_stations/features/screens/payment/razorpay_payment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../station/station.dart';

late String slotTime;
late int slotID;

class BookSlot extends StatefulWidget {
  final int stationID;

  const BookSlot({super.key, required this.stationID});

  @override
  State<BookSlot> createState() => _BookSlotState();
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
              title: const Text("Slot Booking", style: TextStyle(color: Colors.white),),
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
                            ? selectedColor
                            : (status == 'booked'
                                ? Colors.orange
                                : defaultColor);

                        return GestureDetector(
                          onTap: () {
                            var slot = station.slots[index];
                            String status = slot.containsKey('status')
                                ? slot['status']
                                : '';

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

                    // Conditionally show selected slots
                    if (selectedSlots.isNotEmpty)
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
                                children: selectedSlots.map((index) {
                                  var slot = station.slots[index];
                                  return Chip(
                                    label: Text(
                                      '${slot['time']}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          )
                        ],
                      ),

                    const SizedBox(
                      height: 16,
                    ),

                    ElevatedButton(
                      onPressed: selectedSlots.isNotEmpty
                          ? () {
                              // Handle the Confirm and Pay action
                              Get.offAll(() => RazorPayPaymentScreen(stationID: widget.stationID, slotTime: slotTime, slotID: slotID));
                            }
                          : () {
                              // Show a toast message indicating that a slot should be selected
                              showToast('Please select a slot first');
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedSlots.isNotEmpty
                            ? const Color.fromARGB(255, 22, 22, 22)
                            : const Color.fromARGB(255, 56, 56, 56), // Disabled color
                        side: const BorderSide(
                            color: Color.fromARGB(255, 20, 20, 20)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Confirm and Pay",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
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

  // Add a method to handle the selection of slots
  void handleSlotSelection(int index) {
    if (selectedSlots.contains(index)) {
      selectedSlots.remove(index);
    } else {
      selectedSlots.clear();
      selectedSlots.add(index);
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
}
