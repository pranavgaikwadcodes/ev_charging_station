import 'dart:ffi';

import 'package:ev_charging_stations/features/screens/login/login.dart';
import 'package:ev_charging_stations/features/screens/onboarding.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();

  @override
  void onReady() {
    super.onReady();
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  void screenRedirect() {
    deviceStorage.writeIfNull('isFirstTime', true);
    final isFirstTime = deviceStorage.read('isFirstTime') ?? true;

    print('isFirstTime: $isFirstTime');

    isFirstTime ? goToOnboardingScreen() : goToLoginScreen();
  }

  void goToOnboardingScreen() {
    print('Navigating to onboarding screen');
    Get.off(() => const OnBoardingScreen());
  }

  void goToLoginScreen() {
    print('Navigating to login screen');
    Get.off(() => LoginScreen());
  }


}
