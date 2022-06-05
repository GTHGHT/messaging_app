import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreServices {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<void> addUserDoc(
      {required String email, required String username}) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(username);
      await user.updatePhotoURL("default_profile.png");
      final userRef = _firestore.collection('users').doc(user.uid);
      await userRef.set({
        'uid': user.uid,
        'username': user.displayName,
        'image': user.photoURL,
        'email': user.email,
      });
    }
  }

  static Future<void> changeUserName({required String name}) async {}

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserGroups() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection("users")
          .doc(user.uid)
          .collection("groups")
          .snapshots();
    } else {
      throw Exception("Gagal Menerima Daftar Group");
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserPersonalChats() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection("users")
          .doc(user.uid)
          .collection("personalChats")
          .snapshots();
    } else {
      throw Exception("Gagal Menerima Daftar Group");
    }
  }

  // static Future<bool> createGroup({
  //   required String groupId,
  //   required String groupName,
  //   String? groupImage,
  //   required String groupDesc,
  // }) async {
  //   final user = _auth.currentUser;
  //   if (user != null) {
  //     final groupRef = _firestore.collection('groups').doc(groupId);
  //     await groupRef.get().then((value) async {
  //       if (value.exists) {
  //         return false;
  //       } else {
  //         await groupRef.set({
  //           'id': groupId,
  //           'type': 1,
  //           'title': groupName,
  //           'image': groupImage ?? "default_profile.png",
  //           'desc': groupDesc,
  //         });
  //         await groupRef.collection('members').doc(user.uid).set({
  //           'uid': user.uid,
  //           'name': user.displayName,
  //           'image': user.photoURL,
  //           'email': user.email,
  //         });
  //         await _firestore
  //             .collection("users")
  //             .doc(user.uid)
  //             .collection("groups")
  //             .doc(groupId)
  //             .set({
  //           'id': groupId,
  //           'title': groupName,
  //           'image': groupImage ?? "default_profile.png",
  //         });
  //       }
  //     });
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
}