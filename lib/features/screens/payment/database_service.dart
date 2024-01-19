import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> updateUser(int stationID, String slotTime) async {
    try {
      if (user != null) {
        // Get the reference to the user's document
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('users').doc(user!.email!);

        String _date = DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal());
        String _time = slotTime;
        int _stationID = stationID;

        // Update Firestore with the new booking
        await userDocRef.update({
          'bookings': FieldValue.arrayUnion([
            {
              'stationID': _stationID,
              'time': _time,
              'date': _date,
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

  Future<void> updateStation(int stationID, int slotID) async {
  try {
    if (user != null) {
      // Get the reference to the station document
      DocumentReference stationDocRef = _firestore.collection('stations').doc(stationID.toString());

      // Fetch the current station document
      DocumentSnapshot stationSnapshot = await stationDocRef.get();
      Map<String, dynamic> stationData = stationSnapshot.data() as Map<String, dynamic>;

      // Get the current slots array
      List<Map<String, dynamic>> slots = List<Map<String, dynamic>>.from(stationData['slots'] as List);

      int _time = slotID;
      String suffix;

      if(slotID == 0){
        _time = _time + 12;
        suffix = 'AM';
      } else if(slotID > 12){
        _time = _time - 12;
        suffix = 'PM';
      } else {
        suffix = 'AM';
      }

      // Update the specific slot
      slots[slotID] = {
        'time': "$_time $suffix",
        'status': 'booked',
        'bookedBy': user!.email,
      };

      // Update Firestore with the new slots array
      await stationDocRef.update({
        'slots': slots,
      });

      print('Booking updated successfully in Station Firestore');
    } else {
      print('User is not authenticated');
    }
  } catch (e) {
    print('Error updating Booking in Station Firestore: $e');
  }
}



}
