// station.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Station {
  final int stationID;
  final String name;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final List<dynamic> slots;
  
  Station({
    required this.stationID,
    required this.name,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.slots,
  });

  // Factory method to create a Station object from a DocumentSnapshot
  factory Station.fromFirestore(DocumentSnapshot doc) {
    // Extract data from the DocumentSnapshot
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    // Check if data is not null before accessing fields
    if (data == null) {
      // Handle the case where data is null (you can return a default or throw an exception)
      throw const FormatException("Document data is null");
    }

    // Ensure proper conversion for latitude and longitude
    double? latitude = (data['latitude'] is num) ? data['latitude'].toDouble() : null;
    double? longitude = (data['longitude'] is num) ? data['longitude'].toDouble() : null;

    // Check if the 'status' key exists before accessing it
    String status = data.containsKey('status') ? data['status'] : '';

    // Return a new Station object
    return Station(
      stationID: int.parse(doc.id) ?? 0,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      address: data['address'] ?? '',
      latitude: latitude ?? 0.0, // Default to 0.0 if latitude is null
      longitude: longitude ?? 0.0, // Default to 0.0 if longitude is null
      slots: data['slots'] ?? [],
    );
  }


}
