import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pubdev_notifier/utils/firebase/cloud_firestore/cloud_firestore_service.dart';
import 'package:pubdev_notifier/utils/firebase/cloud_firestore/firestore_path.dart';
import 'package:pubdev_notifier/utils/firebase/firebase_auth/firebase_auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    ref.watch(cloudFirestoreServiceProvider),
    ref.watch(firebaseAuthServiceProvider),
  );
});

class AuthService {
  AuthService(this._cloudFirestoreService, this._firebaseAuthService);
  final CloudFirestoreService _cloudFirestoreService;
  final FirebaseAuthService _firebaseAuthService;

  Future<void> signIn() async {
    final user = await _firebaseAuthService.sigInAnonymously();
    final uid = user.user!.uid;
    await _cloudFirestoreService.setData(
      path: FirestorePath.userDocument(uid),
      data: {
        'userId': uid,
        'createdAt': Timestamp.now(),
      },
    );
    // TODO(mafreud): add method to set FCM token
    await _cloudFirestoreService.setData(
      path: FirestorePath.fcmTokenDocument(uid),
      data: {
        'fcmToken': '',
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
    );
  }
}
