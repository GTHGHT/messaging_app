import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthAccess extends ChangeNotifier {
  bool loading = false;
  bool isLoggedIn = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      final newUser = await _auth.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      await _auth.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      isLoggedIn = true;
      await _firestore.collection("users").doc(newUser.user!.uid).set({
        "image": "https://firebasestorage.googleapis.com/v0/b/kongko-ee34d.appspot.com/o/default_profile.png?alt=media&token=b11b4779-be0e-4de4-b501-c32fe3e9b4c9",
        "name": username.text,
        "email": email.text,
        "groups": {},
        "personalChats": {},
      });
      showSnackBar("Berhasil Registrasi");
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

      await _auth.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      isLoggedIn = true;
      showSnackBar("Berhasil Register");
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
    isLoggedIn = false;
    notifyListeners();
  }
}