// import 'dart:async';

// import 'package:geolocator/geolocator.dart';

// class LocationService {
//   static LocationService? _instance;

//   // Add a stream controller to expose location updates
//   final StreamController<Position> _locationController = StreamController<Position>.broadcast();

//   Position _currentLocation = Position(
//     latitude: 0,
//     longitude: 0,
//     timestamp: DateTime.now(),
//     accuracy: 0.0,
//     altitude: 0.0,
//     altitudeAccuracy: 0.0,
//     heading: 0.0,
//     headingAccuracy: 0.0,
//     speed: 0.0,
//     speedAccuracy: 0.0,
//   );

//   factory LocationService() {
//     _instance ??= LocationService._internal();
//     return _instance!;
//   }

//   LocationService._internal() {
//     _requestPermission();
//     _updateLocation();
//   }

//   // Expose the location stream
//   Stream<Position> get locationStream => _locationController.stream;

//   double get latitude => _currentLocation.latitude;
//   double get longitude => _currentLocation.longitude;

//   void _updateLocation() async {
//     try {
//       Position newPosition = await Geolocator.getCurrentPosition();
//       _currentLocation = newPosition;
//       print("Location updated: ${newPosition.latitude}, ${newPosition.longitude}");
//     } catch (e) {
//       print("Error updating location: $e");
//     }
//   }


//   Future<void> _requestPermission() async {
//     LocationPermission permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       print('Location permissions are denied');
//     } else if (permission == LocationPermission.deniedForever) {
//       print('Location permissions are permanently denied, we cannot request permissions.');
//     } else {
//       print('Location permissions granted');
//       _updateLocation(); // Call _updateLocation after getting permissions
//     }
//   }

// }



import 'dart:async';

import 'package:geolocator/geolocator.dart';

class LocationService {
  static LocationService? _instance;

  final StreamController<Position> _locationController = StreamController<Position>.broadcast();
  Position _currentLocation = Position(
    latitude: 0,
    longitude: 0,
    timestamp: DateTime.now(),
    accuracy: 0.0,
    altitude: 0.0,
    altitudeAccuracy: 0.0,
    heading: 0.0,
    headingAccuracy: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
  );

  factory LocationService() {
    _instance ??= LocationService._internal();
    return _instance!;
  }

  LocationService._internal() {
    requestPermission(); // Call _requestPermission instead of _checkLocationPermission
    _updateLocation();
  }

  Stream<Position> get locationStream => _locationController.stream;

  double get latitude => _currentLocation.latitude;
  double get longitude => _currentLocation.longitude;

  Future<void> _updateLocation() async {
    try {
      Position newPosition = await Geolocator.getCurrentPosition();
      _currentLocation = newPosition;
      print("Location updated: ${newPosition.latitude}, ${newPosition.longitude}");
      _locationController.add(newPosition);
    } catch (e) {
      print("Error updating location: $e");
    }
  }

  Future<LocationPermission> requestPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied');
    } else if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied, we cannot request permissions.');
    } else {
      print('Location permissions granted');
      _updateLocation(); // Call _updateLocation after getting permissions
    }
    return permission;
  }

  void dispose() {
    _locationController.close();
  }
}
