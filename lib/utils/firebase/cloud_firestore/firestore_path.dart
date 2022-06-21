class FirestorePath {
  static const userCollection = 'user';
  static userDocument(String userId) => 'user/$userId';
  static githubTokenDocument(String userId) =>
      '${userDocument(userId)}/fcmToken/fcmToken';
}
