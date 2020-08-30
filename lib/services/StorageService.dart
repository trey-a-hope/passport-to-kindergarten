import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

abstract class IStorageService {
  Future<String> uploadImage({@required File file, @required String path});
}

class StorageService extends IStorageService {
  @override
  Future<String> uploadImage(
      {@required File file, @required String path}) async {
    try {
      final StorageReference ref = FirebaseStorage().ref().child(path);
      final StorageUploadTask uploadTask = ref.putFile(file);
      StorageReference sr = (await uploadTask.onComplete).ref;
      return (await sr.getDownloadURL()).toString();
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
