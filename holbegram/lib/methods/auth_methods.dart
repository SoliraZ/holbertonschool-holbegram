import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../screens/auth/methods/user_storage.dart';

class AuthMethode {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> login({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occurred';
    try {
      if (email.isEmpty || password.isEmpty) {
        return 'Please fill all the fields';
      }
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    Uint8List? file,
  }) async {
    String res = 'Some error occurred';
    try {
      if (email.isEmpty || password.isEmpty || username.isEmpty) {
        return 'Please fill all the fields';
      }

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      String photoUrl = '';
      if (file != null) {
        photoUrl = await StorageMethods().uploadImageToStorage(
          false,
          'profilePics',
          file,
        );
      }

      Users users = Users(
        uid: user!.uid,
        email: email,
        username: username,
        bio: '',
        photoUrl: photoUrl,
        followers: [],
        following: [],
        posts: [],
        saved: [],
        searchKey: username.substring(0, 1).toUpperCase(),
      );

      await _firestore.collection('users').doc(user.uid).set(users.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<Users> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .get();

    if (!documentSnapshot.exists) {
      throw Exception(
        'No profile found for this account (it may have been deleted)',
      );
    }

    return Users.fromSnap(documentSnapshot);
  }
}
