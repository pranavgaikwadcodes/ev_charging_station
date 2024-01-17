import 'package:ev_charging_stations/features/authentication/controllers.onboarding/AuthenticationRepository.dart';
import 'package:ev_charging_stations/features/screens/home/home.dart';
import 'package:ev_charging_stations/features/screens/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((FirebaseApp value) => Get.put(AuthenticationRepository()));

  runApp(const App());
}


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // Handle authentication errors
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: Text("Error: ${snapshot.error}")),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading state while checking authentication status
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData) {
            // User is authenticated, navigate to HomeScreen
            return HomeScreen();
          } else {
            // User is not authenticated, show onboarding/login screen
            return const OnBoardingScreen();
          }
        },
      ),
    );
  }
}
