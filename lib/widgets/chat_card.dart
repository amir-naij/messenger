import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    required this.messageText,
    required this.isSender,
    super.key,
  });
  final String messageText;
  final bool isSender;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender == true ? Alignment.topRight : Alignment.topLeft,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(messageText),
        ),
      ),
    );
  }
}
