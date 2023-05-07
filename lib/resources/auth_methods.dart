import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:clone_instagram/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

        // Add user info to firestore
        await _firestore.collection('users').doc(credential.user!.uid).set({
          'uid': credential.user!.uid,
          'username': username,
          'email': email,
          'bio': bio,
          'followers': [],
          'following': [],
          'profileUrl': profileUrl,
        });

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
}
