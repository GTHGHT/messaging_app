import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/utils/personal_chat_data.dart';
import 'package:provider/provider.dart';

import '../components/chats_list_tile.dart';
import '../utils/chat_data.dart';
import '../utils/group_model.dart';

class PersonalChatsPage extends StatelessWidget {
  const PersonalChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const defaultImage = "default_profile.png";
    return StreamBuilder<QuerySnapshot>(
      stream: context.watch<PersonalChatData>().getUserPersonalChats(),
      builder: (context, snapshot) {
        Widget defaultEmptyReturn = const Center(
          child: Text(
            "Personal Chat Kosong, \nSilahkan Join atau Buat Grup",
            textAlign: TextAlign.center,
          ),
        );
        if (!(snapshot.hasData)) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final personalChats = snapshot.data!.docs.toList();
        if (personalChats.isEmpty) {
          return defaultEmptyReturn;
        } else {
          return ListView.builder(
            itemBuilder: (context, index) {
              final memberData =
                  personalChats[index].data() as Map<String, dynamic>;
              return ChatsListTile(
                imagePath: memberData['image'] ?? defaultImage,
                title: memberData['username'],
                onTap: () {
                  context.read<ChatData>().groupModel =
                      GroupModel.fromMap(memberData);
                  Navigator.of(context).pushNamed("/chat");
                },
              );
            },
            itemCount: personalChats.length,
          );
        }
      },
    );
  }
}