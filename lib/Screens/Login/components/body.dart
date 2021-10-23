import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth/Screens/Gflix/index.dart';
import 'package:flutter_auth/Screens/Login/components/background.dart';
import 'package:flutter_auth/Screens/Login/components/facebook_login_controller.dart';
import 'package:flutter_auth/Screens/Login/components/google_sign_in.dart';
import 'package:flutter_auth/Screens/Signup/components/or_divider.dart';
import 'package:flutter_auth/Screens/Signup/components/social_icon.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/rounded_password_field.dart';
import 'package:flutter_auth/model/profile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Body extends StatelessWidget {
  final formkey = GlobalKey<FormState>();
  Profile profile = Profile();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
                appBar: AppBar(
                  title: Text("Error"),
                ),
                body: Center(
                  child: Text("${snapshot.error}"),
                ));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Background(
              child: Form(
                key: formkey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: size.height * 0.03),
                      Image.asset(
                        'assets/images/gflix.png',
                        height: 60.0,
                        width: 100.0,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: size.height * 0.06),
                      RoundedInputField(
                          hintText: "Your Email",
                          onChanged: (String email) {
                            profile.email = email;
                          }),
                      RoundedPasswordField(
                        onChanged: (String password) {
                          profile.password = password;
                        },
                      ),
                      RoundedButton(
                          text: "LOGIN",
                          color: Colors.red, //gray-black
                          press: () async {
                            if (formkey.currentState.validate()) {
                              formkey.currentState.save();
                              try {
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: profile.email,
                                        password: profile.password)
                                    .then((value) {
                                  formkey.currentState.reset();
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(builder: (context) {
                                    return IndexScreen();
                                  }), (Route<dynamic> route) => false);
                                });
                              } on FirebaseAuthException catch (e) {
                                print(e.code);
                                String message;
                                if (e.code == 'wrong-password') {
                                  message = 'รหัสผ่านไม่ถูกต้อง';
                                } else if (e.code == 'user-not-found') {
                                  message =
                                      'ไม่มีอีเมลนี้อยู่ในระบบ โปรดสมัครเพื่อใช้งาน';
                                } else {
                                  message = e.code;
                                }

                                print(message);
                                Fluttertoast.showToast(
                                    msg: message, gravity: ToastGravity.CENTER);
                              }
                            }
                          }),
                      SizedBox(height: size.height * 0.03),
                      AlreadyHaveAnAccountCheck(
                        login: true,
                        press: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SignUpScreen();
                              },
                            ),
                          );
                        },
                      ),
                      OrDivider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SocalIcon(
                            iconSrc: "assets/icons/facebook.svg",
                            press: () async {
                              final facebookProvider =
                                  Provider.of<FacebookSignInController>(context,
                                      listen: false);
                              facebookProvider.login().then((value) {
                                final auth = FirebaseAuth.instance;
                                if (auth.currentUser != null) {
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(builder: (context) {
                                    return IndexScreen();
                                  }), (Route<dynamic> route) => false);
                                }
                              });
                            },
                          ),
                          SocalIcon(
                            iconSrc: "assets/icons/google-plus.svg",
                            press: () async {
                              try {
                                final googleProvider =
                                    Provider.of<GoogleSignInProvider>(context,
                                        listen: false);
                                googleProvider.googleLogin().then((value) {
                                  final auth = FirebaseAuth.instance;
                                  if (auth.currentUser != null) {
                                    Navigator.pushAndRemoveUntil(context,
                                        MaterialPageRoute(builder: (context) {
                                      return IndexScreen();
                                    }), (Route<dynamic> route) => false);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'กรุณาเลือกบัญชีผู้ใช้ด้วยครับ',
                                        gravity: ToastGravity.CENTER);
                                  }
                                });
                              } on PlatformException catch (e) {
                                print(e.toString());
                              } on FirebaseAuthException catch (e) {
                                print(e.toString());
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
