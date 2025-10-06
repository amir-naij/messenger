import 'package:chat_messenger_new/screens/login_page.dart';
import 'package:chat_messenger_new/widgets/message_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({required this.currentUsername, super.key});
  final String currentUsername;

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Messages'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: doUserLogout,
            icon: const Icon(
              Icons.logout,
              color: Color.fromARGB(255, 250, 250, 250),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<ParseObject>>(
        future: doUserQuery(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Container(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(),
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error...: ${snapshot.error.toString()}"),
                );
              } else {
                if (snapshot.data!.isEmpty) {
                  return Center(child: Text('None user found'));
                }

                List<MessageListTile> userTiles = [];
                for (final user in snapshot.data!) {
                  if ((user as ParseUser).username != widget.currentUsername) {
                    userTiles.add(
                      MessageListTile(
                        username: user.username!,
                        currentUsername: widget.currentUsername,
                      ),
                    );
                  }
                }
                return ListView.builder(
                  padding: EdgeInsets.only(top: 10.0),
                  itemCount: userTiles.length,
                  itemBuilder: (context, index) {
                    //print(user.username);
                    //print(index);
                    return userTiles[index];
                  },
                );
              }
          }
        },
      ),
    );
  }

  Future<List<ParseObject>> doUserQuery() async {
    QueryBuilder<ParseUser> queryUsers = QueryBuilder<ParseUser>(
      ParseUser.forQuery(),
    );
    final ParseResponse apiResponse = await queryUsers.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  void doUserLogout() async {
    final user = await ParseUser.currentUser() as ParseUser;
    var response = await user.logout();

    if (response.success) {
      showSuccess("User was successfully logout!", context);
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
              onPressed: () {
                Navigator.of(context)
                  ..pop()
                  ..pop();
                goToLoginPage(context);
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

  void goToLoginPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
