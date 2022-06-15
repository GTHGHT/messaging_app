import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messaging_app/utils/group_model.dart';
import 'package:permission_handler/permission_handler.dart';
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

  File? _image;
  final ImagePicker _picker = ImagePicker();

  showPickerDialog() {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text("Pilih Sumber"),
        children: [
          ListTile(
            leading: Icon(Icons.folder),
            title: Text("dari Galeri"),
            onTap: () async {
              await getImage(ImageSource.gallery);
              Navigator.pop(ctx);
            },
          ),
          ListTile(
            leading: Icon(Icons.camera),
            title: Text("dari Kamera"),
            onTap: () async {
              await getImage(ImageSource.camera);
              Navigator.pop(ctx);
            },
          )
        ],
      ),
    );
  }

  Future<bool> checkAndRequestCameraPermissions() async {
    PermissionStatus permission = await Permission.camera.status;
    if (permission != PermissionStatus.granted) {
      final permissions = await Permission.camera.request();
      return permissions == PermissionStatus.granted;
    } else {
      return true;
    }
  }
  showSnackBar(String content){
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(content),
        ),
      );

  }

  Future<void> getImage(ImageSource source) async {
    if (await checkAndRequestCameraPermissions()) {
      final pickedImage = await _picker.pickImage(source: source);
      if (pickedImage != null) {
        final croppedImage = await ImageCropper().cropImage(
          sourcePath: pickedImage.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          aspectRatioPresets: [CropAspectRatioPreset.square],
          compressQuality: 90,
          compressFormat: ImageCompressFormat.jpg,
        );
        if (croppedImage != null) {
          final fileImage = File(croppedImage.path);
          setState(() {
            _image = fileImage;
          });
        } else {
          showSnackBar("Crop Image Terlebih Dahulu");
        }
      } else {
        showSnackBar("Tidak Ada Gambar Yang Dipilih");
      }
    }
  }

  @override
  dispose() {
    super.dispose();
    groupId.dispose();
    groupTitle.dispose();
    groupDesc.dispose();
  }

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
              bool success = await context.read<GroupData>().createGroup(_image);
              if (success) {
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text("Group Sudah Ada"),
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
            GestureDetector(
              onTap: showPickerDialog,
              child: CircleAvatar(
                radius: 64,
                child: ClipOval(
                  child: _image != null
                      ? Image.file(_image!)
                      : Image.asset("images/default_group.png"),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: groupId,
              decoration: const InputDecoration(hintText: "ID Grup"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: groupTitle,
              decoration: const InputDecoration(hintText: "Judul Grup"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: groupDesc,
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: "Deskripsi Grup",
                contentPadding: EdgeInsets.all(10),
              ),
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