import 'package:ev_charging_stations/features/controller/AuthController.dart';
import 'package:ev_charging_stations/features/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ev_charging_stations/features/screens/signup/signup.dart';






class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final hidePassword = true.obs;
  final isLoading = false.obs;
  final errorText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkUserLoggedIn();
  }

  void checkUserLoggedIn() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      // User is already logged in
      print("User is already logged in: ${user.uid}");
      // Defer navigation until after the frame is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => HomeScreen());
      });
    } else {
      // User is not logged in
      print("User is not logged in");
    }
  }

  void togglePasswordVisibility() {
    hidePassword.value = !hidePassword.value;
  }

  void signIn() async {
    isLoading.value = true;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Get.offAll(() => HomeScreen());
      print("Logged in");
    } catch (e) {
      print("Error: $e");

      if (e is FirebaseAuthException) {
        if (e.code == 'invalid-email' || e.code == 'user-not-found') {
          errorText.value = 'Incorrect email or password';
        } else if (e.code == 'wrong-password') {
          errorText.value = 'Incorrect password';
        } else if (e.code == 'invalid-credential') {
          errorText.value = 'Invalid credential. Please check your email and password.';
        } else if (e.code == 'too-many-requests') {
          errorText.value = 'Access to this account has been temporarily disabled due to many failed login attempts. Please reset your password or try again later.';
        } else {
          errorText.value = 'An error occurred during sign-in';
        }
      } else {
        errorText.value = 'An unexpected error occurred';
      }
    } finally {
      isLoading.value = false;
    }
  }
}

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController loginController = Get.put(LoginController());


  @override
  Widget build(BuildContext context) {

    AuthController authController = Get.put(AuthController());
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  "assets/logo/logo.png",
                  height: 150,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Welcome Back!",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Let's power up your journey with a single click\nYour sustainable travels begin here.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: loginController.emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.mail_outline_rounded),
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Obx(() => TextFormField(
                      controller: loginController.passwordController,
                      obscureText: loginController.hidePassword.value,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => loginController.hidePassword.value = !loginController.hidePassword.value,
                          icon: const Icon(Icons.remove_red_eye_outlined),
                        ),
                      ),
                    ),),
                    
                    const SizedBox(height: 10),

                    Obx(() => // Obx widget to observe changes in errorText
                  loginController.errorText.value.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            loginController.errorText.value,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : const SizedBox.shrink()),

                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loginController.signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Obx(() => // Obx widget to observe changes in isLoading
                            loginController.isLoading.value
                                ? const CircularProgressIndicator(color: Colors.white,) // Show loading circle
                                : const Text(
                                    "Sign In",
                                    style: TextStyle(fontSize: 18),
                                  )),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Get.to(() => const SignupScreen()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Create Account",
                          style: TextStyle(fontSize: 18, color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
