import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Configurações do Firebase para o projeto CognDown (`cogndown`).
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return web;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions não configurado para esta plataforma.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBEW2Jk3kZuKKMf4zhICx-hrXpdC6dtgyk',
    appId: '1:1072332399358:web:71610b8f0c11a6b845fbaf',
    messagingSenderId: '1072332399358',
    projectId: 'cogndown',
    authDomain: 'cogndown.firebaseapp.com',
    storageBucket: 'cogndown.firebasestorage.app',
    measurementId: 'G-HH4GD0H816',
  );
}
