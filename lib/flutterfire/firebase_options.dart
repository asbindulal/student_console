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
    apiKey: 'AIzaSyAs2HN76eexqaQWCdX1KBf8_7Unun1Tpq8',
    appId: '1:916784473458:web:b01eddd9a7dfc19954e9eb',
    messagingSenderId: '916784473458',
    projectId: 'student-console-asbin',
    authDomain: 'student-console-asbin.firebaseapp.com',
    storageBucket: 'student-console-asbin.appspot.com',
    measurementId: 'G-Z8HN1TCBBT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCqLE4PG5g1c1e-T3Yr8PsGApxAuKFrJao',
    appId: '1:916784473458:android:c0963076be531bbd54e9eb',
    messagingSenderId: '916784473458',
    projectId: 'student-console-asbin',
    storageBucket: 'student-console-asbin.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDn4TTfuOzjMKp-MSytW3mklEeT8CrQzkA',
    appId: '1:916784473458:ios:32220ea765c64b4f54e9eb',
    messagingSenderId: '916784473458',
    projectId: 'student-console-asbin',
    storageBucket: 'student-console-asbin.appspot.com',
    iosClientId: '916784473458-5kb1d36mdn328v8t7619pna3jrbre7i6.apps.googleusercontent.com',
    iosBundleId: 'np.com.asbin.studentconsole',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDn4TTfuOzjMKp-MSytW3mklEeT8CrQzkA',
    appId: '1:916784473458:ios:32220ea765c64b4f54e9eb',
    messagingSenderId: '916784473458',
    projectId: 'student-console-asbin',
    storageBucket: 'student-console-asbin.appspot.com',
    iosClientId: '916784473458-5kb1d36mdn328v8t7619pna3jrbre7i6.apps.googleusercontent.com',
    iosBundleId: 'np.com.asbin.studentconsole',
  );
}
