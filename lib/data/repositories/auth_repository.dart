import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../core/services/firebase_service.dart';

class UserProfile {
  final String uid;
  final String? email;
  final String? displayName;

  UserProfile({required this.uid, this.email, this.displayName});
}

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserProfile? _mockUser;

  Stream<UserProfile?> get authStateChanges {
    if (FirebaseService.isInitialized) {
      return _auth.authStateChanges().map((user) {
        if (user == null) return null;
        return UserProfile(
          uid: user.uid,
          email: user.email,
          displayName: user.displayName,
        );
      });
    } else {
      // Mock auth stream
      return Stream.value(_mockUser);
    }
  }

  UserProfile? get currentUser {
    if (FirebaseService.isInitialized && _auth.currentUser != null) {
      return UserProfile(
        uid: _auth.currentUser!.uid,
        email: _auth.currentUser!.email,
        displayName: _auth.currentUser!.displayName,
      );
    }
    return _mockUser ??
        UserProfile(
          uid: 'parent_user_01',
          email: 'parent@example.com',
          displayName: 'Parent Account',
        );
  }

  Future<UserProfile?> signInWithEmailAndPassword(
      String email, String password) async {
    if (FirebaseService.isInitialized) {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserProfile(
        uid: cred.user!.uid,
        email: cred.user!.email,
        displayName: cred.user!.displayName,
      );
    } else {
      _mockUser = UserProfile(
        uid: 'parent_user_01',
        email: email,
        displayName: 'Demo Parent',
      );
      return _mockUser;
    }
  }

  Future<UserProfile?> createUserWithEmailAndPassword(
      String email, String password) async {
    if (FirebaseService.isInitialized) {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserProfile(
        uid: cred.user!.uid,
        email: cred.user!.email,
        displayName: cred.user!.displayName,
      );
    } else {
      _mockUser = UserProfile(
        uid: 'parent_user_01',
        email: email,
        displayName: 'Demo Parent',
      );
      return _mockUser;
    }
  }

  Future<UserProfile?> signInWithGoogle() async {
    // In demo / web without configured OAuth client ID, provide mock fallback
    _mockUser = UserProfile(
      uid: 'parent_google_01',
      email: 'parent.google@example.com',
      displayName: 'Google Parent User',
    );
    return _mockUser;
  }

  Future<void> signOut() async {
    if (FirebaseService.isInitialized) {
      await _auth.signOut();
    }
    _mockUser = null;
  }
}
