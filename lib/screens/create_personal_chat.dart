import 'package:flutter/material.dart';

class CreatePersonalChatScreen extends StatefulWidget {
  const CreatePersonalChatScreen({Key? key}) : super(key: key);

  @override
  State<CreatePersonalChatScreen> createState() =>
      _CreatePersonalChatScreenState();
}

class _CreatePersonalChatScreenState extends State<CreatePersonalChatScreen> {
  TextEditingController controller = TextEditingController();

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Personal Chat"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: "Email Teman"),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Cari Teman"),
            ),
            const SizedBox(height: 20,),
            const AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: Center(child: Text("Teman Tidak Ditemukan"),),
            ),
          ],
        ),
      ),
    );
  }
}