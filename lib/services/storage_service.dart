import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final StorageReference _imageStorage =
      FirebaseStorage().ref().child('report_images/');

  Future<bool> uploadImage(File image) async {
    final StorageUploadTask uploadTask = _imageStorage.putFile(image);
    final Uri downloadUrl = (await uploadTask.onComplete).uploadSessionUri;

    if (downloadUrl != null)
      return true;
    else
      return false;
  }
}
