import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pubdev_notifier/utils/firebase/cloud_firestore/cloud_firestore_service.dart';
import 'package:pubdev_notifier/utils/firebase/cloud_firestore/firestore_path.dart';

final firebaseMessagingServiceProvider =
    Provider<FirebaseMessagingService>((ref) {
  return FirebaseMessagingService(ref.watch(cloudFirestoreServiceProvider));
});

class FirebaseMessagingService {
  FirebaseMessagingService(this._cloudFirestoreService);

  final firebaseMessaging = FirebaseMessaging.instance;
  final CloudFirestoreService _cloudFirestoreService;

  /// fetch FCM token
  Future<String?> _fetchFcmToken() async {
    return firebaseMessaging.getToken();
  }

  /// set FCM token to Cloud Firestore
  Future<void> setFcmTokenToFirestore(String userId) async {
    final fcmToken = await _fetchFcmToken();
    if (fcmToken == null) {
      debugPrint('FCM token is null');
      return;
    }
    await _cloudFirestoreService.setData(
      path: FirestorePath.fcmTokenDocument(userId),
      data: {
        'fcmToken': fcmToken,
        'updatedAt': Timestamp.now(),
      },
    );
  }
}
