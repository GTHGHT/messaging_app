import 'package:flutter/material.dart';
import 'package:messaging_app/utils/group_model.dart';
import 'package:provider/provider.dart';

import '../utils/group_data.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  TextEditingController groupId = TextEditingController();
  TextEditingController groupTitle = TextEditingController();
  TextEditingController groupDesc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final addButton = context.select<GroupData, bool>((value) => value.loading)
        ? const CircularProgressIndicator()
        : ElevatedButton(
            onPressed: () async {
              context.read<GroupData>().groupModel = GroupModel(
                  id: groupId.text,
                  title: groupTitle.text,
                  image: "",
                  desc: groupDesc.text);
              bool success = await context.read<GroupData>().createGroup();
              if (success) {
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Buat Group Gagal"),
                  ),
                );
              }
            },
            child: const Text("Buat Grup"),
          );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Grup"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: groupId,
              decoration: const InputDecoration(hintText: "ID Grup"),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10,),
            TextField(
              controller: groupTitle,
              decoration: const InputDecoration(hintText: "Judul Grup"),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10,),
            TextField(
              controller: groupDesc,
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: "Deskripsi Grup",
                contentPadding: EdgeInsets.all(10),
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 20,
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: addButton,
            ),
          ],
        ),
      ),
    );
  }
}