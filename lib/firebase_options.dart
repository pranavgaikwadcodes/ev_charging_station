// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBtAcI5YOkD7XwsWvV4H1oGbyrApzLP-7M',
    appId: '1:919162595868:web:4c063109e504ad87e40dd9',
    messagingSenderId: '919162595868',
    projectId: 'flutterevstationapp',
    authDomain: 'flutterevstationapp.firebaseapp.com',
    storageBucket: 'flutterevstationapp.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDYrn0s8dhLthWs-jVO5vDoXV2RSlg3EJQ',
    appId: '1:919162595868:android:94108372e93baa67e40dd9',
    messagingSenderId: '919162595868',
    projectId: 'flutterevstationapp',
    storageBucket: 'flutterevstationapp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCnQ-w3_b5LD9-UzPHWttl8nGYQPSWVAm4',
    appId: '1:919162595868:ios:e9880f58efa74bfde40dd9',
    messagingSenderId: '919162595868',
    projectId: 'flutterevstationapp',
    storageBucket: 'flutterevstationapp.appspot.com',
    iosBundleId: 'com.example.evChargingStations',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCnQ-w3_b5LD9-UzPHWttl8nGYQPSWVAm4',
    appId: '1:919162595868:ios:679387f3ef8dc36ce40dd9',
    messagingSenderId: '919162595868',
    projectId: 'flutterevstationapp',
    storageBucket: 'flutterevstationapp.appspot.com',
    iosBundleId: 'com.example.evChargingStations.RunnerTests',
  );
}
