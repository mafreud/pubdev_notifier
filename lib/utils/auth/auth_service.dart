import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pubdev_notifier/app/user/user.dart';
import 'package:pubdev_notifier/utils/firebase/cloud_firestore/cloud_firestore_service.dart';
import 'package:pubdev_notifier/utils/firebase/cloud_firestore/firestore_path.dart';
import 'package:pubdev_notifier/utils/firebase/firebase_auth/firebase_auth_service.dart';
import 'package:pubdev_notifier/utils/firebase/firebase_messaging/firebase_messaging_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    ref.watch(cloudFirestoreServiceProvider),
    ref.watch(firebaseAuthServiceProvider),
    ref.watch(firebaseMessagingServiceProvider),
  );
});

class AuthService {
  AuthService(this._cloudFirestoreService, this._firebaseAuthService,
      this._firebaseMessagingService);
  final CloudFirestoreService _cloudFirestoreService;
  final FirebaseAuthService _firebaseAuthService;
  final FirebaseMessagingService _firebaseMessagingService;

  Future<void> signIn() async {
    final user = await _firebaseAuthService.sigInAnonymously();
    final uid = user.user!.uid;
    await _cloudFirestoreService.setData(
      path: FirestorePath.userDocument(uid),
      data: User(userId: uid, createdAt: DateTime.now()).toJson(),
    );
    await _firebaseMessagingService.setFcmTokenToFirestore(uid);
  }

  Future<void> signOut() async {
    await _firebaseAuthService.signOut();
  }
}
