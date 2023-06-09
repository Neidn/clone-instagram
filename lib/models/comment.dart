import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String commentId;
  final String uid;
  final String username;
  final String profImage;
  final String comment;
  final List likes;
  final Timestamp datePublished;

  Comment({
    required this.commentId,
    required this.uid,
    required this.username,
    required this.profImage,
    required this.comment,
    required this.likes,
    required this.datePublished,
  });

  Map<String, dynamic> toJson() => {
        'commentId': commentId,
        'uid': uid,
        'username': username,
        'profImage': profImage,
        'comment': comment,
        'likes': likes,
        'datePublished': datePublished,
      };

  static Comment fromJson(Map<String, dynamic> data) => Comment(
        commentId: data['commentId'],
        uid: data['uid'],
        username: data['username'],
        profImage: data['profImage'],
        comment: data['comment'],
        likes: data['likes'],
        datePublished: data['datePublished'],
      );

  static Comment fromSnap(DocumentSnapshot documentSnapshot) {
    var snap = documentSnapshot.data() as Map<String, dynamic>;

    return Comment(
      commentId: snap['commentId'],
      uid: snap['uid'],
      username: snap['username'],
      profImage: snap['profImage'],
      comment: snap['comment'],
      likes: snap['likes'],
      datePublished: snap['datePublished'],
    );
  }
}
