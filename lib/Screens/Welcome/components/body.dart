import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(
                    top: 100,
                  ),
                  child: Image.asset(
                    'assets/images/gflix.png',
                    height: 60.0,
                    width: 100.0,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Center(
              child: ImageSlideshow(
                width: 400,
                height: 400,
                initialPage: 0,
                indicatorColor: Colors.red,
                indicatorBackgroundColor: Colors.grey,
                children: [
                  Image.asset(
                    'assets/images/slide1.png',
                    fit: BoxFit.cover,
                  ),
                  Image.asset(
                    'assets/images/slide2.png',
                    fit: BoxFit.cover,
                  ),
                  Image.asset(
                    'assets/images/slide3.png',
                    fit: BoxFit.cover,
                  ),
                ],
                onPageChanged: (value) {
                  print('Page changed: $value');
                },
                autoPlayInterval: 10000,
                isLoop: true,
              ),
            ),
          ),
          Container(
            child: Container(
              margin: EdgeInsets.all(32),
              child: Center(
                child: RoundedButton(
                  text: "Get Started",
                  color: Colors.red,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
