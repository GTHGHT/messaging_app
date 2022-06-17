import 'package:flutter/material.dart';
import 'package:messaging_app/services/access_services.dart';
import 'package:provider/provider.dart';

import '../components/update_bottom_sheet.dart';
import '../services/storage_services.dart';
import '../utils/bottom_nav_bar_data.dart';
import '../utils/image_data.dart';

class UpdateAccountScreen extends StatelessWidget {
  const UpdateAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubah Data Akun"),
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                await context.read<ImageData>().showImagePickerDialog(context);
                await context
                    .read<AccessServices>()
                    .changeImage(context.read<ImageData>().image);
              },
              child: CircleAvatar(
                radius: 64,
                child: ClipOval(
                  child: context.watch<ImageData>().image != null
                      ? Image.file(context.watch<ImageData>().image!)
                      : context.watch<AccessServices>().userModel.image.isEmpty
                          ? Image.asset("images/default_profile.png")
                          : FutureBuilder<String>(
                              future: StorageService.getImageLink(context
                                  .read<AccessServices>()
                                  .userModel
                                  .image),
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
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text("Nama"),
              subtitle:
                  Text(context.watch<AccessServices>().userModel.username),
              trailing: Icon(Icons.edit),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: UpdateBottomSheet(
                        initialValue:
                            context.read<AccessServices>().userModel.username,
                        loading: context.watch<AccessServices>().loading,
                        title: 'Ubah Nama',
                        onPressed: (ctx, value) async {
                          if (value.isNotEmpty) {
                            await ctx
                                .read<AccessServices>()
                                .changeUsername(value);
                          }
                          Navigator.pop(ctx);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.alternate_email),
              title: Text("Email"),
              subtitle: Text(context.watch<AccessServices>().userModel.email),
              trailing: Icon(Icons.edit),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: UpdateBottomSheet(
                        loading: context.watch<AccessServices>().loading,
                        title: "Ubah Email",
                        initialValue:
                            context.read<AccessServices>().userModel.email,
                        onPressed: (ctx, value) async {
                          if (value.isNotEmpty &&
                              RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                            value = value.toLowerCase();
                            await ctx.read<AccessServices>().changeEmail(value);
                            Navigator.pushNamedAndRemoveUntil(
                                ctx, '/landing', (_) => false);
                            ctx.read<BottomNavBarData>().currentIndex = 0;
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Perubahan Email Berhasil, Silahkan Login Ulang",
                                ),
                              ),
                            );
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}