import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookSignInController with ChangeNotifier {
  final facebookAuth = FacebookAuth.instance;
  Map userData;

  login() async {
    try {
      final facebookLoginResult = await facebookAuth.login();

      final requestData = await FacebookAuth.instance.getUserData();
      userData = requestData;
      final FacebookAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(
              facebookLoginResult.accessToken.token);

      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

      await FirebaseFirestore.instance.collection('users').add({
        'email': userData['email'],
      });
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
    notifyListeners();
  }

  logOut() async {
    await FacebookAuth.instance.logOut();
    userData = null;
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
