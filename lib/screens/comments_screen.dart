import 'package:clone_instagram/utils/global_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/utils/colors.dart';
import '/widgets/comment_card.dart';

import '/models/post.dart';
import '/models/user.dart';

import '/resources/firestore_methods.dart';
import '/providers/user_provider.dart';

class CommentsScreen extends StatefulWidget {
  static const String routeName = '/comments';

  // get data from arguments
  const CommentsScreen({super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Post post = ModalRoute.of(context)!.settings.arguments as Post;
    final User user = Provider.of<UserProvider>(context).getUser;
    // final Post post = Post.fromSnap(queryDocumentSnapshot);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(firebasePosts)
            .doc(post.postId)
            .collection(firebaseComments)
            .orderBy('datePublished', descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return CommentCard(
                snap: snapshot.data.docs[index].data(),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.profileUrl),
                radius: 18,
              ),

              // TODO: Add text field
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user.username}...',
                      border: InputBorder.none,
                    ),
                    controller: _commentController,
                  ),
                ),
              ),

              InkWell(
                onTap: () async {
                  await FirestoreMethods().postComment(
                    post.postId,
                    user.uid,
                    _commentController.text.trim(),
                    user.username,
                    user.profileUrl,
                  );
                  setState(() {
                    _commentController.clear();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: blueColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
