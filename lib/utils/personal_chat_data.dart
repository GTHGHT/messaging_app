import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/services/api.dart';
import 'package:messaging_app/utils/member_model.dart';

class PersonalChatData extends ChangeNotifier {
  String _currentUid = "";
  MemberModel _friendModel = MemberModel.initial();
  bool loading = false;

  final Api _currentUserApi = Api(collection: "");
  final Api _userApi = Api(collection: "users");
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

  void markAsLoading(){
    loading = true;
    notifyListeners();
  }

  Future<bool> getFriendFromEmail(String email) async {
    markAsLoading();
    final friendData = await _userApi.searchDocument('email', email);

    final friend = friendData.docs.toList();
    if (friend.isEmpty) {
      friendModel = MemberModel.initial();
      loading = false;
      notifyListeners();
      return false;
    } else if (friend[0].data()['uid'] == _auth.currentUser!.uid){
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
      _userApi.docId = user.uid;
      _friendApi.docId = user.uid;
      _currentUserApi.docId = friendModel.uid;
      final personalChat = await _currentUserApi.getDocument();
      if (personalChat.exists) {
        loading = false;
        notifyListeners();
        throw Exception("Personal Chat Sudah Ada");
      }
      final userDoc = await _userApi.getDocument();
      final userModel = MemberModel.fromMap(userDoc.data() ?? {});
      await _friendApi.setDocument(userModel.toMap());
      await _currentUserApi.setDocument(friendModel.toMap());
      final personalChatId = user.uid + "_" + friendModel.uid;
      await Api(collection: "groups", docId: personalChatId).setDocument({
        'id': personalChatId,
        'type': 2,
      });
      final memberApi = Api(collection: "groups/$personalChatId/members");
      memberApi.docId = user.uid;
      await memberApi.setDocument(userModel.toMapShort());
      await memberApi.setDocument(friendModel.toMapShort());
    }
    loading = false;
    notifyListeners();
  }

  loadUser() {
    _currentUid = _auth.currentUser!.uid;
    _currentUserApi.collection =
        "users/${_auth.currentUser!.uid}/personalChats";
  }

  String get currentUid => _currentUid;

  MemberModel get friendModel => _friendModel;

  set friendModel(MemberModel value) {
    _friendModel = value;
    _friendApi.collection = "users/${value.uid}/personalChats";
    notifyListeners();
  }
}