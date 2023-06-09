import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/utils/global_variables.dart';
import '/utils/colors.dart';
import '/utils/utils.dart';

import '/resources/firestore_methods.dart';

import '/models/post.dart' as model;
import '/models/user.dart' as model;

import '/screens/login_screen.dart';

import '/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

  final String uid;

  const ProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late model.User _user;
  late int _postLength;
  int _followingLength = 0;
  int _followersLength = 0;
  bool _isFollowing = false;
  bool _isLoading = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection(firebaseUsers)
          .doc(widget.uid)
          .get();

      QuerySnapshot postSnapshot = await FirebaseFirestore.instance
          .collection(firebasePosts)
          .where('uid', isEqualTo: widget.uid)
          .get();

      setState(() {
        _user = model.User.fromSnap(userSnapshot);
        _followingLength = _user.following.length;
        _followersLength = _user.followers.length;
        _postLength = postSnapshot.docs.length;
        _isFollowing =
            _user.followers.contains(FirebaseAuth.instance.currentUser!.uid);
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(_user.username),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Profile Image
                          CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            backgroundImage: NetworkImage(_user.profileUrl),
                            radius: 40,
                          ),

                          // Profile Name
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.values[0],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    buildStatColumn(
                                      _postLength,
                                      'Posts',
                                    ),
                                    buildStatColumn(
                                      _followersLength,
                                      'followers',
                                    ),
                                    buildStatColumn(
                                      _followingLength,
                                      'following',
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    (FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid)
                                        ? FollowButton(
                                            onPressed: () {
                                              FirebaseAuth.instance
                                                  .signOut()
                                                  .then((_) {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginScreen(),
                                                  ),
                                                );
                                                return;
                                              });
                                            },
                                            backgroundColor:
                                                mobileBackgroundColor,
                                            borderColor: Colors.grey,
                                            text: 'Sign Out',
                                            textColor: primaryColor,
                                          )
                                        : _isFollowing
                                            ? FollowButton(
                                                onPressed: () async {
                                                  await FirestoreMethods()
                                                      .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          widget.uid);
                                                  setState(() {
                                                    _isFollowing = false;
                                                    _followersLength--;
                                                  });
                                                },
                                                backgroundColor: Colors.white,
                                                borderColor: Colors.grey,
                                                text: 'Unfollow',
                                                textColor: Colors.black,
                                              )
                                            : FollowButton(
                                                onPressed: () async {
                                                  await FirestoreMethods()
                                                      .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          widget.uid);

                                                  setState(() {
                                                    _isFollowing = true;
                                                    _followersLength++;
                                                  });
                                                },
                                                backgroundColor: Colors.blue,
                                                borderColor: Colors.blue,
                                                text: 'Follow',
                                                textColor: Colors.white,
                                              ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Profile Name
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          _user.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Profile Bio
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(_user.bio),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection(firebasePosts)
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        final DocumentSnapshot snap =
                            snapshot.data!.docs[index];

                        final model.Post post = model.Post.fromSnap(snap);

                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(post.postUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$num',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
