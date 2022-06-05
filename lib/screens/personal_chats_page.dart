import 'package:flutter/material.dart';

import '../components/chats_list_tile.dart';

class PersonalChatsPage extends StatelessWidget {
  const PersonalChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const defaultImage = "default_profile.png";
    return ListView.separated(
      itemBuilder: (context, index) {
        return ChatsListTile(
          imagePath: defaultImage,
          title: "Personal Chat $index",
          onTap: () {},
        );
      },
      separatorBuilder: (_, __) => const Divider(),
      itemCount: 5,
    );
  }
}