import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateStreamProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

/// FirebaseAuthService's provider(riverpod)
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((_) {
  return FirebaseAuthService();
});

/// Firebase Auth related APIs
class FirebaseAuthService {
  /// Firebase Auth instance
  final firebaseAuth = FirebaseAuth.instance;

  /// sign in anonymously, using Firebase Auth
  Future<UserCredential> sigInAnonymously() async {
    return await firebaseAuth.signInAnonymously();
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
