import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:messaging_app/services/api.dart';
import 'package:messaging_app/utils/group_model.dart';
import 'package:messaging_app/utils/member_model.dart';

class GroupData extends ChangeNotifier {
  GroupModel _groupModel = GroupModel.initial();
  bool loading = false;

  final Api _groupApi = Api(collection: "", docId: "");
  final Api _userApi = Api(collection: "", docId: "");
  static final _auth = FirebaseAuth.instance;

  GroupModel get groupModel => _groupModel;

  set groupModel(GroupModel value) {
    _groupModel = value;
    _groupApi.collection = "groups";
    _groupApi.docId = _groupModel.id;
    _userApi.collection = "users/${_auth.currentUser!.uid}/groups";
    _userApi.docId = _groupModel.id;
    notifyListeners();
  }

  set groupId(String id) {
    _groupModel = GroupModel.initial();
    _groupModel.id = id;
    _groupApi.collection = "groups";
    _groupApi.docId = _groupModel.id;
    notifyListeners();
  }

  void markAsLoading(){
    loading = true;
    notifyListeners();
  }

  void loadUser(){
    _userApi.collection = "users/${_auth.currentUser!.uid}/groups";
    notifyListeners();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserGroups() {
    final user = _auth.currentUser;
    if (user != null) {
      return _userApi.streamCollection();
    } else {
      throw Exception("Gagal Menerima Daftar Group");
    }
  }

  Future<bool> createGroup() async {
    markAsLoading();
    final user = _auth.currentUser;
    if (user != null) {
      final group = await _groupApi.getDocument();
      if (group.exists) {
        loading = false;
        notifyListeners();
        return false;
      } else {
        await _groupApi.setDocument(groupModel.toMap());
        final _userDoc = await Api(collection: 'users', docId: user.uid).getDocument();
        final _userModel = MemberModel.fromMap(_userDoc.data() ?? {});
        await Api(
          collection: "groups/${_groupModel.id}/members",
          docId: user.uid,
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
      final _userDoc = await Api(collection: 'groups', docId: user.uid).getDocument();
      final _userModel = MemberModel.fromMap(_userDoc.data() ?? {});
      await Api(collection: "groups/${groupModel.id}/members", docId: user.uid)
          .setDocument(_userModel.toMapShort());
    }
    loading = false;
    notifyListeners();
  }
}