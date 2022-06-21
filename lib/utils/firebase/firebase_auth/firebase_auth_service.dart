import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// FirebaseAuthService's provider(riverpod)
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((_) {
  return FirebaseAuthService();
});

/// Firebase Auth related APIs
class FirebaseAuthService {
  /// Firebase Auth instance
  final firebaseAuth = FirebaseAuth.instance;

  /// sign in anonymously, using Firebase Auth
  Future<void> sigInAnonymously() async =>
      await firebaseAuth.signInAnonymously();
}
