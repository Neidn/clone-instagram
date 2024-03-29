import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/screens/feed_screen.dart';
import '/screens/search_screen.dart';
import '/screens/add_post_screen.dart';
import '/screens/profile_screen.dart';

const webScreenSize = 600;

final homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('Favorite'),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];

const String firebaseUsers = 'users';
const String firebasePosts = 'posts';
const String firebaseComments = 'comments';
