import 'package:flutter/material.dart';
import 'dart:convert' show json;
import 'package:http/http.dart' as http;
import 'package:pusher_websocket_flutter/pusher.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:integram_chat_demo/main.dart';
import 'package:integram_chat_demo/providers/chat_messages.dart';
import 'package:integram_chat_demo/models/message_model.dart';
import 'package:integram_chat_demo/widgets/chat_list.dart';
import 'package:integram_chat_demo/widgets/message_composer.dart';
import 'package:integram_chat_demo/secret/param.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ChatMessages(),
      child: InitScaffold(widget: widget),
    );
  }
}

class InitScaffold extends StatefulWidget {
  final ChatScreen widget;
  Channel channel;

  InitScaffold({Key key, @required this.widget}) : super(key: key);

  @override
  _InitScaffoldState createState() => _InitScaffoldState();
}

class _InitScaffoldState extends State<InitScaffold> {
  ChatMessages chatData;

  @override
  void initState() {
    super.initState();
    initPusher();
  }

  void initPusher() async {
    try {
      await Pusher.init(APP_KEY, PusherOptions(cluster: "us2"));
      await Pusher.connect();
      String session = await storage.read(key: "session");
      widget.channel = await Pusher.subscribe(session);

      await widget.channel.bind('message-in', (event) {
        var data = json.decode(event.data);

        if (data != null) {
          var messageData = json.decode(data["message"]);
          final f = new DateFormat('dd-MM-yyyy hh:mm');

          var message = Message(
              sender: 1,
              text: messageData["content"].toString(),
              time: f.format(DateTime.parse(messageData["time"])));

          chatData.addChatMessage(message);
        }
      });

      http.post("$API_SERVER/conversation/message-in",
          body: {"content": "/start", "session": session});
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    chatData = Provider.of<ChatMessages>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () {},
        ),
        title: Text(
          'Integram Chat Demo',
          style: TextStyle(
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  child: ChatList(),
                ),
              ),
            ),
            MessageComposer(),
          ],
        ),
      ),
    );
  }
}
