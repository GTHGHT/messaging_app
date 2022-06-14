import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/services/api.dart';
import 'package:messaging_app/utils/member_model.dart';

class PersonalChatData extends ChangeNotifier {
  MemberModel _friendModel = MemberModel.initial();
  bool loading = false;

  final Api _currentUserApi = Api(collection: "");
  final Api _globalUserApi = Api(collection: "users");
  final Api _friendApi = Api(collection: "");
  final _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserPersonalChats() {
    final user = _auth.currentUser;
    if (user != null) {
      return _currentUserApi.streamCollection();
    } else {
      throw Exception("Gagal Menerima Daftar Group");
    }
  }

  void markAsLoading() {
    loading = true;
    notifyListeners();
  }

  Future<bool> getFriendFromEmail(String email) async {
    markAsLoading();
    final friendData = await _globalUserApi.searchDocument('email', email);

    final friend = friendData.docs.toList();
    if (friend.isEmpty) {
      friendModel = MemberModel.initial();
      loading = false;
      notifyListeners();
      return false;
    } else if (friend[0].data()['uid'] == _auth.currentUser!.uid) {
      friendModel = MemberModel.initial();
      loading = false;
      notifyListeners();
      return false;
    } else {
      friendModel = MemberModel.fromMap(friend[0].data());
      loading = false;
      notifyListeners();
      return true;
    }
  }

  createPersonalChat() async {
    markAsLoading();
    final user = _auth.currentUser;
    if (user != null) {
      _globalUserApi.docId = user.uid;
      _friendApi.docId = user.uid;
      _currentUserApi.docId = friendModel.uid;
      final personalChat = await _currentUserApi.getDocument();
      if (personalChat.exists) {
        loading = false;
        notifyListeners();
        throw Exception("Personal Chat Sudah Ada");
      }
      final userDoc = await _globalUserApi.getDocument();
      final userModel = MemberModel.fromMap(userDoc.data() ?? {});
      final pcId = await Api(collection: "groups").addDocumentWithId({
        'type': 2,
      });
      await _friendApi.setDocument(
        userModel.toMapShort()..addAll({'id': pcId}),
      );
      await _currentUserApi.setDocument(
        friendModel.toMapShort()..addAll({'id': pcId}),
      );
      final memberApi = Api(collection: "groups/$pcId/members");
      memberApi.docId = userModel.uid;
      await memberApi.setDocument(userModel.toMapShort());
      memberApi.docId = friendModel.uid;
      await memberApi.setDocument(friendModel.toMapShort());
      _friendModel = MemberModel.initial();
    }
    loading = false;
    notifyListeners();
  }

  clearModel(){
    _friendModel = MemberModel.initial();
  }

  loadUser() {
    _currentUserApi.collection =
        "users/${_auth.currentUser!.uid}/personalChats";
  }

  MemberModel get friendModel => _friendModel;

  set friendModel(MemberModel value) {
    _friendModel = value;
    _friendApi.collection = "users/${value.uid}/personalChats";
    notifyListeners();
  }
}