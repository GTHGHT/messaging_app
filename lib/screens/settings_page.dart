import 'package:flutter/material.dart';
import 'package:messaging_app/services/access_services.dart';
import 'package:provider/provider.dart';

import '../services/storage_services.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 20,
        ),
        ListTile(
          leading: FutureBuilder<String>(
            future: StorageService.getImageLink(
                context.read<AccessServices>().userModel.image),
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return CircleAvatar(
                radius: 32,
                child: ClipOval(
                  child: Image.network(snapshot.data ?? ""),
                ),
              );
            },
          ),
          title: Text(context.watch<AccessServices>().userModel.username),
          subtitle: Text(context.watch<AccessServices>().userModel.email),
        ),
        ListTile(
          leading: Icon(Icons.info),
          title: Text("Ubah Data Akun"),
          trailing: Icon(Icons.navigate_next),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.color_lens),
          title: Text("Ubah Tema"),
          trailing: Icon(Icons.navigate_next),
          onTap: () => Navigator.pushNamed(context, '/change_theme_mode'),
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text("Keluar Dari Akun"),
          onTap: () {
            context.read<AccessServices>().logout();
            Navigator.pushReplacementNamed(context, "/landing");
          },
        ),
      ],
    );
  }
}