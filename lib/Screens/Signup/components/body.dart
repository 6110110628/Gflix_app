import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Signup/components/background.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/rounded_password_field.dart';
import 'package:flutter_auth/model/profile.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
                        },
                        color: Colors.black,
                      ),
                      RoundedPasswordField(
                          onChanged: (String password) {
                            profile.password = password;
                          },
                          color: Colors.black),
                      RoundedButton(
                          text: "SIGN UP",
                          color: Colors.orange,
                          press: () async {
                            if (formkey.currentState.validate()) {
                              formkey.currentState.save();
                              try {
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: profile.email,
                                        password: profile.password)
                                    .then((value) {
                                  formkey.currentState.reset();
                                  Fluttertoast.showToast(
                                      msg: 'สร้างบัญชีผู้ใช้เรียบร้อยแล้ว',
                                      gravity: ToastGravity.TOP);
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return LoginScreen();
                                  }));
                                });
                              } on FirebaseAuthException catch (e) {
                                print(e.code);
                                String message;
                                if (e.code == 'email-already-in-use') {
                                  message =
                                      'มีอีเมลนี้อยู่ในระบบแล้วครับ โปรดใช้อีเมลอื่นแทน';
                                } else if (e.code == 'weak-password') {
                                  message =
                                      'รหัสผ่านต้องมีความยาว 6 ตัวอักษรขึ้นไป';
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
                        login: false,
                        press: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return LoginScreen();
                              },
                            ),
                          );
                        },
                      ),
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
