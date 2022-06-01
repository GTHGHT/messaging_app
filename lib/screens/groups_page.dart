import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/services/firestore_services.dart';

import '../components/chats_list_tile.dart';

class GroupsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Hapus Line Di Bawah
    const defaultImage =  NetworkImage(
        "https://firebasestorage.googleapis.com/v0/b/kongko-ee34d.appspot.com/o/default_profile.png?alt=media&token=b11b4779-be0e-4de4-b501-c32fe3e9b4c9");

    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreServices.getUserGroups(),
      builder: (context, snapshot) {
        Widget defaultEmptyReturn = const Center(
          child: Text("Grup Kosong, Silahkan Join atau Buat Grup"),
        );
        if (!(snapshot.hasData)) {
          return defaultEmptyReturn;
        }
        final groups = snapshot.data!.docs.toList();
        if (groups.isEmpty) {
          return defaultEmptyReturn;
        }

        return ListView.builder(
          itemBuilder: (context, index) {
            final groupData = groups[index].data() as Map<String, dynamic>;
            return ChatsListTile(
              image: groupData['image'] ?? defaultImage,
              title: groupData['title'],
              onTap: () {},
            );
          },
          itemCount: groups.length,
        );
      },
    );

    // return ListView.separated(
    //   itemBuilder: (context, index) {
    //     return ChatsListTile(
    //       image: NetworkImage(defaultImage),
    //       title: "Group $index",
    //       lastMessage: 'Ini Message Terakhir Dari Group',
    //       sentTime: "12.0$index",
    //     );
    //   },
    //   separatorBuilder: (_, __) => Divider(),
    //   itemCount: 5,
    // );
  }
}