import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_charging_stations/features/authentication/userModel.dart';
import 'package:ev_charging_stations/features/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {

  late String name;
  final hidePassword = true.obs;
  
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  RxBool isLoading = false.obs;
  var userCredentials;

  Future<void> signupWithEmailAndPwd () async {
    isLoading.value = true;
    try{
      await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim(),
      );

      await FirebaseFirestore.instance.collection("users")
      .doc(emailController.text.trim())
      .set(
        {"email" : emailController.text.trim(),
        "name" : nameController.text.trim(),}
      );

      isLoading.value = false;

      Get.to( () => HomeScreen() );
      
    } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          isLoading.value = false;
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          isLoading.value = false;
        }
      } catch (e) {
        print(e);
        isLoading.value = false;
      }

      isLoading.value = false;

  } 

}