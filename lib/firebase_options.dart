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
    apiKey: 'AIzaSyAYumqDDF8FdnDHek4Ja5Qrfe1Rrng1Lno',
    appId: '1:971079052727:web:9fed5eade521bf88ab4c32',
    messagingSenderId: '971079052727',
    projectId: 'mynotes-flutter-project-0451',
    authDomain: 'mynotes-flutter-project-0451.firebaseapp.com',
    storageBucket: 'mynotes-flutter-project-0451.appspot.com',
    measurementId: 'G-2EP2ED6SFT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBYuGZ9JCMP5ChTSNe25q9iaRMseGDohBs',
    appId: '1:971079052727:android:3178bdc6fb9b3475ab4c32',
    messagingSenderId: '971079052727',
    projectId: 'mynotes-flutter-project-0451',
    storageBucket: 'mynotes-flutter-project-0451.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDw56yZzQePayuDjGjGC1b6482dPj2XPyc',
    appId: '1:971079052727:ios:d703a7e366820c7bab4c32',
    messagingSenderId: '971079052727',
    projectId: 'mynotes-flutter-project-0451',
    storageBucket: 'mynotes-flutter-project-0451.appspot.com',
    iosClientId: '971079052727-sbn9295unqvo3kupt2j2402fkdvupqij.apps.googleusercontent.com',
    iosBundleId: 'com.domainname.mynotes',
  );
}
