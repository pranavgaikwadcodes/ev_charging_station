
class Station {
  final String name;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final String status;
  final int stationID; // Change Random to int for stationID

  Station({
    required this.stationID,
    required this.name,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.status,
  });
}

List<Station> generateStations() {
  List<Station> Stations = [];


  // Manually add stations
  Stations.add(
    Station(
      stationID: 1,
      name: 'Manual Station 1',
      description: 'Description of Manual Station 1.',
      address: 'xyz abc city, pin, mh',
      latitude: 18.507966,  // Replace with the desired latitude
      longitude: 73.808073, // Replace with the desired longitude
      status: 'active',
    ),
  );

  Stations.add(
    Station(
      stationID: 2,
      name: 'Manual Station 2',
      description: 'Lohia Jain It Park',
      address: 'Paud Rd, Kothrud',
      latitude: 18.508625, 
      longitude: 73.789094,
      status: 'active',
    ),
  );

  Stations.add(
    Station(
      stationID: 3,
      name: 'Manual Station 3',
      description: 'Karve Nagar, Pune',
      address: 'Opp Vandevi Mandik, Hingne Budrukh, Karve Nagar, Pune, Maharashtra 411052',
      latitude: 18.492962, 
      longitude: 73.815376,
      status: 'active',
    ),
  );
  
  Stations.add(
    Station(
      stationID: 4,
      name: 'Manual Station 4',
      description: 'Sheela Vihar Colony, Pune',
      address: 'Sheela Vihar Colony, Pune, Maharashtra 411038',
      latitude: 18.506067, 
      longitude: 73.824270,
      status: 'active',
    ),
  );
  
  Stations.add(
    Station(
      stationID: 5,
      name: 'Manual Station 5',
      description: 'Revenue Colony, Pune',
      address: 'Kushabhau Jejurikar Rd, Revenue Colony, Pune, Maharashtra 411005',
      latitude: 18.528305,  
      longitude: 73.849857,
      status: 'active',
    ),
  );
  
  Stations.add(
    Station(
      stationID: 6,
      name: 'Manual Station 6',
      description: 'Deccan Gymkhana, Pune',
      address: 'Deccan Gymkhana, Pune, Maharashtra 411004',
      latitude: 18.513825, 
      longitude: 73.840787,
      status: 'active',
    ),
  );
  
  Stations.add(
    Station(
      stationID: 10,
      name: 'Manual Station 10',
      description: 'Warje, Pune',
      address: 'Warje Malwadi Rd, Motiram Nagar, Warje, Pune, Maharashtra 411058',
      latitude: 18.487367, 
      longitude: 73.796391,
      status: 'active',
    ),
  );
  
  Stations.add(
    Station(
      stationID: 10,
      name: 'Manual Station 10',
      description: 'Pashan, Pune',
      address: 'Pashan, Pune, Maharashtra 411021',
      latitude: 18.536506,
      longitude: 73.782883,
      status: 'active',
    ),
  );
  
  Stations.add(
    Station(
      stationID: 11,
      name: 'Manual Station 11',
      description: 'Swargate, Pune',
      address: 'Swargate, Pune, Maharashtra 411037',
      latitude: 18.500151, 
      longitude: 73.858782,
      status: 'active',
    ),
  );
  
  Stations.add(
    Station(
      stationID: 12,
      name: 'Manual Station 12',
      description: 'Koregaon Park, Pune',
      address: 'Koregaon Park, Pune, Maharashtra ',
      latitude: 18.539365, 
      longitude: 73.887928,
      status: 'active',
    ),
  );
  
  Stations.add(
    Station(
      stationID: 13,
      name: 'Manual Station 13',
      description: 'Baner, Pune',
      address: 'Baner, Pune, Maharashtra ',
      latitude: 18.564590, 
      longitude: 73.776508,
      status: 'active',
    ),
  );
  
  Stations.add(
    Station(
      stationID: 14,
      name: 'Manual Station 14',
      description: 'Kothrud, Pune',
      address: 'Yashashree Society, Rambaug Colony, Kothrud, Pune, Maharashtra 411038',
      latitude: 18.518168, 
      longitude: 73.817204,
      status: 'active',
    ),
  );
  

  
  // Random random = Random();

  // for (int i = 1; i <= 25; i++) {
  //   double latitude = 18.5204 + (random.nextDouble() - 0.5) * 0.1; // Random latitude around Pune
  //   double longitude = 73.8567 + (random.nextDouble() - 0.5) * 0.1; // Random longitude around Pune

  //   Stations.add(
  //     Station(
  //       stationID: random.nextInt(100), // Use nextInt to get a random integer between 0 and 99
  //       name: 'Station $i',
  //       description: '$i description of the station.',
  //       address: 'xyz abc city, pin, mh',
  //       latitude: latitude,
  //       longitude: longitude,
  //       status: 'active',
  //     ),
  //   );
  // }

  return Stations;
}



// {
//   "stationID": 1,
//   "name": "Charging Station 1",
//   "description": "Description of Charging Station 1.",
//   "address": "xyz abc city, pin, mh",
//   "latitude": 18.507966,
//   "longitude": 73.808073,
//   "status": "active",
//   "slots": [
//     {"time": "12 AM", "status": "free", "bookedBy": null},
//     {"time": "1 AM", "status": "free", "bookedBy": null},
//     {"time": "2 AM", "status": "free", "bookedBy": null},
//     {"time": "3 AM", "status": "free", "bookedBy": null},
//     {"time": "4 AM", "status": "free", "bookedBy": null},
//     {"time": "5 AM", "status": "free", "bookedBy": null},
//     {"time": "6 AM", "status": "free", "bookedBy": null},
//     {"time": "7 AM", "status": "free", "bookedBy": null},
//     {"time": "8 AM", "status": "free", "bookedBy": null},
//     {"time": "9 AM", "status": "free", "bookedBy": null},
//     {"time": "10 AM", "status": "free", "bookedBy": null},
//     {"time": "11 AM", "status": "free", "bookedBy": null},
    
//     {"time": "12 PM", "status": "free", "bookedBy": null},
//     {"time": "1 PM", "status": "free", "bookedBy": null},
//     {"time": "2 PM", "status": "free", "bookedBy": null},
//     {"time": "3 PM", "status": "free", "bookedBy": null},
//     {"time": "4 PM", "status": "free", "bookedBy": null},
//     {"time": "5 PM", "status": "free", "bookedBy": null},
//     {"time": "6 PM", "status": "free", "bookedBy": null},
//     {"time": "7 PM", "status": "free", "bookedBy": null},
//     {"time": "8 PM", "status": "free", "bookedBy": null},
//     {"time": "9 PM", "status": "free", "bookedBy": null},
//     {"time": "10 PM", "status": "free", "bookedBy": null},
//     {"time": "11 PM", "status": "free", "bookedBy": null},
//   ]
// }