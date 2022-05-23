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
        title: Text("Buat Grup"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: groupId,
              decoration: InputDecoration(hintText: "Grup ID"),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: groupTitle,
              decoration: InputDecoration(hintText: "Judul Grup"),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: groupDesc,
              minLines: 3,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "Deskripsi Grup",
                contentPadding: EdgeInsets.all(10),
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                await FirestoreServices.createGroup(groupId: groupId.text, groupName: groupTitle.text, groupDesc: groupDesc.text);

                Navigator.of(context).pop();
              },
              child: Text("Buat Grup"),
            ),
          ],
        ),
      ),
    );
  }
}