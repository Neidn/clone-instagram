import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Add profile image to storage
  Future<String> uploadImageToStrong(
    String childName,
    Uint8List image,
    bool isPost,
  ) async {
    Reference reference = _firebaseStorage
        .ref()
        .child(childName)
        .child(_firebaseAuth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v4();
      reference = reference.child(id);
    }

    UploadTask uploadTask = reference.putData(image);

    TaskSnapshot taskSnapshot = await uploadTask;
    String url = await taskSnapshot.ref.getDownloadURL();

    return url;
  }
}
