class FirestorePath {
  static const userCollection = 'user';
  static userDocument(String userId) => 'user/$userId';
  static fcmTokenDocument(String userId) =>
      '${userDocument(userId)}/fcmToken/fcmToken';
}
