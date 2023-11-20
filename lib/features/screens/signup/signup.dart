import 'package:ev_charging_stations/features/screens/login/login.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              // Title
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: const Text(
                  "CREATE NEW ACCOUNT",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Form
              Form(
                child: Column(
                  children: [
                    // First Name
                    TextFormField(
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "First Name",
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Last Name
                    TextFormField(
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Last Name",
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Username
                    TextFormField(
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Username",
                        prefixIcon: const Icon(Icons.verified_user),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Email
                    TextFormField(
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.mail_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Password
                    TextFormField(
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Confirm Password
                    TextFormField(
                      obscureText: true,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Signup Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Create Account",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),
                    // Already have an account text
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Already have an account? Login here.",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
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
