import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:integram_chat_demo/screens/splash_screen.dart';

final storage = FlutterSecureStorage();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Integram Chat Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(0, 32, 56, 1),
        accentColor: Color(0xFFFEF9EB),
      ),
      home: SplashScreen(),
    );
  }
}
