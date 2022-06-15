import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:messaging_app/utils/member_model.dart';

import 'api.dart';

class AccessServices extends ChangeNotifier {
  bool loading = false;
  final _auth = FirebaseAuth.instance;
  final _storage = const FlutterSecureStorage();
  MemberModel _userModel = MemberModel.initial();

  MemberModel get userModel => _userModel;

  void showLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  Future<bool> register({
    required TextEditingController username,
    required TextEditingController email,
    required TextEditingController password,
    required TextEditingController confirmPassword,
    required void Function(String message) showSnackBar,
  }) async {
    try {
      showLoading(true);
      if (username.text.isEmpty ||
          email.text.isEmpty ||
          password.text.isEmpty ||
          confirmPassword.text.isEmpty) {
        showSnackBar("Isi Semua Form");
        throw Exception();
      }
      if (password.text.length < 8) {
        showSnackBar("Password Minimal 8 Karakter");
        throw Exception();
      } else if (password.text != confirmPassword.text) {
        showSnackBar("Password tidak sama");
        throw Exception();
      }
      email.text = email.text.toLowerCase();
      await _auth.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      await _auth.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      await addUserDoc(
        username: username.text,
        email: email.text,
      );
      _userModel = MemberModel(
        uid: _auth.currentUser!.uid,
        username: username.text,
        image: "default_profile.png",
        email: email.text,
      );
      await _storage.write(key: "KEY_USERNAME", value: email.text);
      await _storage.write(key: "KEY_PASSWORD", value: password.text);
      showSnackBar("Berhasil Registrasi");
      showLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        showSnackBar("Email Sudah Terdaftar, Silahkan Login");
      } else if (e.code == "invalid-email") {
        showSnackBar("Email Anda Tidak Sah");
      } else if (e.code == "weak-password") {
        showSnackBar("Password Anda Terlalu Lemah");
      } else {
        showSnackBar(e.message ?? "Terjadi Kesalahan");
      }
      return false;
    } finally {
      showLoading(false);
    }
  }

  Future<void> addUserDoc(
      {required String email, required String username}) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userRef = Api(collection: 'users', docId: user.uid);
      await userRef.setDocument({
        'uid': user.uid,
        'username': username,
        'image': "default_profile.png",
        'email': email,
      });
    }
  }

  Future<void> loadUserDoc() async {
    final userRef = await Api(
      collection: 'users',
      docId: _auth.currentUser!.uid,
    ).getDocument();
    _userModel = MemberModel(
      uid: _auth.currentUser!.uid,
      username: userRef["username"],
      image: userRef["image"],
      email: userRef["email"],
    );
  }

  Future<bool> loginUserFromStorage() async {
    if (await _storage.read(key: 'KEY_USERNAME') != null) {
      await _auth.signInWithEmailAndPassword(
        email: await _storage.read(key: 'KEY_USERNAME') ?? '',
        password: await _storage.read(key: 'KEY_PASSWORD') ?? '',
      );
      await loadUserDoc();
      return true;
    } else {
      return false;
    }
  }

  static Future<void> changeUserName({required String name}) async {}

  Future<bool> login({
    required TextEditingController email,
    required TextEditingController password,
    required void Function(String message) showSnackBar,
  }) async {
    try {
      showLoading(true);
      if (email.text.isEmpty || password.text.length < 5) {
        showSnackBar("Isi Email dan Password Anda");
        throw Exception();
      }
      email.text = email.text.toLowerCase();
      await _auth.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      await loadUserDoc();
      await _storage.write(key: "KEY_USERNAME", value: email.text);
      await _storage.write(key: "KEY_PASSWORD", value: password.text);
      showSnackBar("Berhasil Login");
      showLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        showSnackBar("Email Tidak Ditemukan, Silahkan Register");
      } else if (e.code == "invalid-email") {
        showSnackBar("Email Anda Tidak Sah");
      } else if (e.code == "wrong-password") {
        showSnackBar("Password Anda Salah");
      } else {
        showSnackBar(e.message ?? "Terjadi Kesalahan");
      }
      return false;
    } finally {
      showLoading(false);
    }
  }

  void logout() {
    _auth.signOut();
    _storage.deleteAll().ignore();
    notifyListeners();
  }
}