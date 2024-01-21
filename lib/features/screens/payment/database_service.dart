import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> updateUser(int stationID, String slotTime, int slotSelected, int slotID) async {
    try {
      if (user != null) {
        // Get the reference to the user's document
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('users').doc(user!.email!);

        String date = DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal());
        String time = slotTime;
        int stationID0 = stationID;

        // Update Firestore with the new booking
        await userDocRef.update({
          'bookings': FieldValue.arrayUnion([
            {
              'stationID': stationID0,
              'time': time,
              'date': date,
              'port': slotSelected,
              'slotID': slotID,
            }
          ]),
        });

        print('Booking updated successfully in User Firestore');
      } else {
        print('User is not authenticated');
      }
    } catch (e) {
      print('Error updating Booking in User Firestore: $e');
    }
  }

  Future<void> updateStation(int stationID, int slotID, int slotSelected) async {
  
  printInfo(info: 'SlotSelected: $slotSelected');
  
    try {

      // Check for which slot to update
      String slotToUpdate = '';
      if(slotSelected == 1) {
        slotToUpdate = 'slots';
      } else {
        slotToUpdate = 'slots_2';
      }
      

      if (user != null) {
        // Get the reference to the station document
        DocumentReference stationDocRef = _firestore.collection('stations').doc(stationID.toString());

        // Fetch the current station document
        DocumentSnapshot stationSnapshot = await stationDocRef.get();
        Map<String, dynamic> stationData = stationSnapshot.data() as Map<String, dynamic>;

        // Get the current slots array
        List<Map<String, dynamic>> slots = List<Map<String, dynamic>>.from(stationData['$slotToUpdate'] as List);

        int time = slotID;
        String suffix;

        if(slotID == 0){
          time = time + 12;
          suffix = 'AM';
        } else if(slotID > 12){
          time = time - 12;
          suffix = 'PM';
        } else {
          suffix = 'AM';
        }

        // Update the specific slot
        slots[slotID] = {
          'time': "$time $suffix",
          'status': 'booked',
          'bookedBy': user!.email,
        };

        // Update Firestore with the new slots array
        await stationDocRef.update({
          '$slotToUpdate': slots,
        });

        print('Booking updated successfully in Station Firestore');
      } else {
        print('User is not authenticated');
      }
    } catch (e) {
      print('Error updating Booking in Station Firestore: $e');
    }
     


}


  Future<void> moveToUserBookingHistory(int stationID, String slotTime, int slotSelected, int slotID) async {
    try {
      if (user != null) {
        // Get the reference to the user's document
        DocumentReference userDocRef = _firestore.collection('users').doc(user!.email!);

        String date = DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal());
        String time = slotTime;
        int stationID0 = stationID;

        // Remove the booking from the 'bookings' array
        await userDocRef.update({
          'bookings': FieldValue.arrayRemove([
            {
              'stationID': stationID,
              'time': time,
              'date': date,
              'port': slotSelected,
              'slotID': slotID,
            }
          ]),
        });

        // Add the booking to the 'bookingHistory' array
        await userDocRef.update({
          'bookingHistory': FieldValue.arrayUnion([
            {
              'stationID': stationID0,
              'time': time,
              'date': date,
              'port': slotSelected,
              'slotID': slotID,
            }
          ]),
        });

        print('Booking moved to User Booking History successfully');
      } else {
        print('User is not authenticated');
      }
    } catch (e) {
      print('Error moving booking to User Booking History: $e');
    }
  }

  Future<void> freeStationSlot(int stationID, int slotSelected, int slotID) async {
    try {
      // Check for which slot to update
      String slotToUpdate = (slotSelected == 1) ? 'slots' : 'slots_2';

      // Get the reference to the station document
      DocumentReference stationDocRef = _firestore.collection('stations').doc(stationID.toString());

      // Fetch the current station document
      DocumentSnapshot stationSnapshot = await stationDocRef.get();
      Map<String, dynamic> stationData = stationSnapshot.data() as Map<String, dynamic>;

      // Get the current slots array
      List<Map<String, dynamic>> slots = List<Map<String, dynamic>>.from(stationData['$slotToUpdate'] as List);

      // Update the specific slot to be free
      slots[slotID] = {
        'time': slots[slotID]['time'],
        'status': 'free',
        'bookedBy': '',
      };

      // Update Firestore with the new slots array
      await stationDocRef.update({
        '$slotToUpdate': slots,
      });

      print('Station slot freed successfully');
    } catch (e) {
      print('Error freeing station slot: $e');
    }
  }



}
