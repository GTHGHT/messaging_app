import 'package:flutter/material.dart';
import 'package:messaging_app/components/chats_list_tile.dart';
import 'package:provider/provider.dart';

import '../utils/group_data.dart';
import '../utils/group_model.dart';

class JoinGroupScreen extends StatefulWidget {
  const JoinGroupScreen({Key? key}) : super(key: key);

  @override
  State<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  TextEditingController controller = TextEditingController();

  @override
  initState() {
    super.initState();
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  showSnackBar(String value) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(value),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final searchButton =
        context.select<GroupData, bool>((value) => value.loading)
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () async {
                  try {
                    if(controller.text.isNotEmpty) {
                      context
                          .read<GroupData>()
                          .groupId = controller.text;
                      final groupInfo =
                      await context.read<GroupData>().getGroupInfo();
                      if (groupInfo.exists) {
                        context
                            .read<GroupData>()
                            .groupModel =
                            GroupModel.fromMap(groupInfo.data()!);
                        return;
                      }
                    }
                    showSnackBar("${controller.text} Tidak Ditemukan");
                  } catch (e) {
                    showSnackBar(e.toString());
                  }
                },
                child: const Text("Cari Grup"),
              );

    final searchResult = context.watch<GroupData>().groupModel.title.isEmpty
        ? const Center(
            child: Text("Grup Tidak Ditemukan"),
          )
        : ChatsListTile(
            imagePath: context.watch<GroupData>().groupModel.image,
            title: context.watch<GroupData>().groupModel.title,
            onTap: () async {
              try {
                await context.read<GroupData>().joinGroup();
                Navigator.of(context).pop();
              } catch (e) {
                showSnackBar(e.toString());
              }
            },
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Join Grup"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: "ID Grup"),
            ),
            const SizedBox(
              height: 10,
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: searchButton,
            ),
            const SizedBox(
              height: 20,
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: searchResult,
            ),
          ],
        ),
      ),
    );
  }
}