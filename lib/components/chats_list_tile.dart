
import 'package:flutter/material.dart';

class ChatsListTile extends StatelessWidget {
  const ChatsListTile({
    Key? key,
    required this.image,
    required this.title,
    required this.lastMessage,
    required this.sentTime,
    this.onTap
  }) : super(key: key);

  final ImageProvider image;
  final String title;
  final String lastMessage;
  final String sentTime;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipOval(
        child: Image(
          image: image,
          height: 44,
          width: 44,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(
        lastMessage,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: Text(
        sentTime,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      onTap: onTap,
    );
  }
}