import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  static Future<void> initialize() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
        _isInitialized = true;
        debugPrint('[FirebaseService] Firebase successfully initialized.');
      } else {
        _isInitialized = true;
      }
    } catch (e) {
      debugPrint('[FirebaseService] Firebase not configured with credentials: $e');
      debugPrint('[FirebaseService] Running with built-in reactive Mock Store for immediate UI & cross-platform preview.');
      _isInitialized = false;
    }
  }
}
