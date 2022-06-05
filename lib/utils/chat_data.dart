import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:messaging_app/services/api.dart';
import 'package:messaging_app/utils/group_model.dart';

class ChatData extends ChangeNotifier {
  GroupModel _groupModel = GroupModel.initial();
  String _messageText = "";
  bool loading = false;

  Api api = Api(collection: "");
  final _auth = FirebaseAuth.instance;

  void send() async {
    loading = true;
    notifyListeners();
    await api.addDocument({
      'text': _messageText,
      'sender': _auth.currentUser!.displayName,
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

  GroupModel get groupModel => _groupModel;

  set groupModel (GroupModel value){
    if (_groupModel.id != value.id) {
      _messageText = "";
    }
    _groupModel = value;
    api.collection = "groups/${value.id}/messages";
    notifyListeners();
  }

  String get groupId => _groupModel.id;

  String get title => _groupModel.title;

  String get image => _groupModel.image;

  String get messageText => _messageText;

  set messageText(String value) {
    _messageText = value;
    notifyListeners();
  }
}