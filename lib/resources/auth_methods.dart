import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/utils/global_variables.dart';

import '/models/user.dart' as model;

import '/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetail() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection(firebaseUsers).doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  // Sign up(email, password, username, bio)
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List? profileImage,
  }) async {
    String result = 'Some error occurred.';

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          profileImage != null) {
        // Register user
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String profileUrl = await StorageMethods()
            .uploadImageToStrong('profilePics', profileImage!, false);

        model.User user = model.User(
          email: email,
          uid: credential.user!.uid,
          profileUrl: profileUrl,
          username: username,
          bio: bio,
          followers: [],
          following: [],
        );

        // Add user info to firestore
        await _firestore.collection(firebaseUsers).doc(credential.user!.uid).set(
              user.toJson(),
            );

        result = 'Success';
      }
    } catch (e) {
      result = e.toString();
    }

    return result;
  }

  // Sign in(email, password)
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String result = 'Some error occurred.';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        result = 'Success';
      } else {
        result = 'Please enter email and password.';
      }
    } catch (e) {
      result = e.toString();
    }

    return result;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
