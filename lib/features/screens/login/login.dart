import 'package:ev_charging_stations/features/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:ev_charging_stations/features/screens/signup/signup.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail_outline_rounded),
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: "Password",
                        suffixIcon: Icon(Icons.remove_red_eye),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(value: false, onChanged: (value) {}),
                            const Text("Remember me"),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forgot Password",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Get.to( () => const HomeScreen()),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Sign In",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Get.to(() => const SignupScreen()),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          side: BorderSide(color: Colors.blue),
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
