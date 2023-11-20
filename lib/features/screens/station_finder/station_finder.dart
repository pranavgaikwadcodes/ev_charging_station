import 'package:ev_charging_stations/features/screens/map_screen/map_screen.dart';
import 'package:flutter/material.dart';

class StationFinderScreen extends StatefulWidget {
  const StationFinderScreen({Key? key}) : super(key: key);

  @override
  _StationFinderScreenState createState() => _StationFinderScreenState();
}

class _StationFinderScreenState extends State<StationFinderScreen> {
  String? locationValue;
  String? vehicleTypeValue;

  Widget buildDropdownField(String labelText, List<String> items,
      String? selectedValue, void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.directions_car),
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

  @override
  Widget build(BuildContext context) {
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
            buildDropdownField(
              'Select Vehicle Type',
              ['2 Wheeler', '4 Wheeler'],
              vehicleTypeValue,
              (String? value) {
                setState(() {
                  vehicleTypeValue = value;
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
                          color: Color.fromARGB(255, 253, 253, 253)),
                    ),
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
            const Text("Stations",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black)),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero, // Set padding to zero
                itemCount:
                    10, // Change this to the number of demo stations you want
                itemBuilder: (context, index) {


                  return GestureDetector(
                    onTap: () {
                      // Navigate to the new map screen when the card is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapScreen(), // Replace MapScreen with the actual screen you want to navigate to
                        ),
                      );
                    },
                    


                    child: Card(
                      color: Color.fromARGB(221, 228, 228, 228),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      width: 95,
                                      child: Column(children: [
                                        Text(
                                          'Station: ${index + 1}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        const Text('Station name here',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w500),
                                            overflow: TextOverflow.ellipsis),
                                      ]),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Column(
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      child: Column(children: [
                                        Text('Distance',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black),
                                            overflow: TextOverflow.ellipsis),
                                        Text('5km',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w500),
                                            overflow: TextOverflow.ellipsis),
                                      ]),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Column(
                                  children: [
                                    SizedBox(
                                      width: 60,
                                      child: Column(
                                        children: [
                                          Text('Status',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black),
                                              overflow: TextOverflow.ellipsis),
                                          Text('Active',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color.fromARGB(255, 16, 156, 21),
                                                  fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.ellipsis),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Column(
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      child: Column(
                                        children: [
                                          Text(
                                            'Location',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black),
                                          ),
                                          Text('Pune west city',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(255, 14, 85, 143)),
                                              overflow: TextOverflow.ellipsis),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
