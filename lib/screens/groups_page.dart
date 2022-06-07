import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/utils/chat_data.dart';
import 'package:messaging_app/utils/group_data.dart';
import 'package:messaging_app/utils/group_model.dart';
import 'package:provider/provider.dart';

import '../components/chats_list_tile.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const defaultImage = "default_group.png";

    return StreamBuilder<QuerySnapshot>(
      stream: context.watch<GroupData>().getUserGroups(),
      builder: (context, snapshot) {
        Widget defaultEmptyReturn = const Center(
          child: Text("Grup Kosong, Silahkan Join atau Buat Grup"),
        );
        if (!(snapshot.hasData)) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final groups = snapshot.data!.docs.toList();
        if (groups.isEmpty) {
          return defaultEmptyReturn;
        }

        return ListView.builder(
          itemBuilder: (context, index) {
            final groupData = groups[index].data() as Map<String, dynamic>;
            return ChatsListTile(
              imagePath: groupData['image'] ?? defaultImage,
              title: groupData['title'],
              onTap: () {
                context.read<ChatData>().groupModel =
                    GroupModel.fromMap(groupData);
                Navigator.of(context).pushNamed("/chat");
              },
            );
          },
          itemCount: groups.length,
        );
      },
    );
  }
}