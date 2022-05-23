import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Screen"),
      ),
      body: ListView.builder(
        reverse: true,
        itemBuilder: (context, index) {
          return Expanded(
            child: Container(),
          );
        },
        itemCount: 20,
      ),
    );
  }
}