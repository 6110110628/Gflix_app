import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';

class IndexScreen extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wellcome to Gflix'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              Text(
                auth.currentUser.email,
                style: TextStyle(fontSize: 25),
              ),
              ElevatedButton(
                child: Text('ออกจากระบบ'),
                onPressed: () {
                  auth.signOut().then((value) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return WelcomeScreen();
                    }));
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
