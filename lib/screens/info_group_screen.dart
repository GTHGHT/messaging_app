import 'package:flutter/material.dart';
import 'package:messaging_app/utils/chat_data.dart';
import 'package:provider/provider.dart';

import '../services/storage_services.dart';

class InfoGroupScreen extends StatelessWidget {
  const InfoGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Info Group"),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          CircleAvatar(
            radius: 64,
            child: ClipOval(
              child: context.watch<ChatData>().image.isEmpty
                  ? Image.asset("images/default_group.png")
                  : FutureBuilder<String>(
                      future: StorageService.getImageLink(
                          context.watch<ChatData>().image),
                      builder: (_, snapshot) {
                        if (!snapshot.hasData) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Image(
                          image: NetworkImage(snapshot.data ?? ""),
                        );
                      },
                    ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: Icon(Icons.text_snippet),
            title: Text("Grup Id"),
            subtitle: Text(context.watch<ChatData>().groupId),
            trailing: Icon(Icons.edit),
          ),
          ListTile(
            leading: Icon(Icons.groups),
            title: Text("Judul Grup"),
            subtitle: Text(context.watch<ChatData>().title),
            trailing: Icon(Icons.edit),
          ),
          ListTile(
            title: Text("Deskripsi Grup"),
            subtitle: Text(context.watch<ChatData>().groupModel.desc?? ""),
            trailing: Icon(Icons.edit),
          ),
        ],
      ),
    );
  }
}