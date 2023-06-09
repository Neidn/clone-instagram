import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '/utils/global_variables.dart';

import '/models/comment.dart';
import '/models/post.dart';
import '/resources/storage_methods.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String description,
    Uint8List image,
    String uid,
    String username,
    String profImage,
  ) async {
    String response = "Some Error Occurred";

    try {
      String photoUrl = await StorageMethods().uploadImageToStrong(
        firebasePosts,
        image,
        true,
      );

      String postId = const Uuid().v4();

      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        dataPublished: Timestamp.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );

      _firestore.collection(firebasePosts).doc(postId).set(post.toJson());
      response = 'success';
    } catch (e) {
      response = e.toString();
    }
    return response;
  }

  Future<void> likePost(
    String postId,
    String uid,
    List likes,
  ) async {
    try {
      if (likes.contains(uid)) {
        likes.remove(uid);
      } else {
        likes.add(uid);
      }

      await _firestore.collection(firebasePosts).doc(postId).update({
        'likes': likes,
      });
    } catch (e) {
      return;
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection(firebasePosts).doc(postId).delete();
    } catch (e) {
      return;
    }
  }

  Future<void> postComment(
    String postId,
    String uid,
    String comment,
    String username,
    String profImage,
  ) async {
    try {
      if (comment.isEmpty) {
        return;
      }

      final String commentId = const Uuid().v4();

      final Comment tmpComment = Comment(
        commentId: commentId,
        comment: comment,
        uid: uid,
        username: username,
        profImage: profImage,
        likes: [],
        datePublished: Timestamp.now(),
      );

      await _firestore
          .collection(firebasePosts)
          .doc(postId)
          .collection(firebaseComments)
          .doc(commentId)
          .set(tmpComment.toJson());
    } catch (e) {
      return;
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection(firebaseUsers).doc(uid).get();

      List following = (userSnapshot.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection(firebaseUsers).doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });

        await _firestore.collection(firebaseUsers).doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
      } else {
        await _firestore.collection(firebaseUsers).doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });

        await _firestore.collection(firebaseUsers).doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
      }
    } catch (e) {
      return;
    }
  }
}
