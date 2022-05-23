import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreServices{
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;
  static final _storage = FirebaseStorage.instance;

  static Future<void> addUserDoc({required String email, required String username}) async {
    if(_auth.currentUser != null){
      final user = _auth.currentUser;
      await user!.updateDisplayName(username);
      await user.updatePhotoURL(_storage.ref('default_profile.png').fullPath);
      final userRef =  _firestore.collection('users').doc(user.uid);
      await userRef.set({
        'uid': user.uid,
        'username': user.displayName,
        'image': user.photoURL,
        'email': user.email,
      });
    }
  }

  static Future<bool> createGroup({
    required String groupId,
    required String groupName,
    String? groupImage,
    required String groupDesc,
  }) async {
    if(_auth.currentUser != null){
      final user = _auth.currentUser;
      final groupRef = _firestore.collection('groups').doc(groupId);
      await groupRef.get().then((value) async{
        if(value.exists){
          return false;
        } else {
          await groupRef.set({
            'id': groupId,
            'type': 1,
            'title': groupName,
            'image': groupImage ?? _storage.ref("default_group.png").fullPath,
          });
          await groupRef.collection('members').doc(user!.uid).set({
            'uid': user.uid,
            'username': user.displayName,
            'image': user.photoURL,
            'email': user.email,
          });
          return true;
        }
      });
    }
    return false;
  }
}