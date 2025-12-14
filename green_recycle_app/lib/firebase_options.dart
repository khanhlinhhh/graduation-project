// File generated based on google-services.json
// This file is required for Firebase initialization

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAnG5vcOU8_7ZWvE-iEnciH5i8sBSngwAw',
    appId: '1:49958639886:android:8c2db18d029db583f8df5f',
    messagingSenderId: '49958639886',
    projectId: 'green-app-95926',
    storageBucket: 'green-app-95926.firebasestorage.app',
  );

  // Placeholder for iOS - update with actual values from GoogleService-Info.plist
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAnG5vcOU8_7ZWvE-iEnciH5i8sBSngwAw',
    appId: '1:49958639886:android:8c2db18d029db583f8df5f',
    messagingSenderId: '49958639886',
    projectId: 'green-app-95926',
    storageBucket: 'green-app-95926.firebasestorage.app',
    iosBundleId: 'com.greenrecycle.greenRecycleApp',
  );

  // Placeholder for macOS
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAnG5vcOU8_7ZWvE-iEnciH5i8sBSngwAw',
    appId: '1:49958639886:android:8c2db18d029db583f8df5f',
    messagingSenderId: '49958639886',
    projectId: 'green-app-95926',
    storageBucket: 'green-app-95926.firebasestorage.app',
  );

  // Placeholder for Web - update with actual web app config from Firebase Console
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAnG5vcOU8_7ZWvE-iEnciH5i8sBSngwAw',
    appId: '1:49958639886:android:8c2db18d029db583f8df5f',
    messagingSenderId: '49958639886',
    projectId: 'green-app-95926',
    storageBucket: 'green-app-95926.firebasestorage.app',
    authDomain: 'green-app-95926.firebaseapp.com',
  );

  // Placeholder for Windows
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAnG5vcOU8_7ZWvE-iEnciH5i8sBSngwAw',
    appId: '1:49958639886:android:8c2db18d029db583f8df5f',
    messagingSenderId: '49958639886',
    projectId: 'green-app-95926',
    storageBucket: 'green-app-95926.firebasestorage.app',
  );
}
