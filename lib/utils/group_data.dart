import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:messaging_app/services/api.dart';
import 'package:messaging_app/services/storage_services.dart';
import 'package:messaging_app/utils/group_model.dart';
import 'package:messaging_app/utils/member_model.dart';
import 'dart:io';

class GroupData extends ChangeNotifier {
  GroupModel _groupModel = GroupModel.initial();
  bool loading = false;

  final Api _groupApi = Api(collection: "", doc: "");
  final Api _userApi = Api(collection: "", doc: "");
  final Api _currentUserApi = Api(collection: "");
  static final _auth = FirebaseAuth.instance;

  GroupModel get groupModel => _groupModel;

  set groupModel(GroupModel value) {
    _groupModel = value;
    _groupApi.collection = "groups";
    _groupApi.doc = _groupModel.id;
    _userApi.collection = "users/${_auth.currentUser!.uid}/groups";
    _userApi.doc = _groupModel.id;
    notifyListeners();
  }

  clearModel(){
    _groupModel = GroupModel.initial();
  }

  set groupId(String id) {
    _groupModel = GroupModel.initial();
    _groupModel.id = id;
    _groupApi.collection = "groups";
    _groupApi.doc = _groupModel.id;
    notifyListeners();
  }

  void markAsLoading(){
    loading = true;
    notifyListeners();
  }

  void loadUser(){
    _userApi.collection = "users/${_auth.currentUser!.uid}/groups";
    _currentUserApi.collection = "users";
    _currentUserApi.doc = _auth.currentUser!.uid;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserGroups() {
    final user = _auth.currentUser;
    if (user != null) {
      return _userApi.streamCollection();
    } else {
      throw Exception("Gagal Menerima Daftar Group");
    }
  }

  Future<bool> createGroup(File? groupImage) async {
    markAsLoading();
    final user = _auth.currentUser;
    if (user != null) {
      final group = await _groupApi.getDocument();
      if (group.exists) {
        loading = false;
        notifyListeners();
        return false;
      } else {
        if(groupImage != null){
          final location = await StorageService.uploadFile(groupImage, "group_picture/");
          groupModel.image = location;
        } else {
          groupModel.image = "default_group.png";
        }
        await _groupApi.setDocument(groupModel.toMap());
        final _userDoc = await _currentUserApi.getDocument();
        final _userModel = MemberModel.fromMap(_userDoc.data() ?? {});
        await Api(
          collection: "groups/${_groupModel.id}/members",
          doc: user.uid,
        ).setDocument(_userModel.toMapShort());
        await _userApi.setDocument(groupModel.toMapShort());
        loading = false;
        notifyListeners();
        return true;
      }
    } else {
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getGroupInfo() async {
    markAsLoading();
    final user = _auth.currentUser;
    if (user != null) {
      var doc = await _groupApi.getDocument();
      loading = false;
      notifyListeners();
      return doc;
    } else {
      loading = false;
      notifyListeners();
      throw Exception("Anda Belum Login");
    }
  }

  Future<void> joinGroup() async {
    markAsLoading();
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _userApi.getDocument();
      if (doc.exists) {
        throw Exception("Sudah Join Grup Tersebut");
      }
      await _userApi.setDocument(groupModel.toMapShort());
      final _userDoc = await _currentUserApi.getDocument();
      final _userModel = MemberModel.fromMap(_userDoc.data() ?? {});
      await Api(collection: "groups/${groupModel.id}/members", doc: user.uid)
          .setDocument(_userModel.toMapShort());
    }
    loading = false;
    notifyListeners();
  }
}