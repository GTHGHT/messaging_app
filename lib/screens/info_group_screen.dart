import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/utils/chat_data.dart';
import 'package:messaging_app/utils/group_data.dart';
import 'package:messaging_app/utils/search_data.dart';
import 'package:provider/provider.dart';

import '../components/update_bottom_sheet.dart';
import '../services/storage_services.dart';
import '../utils/image_data.dart';

class InfoGroupScreen extends StatelessWidget {
  const InfoGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Info Group"),
        actions: [
          Tooltip(
            message: "Keluar Grup",
            child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Keluar Grup'),
                      content:
                          Text('Apakah Kamu Yakin Ingin Keluar Dari Grup?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await context
                                .read<GroupData>()
                                .exitGroup(context.read<ChatData>().groupId);
                            Navigator.popUntil(
                                context, (e) => e.isFirst); // Closes the dialog
                          },
                          child: Text('Ya'),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () async {
              await context.read<ImageData>().showImagePickerDialog(context);
              context
                  .read<ChatData>()
                  .changeGroupImage(context.read<ImageData>().image);
              showDialog(
                  context: context,
                  builder: (context) {
                    if (context.watch<ChatData>().loading) {
                      return AlertDialog(
                          title: Text("Mengubah Gambar..."),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                            ],
                          ));
                    } else {
                      Navigator.pop(context);
                      return SizedBox();
                    }
                  });
            },
            child: CircleAvatar(
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
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: Icon(Icons.text_snippet),
            title: Text("Grup Id"),
            subtitle: Text(context.watch<ChatData>().groupId),
          ),
          ListTile(
            leading: Icon(Icons.groups),
            title: Text("Judul Grup"),
            subtitle: Text(context.watch<ChatData>().title),
            trailing: Icon(Icons.edit),
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: UpdateBottomSheet(
                    initialValue: context.watch<ChatData>().title,
                    title: "Ubah Judul Group",
                    loading: context.watch<ChatData>().loading,
                    onPressed: (context, value) async {
                      await context.read<ChatData>().changeGroupTitle(value);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text("Deskripsi Grup"),
            subtitle: Text(context.watch<ChatData>().groupModel.desc ?? ""),
            trailing: Icon(Icons.edit),
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: UpdateBottomSheet(
                    initialValue:
                        context.watch<ChatData>().groupModel.desc ?? "",
                    title: "Ubah Deskripsi Grup",
                    loading: context.watch<ChatData>().loading,
                    onPressed: (context, value) async {
                      await context.read<ChatData>().changeGroupDesc(value);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
          ),
          Card(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: context.watch<ChatData>().getGroupMembers(),
              builder: (context, snapshot) {
                Widget defaultEmptyReturn = const Center(
                  child: Text("Member Kosong, Mungkin Terjadi Error"),
                );
                if (!(snapshot.hasData)) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final members = snapshot.data!.docs;
                if (members.isEmpty) {
                  return defaultEmptyReturn;
                }

                return Column(
                  children: members
                      .where((element) => element["username"]
                          .toString()
                          .toLowerCase()
                          .contains(context
                              .watch<SearchData>()
                              .searchTerm
                              .toLowerCase()))
                      .map<Widget>(
                        (value) => MemberListTile(
                          image: value["image"],
                          name: value["username"],
                          isAdmin: value.data().containsKey("isAdmin")
                              ? value["isAdmin"]
                              : false,
                          onLongPress: context.watch<ChatData>().isAdmin?(){}:null,
                        ),
                      )
                      .toList()
                    ..insert(
                      0,
                      Row(
                        children: [
                          SizedBox(width: 16),
                          Text(
                            "Member Grup",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Expanded(child: SizedBox()),
                          if (context.watch<ChatData>().isAdmin)
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {},
                            ),
                          IconButton(
                            onPressed: () {
                              context.read<SearchData>().showSearchField =
                                  !context.read<SearchData>().showSearchField;
                            },
                            icon: Icon(
                                context.watch<SearchData>().showSearchField
                                    ? Icons.close
                                    : Icons.search),
                          ),
                        ],
                      ),
                    )
                    ..insert(
                      1,
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: context.watch<SearchData>().showSearchField
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: TextField(
                                  autofocus: true,
                                  onChanged: (value) => context
                                      .read<SearchData>()
                                      .searchTerm = value,
                                ),
                              )
                            : SizedBox(),
                      ),
                    ),
                );
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom,
          )
        ],
      ),
    );
  }
}

class MemberListTile extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String image;
  final String name;
  final bool isAdmin;

  const MemberListTile({
    Key? key,
    this.onTap,
    this.onLongPress,
    required this.image,
    required this.name,
    required this.isAdmin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: SizedBox(
        height: 72,
        child: Row(
          children: [
            SizedBox(
              width: 16,
            ),
            ClipOval(
              child: FutureBuilder<String>(
                future: StorageService.getImageLink(image),
                builder: (_, snapshot) {
                  if (!snapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Image(
                    image: NetworkImage(snapshot.data ?? ""),
                    height: 44,
                    width: 44,
                  );
                },
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(
                  height: 5,
                ),
                if (isAdmin)
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Admin"),
                  )
              ],
            ),
            Expanded(
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}