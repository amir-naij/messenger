import 'package:chat_messenger_new/widgets/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    required this.senderUsername,
    required this.recieverUsername,
    super.key,
  });

  final String senderUsername;
  final String recieverUsername;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String className;
  var textController = TextEditingController();
  late Stream<List<ParseObject>> convsStream;
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    // final chatConvs =
    //     ParseObject('${widget.senderUsername}_${widget.recieverUsername}');
    // print(chatConvs.containsKey('convo'));

    getQueryCount().then((value) {
      print(value);
      if (value != 0) {
        setState(() {
          className = '${widget.recieverUsername}_${widget.senderUsername}';
        });
      } else {
        setState(() {
          className = '${widget.senderUsername}_${widget.recieverUsername}';
        });
      }
    });
    convsStream = getConvs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.recieverUsername)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ParseObject>>(
              stream: getConvs(),
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
                      return Center(child: Text("loading..."));
                    }
                    if (!snapshot.hasData) {
                      return Center(child: Text("No Data..."));
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.only(top: 10.0),
                        itemCount: snapshot.data!.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          final reversedIndex =
                              snapshot.data!.length - 1 - index;
                          //*************************************
                          //Get Parse Object Values
                          final varConvs = snapshot.data![reversedIndex];
                          final varMessage = varConvs.get<String>('convo')!;
                          //*************************************
                          return ChatCard(
                            messageText: varMessage,
                            isSender: varMessage.startsWith(
                              widget.senderUsername,
                            ),
                          );
                        },
                      );
                    }
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    child: TextField(
                      controller: textController,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                        ),
                        hintText: 'Message',
                      ),
                    ),
                  ),
                ),
                IconButton(
                  iconSize: 30,
                  onPressed: () async {
                    await saveConvs(textController.text);
                    setState(() {
                      textController.clear();
                    });
                  },
                  icon: Icon(Icons.send_sharp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveConvs(String text) async {
    print(className);
    final chatConvs = ParseObject(className)
      ..set('convo', '${widget.senderUsername}:  $text');

    await chatConvs.save();
  }

  Stream<List<ParseObject>> getConvs() async* {
    print(className);
    while (true) {
      QueryBuilder<ParseObject> queryConvs = QueryBuilder<ParseObject>(
        ParseObject(className),
      );
      final ParseResponse apiResponse = await queryConvs.query();
      if (apiResponse.success && apiResponse.results != null) {
        yield apiResponse.results as List<ParseObject>;
      } else {
        yield [];
      }
    }
  }

  Future<int> getQueryCount() async {
    QueryBuilder<ParseObject> queryConvs = QueryBuilder<ParseObject>(
      ParseObject('${widget.recieverUsername}_${widget.senderUsername}'),
    );

    final ps = await queryConvs.query();

    return (ps.count);
  }
}
