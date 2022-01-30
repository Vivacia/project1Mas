import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (kIsWeb) {
      // Web
      return const FirebaseOptions(
        apiKey: 'AIzaSyAgUhHU8wSJgO5MVNy95tMT07NEjzMOfz0',
        appId: '1:862006808495:web:bd28235b117df4e2b8295a',
        messagingSenderId: '448618578101',
        projectId: 'react-native-firebase-testing',
        authDomain: 'react-native-firebase-testing.firebaseapp.com',
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      // iOS and MacOS
      return const FirebaseOptions(
        apiKey: 'AIzaSyAHAsf51D0A407EklG1bs-5wA7EbyfNFg0',
        appId: '1:862006808495:ios:0fb54411f4f93647b8295a',
        messagingSenderId: '448618578101',
        projectId: 'react-native-firebase-testing',
        authDomain: 'react-native-firebase-testing.firebaseapp.com',
        iosBundleId: 'io.flutter.plugins.firebase.auth',
        databaseURL: 'https://react-native-firebase-testing.firebaseio.com',
        iosClientId:
            '448618578101-m53gtqfnqipj12pts10590l37npccd2r.apps.googleusercontent.com',
        androidClientId:
            '448618578101-26jgjs0rtl4ts2i667vjb28kldvs2kp6.apps.googleusercontent.com',
        storageBucket: 'react-native-firebase-testing.appspot.com',
      );
    } else {
      // Android
      return const FirebaseOptions(
        apiKey: 'AIzaSyCuu4tbv9CwwTudNOweMNstzZHIDBhgJxA',
        appId: '1:862006808495:android:dd2e26921327db5db8295a',
        messagingSenderId: '448618578101',
        projectId: 'react-native-firebase-testing',
        authDomain: 'react-native-firebase-testing.firebaseapp.com',
        databaseURL: 'https://react-native-firebase-testing.firebaseio.com',
        androidClientId:
            '448618578101-qd7qb4i251kmq2ju79bl7sif96si0ve3.apps.googleusercontent.com',
      );
    }
  }
}
