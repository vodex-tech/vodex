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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBet9CBfIHMxr5juZXNNZJhbbvUhZ9X8lQ',
    appId: '1:940744320448:web:f2eefeea1d4ed049809425',
    messagingSenderId: '940744320448',
    projectId: 'vodex-logic',
    authDomain: 'vodex-logic.firebaseapp.com',
    databaseURL: 'https://vodex-logic-default-rtdb.firebaseio.com',
    storageBucket: 'vodex-logic.appspot.com',
    measurementId: 'G-3728MKGPRV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDKc22t59yfiFSjG1sNmly7GT9OH1DiX18',
    appId: '1:940744320448:android:2529ea2fbd3fde90809425',
    messagingSenderId: '940744320448',
    projectId: 'vodex-logic',
    databaseURL: 'https://vodex-logic-default-rtdb.firebaseio.com',
    storageBucket: 'vodex-logic.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBODLpOG923fgv7rpiVtDGoJN8xenbUr8k',
    appId: '1:940744320448:ios:1316ebbd414af8f2809425',
    messagingSenderId: '940744320448',
    projectId: 'vodex-logic',
    databaseURL: 'https://vodex-logic-default-rtdb.firebaseio.com',
    storageBucket: 'vodex-logic.appspot.com',
    iosBundleId: 'com.vodex.logicStudy',
  );
}
