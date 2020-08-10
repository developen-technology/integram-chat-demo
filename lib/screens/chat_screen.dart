import 'package:flutter/material.dart';
import 'dart:convert' show json;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:intl/intl.dart';

import 'package:integram_chat_demo/providers/chat_messages.dart';
import 'package:integram_chat_demo/models/message_model.dart';
import 'package:integram_chat_demo/widgets/chat_list.dart';
import 'package:integram_chat_demo/widgets/message_composer.dart';
import 'package:integram_chat_demo/secret/param.dart';
import 'package:provider/provider.dart';

import 'dart:developer';

class ChatScreen extends StatefulWidget {
  final WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(WS_URL));

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ChatMessages(),
      child: InitScaffold(widget: widget),
    );
  }
}

class InitScaffold extends StatelessWidget {
  InitScaffold({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final ChatScreen widget;

  @override
  Widget build(BuildContext context) {
    final ChatMessages chatData = Provider.of<ChatMessages>(context);

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
                  child: StreamChatBuilder(widget.channel, widget, chatData),
                ),
              ),
            ),
            MessageComposer(widget.channel),
          ],
        ),
      ),
    );
  }
}

class StreamChatBuilder extends StatefulWidget {
  WebSocketChannel channel;
  ChatMessages chatData;
  ChatScreen widget;

  StreamChatBuilder(this.channel, this.widget, this.chatData);

  @override
  _StreamChatBuilderState createState() => _StreamChatBuilderState();
}

class _StreamChatBuilderState extends State<StreamChatBuilder> {
  @override
  void initState() {
    super.initState();

    widget.channel.stream.asBroadcastStream().listen((event) {
      var data = json.decode(event);
      log(data.toString());

      if (data != null) {
        var messageData = json.decode(data["data"]);

        final f = new DateFormat('dd-MM-yyyy hh:mm');

        //log(data["data"].toString());
        var message = Message(
            sender: 1,
            text: messageData["content"].toString(),
            time: f.format(DateTime.parse(messageData["time"])));

        widget.chatData.addChatMessage(message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChatList();
  }
}
