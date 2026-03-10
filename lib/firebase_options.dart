import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError('Plataforma não suportada');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSy_Android_Placeholder',
    appId: '1:play2travel:android:12345',
    messagingSenderId: '123456789',
    projectId: 'play2travel',
    storageBucket: 'play2travel.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSy_iOS_Placeholder',
    appId: '1:play2travel:ios:12345',
    messagingSenderId: '123456789',
    projectId: 'play2travel',
    storageBucket: 'play2travel.appspot.com',
    iosBundleId: 'com.example.play2travel',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSy_Web_Placeholder',
    appId: '1:play2travel:web:12345',
    messagingSenderId: '123456789', // ESTA LINHA RESOLVE O ERRO
    projectId: 'play2travel',
    authDomain: 'play2travel.firebaseapp.com',
    storageBucket: 'play2travel.appspot.com',
  );
}