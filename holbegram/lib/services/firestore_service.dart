import 'package:cloud_firestore/cloud_firestore.dart';

/// Cloud Firestore access for Holbegram user profiles.
class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  Future<void> upsertUserProfile({
    required String uid,
    required String email,
    String? username,
  }) async {
    final docRef = _users.doc(uid);
    final existing = await docRef.get();
    await docRef.set(
      {
        'uid': uid,
        'email': email,
        'username': ?username,
        'updatedAt': FieldValue.serverTimestamp(),
        if (!existing.exists) 'createdAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfile(String uid) {
    return _users.doc(uid).get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUserProfile(String uid) {
    return _users.doc(uid).snapshots();
  }
}
