// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyD32csCYZbjNHXv1SignbNLg6wyNlfAjO0',
    appId: '1:727775604654:web:7b162cf3592c9ea74ba23f',
    messagingSenderId: '727775604654',
    projectId: 'anicom-app',
    authDomain: 'anicom-app.firebaseapp.com',
    databaseURL: 'https://anicom-app-default-rtdb.firebaseio.com',
    storageBucket: 'anicom-app.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDTmv0Yczpdkqzefwiwq9K5XL4Ur9sILQs',
    appId: '1:727775604654:android:3984d46b47f249c34ba23f',
    messagingSenderId: '727775604654',
    projectId: 'anicom-app',
    databaseURL: 'https://anicom-app-default-rtdb.firebaseio.com',
    storageBucket: 'anicom-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB5nsKYoyRI_y8Tf1b5QxsaTVIwXbkycBQ',
    appId: '1:727775604654:ios:b0a4866df3ab9da54ba23f',
    messagingSenderId: '727775604654',
    projectId: 'anicom-app',
    databaseURL: 'https://anicom-app-default-rtdb.firebaseio.com',
    storageBucket: 'anicom-app.firebasestorage.app',
    iosBundleId: 'com.example.anicomApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB5nsKYoyRI_y8Tf1b5QxsaTVIwXbkycBQ',
    appId: '1:727775604654:ios:b0a4866df3ab9da54ba23f',
    messagingSenderId: '727775604654',
    projectId: 'anicom-app',
    databaseURL: 'https://anicom-app-default-rtdb.firebaseio.com',
    storageBucket: 'anicom-app.firebasestorage.app',
    iosBundleId: 'com.example.anicomApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD32csCYZbjNHXv1SignbNLg6wyNlfAjO0',
    appId: '1:727775604654:web:86c6e2231ddfedfd4ba23f',
    messagingSenderId: '727775604654',
    projectId: 'anicom-app',
    authDomain: 'anicom-app.firebaseapp.com',
    databaseURL: 'https://anicom-app-default-rtdb.firebaseio.com',
    storageBucket: 'anicom-app.firebasestorage.app',
  );
}
