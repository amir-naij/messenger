import 'package:chat_messenger_new/screens/chat_page.dart';
import 'package:flutter/material.dart';

class MessageListTile extends StatelessWidget {
  const MessageListTile({
    required this.currentUsername,
    required this.username,
    super.key,
  });
  final String username;
  final String currentUsername;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        title: Text(username),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                senderUsername: currentUsername,
                recieverUsername: username,
              ),
            ),
          );
        },
      ),
    );
  }
}
