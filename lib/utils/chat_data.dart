import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:messaging_app/services/api.dart';
import 'package:messaging_app/utils/group_model.dart';
import 'package:messaging_app/utils/user_model.dart';

class ChatData extends ChangeNotifier {
  GroupModel _groupModel = GroupModel.initial();
  UserModel _currentUserModel = UserModel.initial();
  String _messageText = "";
  bool loading = false;

  Api api = Api(collection: "");
  final _auth = FirebaseAuth.instance;

  void send() async {
    loading = true;
    notifyListeners();
    await api.addDocument({
      'text': _messageText,
      'sender': _currentUserModel.username,
      'sender_uid': _auth.currentUser!.uid,
      'sent_time': FieldValue.serverTimestamp(),
    });
    _messageText = "";
    loading = false;
    notifyListeners();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamMessages() {
    return api.streamCollection(sortBy: 'sent_time');
  }

  Future<void> loadDesc() async {
    if (_groupModel.desc == null) {
      _groupModel.desc = await Api(collection: "groups", doc: _groupModel.id)
          .getDocument()
          .then((value) => value.data()!["desc"]);
      notifyListeners();
    }
  }

  loadUser() async {
    final _currentUserDoc =
        await Api(collection: "users", doc: _auth.currentUser!.uid)
            .getDocument();
    _currentUserModel =
        UserModel.fromMap(_currentUserDoc.data() as Map<String, dynamic>);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getGroupMembers() {
    return Api(collection: "groups/${_groupModel.id}/members").streamCollection();
  }


  set messageText(String value) {
    _messageText = value;
    notifyListeners();
  }

  set groupModel(GroupModel value) {
    if (_groupModel.id != value.id) {
      _messageText = "";
    }
    _groupModel = value;
    api.collection = "groups/${value.id}/messages";

    notifyListeners();
  }

  GroupModel get groupModel => _groupModel;

  String get groupId => _groupModel.id;

  String get title => _groupModel.title;

  String get image => _groupModel.image;

  String get messageText => _messageText;
}