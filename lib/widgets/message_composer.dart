import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:integram_chat_demo/main.dart';
import 'package:integram_chat_demo/secret/param.dart';
import 'package:integram_chat_demo/providers/chat_messages.dart';
import 'package:integram_chat_demo/models/message_model.dart';

class MessageComposer extends StatefulWidget {
  @override
  _MessageComposerState createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
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

    String session = await storage.read(key: "session");

    final f = new DateFormat('dd-MM-yyyy hh:mm');
    var message = Message(
        sender: -1, text: _msgcontroller.text, time: f.format(DateTime.now()));
    chatData.addChatMessage(message);

    await http.post("$API_SERVER/conversation/message-in",
        body: {"content": _msgcontroller.text, "session": session});

    _msgcontroller.text = "";
  }
}
