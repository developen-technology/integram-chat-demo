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
    var jwtToken = await _authenticate(CLIENT_TOKEN);

    // Just for branding
    if (jwtToken != null) {
      storage.write(key: "jwtToken", value: jwtToken.toString());
      new Timer(Duration(seconds: 5), onDoneLoading);
    } else {
      setState(() {
        splashMessage = "Error de autenticación...";
        isLoading = false;
      });
    }
  }

  Future<String> _authenticate(String token) async {
    var res = await http
        .post("$API_SERVER/auth/comunication-server", body: {"token": token});

    if (res.statusCode == 200) {
      var data = json.decode(res.body);

      if (data["success"]) {
        return data["token"];
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
