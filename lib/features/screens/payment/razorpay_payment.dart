import 'package:ev_charging_stations/features/screens/bookings/view_bookings.dart';
import 'package:ev_charging_stations/features/screens/bookslot/bookslot.dart';
import 'package:ev_charging_stations/features/screens/payment/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayPaymentScreen extends StatefulWidget {
  final int stationID;
  final int slotID, slotSelected;
  final String slotTime;

  const RazorPayPaymentScreen({super.key, required this.stationID, required this.slotTime, required this.slotID, required this.slotSelected});

  @override
  State<RazorPayPaymentScreen> createState() => _RazorPayPaymentScreenState();
}

class _RazorPayPaymentScreenState extends State<RazorPayPaymentScreen> {
  late Razorpay _razorpay;
  final user = FirebaseAuth.instance.currentUser!;

  void openCheckout(amount) async {
    amount = amount * 100;
    var options = {
      // 'key': 'rzp_test_YViNItgZr6irqs',
      // 'key': 'rzp_test_FoEhUHodBwBdY1',
      'key': 'rzp_test_WbAxTov9hC5RKF',
      'amount': amount,
      'name': 'EV Station',
      'prefill': {'email': user.email},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) async {

    try {
      // update in database
      await DatabaseService().updateUser(widget.stationID, widget.slotTime, widget.slotSelected, widget.slotID);
      await DatabaseService().updateStation(widget.stationID, widget.slotID, widget.slotSelected);
      

      Get.offAll(() => const ViewBookingsScreen());

      Fluttertoast.showToast(
          msg: "Payment Successful ${response.paymentId!}",
          toastLength: Toast.LENGTH_SHORT);
            
      Fluttertoast.showToast(
        msg: "Booking Congfirmed!\nYour Slot Was Booked",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

    } catch (e) {
      print('Error : $e');
    }
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Error ${response.message!}",
        toastLength: Toast.LENGTH_LONG);
  }

  void handleExternalWallets(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "ExternalWallets ${response.walletName!}",
        toastLength: Toast.LENGTH_SHORT);
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
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallets);

    openCheckout(10);

    print("myslot: ${widget.slotTime}");
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
        title: const Text("Payment Screen", style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          const Text("Please Dont close the App. loading..."),
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
          ),
          CircularProgressIndicator(color: Colors.black,),

        ],
      ),
    );
  }
  




}


// this is my users collection
// email, name, age, mobile and
// vehicle array that has vehicle info 
// need to create a bookings array that has ongoing array which has all info on the ongoing bookings