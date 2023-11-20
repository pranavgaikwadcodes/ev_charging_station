import 'package:ev_charging_stations/features/screens/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      home: OnBoardingScreen(),
    );
  }
}