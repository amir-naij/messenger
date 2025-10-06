import 'package:chat_messenger_new/widgets/signing_field.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  static const darkGray = Color.fromARGB(255, 33, 33, 33);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromARGB(255, 33, 33, 33),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/messenger.png',
              width: 180,
              color: darkGray,
            ),
            const SizedBox(height: 30),
            InputContainer(
              hintText: 'Username',
              textController: usernameController,
            ),
            InputContainer(hintText: 'Email', textController: emailController),
            InputContainer(
              hintText: 'Password',
              textController: passwordController,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom().copyWith(
                backgroundColor: const MaterialStatePropertyAll(darkGray),
                foregroundColor: const MaterialStatePropertyAll(
                  Color.fromARGB(255, 250, 250, 250),
                ),
                fixedSize: const MaterialStatePropertyAll(Size(150, 40)),
              ),
              onPressed: () => doUserRegistration(context),
              // () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => MessagesPage(),
              //     ),
              //   );
              // },
              child: Text('Sign up'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void doUserRegistration(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final user = ParseUser.createUser(username, password, email);
    var response;
    try {
      response = await user.signUp();
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    if (response.success) {
      showSuccess(context);
    } else {
      Navigator.of(context).pop();
      showError(response.error!.message, context);
    }
  }

  void showSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success!"),
          content: const Text("User was successfully created!"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }

  void showError(String errorMessage, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!"),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
