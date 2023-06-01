import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String profileUrl;
  final String username;
  final String bio;
  final List<dynamic> followers;
  final List<dynamic> following;

  const User({
    required this.email,
    required this.uid,
    required this.profileUrl,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'uid': uid,
        'profileUrl': profileUrl,
        'username': username,
        'bio': bio,
        'followers': followers,
        'following': following,
      };

  static User fromSnap(DocumentSnapshot documentSnapshot) {
    var snap = documentSnapshot.data() as Map<String, dynamic>;

    return User(
      email: snap['email'],
      uid: snap['uid'],
      profileUrl: snap['profileUrl'],
      username: snap['username'],
      bio: snap['bio'],
      followers: snap['followers'],
      following: snap['following'],
    );
  }
}
