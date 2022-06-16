import 'package:flutter/material.dart';
import 'package:messaging_app/services/access_services.dart';
import 'package:provider/provider.dart';

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
                      child: updateNameScreen(),
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
                      child: updateEmailScreen(),
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

class updateNameScreen extends StatefulWidget {
  @override
  State<updateNameScreen> createState() => _updateNameScreenState();
}

class _updateNameScreenState extends State<updateNameScreen> {
  final valueController = TextEditingController();

  @override
  initState() {
    super.initState();
    valueController.text = context.read<AccessServices>().userModel.username;
  }

  @override
  dispose() {
    super.dispose();
    valueController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ubahButton = context.watch<AccessServices>().loading
        ? SizedBox(
            key: ValueKey(1),
            height: 52.0,
            width: 52.0,
            child: CircularProgressIndicator(
              strokeWidth: 6,
            ),
          )
        : SizedBox(
            key: ValueKey(2),
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              child: Text(
                'Ubah',
              ),
              onPressed: () async {
                if (valueController.text.isNotEmpty) {
                  await context
                      .read<AccessServices>()
                      .changeUsername(valueController.text);
                }
                Navigator.pop(context);
              },
            ),
          );
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Ubah Nama',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: valueController,
            autofocus: true,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: ubahButton,
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.red),
            onPressed: () => Navigator.pop(context),
            child: Text("Batalkan"),
          ),
        ],
      ),
    );
  }
}

class updateEmailScreen extends StatefulWidget {
  @override
  State<updateEmailScreen> createState() => _updateEmailScreenState();
}

class _updateEmailScreenState extends State<updateEmailScreen> {
  final valueController = TextEditingController();

  @override
  initState() {
    super.initState();
    valueController.text = context.read<AccessServices>().userModel.email;
  }

  @override
  dispose() {
    super.dispose();
    valueController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ubahButton = context.watch<AccessServices>().loading
        ? SizedBox(
            key: ValueKey(1),
            height: 52.0,
            width: 52.0,
            child: CircularProgressIndicator(
              strokeWidth: 6,
            ),
          )
        : SizedBox(
            key: ValueKey(2),
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              child: Text(
                'Ubah',
              ),
              onPressed: () async {
                if (valueController.text.isNotEmpty &&
                    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(valueController.text)) {
                  await context
                      .read<AccessServices>()
                      .changeEmail(valueController.text);
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/landing', (_) => false);
                  context.read<BottomNavBarData>().currentIndex = 0;
                  ScaffoldMessenger.of(context).showSnackBar(
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
          );
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Ubah Email',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: valueController,
            autofocus: true,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          AnimatedSwitcher(
              duration: Duration(milliseconds: 200), child: ubahButton),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.red),
            onPressed: () => Navigator.pop(context),
            child: Text("Batalkan"),
          ),
        ],
      ),
    );
  }
}