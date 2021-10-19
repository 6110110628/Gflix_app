import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class FacebookLogIn extends StatefulWidget {
  @override
  _FacecookLogInState createState() => _FacecookLogInState();
}

class _FacecookLogInState extends State<FacebookLogIn> {
  bool _isLogin = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FacebookLogin _facebookLogin = FacebookLogin();
  User _user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLogin ? Center() : Center(),
    );
  }

  Future _handleLogin() async {
    FacebookLoginResult _result =
        await _facebookLogin.logInWithReadPermissions(['email']);
    switch (_result.status) {
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        break;
      case FacebookLoginStatus.error:
        print("error");
        break;
      case FacebookLoginStatus.loggedIn:
        await _loginWithFacebook(_result);
        break;
    }
  }

  Future _loginWithFacebook(FacebookLoginResult _result) async {
    FacebookAccessToken _accessToken = _result.accessToken;
    AuthCredential _credential =
        FacebookAuthProvider.credential(_accessToken.token);
    var a = await _auth.signInWithCredential(_credential);
    setState(() {
      _isLogin = true;
      _user = a.user;
    });
  }

  Future _FacebookSignOut() async {
    await _auth.signOut().then((value) {
      setState(() {
        _facebookLogin.logOut();
        _isLogin = false;
      });
    });
  }
}
