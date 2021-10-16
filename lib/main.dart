import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/wrapper.dart';

import 'Screens/Gflix/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GFlix',
      theme: ThemeData(
        primaryColor: Colors.grey,
        scaffoldBackgroundColor: Color.fromRGBO(64, 64, 64, 64),
      ),
      home: Wrapper(),
    );
  }
}
