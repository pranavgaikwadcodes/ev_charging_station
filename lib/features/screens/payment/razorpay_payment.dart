import 'package:ev_charging_stations/features/screens/bookings/view_bookings.dart';
import 'package:ev_charging_stations/features/screens/bookslot/bookslot.dart';
import 'package:ev_charging_stations/features/screens/home/home.dart';
import 'package:ev_charging_stations/features/screens/map_screen/map_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayPaymentScreen extends StatefulWidget {
  final int stationID;

  const RazorPayPaymentScreen({Key? key, required this.stationID})
      : super(key: key);

  @override
  State<RazorPayPaymentScreen> createState() => _RazorPayPaymentScreenState();
}

class _RazorPayPaymentScreenState extends State<RazorPayPaymentScreen> {
  late Razorpay _razorpay;
  final user = FirebaseAuth.instance.currentUser!;

  void openCheckout(amount) async {
    amount = amount * 100;
    var options = {
      'key': 'rzp_test_YViNItgZr6irqs',
      'amount': amount,
      'name': 'EV Station',
      'prefill': {'email': user.email},
      'external': {
        'wallets': ['paytm', 'googlepay']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {

    // update in database
    updateBookingsInDatabase(user, widget.stationID);


    Get.offAll(() => const ViewBookingsScreen());

    Fluttertoast.showToast(
        msg: "Payment Successful ${response.paymentId!}",
        toastLength: Toast.LENGTH_LONG);
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Error ${response.message!}",
        toastLength: Toast.LENGTH_LONG);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);

    openCheckout(10);
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
            Get.offAll(() => BookSlot(stationID: widget.stationID));
          },
        ),
        title: const Text("Payment Screen"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          const Text("Please Dont close the App"),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                openCheckout(10);
              });
            },
            child: const Text('Pay', style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700
            ),),
          )

        ],
      ),
    );
  }
  
  // Update in Firestore
  void updateBookingsInDatabase(User user, int stationID) {
    // update in users database

    // update the station database
  }
}


// users collection
// email name age mobile 
// vehicle array that has vehicle info 
// need to create a bookings array that has ongoing array which has all info on the ongoing bookings