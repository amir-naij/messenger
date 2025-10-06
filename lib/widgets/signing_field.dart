import 'package:flutter/material.dart';

class InputContainer extends StatelessWidget {
  const InputContainer({
    required this.hintText,
    required this.textController,
    super.key,
  });

  final String hintText;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 1.7,
          color: const Color.fromARGB(255, 189, 189, 189),
        ),
      ),
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
        ),
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        expands: true,
        minLines: null,
        maxLines: null,
      ),
    );
  }
}
