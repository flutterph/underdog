import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final StorageReference _imageStorage =
      FirebaseStorage.instance.ref().child('report_images/');

  Future<String> uploadImage(File image) async {
    final StorageUploadTask uploadTask = _imageStorage.putFile(image);
    final Uri imageUrl = (await uploadTask.onComplete).uploadSessionUri;

    return imageUrl.toString();
  }
}
