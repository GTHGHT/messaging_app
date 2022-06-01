import 'package:flutter/material.dart';
import 'package:messaging_app/services/firestore_services.dart';

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
              decoration: const InputDecoration(hintText: "Grup ID"),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: groupTitle,
              decoration: const InputDecoration(hintText: "Judul Grup"),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: groupDesc,
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: "Deskripsi Grup",
                contentPadding: const EdgeInsets.all(10),
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                bool success = await FirestoreServices.createGroup(
                    groupId: groupId.text,
                    groupName: groupTitle.text,
                    groupDesc: groupDesc.text);
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
            ),
          ],
        ),
      ),
    );
  }
}