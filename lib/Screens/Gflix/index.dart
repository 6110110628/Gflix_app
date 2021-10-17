import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Gflix/utils/text.dart';
import 'package:flutter_auth/Screens/Gflix/widgets/toprated.dart';
import 'package:flutter_auth/Screens/Gflix/widgets/trending.dart';
import 'package:flutter_auth/Screens/Gflix/widgets/tv.dart';
import 'package:flutter_auth/Screens/Login/components/google_sign_in.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_api/tmdb_api.dart';

class IndexScreen extends StatefulWidget {
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  final String apikey = '58872d641e47bcf01e8b47c75e020623';
  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1ODg3MmQ2NDFlNDdiY2YwMWU4YjQ3Yzc1ZTAyMDYyMyIsInN1YiI6IjYxM2U3ZTVjOTE3NDViMDA5MWU3OGI5NyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.q-bvvinn7hwRIRHRRQtfgQRWsbhITyfALcho9Y8zhJk';
  List trendingmovies = [];
  List topratedmovies = [];
  List tv = [];
  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    loadmovies();
  }

  loadmovies() async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apikey, readaccesstoken),
      logConfig: ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    Map trendingresult = await tmdbWithCustomLogs.v3.trending.getTrending();
    Map topratedresult = await tmdbWithCustomLogs.v3.movies.getTopRated();
    Map tvresult = await tmdbWithCustomLogs.v3.tv.getPouplar();
    print((trendingresult));
    setState(() {
      trendingmovies = trendingresult['results'];
      topratedmovies = topratedresult['results'];
      tv = tvresult['results'];
    });
  }

  _showLogoutDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            scrollable: true,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                modified_text(text: "Log Out", size: 25, color: Colors.black),
                SizedBox(
                  height: 15,
                ),
                modified_text(
                    text: "Are you sure you want to log out?",
                    size: 15,
                    color: Colors.black),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      color: Colors.white,
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      color: Colors.red,
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        'Log Out',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      onPressed: () async {
                        try {
                          auth.signOut().then((value) {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return WelcomeScreen();
                            }));
                          });
                        } catch (e) {
                          Fluttertoast.showToast(
                              msg: e.message, gravity: ToastGravity.CENTER);
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: modified_text(text: 'GFlix Movie App'),
          backgroundColor: Colors.red,
        ),
        body: ListView(
          children: [
            TrendingMovies(
              trending: trendingmovies,
            ),
            TV(tv: tv),
            TopRatedMovies(
              toprated: topratedmovies,
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 3,
                  child: SvgPicture.asset(
                    'assets/icons/tmdb_full_logo.svg',
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  flex: 4,
                  child: modified_text(
                    text:
                        'GFlix application uses the TMDB API but is not endorsed or certified by TMDB.',
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Colors.red,
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Text(
                    'Log Out',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  onPressed: _showLogoutDialog,
                ),
              ],
            ),
          ],
        ));
  }
}
