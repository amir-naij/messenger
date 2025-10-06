import 'package:chat_messenger_new/themes/light_theme.dart';
import 'package:chat_messenger_new/widgets/page_direct.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final keyApplicationId = 'fFSqGn1Rl0giBYUCly7EbWRd9hPVAEa7ZWNjAAY7';
  final keyClientKey = 'pb2nRfGNt96p2stsqHHW9KcoGBnpYXlvfu5bGCZ0';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(
    keyApplicationId,
    keyParseServerUrl,
    clientKey: keyClientKey,
    autoSendSessionId: true,
  );
  runApp(
    MaterialApp(
      home: FirstPageDirect(),
      theme: LightTheme().lightTheme,
      debugShowCheckedModeBanner: false,
    ),
  );
}
