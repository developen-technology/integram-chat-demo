import 'package:flutter/material.dart';
import 'dart:convert' show json;
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:intl/intl.dart';

import 'package:integram_chat_demo/main.dart';
import 'package:integram_chat_demo/providers/chat_messages.dart';
import 'package:integram_chat_demo/models/message_model.dart';

class MessageComposer extends StatefulWidget {
  WebSocketChannel channel;

  MessageComposer(this.channel);

  @override
  _MessageComposerState createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  String jwtToken;

  var _msgcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: _msgcontroller,
              onSubmitted: (String text) {
                _sendMessage();
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Enviar Mensaje...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              _sendMessage();
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    final chatData = Provider.of<ChatMessages>(context, listen: false);
    if (_msgcontroller.text.isEmpty) return;

    final f = new DateFormat('dd-MM-yyyy hh:mm');
    var message = Message(
        sender: -1, text: _msgcontroller.text, time: f.format(DateTime.now()));

    if (jwtToken == null) {
      jwtToken = await storage.read(key: "jwtToken");
    }

    final apiFormat = DateFormat('yyyy-MM-dd hh:mm:ss');

    var data = json.encode({
      'action': "echoTest",
      'payload': {
        'id': 1,
        'time': apiFormat.format(DateTime.now()),
        'content': _msgcontroller.text,
        'is_seen': false,
        'is_sent': true,
        'type_id': 2,
        'sender_id': -1,
        'lead_id': -1,
        'token': jwtToken,
      }
    });

    widget.channel.sink.add(data);

    _msgcontroller.text = "";
    chatData.addChatMessage(message);
  }
}
