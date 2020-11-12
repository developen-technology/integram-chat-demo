import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'dart:async';

import 'package:integram_chat_demo/main.dart';
import 'package:integram_chat_demo/secret/param.dart';
import 'package:integram_chat_demo/screens/chat_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  String splashMessage = 'Autenticando Usuario...';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _onAuthenticate();
  }

  void _onAuthenticate() async {
    var session = await _authenticate(CLIENT_ID);

    // Just for branding
    if (session != null) {
      storage.write(key: "session", value: session.toString());
      new Timer(Duration(seconds: 5), onDoneLoading);
    } else {
      setState(() {
        splashMessage = "Error de autenticación...";
        isLoading = false;
      });
    }
  }

  Future<String> _authenticate(String clientId) async {
    var res = await http.post("$API_SERVER/conversation/greeting-mobile",
        body: {"client_id": clientId});

    if (res.statusCode == 200) {
      var data = json.decode(res.body);

      if (data["success"]) {
        return data["data"];
      }
    }

    return null;
  }

  onDoneLoading() async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ChatScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                child: Image.asset(
              'assets/images/integram-logo.png',
              height: 200,
              width: 600,
            )),
            SizedBox(
              height: 20.0,
            ),
            if (isLoading == true)
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              splashMessage,
              style: TextStyle(
                color: Colors.white,
                fontSize: 23.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
