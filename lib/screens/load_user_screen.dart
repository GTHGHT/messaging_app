import 'package:flutter/material.dart';
import 'package:messaging_app/services/access_services.dart';
import 'package:provider/provider.dart';

import '../utils/chat_data.dart';
import '../utils/group_data.dart';
import '../utils/personal_chat_data.dart';

class LoadUserScreen extends StatefulWidget {
  const LoadUserScreen({Key? key}) : super(key: key);

  @override
  State<LoadUserScreen> createState() => _LoadUserScreenState();
}

class _LoadUserScreenState extends State<LoadUserScreen> {

  initState() {
    super.initState();
    loadUser();
  }

  loadUser() async{
    final bool loginStatus =
    await context.read<AccessServices>().loginUserFromStorage();
    if (loginStatus) {
      context.read<GroupData>().loadUser();
      context.read<PersonalChatData>().loadUser();
      context.read<ChatData>().loadUser();
      await Navigator.pushReplacementNamed(context, "/main");
    } else {
      await Navigator.pushReplacementNamed(context, "/landing");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 20,),
              Text("Tunggu Sebentar")
            ],
          ),
        ),
      ),
    );
  }
}