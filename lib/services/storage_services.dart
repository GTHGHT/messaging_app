import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final _storage = FirebaseStorage.instance;

  static Future<String> getImageLink(String path) async {
    return await _storage.ref(path).getDownloadURL();
  }
}