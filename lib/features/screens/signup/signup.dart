import 'package:ev_charging_stations/features/controller/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());

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
                    // Name
                    TextFormField(
                      controller: authController.nameController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
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
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.mail_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Password
                    Obx(() => TextFormField(
                      controller: authController.passwordController,
                      style: const TextStyle(color: Colors.black),
                      obscureText: authController.hidePassword.value,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),

                        suffixIcon: IconButton(
                          onPressed: () => authController.hidePassword.value = !authController.hidePassword.value,
                          icon: const Icon(Icons.remove_red_eye_outlined),
                        ),
                      ),
                    ),),

                    const SizedBox(height: 15),
                    
                    // Signup Button
                    SizedBox(
                      child: 
                      Obx(() => authController.isLoading.value ? const CircularProgressIndicator() : ElevatedButton(
                        onPressed: () {
                          authController.signupWithEmailAndPwd();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        ),
                        child: const Text(
                          "Create Account",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),)
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
