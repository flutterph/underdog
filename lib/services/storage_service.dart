import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:underdog/service_locator.dart';
import 'package:underdog/services/auth_service.dart';

class StorageService {
  final StorageReference _imageStorage = FirebaseStorage.instance.ref();

  Future<String> uploadImage(File image) async {
    final AuthService authService = locator<AuthService>();
    final StorageUploadTask uploadTask = _imageStorage
        .child('report_images')
        .child(await authService.getUserId())
        .child(DateTime.now().toIso8601String())
        .putFile(image);
    final String imageUrl =
        await (await uploadTask.onComplete).ref.getDownloadURL();

    return imageUrl.toString();
  }
}
