
import 'package:flutter/material.dart';

import '../components/chats_list_tile.dart';

class GroupsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: Hapus Line Di Bawah
    final defaultImage =
        "https://firebasestorage.googleapis.com/v0/b/kongko-ee34d.appspot.com/o/default_profile.png?alt=media&token=b11b4779-be0e-4de4-b501-c32fe3e9b4c9";

    return ListView.separated(
      itemBuilder: (context, index) {
        return ChatsListTile(
          image: NetworkImage(defaultImage),
          title: "Group $index",
          lastMessage: 'Ini Message Terakhir Dari Group',
          sentTime: "12.0$index",
        );
      },
      separatorBuilder: (_, __) => Divider(),
      itemCount: 5,
    );
  }
}