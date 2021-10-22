import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    } on PlatformException catch (e) {
      print(e.code);
      String message;
      if (e.code == 'FAILED') {
        message = 'ผู้ใช้ยกเลิกการเข้าสู่ระบบ';
      } else {
        message = e.code;
      }

      print(message);
      Fluttertoast.showToast(msg: message, gravity: ToastGravity.CENTER);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      String message;
      if (e.code == 'account-exists-with-different-credential') {
        message = 'บัญชีนี้ถูกใช้สมัครกับผู้ให้บริการอื่นแล้ว';
      } else {
        message = e.code;
      }

      print(message);
      Fluttertoast.showToast(msg: message, gravity: ToastGravity.CENTER);
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
