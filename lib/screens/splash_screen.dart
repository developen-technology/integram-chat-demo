import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'dart:async';

import 'package:flutter_chat_ui/secret/param.dart';
import 'package:flutter_chat_ui/screens/chat_screen.dart';
import 'package:flutter_chat_ui/models/message_model.dart';

final storage = FlutterSecureStorage();

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  String splashMessage = 'Autenticando Usuario...';

  @override
  void initState() {
    super.initState();

    var jwtToken = authenticate(CLIENT_TOKEN);

    // Just for branding
    if (jwtToken != null) {
      storage.write(key: "jwtToken", value: jwtToken.toString());
      new Timer(Duration(seconds: 5), onDoneLoading);
    } else {
      setState(() {
        splashMessage = "Error de autenticación...";
      });
    }
  }

  Future<String> authenticate(String token) async {
    var res = await http
        .post("$SERVER_IP/auth/comunication-server", body: {"token": token});

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
        .push(MaterialPageRoute(builder: (context) => ChatScreen(user: greg)));
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
