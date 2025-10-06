import 'package:chat_messenger_new/screens/messages_page.dart';
import 'package:chat_messenger_new/screens/sign_up_page.dart';
import 'package:chat_messenger_new/widgets/signing_field.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  static const darkGray = Color.fromARGB(255, 33, 33, 33);
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              onPressed: () => doUserLogin(context),
              // () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => MessagesPage(),
              //     ),
              //   );
              // },
              child: Text('Login'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Not registered yet? '),
                TextButton(
                  style: TextButton.styleFrom().copyWith(
                    foregroundColor: const MaterialStatePropertyAll(darkGray),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: Text('Sign up now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void doUserLogin(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    final user = ParseUser(username, password, null);
    var response;
    try {
      response = await user.login();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    Navigator.of(context).pop();
    if (response.success) {
      showSuccess("User was successfully login!", context);
    } else {
      showError(response.error!.message, context);
    }
  }

  void showSuccess(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success!"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () async {
                Navigator.of(context)
                  ..pop()
                  ..pop();
                goToMessagesPage(context);
              },
            ),
          ],
        );
      },
    );
  }

  void goToMessagesPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MessagesPage(currentUsername: usernameController.text.trim()),
      ),
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
