import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/components/facebook_login_controller.dart';
import 'package:flutter_auth/Screens/Login/components/google_sign_in.dart';
import 'package:flutter_auth/wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider<GoogleSignInProvider>(
              create: (context) => GoogleSignInProvider()),
          ChangeNotifierProvider<FacebookSignInController>(
              create: (context) => FacebookSignInController())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GFlix',
          theme: ThemeData(
            primaryColor: Colors.grey,
            scaffoldBackgroundColor: Colors.black,
          ),
          home: Wrapper(),
        ),
      );
}
