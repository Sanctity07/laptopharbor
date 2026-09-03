// File generated from google-services.json for project: laptop-harbor-e1c54
// If you add iOS or web support later, run `flutterfire configure` again.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Web is not configured yet. Add a web app in the Firebase Console '
        'and re-run `flutterfire configure`.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'iOS is not configured yet. Add an iOS app in the Firebase Console '
          'and re-run `flutterfire configure`.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'macOS is not configured yet.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'Windows is not configured yet.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // ── Android ─────────────────────────────────────────────────────────────
  // Source: android/app/google-services.json
  // Project: laptop-harbor-e1c54  |  Package: com.example.laptopharbor
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC5GobYvZ565MMWYcdOhaawI29WO9KvHCs',
    appId: '1:404084560162:android:f2b266bfae88463795557b',
    messagingSenderId: '404084560162',
    projectId: 'laptop-harbor-e1c54',
    storageBucket: 'laptop-harbor-e1c54.firebasestorage.app',
  );
}
