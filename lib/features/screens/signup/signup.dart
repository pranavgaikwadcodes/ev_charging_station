import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_charging_stations/features/screens/home/home.dart';
import 'package:ev_charging_stations/features/screens/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthController extends GetxController {
  late String name;
  final hidePassword = true.obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController vehicleRegistrationPlateNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  RxBool isLoading = false.obs;
  var userCredentials;

  void showErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color.fromARGB(255, 54, 190, 244),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> signupWithEmailAndPwd() async {
    isLoading.value = true;
    try {
      await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await _db.collection("users").doc(emailController.text.trim()).set({
        "email": emailController.text.trim(),
        "name": nameController.text.trim(),
        "vehicleRegistrationPlateNumber": vehicleRegistrationPlateNumberController.text.trim(),
      });

      isLoading.value = false;
      // Show toast message
      Fluttertoast.showToast(
        msg: "Registration successful, Logging you in...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Get.to(() => HomeScreen());
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      if (e.code == 'weak-password') {
        showErrorMessage('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showErrorMessage('The account already exists for that email.');
      }
    } catch (e) {
      isLoading.value = false;
      showErrorMessage('An unexpected error occurred');
    }

    isLoading.value = false;
  }
}

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            "assets/background2.png", // Replace with your background image asset
            fit: BoxFit.cover,
          ),
          // Glass effect container
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.3),
              // Adjust the opacity as needed
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Form
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(158, 255, 255, 255),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Form(
                        child: Column(
                          children: [
                            // Title
                            Container(
                              child: const Text(
                                "CREATE NEW ACCOUNT",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            // Name
                            TextFormField(
                              controller: authController.nameController,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "Name",
                                prefixIcon: const Icon(Icons.mail_rounded),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            // Email
                            TextFormField(
                              controller: authController.emailController,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "Email",
                                prefixIcon: const Icon(Icons.mail_rounded),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            // Number Plate
                            TextFormField(
                              controller: authController.vehicleRegistrationPlateNumberController,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "Vehicle registration plate number",
                                prefixIcon: const Icon(Icons.confirmation_number),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),

                            // Password
                            Obx(
                              () => TextFormField(
                                controller: authController.passwordController,
                                style: const TextStyle(color: Colors.black),
                                obscureText: authController.hidePassword.value,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: "Password",
                                  prefixIcon: const Icon(Icons.lock),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () =>
                                        authController.hidePassword.value =
                                            !authController.hidePassword.value,
                                    icon: const Icon(
                                        Icons.remove_red_eye_outlined),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 15),

                            // Signup Button
                            SizedBox(
                              child: Obx(
                                () => authController.isLoading.value
                                    ? const CircularProgressIndicator()
                                    : ElevatedButton(
                                        onPressed: () {
                                          if (authController.nameController.text.isEmpty ||
                                              authController.emailController
                                                  .text.isEmpty ||
                                              authController.passwordController
                                                  .text.isEmpty) {
                                            // Show toast message if any of the fields is empty
                                            authController.showErrorMessage(
                                                "Fill All Details To Sign-Up");
                                          } else {
                                            authController
                                                .signupWithEmailAndPwd();
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color.fromARGB(
                                              255, 111, 214, 255),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 10),
                                        ),
                                        child: const Text(
                                          "Create Account",
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 30),
                            // Already have an account text
                            GestureDetector(
                              onTap: () {
                                Future.delayed(Duration.zero, () {
                                  Get.off(() => LoginScreen());
                                });
                              },
                              child: const Text(
                                "Already have an account? Login here.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
