import 'package:chat_messenger_new/screens/login_page.dart';
import 'package:chat_messenger_new/screens/messages_page.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

// ignore: must_be_immutable
class FirstPageDirect extends StatelessWidget {
  FirstPageDirect({super.key});
  late ParseUser loggedUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: hasUserLogged(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Scaffold(
              body: Center(
                child: Container(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          default:
            if (snapshot.hasData && snapshot.data!) {
              print(loggedUser.username);
              return MessagesPage(currentUsername: loggedUser.username!);
            } else {
              return LoginPage();
            }
        }
      },
    );
  }

  Future<bool> hasUserLogged() async {
    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser == null) {
      return false;
    }
    //Checks whether the user's session token is valid
    final ParseResponse? parseResponse =
        await ParseUser.getCurrentUserFromServer(currentUser.sessionToken!);

    loggedUser = currentUser;
    if (parseResponse?.success == null || !parseResponse!.success) {
      //Invalid session. Logout
      await currentUser.logout();
      return false;
    } else {
      return true;
    }
  }
}
